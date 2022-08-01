#!/bin/bash
PSQL="psql --username=freecodecamp --dbname=number_guess -t --no-align -c"
R=$(($(($RANDOM%1000))+1))
echo $R