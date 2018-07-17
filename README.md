# Faqbot

Faqbot is a bot developed in Ruby using Sinatra framework. This bot can be used for growing
a Frequently Asked Question (FAQ). You can create, list, remove and search questions with Faqbot.
It also has a link aggregator so you can add, list and remove links as well.

## Getting Started

To get started you can copy or fork this repository to your machine/github account and build it by yourself.

### Prerequisites

You need install docker/docker-compose to build this project.
To get more information about it check: [Docker Installation](https://docs.docker.com/engine/installation/)

### Building

After installed docker/docker-compose, go to project folder on terminal and run the following command to build the rails environment enter (Depending on your docker installation, you'll need to run with root permissions)

```
docker-compose build
```

Then, you'll run the db:create and db:migrate

```
docker-compose run --rm app rake db:create
```

```
docker-compose run --rm app rake db:migrate
```

There are some spec tests, to run them type
```
docker-compose run --rm app rspec
```

After this you'll need to create an account on [Dialogflow](https://dialogflow.com/) and [Heroku](https://heroku.com/).
Then you'll deploy the app on Heroku. To learn how to do this check [Deploy Heroku with Git](https://devcenter.heroku.com/articles/git)
It's necessary to create an agent on Dialogflow. To learn how to do this check [First Agent](https://dialogflow.com/docs/getting-started/building-your-first-agent)

After these steps, you'll use your agent to create intents. Notice that an intent is something your agent
shall understand on a natural language. Each intent you create must have an action with the same name on parameters that you can check on app/services/interpret_service.rb to execute something on faqbot.
Notice that some intents will need parameters to do their work. Those parameters must be specified on intent.

Having made deploy and agent you can integrated the agent with some app like Slack. [See how to do this](https://dialogflow.com/docs/integrations/)

## Built With

* [Ruby](https://www.ruby-lang.org/en/)
* [Sinatra](http://www.sinatrarb.com/)
* [Docker](https://www.docker.com/)
* [PostgreSQL](https://www.postgresql.org/)
* [Dialogflow](http://dialogflow.com/)

## Authors

* **Maicon Vinicios** - [maiconvos](https://github.com/maiconvos)

## How to contribute

If you want to help this project you can develop features and send a pull request.
