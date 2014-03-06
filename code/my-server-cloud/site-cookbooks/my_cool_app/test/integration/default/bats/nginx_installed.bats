#!/usr/bin/env bats

@test "nginx binary is found in PATH" {
  run which nginx
  [ "$status" -eq 0 ]
}