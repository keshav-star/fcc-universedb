#! /bin/bash

if [[ $1 == "test" ]]
then
  PSQL="psql --username=postgres --dbname=worldcuptest -t --no-align -c"
else
  PSQL="psql --username=freecodecamp --dbname=worldcup -t --no-align -c"
fi

# Do not change code above this line. Use the PSQL variable above to query your database.

cat games.csv | while IFS="," read YEAR ROUND WINNER OPPONENT WIN_GOALS OPP_GOALS
do
  if [[ $WINNER != "winner" ]]
  then
    #get team_id
    WIN_ID=$($PSQL "SELECT team_id FROM teams WHERE name='$WINNER'")
    
    #if not found
    if [[ -z $WIN_ID ]]
    then
      #insert team
      INSERT_TEAM_NAME=$($PSQL "INSERT INTO teams(name) values('$WINNER')")
      
      if [[ $INSERT_TEAM_NAME == "INSERT 0 1" ]]
      then
        echo Inserted into teams, $WINNER
      fi
      #new winner id
      WIN_ID=$($PSQL "SELECT team_id FROM teams WHERE name='$WINNER'")
    fi
  fi

  if [[ $OPPONENT != "opponent" ]]
  then
    #get team_id
    OPP_ID=$($PSQL "SELECT team_id FROM teams WHERE name='$OPPONENT'")
    
    #if not found
    if [[ -z $OPP_ID ]]
    then
      #insert team
      INSERT_TEAM_NAME=$($PSQL "INSERT INTO teams(name) values('$OPPONENT')")
      
      if [[ $INSERT_TEAM_NAME == "INSERT 0 1" ]]
      then
        echo Inserted into teams, $OPPONENT
      fi
      #new Opponent ID
      OPP_ID=$($PSQL "SELECT team_id FROM teams WHERE name='$OPPONENT'")
    fi
  fi

  if [[ $YEAR != 'year' ]]
  then
    INSERT_RESULT=$($PSQL "INSERT INTO games(year,round,winner_goals,opponent_goals,winner_id,opponent_id) values ($YEAR,'$ROUND',$WIN_GOALS,$OPP_GOALS,$WIN_ID,$OPP_ID)")
    echo "$INSERT_RESULT with $YEAR , $ROUND , $WIN_ID , $OPP_ID"
  fi
done
