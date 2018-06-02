# sm_entrypoint

A simple entrypoint to load AWS SecretManager Secrets into the OS environment

Credentials must be set properly for this to work (either via ENV Vars or preferrably IAM Assumed Role)

An environment variable, SM_VARS must be set with a comma separated list of AWS SecretManager Secrets.


