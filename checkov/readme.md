# Checkov Usage

This document shows how to install Checkov and run a basic infrastructure-as-code scan.

## Install

```bash
sudo apt install pipx -y
pipx ensurepath
pipx install checkov
```

## Verify installation

```bash
checkov --version
```

## Scan current directory

```bash
checkov -d .
```

## Scan with configuration file

```bash
checkov --config-file .checkov.yaml
```

## Export JUnit XML report

```bash
checkov -d . --config-file .checkov.yaml --output junitxml > checkov-report.xml
```

## Scan for Secrets

```bash
checkov -d . --framework secrets
```

## Running a Targeted Scan on Specific Files

```bash
checkov -f startup_script.sh --framework secrets
```

### Install Junit plugin on Jenkins for reports