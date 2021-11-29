# Tic-Tac-Toe bash game

Files:
- play.sh - script that runs game
- functions.sh - library containing all necessary functions to perform tic-tac-toe game

How to play:
1. Execute script "./play.sh".
2. Choose if you want to start new game (option 1) or load game (option 2) from file.
  Please enter "1" or "2".
  If you chose "2": 
  You can load game from any file that have following format:
  ```
  1 2 3 4 5 6 7 8 9
  ```
  Where any of these numbers can also be either 'O' or 'X' (then, that field is selected as X or O).
  Each number 1..9 is the number of the given field:
  ```
  1 2 3
  4 5 6
  7 8 9
  ```
  You can load only saves after both players move, so the count of X and the count of O are equal.
  If you load save with satisfied winning condition, the game will stop immediately after start.

3. Choose if you want to play versus computer or another player.
4. Player 1 (X) starts. To play you have to input number of the field. You can't choose field which is already filled with O or X.
  After entering valid number, the player changes (the second player or computer makes move).
  The board is shown on the screen.
  At the start of round (after both players move) you can [E]xit the game or [S]ave.
5. The game ends when winning condition is satisfied or every field is filled, which results in draw (after 9 moves).
