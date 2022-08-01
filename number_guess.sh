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
echo "Guess the secret number between 1 and 1000:"
read GUESS
GUESSNO=1
CATCHER(){
  echo $1
  read GUESS
  GAME
}
GAME(){ 
  if [[ $GUESS =~ ^[0-9]+$ ]]
  then
    while [[ $GUESS -ne $R ]]
    do

      if [[ $GUESS =~ ^[0-9]+$ ]]
      then
        if [ $GUESS -lt $R ]
        then
          echo "It's higher than that, guess again:"
          read GUESS
          ((GUESSNO=GUESSNO+1))
        else
          echo "It's lower than that, guess again:"
          read GUESS
          ((GUESSNO=GUESSNO+1))
        fi
        
      else
        CATCHER "That is not an integer, guess again:" 
      fi
    done
  else
GAME


INSERT_TO_DATABASE2=$($PSQL "UPDATE userbase SET games_played = $GAMES_PLAYED WHERE username = '$USERNAME'")
if [[ $GUESSNO -le $BEST_GAME ]];
then
  INSERT_TO_DATABASE3=$($PSQL "UPDATE userbase SET best_game = $GUESSNO WHERE username = '$USERNAME'")
fi

echo "You guessed it in "$GUESSNO" tries. The secret number was "$R". Nice job!"
#echo "Good job $R was it with $GUESSNO guesses "