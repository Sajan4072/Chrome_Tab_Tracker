#!/bin/bash

LINKS_DIR="./links"

# Detect OS and set chrome cmd
detect_os() {
    case "$(uname -s)" in
        Linux*)   CHROME_CMD="google-chrome" ;;   
        Darwin*)  CHROME_CMD="open -a 'Google Chrome'" ;; 
        CYGWIN*|MINGW*|MSYS*) CHROME_CMD="start chrome" ;;  
        *) echo "Unsupported OS. Exiting."; exit 1 ;;
    esac
}


list_files() {
    echo "List of files:"
    mapfile -t files < <(find "$LINKS_DIR" -maxdepth 1 -type f -name "*.txt")

    if [[ ${#files[@]} -eq 0 ]]; then
        echo "No .txt files found in $LINKS_DIR. Exiting."
        exit 1
    fi

    for i in "${!files[@]}"; do
        echo "$((i + 1)). ${files[$i]}"
    done
}


get_user_selection() {
    read -p "Enter file number to open: " file_number

    if ! [[ "$file_number" =~ ^[0-9]+$ ]] || (( file_number < 1 || file_number > ${#files[@]} )); then
        echo "Invalid selection. Please enter a valid number."
        exit 1
    fi

    selected_file="${files[$((file_number - 1))]}"
}

# Open links in Google Chrome
open_links() {
    echo "Opening links from: $selected_file"

    while IFS= read -r link || [[ -n "$link" ]]; do
        if [[ -n "$link" ]]; then
            if [[ "$OSTYPE" == "msys" || "$OSTYPE" == "cygwin" || "$OSTYPE" == "mingw"* ]]; then
                link_escaped=$(echo "$link" | sed 's/&/^&/g')  
                eval "start chrome \"$link_escaped\""  
            else
                "$CHROME_CMD" "$link" &  
            fi
        fi
    done < "$selected_file"

    echo "All links have been opened in Google Chrome."
}


main() {
    detect_os
    list_files
    get_user_selection
    open_links
}

main