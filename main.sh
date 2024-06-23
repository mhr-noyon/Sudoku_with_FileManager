#------------------------- Global Declaration -------------------------
# Color codes
RED='\033[0;31m'
GREEN='\033[0;32m'

BLUE='\033[0;34m'
YELLOW='\033[0;33m'
NC='\033[0m' # No Color
wait(){
     for ((i=$1; i>0; i--)) do
          echo "$2 in $i..."
          sleep 1
     done
     clear
}
lineBreak(){
     for ((i=0;i<$1;i++)) do
          echo ""
     done
}
Exit(){
     lineBreak 2
     wait 3 "Exiting"
     exit 0 
}
getDirectory(){
     echo "Your current directory is: $(pwd)"
     lineBreak 2
     while true; do
          read -p "Do you want to change directory? (y/n): " choice
          if [ "$choice" != "y" ] && [ "$choice" != "n" ]; then
               lineBreak 2
               echo "Invalid response. Please enter 'y' or 'n'."
          elif [ "$choice" == "y" ]; then
               ChangeDirectory
               break
          else
               break
          fi
          lineBreak 2
     done
     clear
}
let items     #Array to store file names
showListFiles() {
     echo "Folders and text files in the current directory:"
     echo "---------------------------------------------"
     index=1
     for item in *; do
          if [ -d "$item" ]; then
               echo -e "${RED}$index. [Folder] $item${NC}"
          elif [ -f "$item" ] && [[ "$item" == *.* ]]; then
               echo -e "${GREEN}$index. [File] $item${NC}"
          else
               echo "$index. [Unknown] $item"
          fi
          items[$index]="$item"
          ((index++))
     done
     echo "$index. Back .."
     echo "$((index+1)). Stop browsing"
     echo "---------------------------------------------"
}
#---------------------- Global Declaration Ends --------------------------
viewFileContent() {
    clear
    echo "--------------------------"
    echo "       View File Content       "
    echo "--------------------------"
    lineBreak 2
    getDirectory #calling function to get required directory
    
    viewContent() {
        lineBreak 2
        read -p "Enter the number of the file you want to view: " file_index
        lineBreak 3

        if [ "$file_index" -eq "$index" ]; then
            cd ..
            CURRENT_DIR=$(pwd)
            echo "Entered parent directory"
            echo "Current folder path: $CURRENT_DIR"
            return
        elif [ "$file_index" -eq "$((index+1))" ]; then
            echo "You are done browsing. Exiting..."
            wait 2 "Going Back"
            clear
            return
        fi

        selected_item="${items[$file_index]}"
        if [ -f "$selected_item" ]; then
            clear
            echo "--------------------------"
            echo "       File Content       "
            echo "--------------------------"
            lineBreak 2
            cat "$selected_item"
            lineBreak 3
            read -p "Press Enter to return..."
        elif [ -d "$selected_item" ]; then
            echo "The selected item is a folder. Please select a file."
            wait 2 "Refreshing"
        else
            echo "Invalid selection. Please select a valid file."
            wait 2 "Refreshing"
        fi
    }

    flag=1
    while [ $flag -eq 1 ]; do
        clear
        echo "--------------------------"
        echo "       View File Content       "
        echo "--------------------------"
        lineBreak 2
        showListFiles #showing files in current directory
        viewContent
        if [ "$file_index" -eq "$((index+1))" ]; then
            flag=0
        fi
        lineBreak 2
    done
}
insertTextToFile() {
    clear
    echo "--------------------------"
    echo "    Insert Text into File      "
    echo "--------------------------"
    lineBreak 2
    getDirectory 
    showListFiles
    lineBreak 2
    read -p "Enter the name of the file you want to insert text into: " file_name
    lineBreak 2
    
    echo "Old text: "
    cat "${file_name}"
    lineBreak 3

    if [ ! -f "$file_name" ]; then
        echo "File $file_name does not exist."
        wait 2 "Refreshing"
        return
    fi

    echo "Enter the text to insert. Press Ctrl+D when finished:"
    cat >> "$file_name"
    lineBreak 2
    echo "Text inserted successfully into file $file_name."
    wait 3 "Refreshing"
}
ChangeDirectory() {
     clear
     flag=1
     enterFolder() {
          lineBreak 2
          read -p "Enter the number of the folder you want to enter: " folder_index
          lineBreak 3
          if [ "$folder_index" -eq "$index" ]; then
               cd ..
               CURRENT_DIR=$(pwd)
               echo "Entered parent directory"
               echo "Current folder path: $CURRENT_DIR"
               return
          elif [ "$folder_index" -eq "$((index+1))" ]; then
               flag=0
               CURRENT_DIR=$(pwd)
               echo "Current folder path: $CURRENT_DIR"
               echo "You are done browsing. Exiting..."
               wait 2 "Going Back"
               clear
               return
          fi
          selected_item="${items[$folder_index]}"
          if [ -d "$selected_item" ]; then
               cd "$selected_item" || exit
               echo "Entered folder: $selected_item"
               lineBreak 2
               echo "Current folder path: $(pwd)" 
          else
               echo "Invalid selection or not a folder."
               wait 3 "Refreshing"
          fi
    }

     while [ $flag -eq 1 ]; do
          clear
          echo "---------------------------"
          echo "       Change Directory     "
          echo "---------------------------"
          lineBreak 2
          showListFiles #showing files in current directory
          enterFolder
          if [ $flag -eq 0 ]; then
               break
          fi
          lineBreak 2
     done
}

