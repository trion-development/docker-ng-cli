#!/bin/bash

# cd docker-ng-cli

git checkout master
git pull --rebase
git checkout -b ${VERSION}
sed -r -i "s@(.*)NG_CLI_VERSION=.*@\1NG_CLI_VERSION=${VERSION}@g" Dockerfile*
#sed -r -i "s@latest@${VERSION}@g" hooks/multi-arch-manifest.yaml
git commit -a -m "update to ${VERSION}"
git checkout master
git push -u origin ${VERSION}
cd ..

echo "Waiting for build docker-ng-cli"
sleep 10m #amd64
sleep 20m #aarch64
sleep 20m #arm32v7
echo "Build should be done"

cd docker-ng-cli-karma
git checkout master
git pull --rebase
git checkout -b ${VERSION}
sed -i -r "s@(.*)trion/ng-cli:.*@\1trion/ng-cli:${VERSION}@g" Dockerfile
git commit -a -m "update to ${VERSION}"
git checkout master
git push -u origin ${VERSION}
cd ..

echo "Waiting for build docker-ng-cli-karma"
sleep 13m
echo "Build should be done"

cd docker-ng-cli-e2e
git checkout master
git pull --rebase
git checkout -b ${VERSION}
sed -i -r "s@(.*)trion/ng-cli-karma:.*@\1trion/ng-cli-karma:${VERSION}@g" Dockerfile
git commit -a -m "update to ${VERSION}"
git checkout master
git push -u origin ${VERSION}
cd ..

echo "Pushing latest..."
cd docker-ng-cli
git push --all
cd ..
cd docker-ng-cli-karma
git push --all
cd ..
cd docker-ng-cli-e2e
git push --all
cd ..
