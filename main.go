package main

import (
    "log"
    "os"
    "os/exec"
    "syscall"
)


func main() {

  log.SetFlags(0)
  log.SetPrefix("[sm_entrypoint] ")

  args := os.Args
  if len(args) <= 1 {
    log.Fatal("missing command")
  }

  names := os.Getenv("SM_VARS")
  if names != "" {
    svc := getService()
    loadSecrets(svc, names)
  } else {
    log.Println("No SM_VARS set.")
  }

  path, err := exec.LookPath(args[1])
  if err != nil {
    log.Fatal(err)
  }
  err = syscall.Exec(path, args[1:], os.Environ())
  if err != nil {
    log.Fatal(err)
  }

}
