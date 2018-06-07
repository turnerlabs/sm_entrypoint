# sm_entrypoint

A simple entrypoint to load AWS SecretManager Secrets into the OS environment.

Credentials must be set properly for this command to work (either via ENV Vars or preferably an IAM Assumed Role).

## Build

Modify the script `go-executable-build.sh` to build your binaries for your architectures.

Run `./go-execuable-build.sh`

Executables will have the form `sm_entrypoint-$GOOS-$GOARCH`.  Choose the one you need for each and mv/copy it to your docker
build directory.  Then add binary in your Dockerfile.

## Usage

```Dockerfile
ADD sm_entrypoint-$GOOS-$GOARCH /my/app/sm_entrypoint

ENTRYPOINT ["/my/app/sm_entrypoint"]

CMD ["/my/app/start_script_or_command"]
```
Replace `$GOOS` and `$GOARCH` with values for your docker image

The following ENV Vars can be set to control sm_entrypoint behavior.
## ENV VARS

- SM_VARS - Comma separated list of Secrets Manager secret names.

The SM_VARS ENV var must be set for sm_entrypoint to know what secrets to load into the environment. If it is missing, the
sm_entrypoint will skip loading any variables and will transfer control the command passed to it.

These ENV Vars are useful for local testing of the entry point and local development.

- AWS_ASSUME_ROLE_ARN (Optional) - Role ARN used to assume that has access to the secrets in Secrets Manager.
- AWS_REGION (Optional) - Region that your Secrets Manager is in.  Use if setting up AWS credentials locall
- AWS_PROFILE - AWS credentials that has access to Secrets Manager OR the role that has access to Secrets Manager.
- AWS_ACCESS_KEY_ID - AWS access key if you aren't using a AWS profile or are testing a srv_ AWS user.
- AWS_SECRET_ACCESS_KEY - AWS secret key if you aren't using a AWS profile or are testing a srv_ AWS user.
