#!/bin/bash

#dic 
LINKS_DIR="./links"


#detect os and set the correcty chrome cmd 
detect_os(){
    case "uname -s" in 
        linux*) CHROME_CMD="google-chrome" ;;
        Darwin*) CHROME_CMD="open -a 'Google Chrome" ;;
        CYGWIN*|MINGW*|MsYS*) CHROME_CMD="cmd.exe /c start chrome" ;;
        *) echo "unsupported Os.Exiting." exit 1 ;;
    esac
}

list_files(){
    echo "list of files"
    mapfile -t files < <(find "$LINKS_DIR" -maxdepth 1 -type f -name "*.txt")
    # echo ${files[@]}

    if [[ ${#files[@]} -eq 0 ]]; then
        echo "No .txt files found in $LINKS_DIR. Exiting."
        exit 1
    fi

    for i in "${!files[@]}"; do          
        echo "$((i+1)).${files[$i]}"
    done

}



main()
{
    list_files
}

main




#list if file 
echo "available files"
