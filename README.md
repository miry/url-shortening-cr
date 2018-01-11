# URL shortening

Sample crystal lang web application to work with redis.
Minimized Docker image.

## Endpoints

* POST /url

# Build

- Install `brew install crystal-lang`
- Download dependicies `crystal deps`
- Run the server `crystal run src/server.cr`

## Docker

```shell
$ docker build -t miry/url-shortening-cr .
$ docker run --net=host -d redis
$ docker run -e BASENAME="http://$(docker-machine ip):3000" -it --net=host miry/url-shortening-cr
```

### Profile

- [2018.01.11 21:45] Finished to build web app
- [2018.01.11 15:25] Started to build web app
