#!/bin/bash

game_on=true
player=1
game_type=-1
board=(1 2 3 4 5 6 7 8 9)
moves=0

function reset_board {
    board=(1 2 3 4 5 6 7 8 9)
};

function load {
    read -r -a board < "$1"
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
            printf "Enter save game name: "
            read -r save
            if [ -e "$save" ]; then
                load "$save"
                break;
            else
                echo "Save game does not exists"
            fi;
        done;
    fi;
};

function print_game_type {
    clear
    echo "Game types:"
    echo "1. Play with computer"
    echo "2. Two players (turn-based multiplayer)"
    printf "Select: "
    read -r game_type
};

function init_game {
    rm log.txt
    touch log.txt
    menu
    print_game_type
    
    if [ "$game_type" -eq 1 ] ; then
        play_with_cpu
        elif [ "$game_type" -eq 2 ] ; then
        play_with_player
    fi
}

function check_win {
    if [ "${board[$1]}" == "${board[$2]}" ] && [ "${board[$2]}" == "${board[$3]}" ]; then
        game_on=false
    fi
};

function check_game {
    check_win 0 1 2
    check_win 3 4 5
    check_win 6 7 8
    check_win 0 3 6
    check_win 1 4 7
    check_win 2 5 8
    check_win 2 4 6
    check_win 0 4 8
};

function check_draw {
    if [ $moves -ge 9 ]; then
        game_on=false
    fi
}

function print_board {
    clear
    echo "Fields:"
    echo "| ${board[0]} ${board[1]} ${board[2]} |"
    echo "| ${board[3]} ${board[4]} ${board[5]} |"
    echo "| ${board[6]} ${board[7]} ${board[8]} |"
};

function change_player {
    if [ $player -eq 1 ]; then
        player=2
    else
        player=1
    fi
}

function select_field {
    printf "Select field or 'S' to save or 'E' to exit: "
    read -r selected_field
    if [ "$selected_field" == "S" ] || [ "$selected_field" == "s" ]; then
        printf "Enter file name:"
        read -r save_name
        echo "${board[@]}" > "$save_name"
        elif [ "$selected_field" == "E" ] || [ "$selected_field" == "e" ]; then
        exit
    else
        selected_field=$selected_field-1
        while [ "$selected_field" -lt 1 ] || [ "$selected_field" -gt 9 ] || [ "${board[$selected_field]}" == "X" ] || [ "${board[$selected_field]}" == "O" ]; do
            echo "Incorrect field select"
            printf "Select field: "
            read -r selected_field
            selected_field=$((selected_field-1))
        done
        if [ $player -eq 1 ]; then
            board[$selected_field]="X"
        else
            board[$selected_field]="O"
        fi
    fi
    echo "Player $player make move $selected_field" >> log.txt
}

function play_with_player {
    while [ $game_on == true ];
    do
        print_board
        select_field
        check_game
        if [ $game_on == false ]; then
            print_board
            echo "Player $player won."
        fi
        change_player
    done
}

function cpu_make_move {
    selected_field=$((RANDOM % 9))
    while [ "$selected_field" -lt 0 ] || [ "$selected_field" -gt 8 ] || [ "${board[$selected_field]}" == "X" ] || [ "${board[$selected_field]}" == "O" ]; do
        selected_field=$((RANDOM % 9))
    done
    if [ $player -eq 1 ]; then
        board[$selected_field]="X"
    else
        board[$selected_field]="O"
    fi
    echo "Player $player make move $selected_field" >> log.txt
}

function play_with_cpu {
    while true ;
    do
        print_board
        if [ $player -eq 1 ]; then
            select_field
            elif [ $player -eq 2 ]; then
            cpu_make_move
        fi
        check_game
        if [ $game_on == false ]; then
            print_board
            echo "Player $player won."
            exit
        fi
        check_draw
        if [ $game_on == false ]; then
            print_board
            echo "Draw."
            exit
        fi
        change_player
    done
}