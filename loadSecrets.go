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

  for _, name := range s {
    ret, err := svc.GetSecretValue(&secretsmanager.GetSecretValueInput{
      SecretId: aws.String(name),
    })

    if err != nil {
      log.Printf("secretsmanager:GetSecretValue failed. (name: %s)\n %v", name, err)
      return
    }

    secrets := make(map[string]string)
    err = json.Unmarshal([]byte(aws.StringValue(ret.SecretString)), &secrets)
    if err != nil {
      log.Printf("secretsmanager:GetSecretValue returns invalid json. (name: %s)\n %v", name, err)
    }

    for key, val := range secrets {
      os.Setenv(key,val)
    }
  }
}
