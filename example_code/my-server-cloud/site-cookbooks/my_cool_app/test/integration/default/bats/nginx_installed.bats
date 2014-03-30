#!/usr/bin/env bats

@test "nginx binary is found in PATH" {
  run which nginx
  [ "$status" -eq 0 ]
}

@test "nginx config is valid" {
  run sudo nginx -t
  [ "$status" -eq 0 ]
}

@test "nginx is running" {
  run service nginx status
  [ "$status" -eq 0 ]
  [ $(expr "$output" : ".*nginx.*running") -ne 0 ]
}