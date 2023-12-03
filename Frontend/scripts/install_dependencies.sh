#!/bin/bash
echo first---------
ls
# Navigate to the project directory
cd /app

echo second---------
ls
npm install
# Remove existing node_modules and package-lock.json
rm -rf node_modules
rm package-lock.json

