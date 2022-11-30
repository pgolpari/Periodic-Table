#!/bin/bash

PSQL="psql -X --username=freecodecamp --dbname=periodic_table --tuples -c"

if [[ ! $1 ]]
then
  echo -e "Please provide an element as an argument."
  exit
fi
ELEMENT=$1

# Get element data if input is numeric (atomic_number)
if (( $ELEMENT > 0 && $ELEMENT < 11 ))
then
   RESULT=$($PSQL "select * from elements e inner join properties p using(atomic_number) left join types t using(type_id) where e.atomic_number=$ELEMENT")
   if [[ ! -z $RESULT ]]
   then
     echo "$RESULT" | while read TYPE_ID BAR ATOMIC_NUMBER BAR SYMBOL BAR NAME BAR ATOMIC_MASS BAR MPC BAR BPC BAR TYPE
     do
       echo -e "The element with atomic number $ATOMIC_NUMBER is $NAME ($SYMBOL). It's a $TYPE, with a mass of $ATOMIC_MASS amu. $NAME has a melting point of $MPC celsius and a boiling point of $BPC celsius."
     done  
     exit
   fi
fi

# Get element data if input is non-numeric (i.e: symbol or name)
RESULT=$($PSQL "select * from elements e inner join properties p using(atomic_number) left join types t using(type_id) where symbol='$ELEMENT' or name='$ELEMENT'")
if [[ ! -z $RESULT ]]
then
  echo "$RESULT" | while read TYPE_ID BAR ATOMIC_NUMBER BAR SYMBOL BAR NAME BAR ATOMIC_MASS BAR MPC BAR BPC BAR TYPE
  do
    echo -e "The element with atomic number $ATOMIC_NUMBER is $NAME ($SYMBOL). It's a $TYPE, with a mass of $ATOMIC_MASS amu. $NAME has a melting point of $MPC celsius and a boiling point of $BPC celsius."
  done  
  exit
fi

echo -e "I could not find that element in the database."
