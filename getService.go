package main

import (
  "github.com/aws/aws-sdk-go/aws"
  "github.com/aws/aws-sdk-go/aws/credentials/stscreds"
  "github.com/aws/aws-sdk-go/aws/ec2metadata"
  "github.com/aws/aws-sdk-go/aws/session"
  "github.com/aws/aws-sdk-go/service/secretsmanager"
  "log"
  "os"
)


func getService() *secretsmanager.SecretsManager {

  sess, err := session.NewSessionWithOptions(session.Options{
      SharedConfigState: session.SharedConfigEnable,
  })

  if err != nil {
    log.Fatalf("failed to create a new session.\n %v", err)
  }
  
  if aws.StringValue(sess.Config.Region) == "" {

    region, err := ec2metadata.New(sess).Region()
    if err != nil {
      log.Fatalf("could not find region configurations:", err)
    }
    sess.Config.Region = aws.String(region)
  }

  if arn := os.Getenv("AWS_ASSUME_ROLE_ARN"); arn != "" {
    creds := stscreds.NewCredentials(sess, arn)
    return secretsmanager.New(sess, &aws.Config{Credentials: creds})
  }

  return secretsmanager.New(sess)

}
