#! /bin/bash

if [[ $1 == "test" ]]
then
  PSQL="psql --username=postgres --dbname=worldcuptest -t --no-align -c"
else
  PSQL="psql --username=freecodecamp --dbname=worldcup -t --no-align -c"
fi

# Do not change code above this line. Use the PSQL variable above to query your database.

$PSQL "truncate table games, teams;"
INSERT="insert into games (year, round, winner_id, opponent_id, winner_goals, opponent_goals) VALUES ";

cat games.csv | while IFS=',' read YEAR ROUND WINNER OPPONENT W_GOALS O_GOALS
do
  [ $YEAR == "year" ] && continue;
  #echo $WINNER $OPPONENT
  WINNER_ID=$($PSQL "SELECT team_id FROM teams where name = '$WINNER'")
  if [[ -z $WINNER_ID ]]
  then
    echo -e -n "\nInserting WINNER $WINNER : "
    $PSQL "INSERT INTO teams (name) values ('$WINNER')";
    WINNER_ID=$($PSQL "SELECT team_id FROM teams where name = '$WINNER'")
  fi
  OPPONENT_ID=$($PSQL "SELECT team_id FROM teams where name = '$OPPONENT'")
  if [[ -z $OPPONENT_ID ]]
  then 
    echo -e -n "\nInserting OPPONENT $OPPONENT : "
    $PSQL "INSERT INTO teams (name) values ('$OPPONENT')";
    OPPONENT_ID=$($PSQL "SELECT team_id FROM teams where name = '$OPPONENT'")
  fi
  echo -e -n "Inserting GAME "
  ROW="($YEAR, '$ROUND', $WINNER_ID, $OPPONENT_ID, $W_GOALS, $O_GOALS)";
  $PSQL "$INSERT $ROW";
done

