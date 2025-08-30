Build Image

```
docker-compose -f ./docker/docker-compose.crash-reproduction.yml up -d --build
```

Run Image

```
docker exec -it docker-rails-crash-test-1 bash
```

Ssh'd into the docker container and run
```
ruby crash_test.rb
```