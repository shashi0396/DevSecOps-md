sudo apt update
sudo apt install docker.io docker-compose-v2 -y
sudo systemctl enable --now docker


mkdir -p ~/dependency-track && cd ~/dependency-track
curl -LO https://dependencytrack.org/docker-compose.yml




sudo docker compose up -d


http://localhost:8080 (or use your Ubuntu server's IP address instead of localhost

Username: admin

Password: admin



git clone https://github.com/aquasecurity/trivy-ci-test.git
cd trivy-ci-test

trivy fs .

trivy fs --severity CRITICAL .

trivy repo https://github.com/aquasecurity/trivy-ci-test

trivy fs --exit-code 1 --severity HIGH,CRITICAL .

trivy fs --format cyclonedx --output sbom.json /path/to/your/project