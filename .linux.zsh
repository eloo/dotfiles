# Aliases
alias ll='ls -alh'
alias dns='( nmcli dev list || nmcli dev show ) 2>/dev/null | grep DNS'

# Functions

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
      extension=${1##*.}
      filename="${1%.*}"
      ocrmypdf -l deu --jbig2-lossy --optimize 3 "$1" "${filename}-ocr.${extension}"
}