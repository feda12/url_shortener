# URL Shortener

## Getting started

Requires Docker >= 1.13.0

Run the following commands to get the application setup:
```
docker-compose build
docker-compose up -d
docker-compose run web rake db:create
docker-compose run web rake db:migrate
docker-compose down
```

Once you have these initial steps, you can run the app using

```
docker-compose up
```

Option `-d` is optional and would run the app in daemon mode.


To run the specs, use the command: `docker-compose run web rspec`

## Goal

Build a web service that allow users to submit a URL and return a “shortened URL” that redirects to that originally submitted URL

## Features

- I can create a new shortened URL
- I get redirected to the URL submitted when I hit the shortened_url
- I can get a list of top 100 most used shortened url
- 

## Architecture
- Has a POST endpoint to submit a URL for shortening
- Has a top 100 endpoint
- Has a background 
- Has a `shortened_url` model:
  - id : uuid
  - title : string, default : nil
  - original_url: string cannot be nil
  - slug: string cannot be nil, unique
  - hit_count : integer, default 0
  - updated_at : datetime auto
  - inserted_at: datetime auto

## Assumptions

- Top 100 
  - descendent order, meaning the most popular URL is at the top
  - popular is defined as how many times the shortened URL was used to reach the original URL
  - duplicate original URL are allowed

- title
  - we only one 

## Security

This API has no security built-in such as authentication. We would rely on Heroku to prevent any kind of DDos attack should we use that Paas.

# Improvements:

- Our top 100 endpoint is doing a query to get the top 100 urls by hit count. This will be quite inefficient as usage grow. An alternative would be a materialized view that runs the "get me the top 100 by hit count" and update itself everytime a hit count change. If this view becomes a burden on the db, we can make it hourly or daily.

- Our title fetcher background worker will not retry to grab the title if it's nil, nor will it be able to update the title to reflect the latest title. A solution to this issue would be to run the job at frequent interval; we would store a datetime on the `shortened_url` indicating when its title was last fetched and look for urls that haven't been updated in X days.

- Add the favicon to the url shortener.
- Use UUID instead of integer for primary keys



Nokigiri for HTML
No job backend but something that should be added for a production app
Use SecureRandom.hex(5) to generate our unique slugs
We have about 36^5 available names, thus over 60 million
Improvement for future versions:
- Have a background worker generates a “stack” of slugs and take whatever is on top
- This would grow with usage
- 
Improvement: background job that runs daily and fetches title for urls that haven’t been updated in 7 days
background job that runs daily for title missing?
background job that removes urls that haven’t been hit in X months
background job that removes urls that haven’t been able to be reached in X months

