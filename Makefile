.PHONY: deps build dist prerelease release

NAME := sm_entrypoint
BUILD_VERSION := $(shell git describe --tags)

deps:
	go get -u github.com/mitchellh/gox
	go get -u github.com/tcnksm/ghr
	go get -u github.com/aws/aws-sdk-go

build:
	echo building bin/${NAME}
	go build -o bin/${NAME} .

dist:
	echo building ${BUILD_VERSION}
	gox -osarch="darwin/amd64" -osarch="linux/386" -osarch="linux/amd64" \
		-ldflags "-X main.version=${BUILD_VERSION}" -output "dist/${NAME}-{{.OS}}-{{.Arch}}"
	chmod a+x dist/*

prerelease:
	ghr --prerelease -u ${CIRCLE_PROJECT_USERNAME} -r ${CIRCLE_PROJECT_REPONAME} --replace `git describe --tags` dist/

release:
	ghr -u ${CIRCLE_PROJECT_USERNAME} -r ${CIRCLE_PROJECT_REPONAME} --replace `git describe --tags` dist/
