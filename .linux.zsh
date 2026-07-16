
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
    # Usage: ocr-pdf [-r] [-f] <file|directory>
    local recursive=false
    local force=false

    while [[ "$#" -gt 0 ]]; do
        case "$1" in
            -r)
                recursive=true
                shift
                ;;
            -f)
                force=true
                shift
                ;;
            --)
                shift
                break
                ;;
            -* )
                echo "Usage: ocr-pdf [-r] [-f] <file|directory>"
                return 1
                ;;
            *)
                break
                ;;
        esac
    done

    file="$1"
    if [[ -z "$file" ]]; then
        echo "Usage: ocr-pdf [-r] [-f] <file|directory>"
        return 1
    fi

    if [[ "$recursive" == true ]]; then
        target="$file"
        if [[ -d "$target" ]]; then
            find "$target" -type f -iname '*.pdf' -print0 | while IFS= read -r -d '' file; do
                if [[ "$force" == true ]]; then
                    ocr-pdf -f "$file"
                else
                    ocr-pdf "$file"
                fi
            done
            return
        fi
    fi

    if [[ -d "$file" ]]; then
        echo "ocr-pdf: '$file' is a directory. Use -r to process directories recursively."
        return 1
    fi

    extension=${file##*.}
    filename="${file%.*}"
    tmpfile="${filename}-ocr.${extension}"

    if [[ "$force" == true ]]; then
        echo "ocr-pdf: forcing OCR update for '$file'."
        ocrmypdf_flags=("--force-ocr")
    else
        ocrmypdf_flags=("--skip-text")
    fi

    if [[ "$force" != true ]]; then
        if command -v pdftotext >/dev/null 2>&1; then
            # Count non-whitespace characters to avoid false positives from newlines
            textchars=$(pdftotext "$file" - 2>/dev/null | tr -d '[:space:]' | wc -c)
            if [[ $? -ne 0 ]]; then
                echo "ocr-pdf: pdftotext failed on '$file'; proceeding with ocrmypdf ${ocrmypdf_flags[*]}."
            elif [[ "$textchars" -gt 0 ]]; then
                echo "ocr-pdf: '$file' already contains selectable text; skipping."
                return 0
            fi
        else
            echo "ocr-pdf: 'pdftotext' not found; will run ocrmypdf with ${ocrmypdf_flags[*]} to avoid double OCR."
        fi
    fi

    # Run OCR, optionally forcing OCR of pages with existing text.
    if ocrmypdf -l deu "${ocrmypdf_flags[@]}" --optimize 2 "$file" "$tmpfile"; then
        # Keep the processed output as "<name>-ocr.pdf" and also overwrite the original file.
        if cp -f "$tmpfile" "$file"; then
            echo "ocr-pdf: created output '$tmpfile' and updated '$file'"
            # remove temporary OCR output when successful
            [[ -f "$tmpfile" ]] && rm -f "$tmpfile"
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