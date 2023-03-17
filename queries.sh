#! /bin/bash

PSQL="psql --username=freecodecamp --dbname=worldcup --no-align --tuples-only -c"

# Do not change code above this line. Use the PSQL variable above to query your database.

echo -e "\nTotal number of goals in all games from winning teams:"
echo "$($PSQL "SELECT SUM(winner_goals) FROM games")"

echo -e "\nTotal number of goals in all games from both teams combined:"
echo "$($PSQL "SELECT SUM(winner_goals + opponent_goals) FROM games")"

echo -e "\nAverage number of goals in all games from the winning teams:"
echo "$($PSQL "SELECT AVG(winner_goals) FROM games")"

echo -e "\nAverage number of goals in all games from the winning teams rounded to two decimal places:"
echo "$($PSQL "SELECT ROUND(AVG(winner_goals), 2) FROM games")"

echo -e "\nAverage number of goals in all games from both teams:"
echo "$($PSQL "SELECT AVG(winner_goals + opponent_goals) FROM games")"


echo -e "\nMost goals scored in a single game by one team:"
Q="select case when (select max(winner_goals) from games) > (select max(opponent_goals) from games) then (select max(winner_goals) from games) else (select max(opponent_goals) from games) end;"
echo "$($PSQL "$Q")"

echo -e "\nNumber of games where the winning team scored more than two goals:"
echo "$($PSQL "SELECT count(*) FROM games where winner_goals > 2")"

echo -e "\nWinner of the 2018 tournament team name:"
echo "$($PSQL "SELECT name FROM games left join teams on team_id = winner_id where year = 2018 and round = 'Final'")"

echo -e "\nList of teams who played in the 2014 'Eighth-Final' round:"
echo "$($PSQL "SELECT distinct(name) FROM games left join teams on (team_id = winner_id or team_id = opponent_id) where year = 2014 and round = 'Eighth-Final' order by name")"


echo -e "\nList of unique winning team names in the whole data set:"
echo "$($PSQL "SELECT distinct(name) FROM teams inner join games on team_id = winner_id order by name")"

echo -e "\nYear and team name of all the champions:"
echo "$($PSQL "SELECT year, name FROM games left join teams on team_id = winner_id where round = 'Final' order by year")"

echo -e "\nList of teams that start with 'Co':"
echo "$($PSQL "SELECT name FROM teams where name like 'Co%'")"