Create(){
     clear
     echo "--------------------------"
     echo "       Create Files       "
     echo "--------------------------"
     lineBreak 2
     getDirectory #calling function to get required directory
     lineBreak 2
     CreateFiles() {
          echo "Creating files..."
          while true; do
               read -p "Enter the name of the file you want to create (with extension): " fileName
               if [ ! -f "$fileName" ]; then
                    lineBreak 2
                    touch "$fileName"
                    echo "File $fileName created."
                    run="false"
                    return
               else
                    lineBreak 2
                    echo "File already exists. Please enter a different name."
                    wait 2 "Refreshing"
                    return
               fi
          done
     }

     CreateDirectories() {
          echo "Creating directories..."
          while true; do
               read -p "Enter the name of the directory you want to create: " directory_name
               if [ ! -d "$directory_name" ]; then
                    lineBreak 2
                    mkdir "$directory_name"
                    echo "Directory $directory_name created."
                    run="false"
                    return
               else
                    lineBreak 2
                    echo "Directory already exists. Please enter a different name."
                    wait 2 "Refreshing"
                    return
               fi
          done
     }

     run="true"
     while $run; do
          clear
          echo "--------------------------"
          echo "       Create Files       "
          echo "--------------------------"
          lineBreak 3
          echo "Your current directory is: $(pwd)"
          lineBreak 2
          echo "Select an option:"
          echo "1. Create files"
          echo "2. Create directories"
          echo "3. Back"
          read -p "Enter your choice: " choice
          clear
          case $choice in
               1) CreateFiles;;
               2) CreateDirectories;;
               3) return ;;
               *) echo "Invalid choice. Please try again.";
          esac
     done
     lineBreak 2
     wait 2 "Going back"
}

