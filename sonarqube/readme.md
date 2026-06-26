
## Installation

docker run -d --name sonarqube -p 9000:9000 -e SONAR_ES_BOOTSTRAP_CHECKS_DISABLE=true sonarqube:lts-community


Access the Dashboard:
Wait a minute for the service to start, then navigate to http://localhost:9000 in your browser.

Log In:
Use the default credentials:

Login: admin
Password: admin

## Generate Global Token & Project level token
sqa_95f659eb58ad87f0fcdae34dd8bfeee711be8770

docker run \
    --rm \
    --network host \
    -e SONAR_HOST_URL="http://localhost:9000" \
    -e SONAR_SCANNER_OPTS="-Dsonar.projectKey=demo-app" \
    -e SONAR_TOKEN="sqa_95f659eb58ad87f0fcdae34dd8bfeee711be8770" \
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

### Jenkins Plugin & Credentials Setup
Before Jenkins can run the pipeline, it needs the SonarQube plugin and the global token you generated earlier.

Install the Plugin:
Go to Manage Jenkins > Plugins > Available plugins.

Search for and install the SonarQube Scanner plugin. Restart Jenkins if prompted.

Add Your SonarQube Token to Jenkins:
Go to Manage Jenkins > Credentials > System > Global credentials.

Click Add Credentials.
Kind: Secret text.

Secret: Paste your global SonarQube token (e.g., the sqp_c6176... token).
ID: sonar-token
Description: SonarQube Global Analysis Token.

Configure the SonarQube Server Integration:
Go to Manage Jenkins > System.
Scroll down to the SonarQube servers section and click Add SonarQube.
Name: SonarQube-Server (Important: We will reference this exact name in the pipeline).

Server URL: http://<YOUR_LINUX_IP>:9000 (Note: Do not use localhost here if Jenkins is running in a separate container/VM. Use your machine's actual local IP address so Jenkins can reach it).

Server authentication token: Select the sonar-token you just created from the dropdown.
Click Save.

Configure the SonarScanner Tool:
Go to Manage Jenkins > Tools.
Scroll down to SonarQube Scanner and click Add SonarQube Scanner.
Name: Sonar-Scanner (Important: We will reference this in the pipeline).
Check Install automatically (so Jenkins downloads it on the fly).
Click Save.