#!/bin/bash

if [[ -z $1 ]]
then
  echo "Please provide an element as an argument."
else
  if [[ $1 =~ ^[1-9]\d*$ ]]
  then
    CONDITION="atomic_number = $1"
  else
    CONDITION="symbol = '$1' OR name = '$1'"
  fi
  IFS="|"
  read NUMBER NAME SYMBOL TYPE MASS MELTING BOILING <<< "$(psql -U freecodecamp -d periodic_table -A -t -c "SELECT atomic_number, name, symbol, type, atomic_mass, melting_point_celsius, boiling_point_celsius FROM elements INNER JOIN properties USING(atomic_number) INNER JOIN types USING(type_id) WHERE $CONDITION LIMIT 1")"
  if [[ -z $NUMBER ]]
  then
    echo "I could not find that element in the database."
  else
    echo "The element with atomic number $NUMBER is $NAME ($SYMBOL). It's a $TYPE, with a mass of $MASS amu. $NAME has a melting point of $MELTING celsius and a boiling point of $BOILING celsius."
  fi
fi