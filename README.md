# sm_entrypoint

This is a simple entrypoint script to load AWS SecretManager Secrets into the OS environment.

Credentials must be set properly for this command to work (either via ENV Vars or, preferably, an IAM Assumed Role).

## Build

The build script is intended to facilitate cross-platform compiling.

If you desire, you can modify the script `go-executable-build.sh` to build your binaries for your architectures.

Run `./go-execuable-build.sh`

Executables will have the form `sm_entrypoint-${GOOS}-${GOARCH}`.  Choose the one you need for each docker image and mv/copy it to your docker
build directory.  Then add the binary in your Dockerfile.

## Usage
Either build from the latest code or download a release from git:  `https://github.com/turnercode/sm_entrypoint/releases/download/${release_tag}/sm_entrypoint-${GOOS}-${GOARCH}`

```Dockerfile
ADD sm_entrypoint-$GOOS-$GOARCH /my/app/sm_entrypoint

ENTRYPOINT ["/my/app/sm_entrypoint"]

CMD ["/my/app/start_script_or_command"]
```
or
```Dockerfile
RUN curl -o /my/app/sm_entrypoint https://github.com/turnerlabs/sm_entrypoint/releases/download/${release_tag}/sm_entrypoint-${GOOS}-${GOARCH}

ENTRYPOINT ["/my/app/sm_entrypoint"]

CMD ["/my/app/start_script_or_command"]
```

Replace `${release_tag}`, `${GOOS}` and `${GOARCH}` with values for your docker image

## ENV VARS
The following ENV Vars can be set to control sm_entrypoint behavior.

- __SM_VARS__ - Comma separated list of Secrets Manager secret names.

The __SM_VARS__ ENV var must be set for sm_entrypoint to know what secrets to load into the environment. If it is missing, the
sm_entrypoint will skip loading any variables and will transfer control the command passed to it.

These ENV Vars are useful for local testing of the entry point and local development.

- __AWS_ASSUME_ROLE_ARN__ - Role ARN used to assume that has access to the secrets in Secrets Manager.
- __AWS_REGION__ - Region that your Secrets Manager is in.  Use if setting up AWS credentials locally.
- __AWS_PROFILE__ - AWS credentials that has access to Secrets Manager OR the role that has access to Secrets Manager.
- __AWS_ACCESS_KEY_ID__ - AWS access key if you aren't using a AWS profile or are testing an AWS IAM user.
- __AWS_SECRET_ACCESS_KEY__ - AWS secret key if you aren't using a AWS profile or are testing an AWS IAM user.
