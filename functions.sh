#!/bin/bash

game_on=true
player=1
game_type=-1
board=(1 2 3 4 5 6 7 8 9)
moves=0

function check_if_save_is_valid {
    read -r -a temp < "$1"
    arr_length=${#temp[@]}
    if [ "$arr_length" -ne 9 ]; then
        echo "Invalid field count in save"
        echo "Should be 9 but there is ${arr_length}"
        return 1
    fi
    moves_in_save=0
    x_count=0
    y_count=0
    id=0
    for element in "${temp[@]}"
    do
        id=$((id+1))
        if [ "$element" == "X" ]; then
            moves_in_save=$((moves_in_save+1))
            x_count=$((x_count + 1))
            continue
        fi
        if [ "$element" == "O" ]; then
            moves_in_save=$((moves_in_save+1))
            y_count=$((y_count + 1))
            continue
        fi
        if [ "$element" -eq "$id" ]; then
            continue
        fi
        echo "Invalid field in save: ${element} (expected $id or X or O)"
        return 1
    done
    
    if [ $x_count -ne $y_count ]; then
        echo "X and O does not match in save."
        return 1
    fi
    return 0
}

function load {
    read -r -a board < "$1"
    check_all
    
};

function menu {
    clear
    echo "Menu:"
    echo "1. New game"
    echo "2. Load game"
    printf "Select: "
    read -r load_game
    if [ "$load_game" -eq 2 ]; then
        while true; do
            printf "Enter save game name (or type RETURN to start new game): "
            read -r save
            if [ -e "$save" ]; then
                if check_if_save_is_valid "$save"; then
                    load "$save"
                    break;
                else
                    echo "Save is not valid"
                fi
                elif [ "$save" == "RETURN" ]; then
                break;
            else
                echo "Save game does not exist"
            fi;
        done;
    fi;
    clear
    echo "Game types:"
    echo "1. Play with computer"
    echo "2. Two players (turn-based multiplayer)"
    printf "Select: "
    read -r game_type
};

function check_row {
    if [ "${board[$1]}" == "${board[$2]}" ] && [ "${board[$2]}" == "${board[$3]}" ]; then
        game_on=false
    fi
};

function check_all {
    check_row 0 1 2
    check_row 3 4 5
    check_row 6 7 8
    check_row 0 3 6
    check_row 1 4 7
    check_row 2 5 8
    check_row 2 4 6
    check_row 0 4 8
    if [ $game_on == false ]; then
        print_board
        echo "Player $player won."
        exit
    fi
    
    if [ $moves -eq 9 ]; then
        print_board
        echo "Draw."
        exit
    fi
};

function print_board {
    clear
    echo "Tic-tac-toe game"
    echo "Board:"
    echo "| ${board[0]} ${board[1]} ${board[2]} |"
    echo "| ${board[3]} ${board[4]} ${board[5]} |"
    echo "| ${board[6]} ${board[7]} ${board[8]} |"
    echo "Player move: $player"
};

function change_player {
    if [ $player -eq 1 ]; then
        player=2
    else
        player=1
    fi
}

function make_move {
    if [ $player -eq 1 ]; then
        board[$1]="X"
    else
        board[$1]="O"
    fi
    echo "Player $player make move $1" >> log.txt
}

function select_field {
    if [ $player -eq 1 ]; then
        echo "New round. You can save or exit here."
        printf "Select field (number) or 'S' to save or 'E' to exit: "
    else
        printf "Select field (number): "
    fi
    
    read -r selected_field
    
    re='^[0-9]+$'
    
    while ! [[ $selected_field =~ $re ]] && ! [ "$selected_field" == "S" ] && ! [ "$selected_field" == "E" ]; do
        echo "Invalid input."
        if [ $player -eq 1 ]; then
            printf "Select field (number) or 'S' to save or 'E' to exit: "
        else
            printf "Select field (number): "
        fi
        read -r selected_field
    done
    
    if [ "$selected_field" == "S" ] && [ $player -eq 1 ]; then
        printf "Enter file name:"
        read -r save_name
        echo "${board[@]}" > "$save_name"
        printf "Select field: "
        read -r selected_field
    fi
    
    if [ "$selected_field" == "E" ] && [ $player -eq 1 ]; then
        exit
    fi
    
    while ! [[ $selected_field =~ $re ]] || [ "$selected_field" -lt 1 ] || [ "$selected_field" -gt 9 ] || [ "${board[$((selected_field-1))]}" == "X" ] || [ "${board[$((selected_field-1))]}" == "O" ]; do
        echo "Incorrect field select"
        printf "Select field: "
        read -r selected_field
    done
    make_move $((selected_field-1))
}

function cpu_move {
    selected_field=$((RANDOM % 9))
    while [ "${board[$selected_field]}" == "X" ] || [ "${board[$selected_field]}" == "O" ]; do
        selected_field=$((RANDOM % 9))
    done
    make_move $selected_field
}

function play {
    while true ;
    do
        print_board
        if [ $player -eq 2 ] && [ "$game_type" -eq 1 ]; then
            cpu_move
        else
            select_field
        fi
        moves=$((moves+1))
        check_all
        
        change_player
    done
}