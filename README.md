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

## Usage

### Shorten a URL

Request

```
curl -X POST -H "Content-Type: application/json" -d '{
  "url": "http://google.com"
  }' "http://localhost:3000/"
```

Response

```
{
  "url": "http://localhost:3000/bdf3da24a9"
}
```

### Top 100

Request

```
curl -X GET "http://localhost:3000/"
```

Response

```
[
  {
    "url": "http://localhost:3000/5831a89efd",
    "original_url": "http://google.com",
    "hit_count": 1,
    "id": 1
  },
  {
    "url": "http://localhost:3000/abc0bb1e76",
    "original_url": "http://google.com",
    "hit_count": 0,
    "id": 34
  }
]
```

### Use shortened URL

To test the shortened URL, copy the URL from the creation step and paste it in a browser.

## Goal

Build a web service that allow users to submit a URL and return a “shortened URL” that redirects to that originally submitted URL

## Features

- I can create a new shortened URL
- I get redirected to the URL submitted when I hit the shortened_url
- I can get a list of top 100 most used shortened url

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

- Title
  - we only want the title after initialization

## Security

This API has no security built-in such as authentication. We would rely on Heroku to prevent any kind of DDos attack should we use that Paas.

# Improvements:

- Our top 100 endpoint is doing a query to get the top 100 urls by hit count. This will be quite inefficient as usage grow. An alternative would be a materialized view that runs the "get me the top 100 by hit count" and update itself everytime a hit count change. If this view becomes a burden on the db, we can make it hourly or daily.

- Our top 100 would probably be more relevant to a user if the original URL is unique, however this would add complexity in our counting methodology.

- Our create endpoint will eventually return errors when `SecureRandom.hex(5)` returns a slug already used. The user would then have to re-submit its URL. In order to prevent this from happening, our architecture would need to scale up. One way would be to have a worker generate slugs, check that they aren't in used and put them in a queue(Redis, S3 etc) to be ready to be used. We can limit our queue to have X number of slugs ready so that we don't end up creating billions of unique slugs.

- Our title fetcher background worker will not retry to grab the title if it's nil, nor will it be able to update the title to reflect the latest title. A solution to this issue would be to run the job at frequent interval; we would store a datetime on the `shortened_url` indicating when its title was last fetched and look for urls that haven't been updated in X days.

- Add the favicon to the url shortener.
- Use UUID instead of integer for primary keys

