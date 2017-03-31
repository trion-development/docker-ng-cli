# docker-ng-cli

Docker container for Angular CLI as build container.
Image on dockerhub: https://hub.docker.com/r/trion/ng-cli/

Example usage
```
docker run -u $(id -u) --rm -v "$PWD":/app trion/ng-cli ng new MyDemo
cd MyDemo
docker run -u $(id -u) --rm -v "$PWD":/app trion/ng-cli ng build
```

To run the Angular CLI development serve from docker you need to map the port, f.e. use
```
docker run -u $(id -u) --rm -p 4200:4200 -v "$PWD":/app trion/ng-cli ng serve -host 0.0.0.0
```


To run Angular CLI unit tests in docker see docker-ng-cli-karma and docker-ng-cli-e2e projects and respective trion/ng-cli-karma and trion/ng-cli-e2e docker images.

See
* https://github.com/trion-development/docker-ng-cli-karma
* https://github.com/trion-development/docker-ng-cli-e2e
