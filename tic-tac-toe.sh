#!/bin/bash

source ./print_functions.sh
source ./game_functions.sh

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

