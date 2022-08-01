#!/bin/bash
PSQL="psql --username=freecodecamp --dbname=number_guess -t --no-align -c"
R=$(($(($RANDOM%1000))+1))
echo $R
echo "Enter your username: " 
read USER_NAME

USERNAME=$($PSQL "SELECT username FROM userbase WHERE username = '$USER_NAME'")




if [[ -z $USERNAME ]]
then 
  USERNAME=$USER_NAME
  echo "Welcome, $USERNAME! It looks like this is your first time here."
  INSERT_TO_DATABASE=$($PSQL "INSERT INTO userbase (username,games_played,best_game) VALUES ('$USERNAME',0,1)")
  GAMES_PLAYED=$($PSQL "SELECT games_played FROM userbase WHERE username = '$USER_NAME'")
  BEST_GAME=$($PSQL "SELECT best_game FROM userbase WHERE username = '$USER_NAME'")
else
  #USERNAME=$($PSQL "SELECT username FROM userbase WHERE username = '$USER_NAME'")
  GAMES_PLAYED=$($PSQL "SELECT games_played FROM userbase WHERE username = '$USERNAME'")
  BEST_GAME=$($PSQL "SELECT best_game FROM userbase WHERE username = '$USERNAME'")
  echo "Welcome back, $USERNAME! You have played $GAMES_PLAYED games, and your best game took $BEST_GAME guesses."
fi
