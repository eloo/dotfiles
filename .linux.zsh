
if [[ ${DEBUG_ZSH} ]]; then
    echo "[$(date +%H:%M:%S.%3N)] Loading Linux dotfile configuration..."
fi


# Aliases
alias ll='ls -alh'
alias dns='( nmcli dev list || nmcli dev show ) 2>/dev/null | grep DNS'

alias ports='sudo netstat -tulpen'


# Functions
function localip(){
    echo "📶  "$(ip addr show | grep "inet\b" | awk '{print $2}' | cut -d/ -f1)
}

function renameMediaFilesToCreateDate(){
    exiftool -r '-FileName<CreateDate' -d %Y-%m-%d_%H-%M-%S%%-c.%%e * $1
}

function renameMediaFilesToDateTimeOriginal(){
    exiftool -r '-FileName<DateTimeOriginal' -d %Y-%m-%d_%H-%M-%S%%-c.%%e * $1
}

function renameMediaFilesToCreateDateWithFolders(){
    exiftool -r '-FileName<CreateDate' -d %Y/%m/%Y-%m-%d_%H-%M-%S%%-c.%%e * $1
}

function renameMediaFilesToDateTimeOriginalWithFolders(){
    exiftool -r '-FileName<DateTimeOriginal' -d %Y/%m/%Y-%m-%d_%H-%M-%S%%-c.%%e * $1
}

function ocr-pdf(){
    # Usage: ocr-pdf [-r] <file|directory>
    if [[ "$1" == "-r" ]]; then
        shift
        target=${1:-.}
        if [[ -d "$target" ]]; then
            find "$target" -type f -iname '*.pdf' -print0 | while IFS= read -r -d '' file; do
                ocr-pdf "$file"
            done
            return
        else
            # if target is a file, fall through to process it
            :
        fi
    fi

    file="$1"
    if [[ -z "$file" ]]; then
        echo "Usage: ocr-pdf [-r] <file|directory>"
        return 1
    fi

    if [[ -d "$file" ]]; then
        echo "ocr-pdf: '$file' is a directory. Use -r to process directories recursively."
        return 1
    fi

    extension=${file##*.}
    filename="${file%.*}"
    tmpfile="${filename}-ocr.${extension}"

    # If pdftotext is available, use it to detect an existing text layer and skip OCR if present.
    if command -v pdftotext >/dev/null 2>&1; then
        # Count non-whitespace characters to avoid false positives from newlines
        textchars=$(pdftotext "$file" - 2>/dev/null | tr -d '[:space:]' | wc -c)
        if [[ $? -ne 0 ]]; then
            echo "ocr-pdf: pdftotext failed on '$file'; proceeding with ocrmypdf --skip-text."
        elif [[ "$textchars" -gt 0 ]]; then
            echo "ocr-pdf: '$file' already contains selectable text; skipping."
            return 0
        fi
    else
        echo "ocr-pdf: 'pdftotext' not found; will run ocrmypdf with --skip-text to avoid double OCR."
    fi

    # Run OCR, skipping pages that already contain text. Removed deprecated --jbig2-lossy option.
    if ocrmypdf -l deu --skip-text --optimize 3 "$file" "$tmpfile"; then
        # Keep the processed output as "<name>-ocr.pdf" and also overwrite the original file.
        if cp -f "$tmpfile" "$file"; then
            echo "ocr-pdf: created output '$tmpfile' and updated '$file'"
        else
            echo "ocr-pdf: failed to overwrite original '$file' after OCR"
            [[ -f "$tmpfile" ]] && rm -f "$tmpfile"
            return 1
        fi
    else
        echo "ocr-pdf: failed to process '$file'"
        [[ -f "$tmpfile" ]] && rm -f "$tmpfile"
        return 1
    fi
}