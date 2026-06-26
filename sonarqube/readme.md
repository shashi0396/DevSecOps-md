## Installation

docker run -d --name sonarqube -p 9000:9000 -e SONAR_ES_BOOTSTRAP_CHECKS_DISABLE=true sonarqube:lts-community


Access the Dashboard:
Wait a minute for the service to start, then navigate to http://localhost:9000 in your browser.

Log In:
Use the default credentials:

Login: admin
Password: admin

## Generate Global Token & Project level token
sqa_1a4e25f46a49a2fec9e92ff35563336830e0908f

docker run \
    --rm \
    --network host \
    -e SONAR_HOST_URL="http://localhost:9000" \
    -e SONAR_SCANNER_OPTS="-Dsonar.projectKey=demo-app" \
    -e SONAR_TOKEN="sqa_1a4e25f46a49a2fec9e92ff35563336830e0908f" \
    -v "$(pwd):/usr/src" \
    sonarsource/sonar-scanner-cli


## Setup Quality Gates

## JAVA Project

sudo apt install default-jdk maven -y


docker run --rm \
  --network host \
  -e SONAR_HOST_URL="http://localhost:9000" \
  -e SONAR_TOKEN="sqa_95f659eb58ad87f0fcdae34dd8bfeee711be8770" \
  -e SONAR_SCANNER_OPTS="-Dsonar.projectKey=java-app -Dsonar.java.binaries=target/classes" \
  -v "$(pwd):/usr/src" \
  sonarsource/sonar-scanner-cli
