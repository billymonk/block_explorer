# NEAR Block Explorer

---

## Get Started

Follow these steps to run the project locally:

### Prerequisites 
- Ruby 3.2.2
- PostgreSQL (I recommend Postgres.app but use what you're comfortable with)

## Setup Instructions

### Install dependencies
- `bundle install`

### Setup database
- `bundle exec rails db:create`
- `bundle exec rails db:migrate`

### Add key for credentials
- `touch ./config/master.key`
- `EDITOR=vim ./config/master.key` and add 984740e0e6969edf69037f04037a4204

### Start server
- `bundle exec rails server`

## Design Decisions

### Using the 'service pattern' for the fetcher

The 'service pattern' was chosen because it is a popular design pattern that most Ruby on Rails developers are familiar with and are generally consistent across all Rails' applications. If I sensed the application was growing more complex and functionality started to intertwine amongst services I'd consider a gem like [interactor](https://github.com/collectiveidea/interactor) which follows the pattern but provides additional functionality.

There is an argument for using 'plain old Ruby objects' (POROs) but found using the pattern to be more conventional and familiar.

Like everything when developing in Ruby on Rails you do have to consider making decisions that aren't part of the [omakase](https://dhh.dk/2012/rails-is-omakase.html) philosophy but this pattern is widely used and if you do run into an issue it's generally easy to find solutions.

### Using Slim

This was a matter of taste, familiarity, and looking at the application as it grew. 

In the end, it was probably unnecessary. With just a single HTML file and no styling sticking to `erb` was the sensible choice.

It is also an opinionated choice and in a large app with many developers there would have been more consideration.

### Using Sidekiq

It didn't make the final product due to time restraints but I chose Sidekiq again because of familiarity and popularity in the Ruby on Rails community. It's a standard job scheduler that most developers are familiar with and is similar to the 'service pattern' with its consistency across apps.

It does come with it's negatives. You need to have `Redis` installed and so you have yet another dependency you have to monitor. It's also a dependency to Ruby on Rails it self since it is not included by default. ActiveJob is built into Rails by default and thus would be the traditional way of handling background jobs and would have been the easier choice but there was a lack of familiarity.

### Having a button to fetch from the endpoint instead of a cron job

This was done solely because of time. The functionality of having a controller action for fetching the data does make sense for some cases. It would be useful in an administrator section to pull certain accounts for testing or resolving issues from failed fetches.

Using the [whenever](https://github.com/javan/whenever) would be one of the methods that could be used to schedule fetches based on how often the data being fetched is updated.

### Calling the service from the controller action

Once Sidekiq wasn't implemented this was the easy route to go.

There is a very obvious issue: you are dependent on the endpoint and also the data returned. If the endpoint goes down or the data takes a non-trivial amount of time to process the user may receive an error or be waiting a long time for the page to refresh.

### Using PostgreSQL

When looking at the response from the endpoint I thought a jsonb field would make sense for the data key inside actions. I have experience with querying jsonb tables in PostgreSQL so it seemed natural to use. It also is trivially easy to start an application with using the `--database` option when creating your app.

It is not necessary though because Rails will turn it into a hash so you can use normal ruby syntax to access elements.

Another reason why it was unnecessary is that it's an application that not every one has installed and can be complicated to configure. Using Rails' default sqlite would be the better option to have chosen for this application

## TODO
- Implement Sidekiq or another background job processor.
- Add styling. If I'd had time I would have just used simple CSS in case there were issues adding Tailwind. Tailwind is the right option for larger applications.
- Add pagination. Right now all matching near transactions are returned. In this case it's okay but that may change.
- Add tests for `NearTransactionsController` and `app/views/near_transactions.html.slim`
- Add error handling around the call to the endpoint. There is no guarantee that it will return a 200 status code.
