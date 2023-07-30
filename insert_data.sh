#! /bin/bash

if [[ $1 == "test" ]]
then
  PSQL="psql --username=postgres --dbname=worldcuptest -t --no-align -c"
else
  PSQL="psql --username=freecodecamp --dbname=worldcup -t --no-align -c"
fi

# Do not change code above this line. Use the PSQL variable above to query your database.

# ----- ADD TEAMS ----- #
cat games.csv | while IFS=',' read YEAR ROUND WINNER OPPONENT WINNER_GOALS OPPONENT_GOALS
do
  LINE="$YEAR $ROUND $WINNER $OPPONENT $WINNER_GOALS $OPPONENT_GOALS"
  if [[ $LINE == "year round winner opponent winner_goals opponent_goals" ]]
  then
    # DO NOTHING
    :
  else

    # Get the team IDs;
    WINNER_TEAM_ID="$($PSQL "SELECT team_id FROM teams WHERE name = '$WINNER';")"
    OPPONENT_TEAM_ID="$($PSQL "SELECT team_id FROM teams WHERE name = '$OPPONENT';")"

    # Check if the winner team ID is in the table already (if the team was added already);
    # If already there : do nothing.
    # If not : add to table.
    if [[ -z "$WINNER_TEAM_ID" ]]
    then
      echo "$($PSQL "INSERT INTO teams(name) VALUES('$WINNER');")"
    else
      # DO NOTHING
      :
    fi

    # Check if the opponent team ID is in the table already (if the team was added already);
    # If already there : do nothing.
    # If not : add to table.
    if [[ -z "$OPPONENT_TEAM_ID" ]]
    then
      echo "$($PSQL "INSERT INTO teams(name) VALUES('$OPPONENT');")"
    else
      # DO NOTHING
      :
    fi

  fi


done

# ----- ADD GAMES ----- #

cat games.csv | while IFS="," read YEAR ROUND WINNER OPPONENT WINNER_GOALS OPPONENT_GOALS
do
  LINE="$YEAR $ROUND $WINNER $OPPONENT $WINNER_GOALS $OPPONENT_GOALS"
  if [[ $LINE == "year round winner opponent winner_goals opponent_goals" ]]
  then
    # DO NOTHING
    :
  else

    WINNER_ID="$($PSQL "SELECT team_id FROM teams WHERE name = '$WINNER';")"
    OPPONENT_ID="$($PSQL "SELECT team_id FROM teams WHERE name = '$OPPONENT';")"

    GAME_ID="$($PSQL "SELECT * FROM games WHERE year = '$YEAR' AND round = '$ROUND' AND winner_id = '$WINNER_ID' AND opponent_id = '$OPPONENT_ID' AND winner_goals = '$WINNER_GOALS' AND opponent_goals = '$OPPONENT_GOALS';")"

    # Check if this specific game_id exists.
    # If exists, do nothing;
    # If it doesnt exist, insert the row.
    if [[ -z "$GAME_ID" ]]
    then
      echo "$($PSQL "INSERT INTO games(year, round, winner_id, opponent_id, winner_goals, opponent_goals) VALUES($YEAR, '$ROUND', $WINNER_ID, $OPPONENT_ID, $WINNER_GOALS, $OPPONENT_GOALS);")"
    else
      # DO NOTHING
      :
    fi

  fi
done
