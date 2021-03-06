# sm_entrypoint

This is a simple entrypoint script to load AWS SecretManager Secrets into the OS environment.

Credentials must be set properly for this command to work (either via ENV Vars or, preferably, an IAM Assumed Role).

## Build

A Makefile is included to facilitate building.

`make build` will build a binary for your automatically detected GOOS and GOARCH.  It will place the binary in `bin/` directory.

If you choose, you can also build for multiple distributions with `make dist`.  You can examine the Makefile and change or add to the list of GOOS and GOARCH combinations.

Executables will have the form `sm_entrypoint-${GOOS}-${GOARCH}` and will be placed in the `dist/` directory.  Choose the one you need for each docker image and mv/copy it to your docker
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

- __SM_VARS__ - Comma separated list of Secrets Manager secret names, and optionally secret versions separated by a ":". There are two special "version labels", AWSCURRENT and AWSPREVIOUS,
that describe the stage of a secret.  The secret can only have 1 AWSCURRENT and AWSPREVIOUS label, which automatically gets set if a version label is not applied at update.  AWSCURRENT represents
the secret that AWS SecretsManager considers the "active" secret and will be the secret the console displays.  The AWSPREVIOUS secret label is applied to the secret that last had the AWSCURRENT
label.  Neither of these labels is required on a secret.  If you manually create a version label and do not also include AWSCURRENT, neither AWSCURRENT or AWSPREVIOUS labels will be moved.

The version label must be unique on a secret version.  If the same version label is applied to a different secret, then the version label is moved to that different secret.  The PutSecretValue 
documentation, <https://docs.aws.amazon.com/secretsmanager/latest/apireference/API_PutSecretValue.html>, best describes this functionality.  With care, version labels can be used to store 
up to 18 different versions of a secrets:
<https://docs.aws.amazon.com/secretsmanager/latest/userguide/reference_limits.html>

  ```
  SM_VARS=secret-name-1[:version1],[secret-name-2[:version2],....]
  ```

The __SM_VARS__ ENV var must be set for sm_entrypoint to know what secrets to load into the environment. If it is missing, the
sm_entrypoint will skip loading any variables and will transfer control the command passed to it.

These ENV Vars are useful for local testing of the entry point and local development.

- __AWS_ASSUME_ROLE_ARN__ - Role ARN used to assume that has access to the secrets in Secrets Manager.
- __AWS_REGION__ - Region that your Secrets Manager is in.  Use if setting up AWS credentials locally.
- __AWS_PROFILE__ - AWS credentials that has access to Secrets Manager OR the role that has access to Secrets Manager.
- __AWS_ACCESS_KEY_ID__ - AWS access key if you aren't using a AWS profile or are testing an AWS IAM user.
- __AWS_SECRET_ACCESS_KEY__ - AWS secret key if you aren't using a AWS profile or are testing an AWS IAM user.
