# docker-blazer

Run Instacart's blazer BI tool with Docker

## Usage

### Using docker compose

Here's how you'd get up and going running a blazer container from scratch using the included example docker compose config:

```
git clone git@github.com:eliotk/docker-blazer.git
cd docker-blazer
docker-compose build
docker-compose up
open http://localhost:3000
```

You should now be able to access blazer in your browser. The docker compose file has created a linked a default postgres container to the blazer container. The env vars in the docker-compose.yml file sets both the blazer rails app DB URL and the target DB URL that blazer uses for querying to point to that linked postgres container. So now you can play around and use blazer to analyze blazer's data :)

## Configuring blazer

Now you want to run the blazer container but query a real, separate database.

Let's say you have a database called `prod_app` you want to query. It's in a postgres cluster that's available at the IP address 10.0.0.4. You have already created a new database in that cluster called `blazer` that the blazer app will use for it's own storage. Here are the setup steps:

```
git clone git@github.com:eliotk/docker-blazer.git
cd docker-blazer
docker build . -t blazer
docker run -e DATABASE_URL="postgres://postgres@10.0.0.4:5432/blazer" -e BLAZER_DATABASE_URL="postgres://postgres@10.0.0.4:5432/prod_app" -p 3000:3000 -d blazer
open localhost:3000
```

That run command:

* Launches the blazer container
* Sets the blazer app (DATABASE_URL) and blazer target (BLAZER_DATABASE_URL) DB URLs environment variables
* Exposes the container port 3000 on the host at port 3000

You should now be able to query your `prod_app` target DB with the blazer app running at localhost:3000

## Development

It may be necessary to update the Gemfile.lock of the rails app inside the repo. You can do so by running a one-off container from the blazer image that mounts the rails_app directory into the container as the main app directory and running the `bundle install` command.

This is how it looks if you're within the repo directory:

`docker run -v $(pwd)/rails_app:/blazer-app  --name blazer --rm blazer bundle install`

Using the `pwd` command is necessary to form an absolute path because a relative path in that volume argument will be treated as a named volume.
