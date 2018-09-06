.PHONY: deps build dist prerelease release

NAME := sm_entrypoint
BUILD_VERSION := $(shell git describe --tags)

deps:
	go get github.com/mitchellh/gox
	go get github.com/tcnksm/ghr

build:
	echo building bin/${NAME}
	go build -o bin/${NAME} .

dist:
	echo building ${BUILD_VERSION}
	gox -osarch="darwin/amd64" -osarch="linux/386" -osarch="linux/amd64" \
		-ldflags "-X main.version=${BUILD_VERSION}" -output "dist/${NAME}-{{.OS}}-{{.Arch}}"

prerelease:
	ghr --prerelease -u ${CIRCLE_PROJECT_USERNAME} -r ${CIRCLE_PROJECT_REPONAME} --replace `git describe --tags` dist/

release:
	ghr -u ${CIRCLE_PROJECT_USERNAME} -r ${CIRCLE_PROJECT_REPONAME} --replace `git describe --tags` dist/
