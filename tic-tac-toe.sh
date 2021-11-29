#!/bin/bash

game_on=true
player=1
game_type=-1
load_game=-1
board=(1 2 3 4 5 6 7 8 9)

function is_number {
    clear
};

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

function print_board {
    clear
    echo "GAME: ${game_on}"
    echo "Fields:"
    echo "| ${board[0]} ${board[1]} ${board[2]} |"
    echo "| ${board[3]} ${board[4]} ${board[5]} |"
    echo "| ${board[6]} ${board[7]} ${board[8]} |"
};

function print_menu {
    echo "Menu:"
    echo "1. New game"
    echo "2. Load game"
    printf "Enter: "
};

function print_game_type {
    echo "Game types:"
    echo "1. Play with computer"
    echo "2. Two players"
    printf "Enter: "
};

function change_player {
    if [ $player -eq 1 ]; then
        player=2
    else
        player=1
    fi
}

function select_field {
    printf "Select field: "
    read -r selected_field
    selected_field=$selected_field-1
    while [ "$selected_field" -lt 1 ] || [ "$selected_field" -gt 9 ] || [ "${board[$selected_field]}" == "X" ] || [ "${board[$selected_field]}" == "O" ]; do
        echo "Incorrect field select"
        printf "Select field: "
        read -r selected_field
        selected_field=$selected_field-1
    done
    if [ $player -eq 1 ]; then
        board[$selected_field]="X"
    else
        board[$selected_field]="O"
    fi
}

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

