<<<<<<< HEAD

=======
>>>>>>> 3cffa8503c2b0c27c97710f7cef017b6e28ece21
## Deploy the vulnerable target app in the background
docker run -d --name juice-shop -p 3000:3000 bkimminich/juice-shop



## Run the ZAP scan directly against the EC2 Public IP
docker run -t --rm \
  -v $(pwd):/zap/wrk/:rw \
  ghcr.io/zaproxy/zaproxy:stable zap-baseline.py \
  -t http://YOUR_EC2_PUBLIC_IP:3000 \
  -r zap_report.html


## ZAP has a dedicated script specifically for this called zap-api-scan.py
docker run -t --rm \
  -v $(pwd):/zap/wrk/:rw \
  ghcr.io/zaproxy/zaproxy:stable zap-api-scan.py \
  -t http://YOUR_BACKEND_IP:8080/v3/api-docs \
  -f openapi \
<<<<<<< HEAD
  -r zap_api_report.html
=======
  -r zap_api_report.html
>>>>>>> 3cffa8503c2b0c27c97710f7cef017b6e28ece21
