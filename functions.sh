#!/bin/bash
function is_number {
    clear
};

function check_win {
    clear
};

function check_game {
    clear
};

function print_board {
    clear
    echo "| ${board[0]} ${board[1]} ${board[2]} |"
    echo "| ${board[3]} ${board[4]} ${board[5]} |"
    echo "| ${board[6]} ${board[7]} ${board[8]} |"
    printf "Enter: "
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

