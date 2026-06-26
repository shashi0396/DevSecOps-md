# Docker Bench for Security

sudo docker run --rm --net host --pid host --userns host --cap-add audit_control \
                        -e DOCKER_CONTENT_TRUST=$DOCKER_CONTENT_TRUST \
                        -v /etc:/etc:ro \
                        -v /usr/bin/containerd:/usr/bin/containerd:ro \
                        -v /usr/bin/runc:/usr/bin/runc:ro \
                        -v /usr/lib/systemd:/usr/lib/systemd:ro \
                        -v /var/lib:/var/lib:ro \
                        -v /var/run/docker.sock:/var/run/docker.sock \
                        --label name=docker-bench-security \
                        docker/docker-bench-security -c check_2_1,check_2_2


# Distroless image

# There is no bash, no npm, no apt, and no ls. If an attacker achieves Remote Code Execution (RCE) 
# inside your application, they cannot spawn a shell or download malicious payloads 
# because the tools to do so literally do not exist.

# Debugging is Difficult: Because there is no shell, you cannot run docker exec -it <container_id> sh to troubleshoot
# a running production container.You must rely entirely on your external application logs (STDOUT/STDERR) and APM tools.


# cosign

curl -O -L "https://github.com/sigstore/cosign/releases/latest/download/cosign-linux-amd64"
chmod +x cosign-linux-amd64
sudo mv cosign-linux-amd64 /usr/local/bin/cosign

cosign version

cosign generate-key-pair

FROM alpine:latest
CMD ["echo", "Signed container demo"]


# Build the image
docker build -t your-docker-username/secure-demo:v1 .

# Log in to your registry
docker login

# Push the image
docker push your-docker-username/secure-demo:v1

cosign sign --key cosign.key your-docker-username/secure-demo:v1
 
cosign verify --key cosign.pub your-docker-username/secure-demo:v1


# trivy


# Install dependencies
sudo apt-get install wget apt-transport-https gnupg lsb-release

# Add Aqua Security public key
wget -qO - https://aquasecurity.github.io/trivy-repo/deb/public.key | gpg --dearmor | sudo tee /usr/share/keyrings/trivy.gpg > /dev/null

# Add the Trivy repository
echo "deb [signed-by=/usr/share/keyrings/trivy.gpg] https://aquasecurity.github.io/trivy-repo/deb $(lsb_release -sc) main" | sudo tee -a /etc/apt/sources.list.d/trivy.list

# Update packages and install Trivy
sudo apt-get update
sudo apt-get install trivy


trivy --version
trivy image nginx:latest


Use a different cache directory

Configure Trivy to store its cache somewhere with more space:

mkdir -p /data/trivy-cache

trivy image \
  --cache-dir /data/trivy-cache \
  nginx:latest

trivy image --severity HIGH,CRITICAL node-secure

trivy image --ignore-unfixed --severity HIGH,CRITICAL node-secure

# .trivyignore
CVE-2023-12345
CVE-2024-67890


# Filter by Package Type
# If you only want to see vulnerabilities in your application code (like npm or pip packages) and ignore OS-level packages (like apt or apk), use --pkg-types:

trivy image --pkg-types library node-secure

# Breaks the build ONLY if there is a patchable CRITICAL vulnerability
trivy image --exit-code 1 --ignore-unfixed --severity CRITICAL node-secure



1. Filesystem & Git Repository Scanning

# Scan a local folder
trivy fs /path/to/your/code

# Scan a remote GitHub repo
trivy repo https://github.com/your-org/your-repo

2. Infrastructure as Code (IaC) Scanning

# Scan a Terraform directory for misconfigurations
trivy config ./terraform-code/

3. Secret Scanning

# Scans an image specifically for hardcoded secrets
trivy image --scanners secret my-app:latest

4. Live Kubernetes Cluster Scanning

# Scan the entire cluster and output a summary report
trivy k8s cluster --report summary

# Scan a specific namespace
trivy k8s --namespace production --report all

5. Software Bill of Materials (SBOM) Generation

# Generate a CycloneDX SBOM in JSON format
trivy image --format cyclonedx --output sbom.json node-secure

6. Output Formatting for SIEMs & CI/CD

Trivy doesn't just output to the terminal. It can format its findings into JSON, HTML, or SARIF.
SARIF is particularly useful because platforms like GitHub Actions, SonarQube,
and enterprise SIEMs (like Splunk) natively ingest SARIF files to automatically create security dashboards and JIRA tickets.


trivy image --format sarif --output trivy-results.sarif node-secure