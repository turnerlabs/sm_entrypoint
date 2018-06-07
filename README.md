# sm_entrypoint

A simple entrypoint to load AWS SecretManager Secrets into the OS environment.

Credentials must be set properly for this command to work (either via ENV Vars or preferably an IAM Assumed Role).

## build

## Usage

```Dockerfile
ENTRYPOINT ["/app/sm_entrypoint"]

CMD ["/my/app/start_script_or_command"]
```

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
