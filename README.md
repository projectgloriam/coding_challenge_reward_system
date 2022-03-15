# Coding Challenge Reward System

This system (Ruby) calculates rewards based on recommendations of customers. The system uses a single controller and action for the job. I decided to use string split and regex methods to extract the customers (Party A and Party B) and their decisions (recommend or accept). Each new line is an array item. If it reaches the turn of the "accept" decision, the appropriate customers will be rewarded. i.e. (1/2)^k points for each confirmed invitation. where k is the level of the invitation. If it reaches the "recommend" decision, the customers are stored, including the invitation but the invitation is not confirmed. 

The endpoint is `welcome_controller.rb` in the `app/controllers/` folder. 

Please follow the instructions below to set up. 

Things you may need:

* Ruby version 2.7.4

* Rails version 7.0.0

## How to get started

Clone the repository:
```
$ git clone https://github.com/projectgloriam/coding_challenge_reward_system
```

Change to the directory
```
$ cd coding_challenge_reward_system
```

Install the gems (libraries)
```
$ bundle install 
```

Migrate the database:
```
$ rails db:migrate
```

Run the app
```
$ rails s
```

Test the app with the sample data `example.txt` using this command
```
curl -X POST localhost:3000/welcome --data-binary @example.txt -H "Content-Type: text/plain"
```