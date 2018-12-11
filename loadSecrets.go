package main

import (
  "encoding/json"
  "github.com/aws/aws-sdk-go/aws"
  "github.com/aws/aws-sdk-go/service/secretsmanager"
  "log"
  "os"
  "strings"
)

func loadSecrets(svc *secretsmanager.SecretsManager, names string) {

  s := strings.Split(names, ",")

  for _, temp := range s {

    s_data := strings.Split(temp, ":")
    name := s_data[0]
    version := "AWSCURRENT"
    if len(s_data) > 1 {
      version = s_data[1]
    }

    log.Printf("This SM_VAR is %s\nGetting Variable (name: %s, version %s)", temp, name, version)

    ret, err := svc.GetSecretValue(&secretsmanager.GetSecretValueInput{
      SecretId: aws.String(name),
      VersionStage: aws.String(version),
    })

    if err != nil {
      log.Fatalf("secretsmanager:GetSecretValue failed. (name: %s, version: %s)\n %v", name, version, err)
    }

    secrets := make(map[string]string)
    err = json.Unmarshal([]byte(aws.StringValue(ret.SecretString)), &secrets)
    if err != nil {
      log.Fatalf("secretsmanager:GetSecretValue returns invalid json. (name: %s, version: %s)\n %v", name, version, err)
    }

    for key, val := range secrets {
      os.Setenv(key,val)
    }
  }
}
