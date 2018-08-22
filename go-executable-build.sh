#!/usr/bin/env bash

# The name of our package
package_name=sm_entrypoint

# By default, we build for the platform we're running on;
# other platforms can be requested as command-line arguments of
# the form $GOOS/$GOARCH. If -a is passed in, we build for our two
# primary targets: linux/amd64 and darwin/amd64.
usage() {
    printf >&2 'Usage: %s [-a] [os/arch ...]\n' "$0"
    printf >&2 'Build %s for the given platforms.\n\n' "$package_name"

    printf >&2 'With no arguments, build for configured Go platform;\n'
    printf >&2 '%s triggers builds for linux/amd64 and darwin/amd64;\n' '-a'
    printf >&2 'other arguments are interpreted as $GOOS/$GOARCH.\n'

    exit $1
}

main() {

  local platform

  if (( $# )); then
    # If we have any command line options, then
    # drop any environmental Go assumptions
    unset GOOS GOARCH

    if [[ "$1" == -a ]]; then
      shift
      set -- linux/amd64 darwin/amd64 "$@"
    fi

    # check the arguments
    for platform; do
      case "$platform" in
        */*) :;;
        -h) usage 0;;
        *) usage 1;;
      esac
    done
  else
    # If we don't have any command-line arguments, use the defaults.
    # The golang install will have figured those out for us, whether
    # set in the environment or just the platform default
    set -- "$(go env GOOS)/$(go env GOARCH)"
  fi

  for platform in "$@"; do
    printf 'Building for %s...' "$platform"
    IFS=/ read os arch <<<"$platform"
    output_name=$package_name-$GOOS-$GOARCH
    if ! GOOS=$os GOARCH=$arch go build -o $output_name .; then
        echo
        echo >&2 "$0: build for '$platform' failed. Aborting."
        exit 1
    fi
    echo done.
  done
}

main "$@"
