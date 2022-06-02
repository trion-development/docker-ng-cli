#!/bin/bash
set -Eeuxo pipefail

# cd docker-ng-cli

if [[ ${VERSION} -eq 0 ]] ; then
    echo 'Please provide version as environment, f.e. VERSION=1.0.0.BETA1'
    exit 1
fi

git checkout master
git pull --rebase
git checkout -b ${VERSION}
sed -r -i "s@(.*)NG_CLI_VERSION=.*@\1NG_CLI_VERSION=${VERSION}@g" Dockerfile*
#sed -r -i "s@latest@${VERSION}@g" hooks/multi-arch-manifest.yaml
git commit -a -m "update to ${VERSION}"
git checkout master
sed -r -i "s@(.*)NG_CLI_VERSION=.*@\1NG_CLI_VERSION=${VERSION}@g" Dockerfile*
git commit -a -m "update to ${VERSION}"
git push -u origin ${VERSION}
cd ..

echo "Waiting for build docker-ng-cli"
sleep 10m #amd64
# sleep 20m #aarch64
# sleep 20m #arm32v7
echo "Build should be done"

cd docker-ng-cli-karma
git checkout master
git pull --rebase
git checkout -b ${VERSION}
sed -i -r "s@(.*)trion/ng-cli:.*@\1trion/ng-cli:${VERSION}@g" Dockerfile
git commit -a -m "update to ${VERSION}"
git checkout master
#only change label, not base image
sed -i -r "s@(.*) ng-cli:.*@\1 ng-cli:${VERSION}@g" Dockerfile
git commit -a -m "update to ${VERSION}"
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

#only change label, not base image
sed -i -r "s@(.*) ng-cli-karma:.*@\1 ng-cli-karma:${VERSION}@g" Dockerfile
#sed -i -r "s@(.*)trion/ng-cli-karma:.*@\1trion/ng-cli-karma:${VERSION}@g" Dockerfile
git commit -a -m "update to ${VERSION}"
git push -u origin ${VERSION}
cd ..

echo "Pushing latest..."
cd docker-ng-cli
git push --all
echo "Waiting for build docker-ng-cli"
sleep 13m
cd ..
cd docker-ng-cli-karma
git push --all
echo "Waiting for build docker-ng-cli-karma"
sleep 13m
cd ..
cd docker-ng-cli-e2e
git push --all
cd ..

echo "(Multi arch build probably in progress...)"