DeleteFiles(){
     clear
     echo "--------------------------"
     echo "       Delete Files       "
     echo "--------------------------"
     lineBreak 2
     getDirectory #calling function to get required directory
     deleteEmptyFile() {
          rm "$selected_item"
     }
     deleteNonEmptyFile() {
          rm -r "$selected_item"
     }

     selected_item
     flag=1
     chooseFile() {
          lineBreak 2
          read -p "Enter the number of the file you want to delete: " folder_index
          lineBreak 3
          if [ "$folder_index" -eq "$index" ]; then
               cd ..
               CURRENT_DIR=$(pwd)
               echo "Entered parent directory"
               echo "Current folder path: $CURRENT_DIR"
               return
          elif [ "$folder_index" -eq "$((index+1))" ]; then
               flag=0
               CURRENT_DIR=$(pwd)
               echo "Current folder path: $CURRENT_DIR"
               echo "You are done browsing. Exiting..."
               sleep 2
               flag=0
               return
          elif [ "$folder_index" -gt "$((index+1))" ]; then
               echo "Invalid selection. Please enter a valid number."
               return
          fi

          flag=0
          
          selected_item="${items[$folder_index]}"
          if [ -s "$selected_item" ]; then
               echo "File $selected_item has content."
               read -p "Are you sure you want to delete the file? (y/n): " choice
               if [ "$choice" != "y" ] && [ "$choice" != "n" ]; then
                    echo "Invalid response. Please enter 'y' or 'n'."
               elif [ "$choice" == "y" ]; then
                    deleteEmptyFile
                    echo "File $selected_item deleted."
               else 
                    echo "File $selected_item not deleted."
               fi
          else
               echo "File $selected_item is empty, deleting the file."
               deleteNonEmptyFile
               wait 2 "File $selected_item deleting"
          fi
    }   
     while [ $flag -eq 1 ]; do
          clear
          echo "--------------------------"
          echo "       Delete Files       "
          echo "--------------------------"
          lineBreak 2
          showListFiles #showing files in current directory
          chooseFile
          if [ $flag -eq 0 ]; then
               break
          fi
          lineBreak 2
          wait 3 "Refresjing"
     done
}


#1: cp, 2: copy, 3: Copy, 4: copied
#1: mv, 2: move, 3: Move, 4: moved
#Function to copy or move files
copyFiles(){
     targetDirectory
     sourceDirectory
     FileNAME
     clear
     chooseSource(){
          echo "------------------------------"
          echo "       $3 Files       "
          echo "-----------------------------"
          lineBreak 2
          getDirectory #calling function to get required directory
          
          echo "------------------------------"
          echo "       $3 Files       "
          echo "------------------------------"
          lineBreak 2
          echo "Your current source path is: $(pwd)"
          lineBreak 2
          sourceDirectory=$(pwd)
          showListFiles  #showing files in current directory
          folder_index=0
          lineBreak 2
          echo "-------------Choose source file-----------------"
          while true; do
               read -p "Choose source file to $2: " folder_index
               if [ "$folder_index" -gt "$((index+1))" ] || [ "$folder_index" -lt "$((1))" ];  then
                    echo "Invalid selection. Please enter a valid number."
               else
                    break
               fi
               lineBreak 1
          done
          FileNAME="${items[$folder_index]}"
          clear
     }
     chooseDestination(){
          echo "-------------------------------"
          echo "       $3 Files       "
          echo "-------------------------------"
          lineBreak 2
          echo "-------------Choose Destination Directory-----------------"
          getDirectory   #calling function to get required directory
          echo "Your current source path is: $(pwd)"
          lineBreak 2
          sourceDirectory=$(pwd)
          showListFiles #showing files in current directory
          folder_index=0
          echo "-------------Destination file-----------------"
          echo "Your current destination path is: $(pwd)"
          targetDirectory=$(pwd)
     }
     copy(){
          chooseSource "$1" "$2" "$3" "$4"
          chooseDestination "$1" "$2" "$3" "$4"
          if [ -f "$sourceDirectory/$FileNAME" ]; then
               $1 "$sourceDirectory/$FileNAME" "$targetDirectory/"
               wait 3 "Copying"
               lineBreak 2
               echo "File $FileNAME "$4" from $sourceDirectory to $targetDirectory."
               lineBreak 2
               wait 3 "Refreshing"
          else
               echo "File $FILE_NAME does not exist in $sourceDirectory."
          fi

     }
     copy "$1" "$2" "$3" "$4"
}

