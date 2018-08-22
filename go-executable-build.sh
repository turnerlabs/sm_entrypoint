#!/usr/bin/env bash

# The name of our package
package_name=sm_entrypoint

# Display usage message on error or help request.
usage() {
    printf >&2 '\nUsage: %s [-h] [-a] [os/arch ...]\n\n' "$0"
    printf >&2 'Build %s for the given platforms.\n\n' "$package_name"

    printf >&2 'With no arguments, build for the locally-configured\n'
    printf >&2 'default Go platform.\n\n'
    printf >&2 '%s\tDisplay this message.\n' '-h'
    printf >&2 '%s\tBuild for linux/amd64 and darwin/amd64.\n\n' '-a'
    printf >&2 'Other arguments are interpreted as target platform specifiers\n'
    printf >&2 'of the form $GOOS/$GOARCH.\n\n'

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
    for platform in "$@"; do
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

  local os arch output_name
  for platform in "$@"; do
    printf 'Building for %s...' "$platform"
    IFS=/ read os arch <<<"$platform"
    output_name=$package_name-$os-$arch
    if ! GOOS=$os GOARCH=$arch go build -o "$output_name" .; then
        printf '\n'
        printf >&2 "%s: build for '%s' failed. Aborting.\n" "$0" "$platform"
        exit 1
    fi
    printf 'done.\n'
  done
}

main "$@"
