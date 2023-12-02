#!/bin/bash

# Identify and kill the Node.js process
node_process_id=$(pgrep -f "node .*your-app-entry-file.js")
if [ -n "$node_process_id" ]; then
  kill -TERM "$node_process_id"
  echo "Node.js process (PID $node_process_id) stopped successfully."
else
  echo "No running Node.js process found."
fi