searchItem() {
    clear
    echo "------------------------------------"
    echo "       Search Files/Folders       "
    echo "------------------------------------"
    lineBreak 2
    getDirectory # calling function to get the required directory

    searchForItem() {
        lineBreak 2
        read -p "Enter the name or substring of the file or folder you want to search: " search_name
        lineBreak 3

        found=0
        for item in *; do
            if [[ "$item" == *"$search_name"* ]]; then
                found=1
                if [ -f "$item" ]; then
                    echo "File '$item' found in the current directory."
                elif [ -d "$item" ]; then
                    echo "Folder '$item' found in the current directory."
                fi
            fi
        done
        lineBreak 2
       read -p "Press Enter to continue..." c

        if [ $found -eq 0 ]; then
            echo "No file or folder containing '$search_name' found in the current directory. Please try again."
            wait 2 "Refreshing"
            return 1
        fi

        return 0
    }

    flag=1
    while [ $flag -eq 1 ]; do
        clear
        echo "------------------------------------"
        echo "       Search Files/Folders       "
        echo "------------------------------------"
        lineBreak 2
        showListFiles # showing files in the current directory
        searchForItem
        if [ $? -eq 0 ]; then
            flag=0
        fi
        lineBreak 2
    done
}
PlaySudokugame(){
     board=(
     "1 2 3 4 5 6 7 8 9"
     "4 5 6 7 8 9 1 2 3"
     "7 8 9 1 2 3 4 5 6"
     "2 3 1 5 6 4 8 9 7"
     "5 6 4 8 9 7 2 3 1"
     "8 9 7 2 3 1 5 6 4"
     "3 1 2 6 4 5 9 7 8"
     "6 4 5 9 7 8 3 1 2"
     "9 7 8 3 1 2 6 4 5"
     )
    
     #To print the board
     printBoard() {
          for ((i=0;i<9;i++)); do
               row=(${board[$i]})
               echo "${row[0]} ${row[1]} ${row[2]} | ${row[3]} ${row[4]} ${row[5]} | ${row[6]} ${row[7]} ${row[8]}"
               if [ $((i % 3)) -eq 2 ] && [ $i -ne 8 ]; then
                    echo "------+-------+------"
               fi
          done
     }
     printBoard2() {
          echo "Col: 1        2         3          4         5         6         7         8          9"
          echo "Row"
                    echo -ne " ${BLUE}-----------------------------${NC}"
                    echo -ne "${BLUE}------------------------------${NC}"
                    echo -ne "${BLUE}------------------------------${NC}"
                    echo
          for ((i=0;i<9;i++)); do
               row=(${board[$i]})
               for ((j=0;j<9;j++)); do
                    if [ ${row[$j]} -eq 0 ]; then
                         row[$j]=" "
                    fi
               done
               #echo ${row[*]}
               echo -ne " ${BLUE}|${NC}       |         |         ${BLUE}|${NC}"
               echo -ne "         |         |         ${BLUE}|${NC}"
               echo -ne "         |         |         ${BLUE}|${NC}"
               echo
               echo -ne "$((i+1))${BLUE}|${GREEN}   ${row[0]}   ${NC}|${GREEN}  "
               echo -ne "${GREEN}   ${row[1]}   ${NC}|${GREEN}  "
               echo -ne "${GREEN}   ${row[2]}   ${BLUE}|${GREEN}  "
               
               echo -ne "${GREEN}   ${row[3]}   ${NC}|${GREEN}  "
               echo -ne "${GREEN}   ${row[4]}   ${NC}|${GREEN}  "
               echo -ne "${GREEN}   ${row[5]}   ${BLUE}|${GREEN}  "
               
               echo -ne "${GREEN}   ${row[6]}   ${NC}|${GREEN}  "
               echo -ne "${GREEN}   ${row[7]}   ${NC}|${GREEN}  "
               echo -ne "${GREEN}   ${row[8]}   ${BLUE}|${NC}"
               echo
               echo -ne " ${BLUE}|${NC}       |         |         ${BLUE}|${NC}"
               echo -ne "         |         |         ${BLUE}|${NC}"
               echo -ne "         |         |         ${BLUE}|${NC}"
               echo
               if [ $((i % 3)) -eq 2 ] && [ $i -ne 8 ]; then
                    echo -ne " ${BLUE}|---------------------------+${NC}"
                    echo -ne "${BLUE}-----------------------------+${NC}"
                    echo -ne "${BLUE}-----------------------------+${NC}"
                elif [ $i -eq 8 ]; then
                    echo -ne " ${BLUE}-----------------------------${NC}"
                    echo -ne "${BLUE}------------------------------${NC}"
                    echo -ne "${BLUE}------------------------------${NC}"
               else 
                    echo -ne " ${BLUE}|${NC}---------------------------${BLUE}+${NC}"
                    echo -ne "${NC}-----------------------------${BLUE}+${NC}"
                    echo -ne "${NC}-----------------------------${BLUE}+${NC}"
               fi
               echo
          done
     }
     declare -a VanishIndexArray
     defineInitialValue(){
        for ((i=0; i<81; i++)); do
            VanishIndexArray[$i]=$i
        done
    }
     # Function to remove an element from the array
     removeElement() {
          local index=$1
          # Vanish the value from the board
          local vanishVal=${VanishIndexArray[$index]}
          local row=$((vanishVal / 9))
          local col=$((vanishVal % 9))
          local line=(${board[$row]})
          line[$col]=0
          board[$row]="${line[*]}"

          VanishIndexArray=("${VanishIndexArray[@]:0:$index}" "${VanishIndexArray[@]:$((index + 1))}")
     }

     # Function to reinitialize the array
     reinitializeArray() {
          local temp=("${VanishIndexArray[@]}")
          VanishIndexArray=("${temp[@]}")
     }

     # Generate a random value from the array
     generateRandomValue() {
          if [[ ${#VanishIndexArray[@]} -eq 0 ]]; then
               echo "${RED}Error! No more values left to remove.${NC}"
               return
          fi
          arrayLength=${#VanishIndexArray[@]}
          randomIndex=$((RANDOM % arrayLength))
          randomValue=${VanishIndexArray[$randomIndex]}
          removeElement $randomIndex
     }

     # Example usage
     defineInitialValue

     removeRandomValues() {
          local numToRemove=$1
          #echo "Removing $numToRemove random values from the board..."
          #read -p "Press any key to continue..."
          local removed=0
          while ((removed < numToRemove)); do
               generateRandomValue
               reinitializeArray
               removed=$((removed + 1))
          done
     }

     swapRows() {
          local r1=$1
          local r2=$2
          temp="${board[$r1]}"
          board[$r1]="${board[$r2]}"
          board[$r2]="$temp"
     }

     swapCols() {
          local c1=$1
          local c2=$2
          for ((i=0; i<9; i++)) do
          row=(${board[$i]})
          temp="${row[$c1]}"
          row[$c1]="${row[$c2]}"
          row[$c2]="$temp"
          board[$i]="${row[*]}"
          done
     }

     shuffleRows() {
          for block in {0..2}; do
               for ((i=0; i<3; i++)); do
                    ranNum=$((RANDOM % 3))
                    swapRows $((block * 3 + i)) $((block * 3 + ranNum))
               done
          done
     }

     shuffleCols() {
          for block in {0..2}; do
               for ((i=0; i<3; i++)); do
                    ranNum=$((RANDOM % 3))
                    swapCols $((block * 3 + i)) $((block * 3 + ranNum))
               done
          done
     }
     checkValuePossible() {
          local row=$(($1 - 1))
          local col=$(($2 - 1))
          local value=$3

          #echo "Row chosen: $row, Column chosen: $col, Value chosen: $value"
          local rowChosen=(${board[$row]})
          #echo "Row chosen: ${rowChosen[*]}"
          echo

          # Check the row
          if [[ " ${rowChosen[*]} " == *" $value "* ]]; then
               echo "Value already exists in the row. Please enter a different value."
               read -p "Press any key to continue..."
               return 0
          fi

          # Check the column
          for ((i=0; i<9; i++)); do
               line=(${board[$i]})
               if [[ "${line[$col]}" == "$value" ]]; then
                    echo "Value already exists in the column. Please enter a different value."
                    read -p "Press any key to continue..."
                    return 0
               fi
          done

          # Check the block
          local startRow=$(( (row / 3) * 3 ))
          local startCol=$(( (col / 3) * 3 ))
          for ((i=startRow; i<startRow + 3; i++)); do
               local line=(${board[$i]})
               for ((j=startCol; j<startCol + 3; j++)); do
                    if [[ "${line[$j]}" == "$value" ]]; then
                         echo "Value already exists in the block. Please enter a different value."
                         read -p "Press any key to continue..."
                         return 0
                    fi
               done
          done

          return 1
     }
     # Starts the game from here
    
     checkMovePossible() {
          local rowChosen=$1
          local colChosen=$2
          local lineTo=(${board[$rowChosen - 1]})
          if [[ ${lineTo[$colChosen - 1]} == 0 ]]; then
               while true; do
                    clear
                    echo "------------------------------------------"
                    echo "              Sudoku Game        "
                    echo "-------------------------------------------"
                    lineBreak 2
                    printBoard2
                    lineBreak 2
                    echo "You have chosen row:${rowChosen}, col:${colChosen}."
                    lineBreak 1
                    read -p "Enter the value you want to move or 0 to go back: " value
                    if [[ $value -eq 0 ]]; then
                         lineBreak 2
                         echo "Without updating value,"
                         wait 3 "Going back"
                         return
                    fi
                    if [[ $value -ge 1 && $value -le 9 ]]; then
                         checkValuePossible $rowChosen $colChosen $value
                         if [[ $? -eq 1 ]]; then
                              lineTo[$colChosen - 1]=$value
                              board[$rowChosen - 1]="${lineTo[*]}"
                              echo "Value $value moved to row $rowChosen, column $colChosen. Refresh to see the changes."
                              read -p "Press any key to continue..."
                              break
                              #wait 3 "Refreshing"
                         fi
                    else
                         echo "Invalid value. Please enter a number between 1 and 9."
                         read -p "Press any key to continue..."
                    fi
               done
          else
               echo 
               #echo "${lineTo[$colChosen - 1]} and length: ${#lineTo[$colChosen - 1]}"
               echo "You cannot move here. Please select another position."
               wait 3 "Refreshing"
          fi
         # wait 2 "Checking"
     }
     playGame(){
          while true; do
               hasEmpty=0
               for eachline in "${board[@]}"; do
                    if [[ "$eachline" == *"0"* ]]; then
                         hasEmpty=1
                         break;
                    fi
               done
               if [[ $hasEmpty -eq 0 ]]; then
                    lineBreak 2
                    echo "Congratulations! You have completed the game."
                    wait 3 "Exiting"
                    break
               fi
               clear
               echo "--------------------------------------------"
               echo "               Sudoku Game        "
               echo "----------------------------------------------"
               lineBreak 2
               printBoard2
               lineBreak 2
               declare -a rowChosen
               declare -a colChosen
               #echo "Enter 0 at any input to go back,  "
               lineBreak 2
               echo "Choose a position to move a value, or enter 0 to exit game."
               lineBreak 1
               read -p "Enter the row number: " rowChosen
               if [[ $rowChosen -eq 0 ]]; then
                    wait 3 "Going Home Menu"
                    return
               fi
               read -p "Enter the column number: " colChosen
               if [[ $colChosen -eq 0 ]]; then
                    wait 3 "Going Home Menu"
                    return
               fi
               if [[ $rowChosen -ge 1 && $rowChosen -le 9 && $colChosen -ge 1 && $colChosen -le 9 ]]; then
                    checkMovePossible $rowChosen $colChosen
               else
                    echo "Invalid row or column number. Please enter a number between 1 and 9."
                    wait 3 "Refreshing"
               fi
          done
     }
     clear     
     createBoard(){
          shuffleRows
          shuffleCols
               echo "--------------------------------------------"
               echo "               Sudoku Game        "
               echo "----------------------------------------------"
          lineBreak 3
          echo "Choose a level to play:"
          echo "Level 1: Easy"
          echo "Level 2: Medium"
          echo "Level 3: Hard"
          lineBreak 2
          read -p "Choose Level: " level
          if [[ $level -eq 1 ]]; then
               removeRandomValues 15
          elif [[ $level -eq 2 ]]; then
               removeRandomValues 25
          elif [[ $level -eq 3 ]]; then
               removeRandomValues 40
          else
               echo "Invalid level. Please enter a number between 1 and 3."
               wait 3 "Refreshing"
               createBoard
          fi
         # removeRandomValues 20
     }

     
     # Function to check if the board is solvable using backtracking
     isSolvable() {
          local board=("$@")  # Copy the board into a local array

          isSafe() {
               local row=$1
               local col=$2
               local num=$3

               # Check row
               for ((x=0; x<9; x++)); do
                    if [[ ${board[$row]:$((x*2)):1} == $num ]]; then
                         return 1
                    fi
               done

               # Check column
               for ((x=0; x<9; x++)); do
                    if [[ ${board[$x]:$((col*2)):1} == $num ]]; then
                         return 1
                    fi
               done

               # Check 3x3 box
               local startRow=$((row - row % 3))
               local startCol=$((col - col % 3))
               for ((i=0; i<3; i++)); do
                    for ((j=0; j<3; j++)); do
                         if [[ ${board[$((startRow + i))]:$(((startCol + j)*2)):1} == $num ]]; then
                              return 1
                         fi
                    done
               done

               return 0
          }

          solveSudoku() {
               for ((row=0; row<9; row++)); do
                    for ((col=0; col<9; col++)); do
                         if [[ ${board[$row]:$((col*2)):1} == '.' ]]; then
                              for num in {1..9}; do
                              if isSafe $row $col $num; then
                                   # Place the number
                                   board[$row]="${board[$row]:0:$((col*2))}$num${board[$row]:$((col*2+1))}"

                                   # Recursively try to solve the rest
                                   if solveSudoku; then
                                        return 0
                                   else
                                        # If it didn't work, backtrack
                                        board[$row]="${board[$row]:0:$((col*2))}.${board[$row]:$((col*2+1))}"
                                   fi
                              fi
                              done
                              return 1
                         fi
                    done
               done
               return 0
          }

          solveSudoku
          return $?
     }

     while true; do
          createBoard
          clear
          lineBreak 3
          echo "    Shuffled Board:"
          lineBreak 2
          printBoard2
          lineBreak 2
          echo "Checking if the board is solvable..."

          lineBreak 1
          if isSolvable "${board[@]}"; then
               echo "The Sudoku board is solvable."
          else
               echo "The Sudoku board is not solvable."
               wait 3 "Generating new board"
               continue
          fi
          lineBreak 2
          echo "1. Start game with this board"
          echo "2. Generate a new board"
          echo "3. Go back to main menu"
          echo "4. Exit"
          lineBreak 2
          read -p "Enter choice: " choice
          if [[ $choice -eq 1 ]]; then
               wait 2 "Starting Game"
               playGame
               return
          elif [[ $choice -eq 2 ]]; then
               wait 2 "Generating new board"
               PlaySudokugame
          elif [[ $choice -eq 3 ]]; then
               wait 3 "Going back"
               return
          elif [[ $choice -eq 4 ]]; then
               Exit
          else
               echo "Invalid choice. Please enter between 1 to 4."
               wait 3 "Refreshing"
          fi
     done
}


showOptions() {
     echo "------------------------------------"
     echo "           My Assistant"
     echo "------------------------------------"
     lineBreak 2
     echo "1. Create files"
     echo "2. Move files"
     echo "3. Copy files"
     echo "4. Delete files"
     echo "5. View files text"
     echo "6. Insert Text To File"
     echo "7. Search a file"
     echo "8. Change current directory"
     echo "9. Play Sudoku game"
     echo "10. Exit"
     lineBreak 2
}


#main function 
main(){
     clear
     while true; do
          clear
          showOptions
          read -p "Enter your choice: " choice
          case $choice in
               1) Create;;
               2) copyFiles "mv" "move" "Move" "moved";;
               3) copyFiles "cp" "copy" "Copy" "Copied";;
               4) DeleteFiles;;
               5) viewFileContent;;
               6) insertTextToFile;;
               7) searchItem;;
               8) ChangeDirectory;;
               9) PlaySudokugame;;
              10) Exit;;
               *) echo "Invalid choice. Please try again.";;
          esac
     done
}
main