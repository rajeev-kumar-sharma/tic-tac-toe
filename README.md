# README

This README would normally document whatever steps are necessary to get the
application up and running.

Things you may want to cover:

* Ruby version

* System dependencies

* Configuration

* Database creation

* Database initialization

* How to run the test suite

* Services (job queues, cache servers, search engines, etc.)

* Deployment instructions

* ...

## APIs

### Player

  1.  Create a user
  
  ```curl
  curl -X POST \
  http://localhost:4000/users \
  -d '{
    "email": "rajeev_sharma@outlook.in"
  }'
  ```

  ```curl
  curl -X POST \
  http://localhost:4000/users \
  -d '{
    "email": "rajeev-sharma@outlook.in"
  }'
  ```

  2.  Make a user online
  
  ```curl
  curl -X PUT \
  http://localhost:4000/users/1 \
  -d '{
    "online": true
  }'
  ```

  ```curl
  curl -X PUT \
  http://localhost:4000/users/2 \
  -d '{
    "online": true
  }'
  ```

### Game

  1.  Start game

  ```curl
  curl -X POST \
  http://localhost:4000/games \
  -d '{
	  "player_1": 1
  }'
  ```

  2.  Check for other user and start play

  ```curl
  curl -X PUT http://localhost:4000/games/1
  ```

  3.  Check game details

  ```curl
  curl -X GET http://localhost:4000/games/1
  ```

### Move

  1.  Make a move

  ```curl
  curl -X POST \
  http://localhost:4000/moves \
  -d '{
    "game_id": 1,
    "user_id": 1,
    "x": 1,
    "y": 1
  }'
  ```