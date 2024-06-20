#!/bin/bash

PSQL="psql --username=freecodecamp --dbname=periodic_table -t --no-align -c"

if [[ -z $1 ]]
then 
  echo Please provide an element as an argument.
else
# check if input is an integer
  if [[ $1 =~ ^[0-9]+$ ]]
  then
    ELEMENT_INPUT=$($PSQL "SELECT atomic_number FROM elements WHERE atomic_number=$1;")
  else
    ELEMENT_INPUT=$($PSQL "SELECT atomic_number FROM elements WHERE symbol='$1' OR name='$1';")
  fi
  if [[ -z $ELEMENT_INPUT ]]
  then
    echo I could not find that element in the database.
  else
    ATOMIC_NUMBER=$($PSQL "SELECT atomic_number FROM elements WHERE atomic_number=$ELEMENT_INPUT;")
    NAME=$($PSQL "SELECT name FROM elements WHERE atomic_number=$ELEMENT_INPUT;")
    SYMBOL=$($PSQL "SELECT symbol FROM elements WHERE atomic_number=$ELEMENT_INPUT;")
    TYPE=$($PSQL "SELECT type FROM types FULL JOIN properties ON types.type_id = properties.type_id WHERE atomic_number=$ATOMIC_NUMBER;") 
    ATOMIC_MASS=$($PSQL "SELECT atomic_mass FROM properties WHERE atomic_number=$ATOMIC_NUMBER;")
    MELTING_POINT=$($PSQL "SELECT melting_point_celsius FROM properties WHERE atomic_number=$ATOMIC_NUMBER;")
    BOILING_POINT=$($PSQL "SELECT boiling_point_celsius FROM properties WHERE atomic_number=$ATOMIC_NUMBER;")
    echo The element with atomic number $ATOMIC_NUMBER is $NAME \($SYMBOL\). It\'s a $TYPE, with a mass of $ATOMIC_MASS amu. $NAME has a melting point of $MELTING_POINT celsius and a boiling point of $BOILING_POINT celsius.
  fi
fi

