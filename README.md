Rails app generated with [lewagon/rails-templates](https://github.com/lewagon/rails-templates), created by the [Le Wagon coding bootcamp](https://www.lewagon.com) team.

## Local development

VolunPeers is a Rails 7.1 app (PostgreSQL) that uses **Redis** as the Action Cable
adapter for real-time chat. Redis must be running for chat to work in development.

### Redis

The app is typically run locally (`bin/rails server`) while Redis runs in Docker.
`config/cable.yml` falls back to `redis://localhost:6379/1` when `REDISCLOUD_URL`
is not set, so all you need is a Redis instance listening on `localhost:6379`.

Start Redis (it is defined as a service in `docker-compose.yml`):

```bash
docker compose up -d redis
```

The container is configured with `restart: unless-stopped`, so it comes back
automatically after a reboot or a Docker restart — you only start it once.

Verify it is reachable:

```bash
docker exec volunpeers-redis-1 redis-cli ping   # => PONG
```

Manage it:

```bash
docker compose stop redis      # stop
docker compose logs -f redis   # tail logs
```

> If you prefer a native install instead of Docker:
> `sudo apt install redis-server` (Debian/Ubuntu/WSL) or `brew install redis` (macOS),
> then start the `redis-server` service. The `localhost:6379` fallback works the same way.

### Full stack in Docker

To run the whole app (web + PostgreSQL + Redis) in containers instead:

```bash
docker compose up
```

In that setup the `web` service reaches Redis at `redis://redis:6379/1`
(via the `REDISCLOUD_URL` env var wired up in `docker-compose.yml`).
