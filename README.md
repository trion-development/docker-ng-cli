# docker-ng-cli

Docker container for Angular CLI as build container.
Image on dockerhub: https://hub.docker.com/r/trion/ng-cli/

Example usage
```
docker run -u $(id -u) --rm -v "$PWD":/app trion/ng-cli ng new MyDemo
cd MyDemo
docker run -u $(id -u) --rm -v "$PWD":/app trion/ng-cli ng build
```

To run the Angular CLI development server from docker you need to map the port, f.e. use
```
docker run -u $(id -u) --rm -p 4200:4200 -v "$PWD":/app trion/ng-cli ng serve -host 0.0.0.0
```

If you want to clone additional git repositories, f.e. from package.json, and you run with a different user than uid 1000 you need to mount the passwd since git requires to resolve the uid.

```
docker run -u $(id -u) --rm -p 4200:4200 -v /etc/passwd:/etc/passwd -v "$PWD":/app trion/ng-cli npm install
```

To run Angular CLI unit tests in docker see docker-ng-cli-karma and docker-ng-cli-e2e projects and respective trion/ng-cli-karma and trion/ng-cli-e2e docker images.

Docker images for Angular karma unit tests and end to end tests with webdriver/selenium:
* https://github.com/trion-development/docker-ng-cli-karma
* https://github.com/trion-development/docker-ng-cli-e2e
