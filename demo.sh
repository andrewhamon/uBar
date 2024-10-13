#!/usr/bin/env bash

while true; do
  cat playground.json | jq -c
  sleep 0.25
done | swift run | while read -r line; do
  id=$(echo $line | jq -r '.id')
  echo "Got json event: $line"
  osascript -e "display notification with title \"Pressed id $id\""
done
