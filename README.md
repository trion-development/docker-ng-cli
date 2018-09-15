# docker-ng-cli

Docker image for Angular CLI to use as build container.

Image on dockerhub: https://hub.docker.com/r/trion/ng-cli/

Currently this image uses node 9 (npm 5) and Debian stretch as base distribution.

## Example usage
```
docker run -u $(id -u) --rm -v "$PWD":/app trion/ng-cli ng new MyDemo
cd MyDemo
docker run -u $(id -u) --rm -v "$PWD":/app trion/ng-cli ng build
```

To run the Angular CLI development server from docker you need to map the port and instruct Angular CLI to listen on all interfaces.
For example use
```
cd MyDemo
docker run -u $(id -u) --rm -p 4200:4200 -v "$PWD":/app trion/ng-cli ng serve -host 0.0.0.0
```

If you want to clone additional git repositories, f.e. from package.json, and you run with a different user than uid 1000 you need to mount the passwd since git requires to resolve the uid.

```
docker run -u $(id -u) --rm -p 4200:4200 -v /etc/passwd:/etc/passwd -v "$PWD":/app trion/ng-cli npm install
```


## Usage in a CI environment
To run Angular CLI unit tests in docker see docker-ng-cli-karma and docker-ng-cli-e2e projects and respective trion/ng-cli-karma and trion/ng-cli-e2e docker images.


Docker images for Angular karma unit tests and end to end tests with webdriver/selenium:
* https://github.com/trion-development/docker-ng-cli-karma
* https://github.com/trion-development/docker-ng-cli-e2e

## using yarn
This image contains yarn preinstalled and can be used as alternative package manager.
If you want to use a shared cache directory for yarn, you will need to mount the directory into the image.

### New project with yarn
```
docker run -u $(id -u) --rm -v "$PWD":/app trion/ng-cli sh -c "ng set --global packageManager=yarn; ng new MyDemoProject"
```

Note the Angular CLI docker container instance is removed after each execution, therefore the selection of the package manager will just influence the current execution.

### Using a shared cache

You can use the regular yarn cache directory or specify a different directory.
Make sure that you already have the cache directory initialized before using it with this docker image, otherwise the permissions might end up wrong.

Using the regular yarn directory, which should be the right choice when using during regular development:
```
docker run -u $(id -u) --rm -v "$HOME/.cache/yarn":/tmp/.cache/yarn -v "$PWD":/app trion/ng-cli sh -c "ng set --global packageManager=yarn; ng new MyDemoProject"
```

Assuming you have a directory "../yarn-cache" with appropriate access rights, you can use it to create a new project using the following command

```
docker run -u $(id -u) --rm -v "$PWD/../yarn-cache":/tmp/.cache/yarn -v "$PWD":/app trion/ng-cli sh -c "ng set --global packageManager=yarn; ng new MyDemoProject"
```

For subsequent package installations (f.e. in a CI build) just use `yarn` instead of `npm`.

### Offline mode
This requires the use of a shared cache and a `yarn.lock` file from a previous yarn package installation run.

```
cd MyDemoProject
docker run -u $(id -u) --rm -v "$PWD/../../yarn-cache":/tmp/.cache/yarn -v "$PWD":/app trion/ng-cli yarn install --offline
```
