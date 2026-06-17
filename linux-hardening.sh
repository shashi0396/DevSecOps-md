# ----------------------------------------------------------------------------------------------------
# 1. Create and Manage Linux Users
# ----------------------------------------------------------------------------------------------------

sudo useradd -m -s /bin/bash devuser

# | Option         | Meaning                                   |
# | -------------- | ----------------------------------------- |
# | `-m`           | Create the user's home directory          |
# | `-s /bin/bash` | Set the user's login shell to `/bin/bash` |

# -s /bin/bash (login shell)

# This specifies which shell starts when the user logs in.

# Common shells:

# /bin/bash — Bash (most common)
# /bin/sh — POSIX shell
# /bin/zsh — Z shell
# /usr/sbin/nologin — Prevent interactive logins
# /bin/false — Immediately exits on login

# You can verify a user's shell in:
grep devuser /etc/passwd
# o/p:
# devuser:x:1001:1001::/home/devuser:/bin/bash

# ----------------------------------------------------------------------------------------------------
# Setting a password:
# ---------------------------------------------------------------------------------------------------

# The account is locked until you assign a password.

sudo passwd devuser

# (keeps your current working directory (/home/ubuntu)
su devuser

su - devuser
# ( so it changes to the user's home directory (/home/devuser) and loads their environment

# ----------------------------------------------------------------------------------------------------
# PASSWORD Reset:
# ----------------------------------------------------------------------------------------------------
# If you have sudo access on the server, you can reset a user's password with:

sudo passwd devuser

# To reset your own password (while logged in as that user):

passwd

# Delete a user and their home directory (-r):
sudo userdel -r devuser

# ----------------------------------------------------------------------------------------------------
# how to recover passwd
# ----------------------------------------------------------------------------------------------------

# see the existing password, that's not possible on Linux.
# Passwords are not stored in plain text.
# Linux stores a hashed version in /etc/shadow, so the original password cannot be recovered.

# You can view the hash (requires root):
sudo cat /etc/shadow | grep devuser

# If you need access to the account - Reset the password instead

#-----------------------------------------------------------------------------------------------------
# Add a user to a group (e.g., the sudo or wheel group for admin rights):
#-----------------------------------------------------------------------------------------------------
sudo usermod -aG sudo devuser

# -a = append (don't remove the user from other groups)
# -G = specify supplementary groups


# Add devuser to the wheel group (common on RHEL/CentOS/Amazon Linux):
sudo usermod -aG wheel devuser

# Verify group membership
groups devuser
# o/p: devuser : devuser sudo
# or 
id devuser
# o/p: uid=1001(devuser) gid=1001(devuser) groups=1001(devuser),27(sudo)

getent group
getent group sudo
# or 
cat /etc/group

#-----------------------------------------------------------------------------------------------------
# Remove a user from a group:
#-----------------------------------------------------------------------------------------------------

sudo deluser devuser sudo
# or 
sudo gpasswd -d devuser sudo


# --------------------------------------------------------------------------------------------------
# 2. Configure Least Privilege Access
# --------------------------------------------------------------------------------------------------

# "Principle of Least Privilege (PoLP)" dictates that a user should only have the bare minimum permissions 
# required to do their job. Instead of giving someone full sudo access, you can restrict them to specific commands.

# Using "visudo":
# Always use the visudo command to edit the /etc/sudoers file.
# It checks for syntax errors before saving, preventing you from locking yourself out

sudo visudo

devuser ALL=(ALL) /bin/systemctl restart nginx

# (If you want them to do it without being prompted for a password, add NOPASSWD: before the command path).

devuser ALL=(ALL) NOPASSWD: /bin/systemctl restart nginx


# You recently authenticated once

# sudo caches authentication for ~5–15 minutes.

sudo -k

# rule does NOT force password — it only allows command

# Create a strict sudo rule (password required)

sudo visudo -f /etc/sudoers.d/devuser

devuser ALL=(ALL) PASSWD: /usr/bin/systemctl restart nginx

sudo -k

sudo systemctl restart nginx
# [sudo] password for devuser:

#-----------------------------------------------------------------------------------------------------
# 3. Harden SSH Configuration & Disable Root Login
#-----------------------------------------------------------------------------------------------------

sudo vi /etc/ssh/sshd_config


sudo cp /home/ubuntu/.ssh/authorized_keys /home/devuser/.ssh/
sudo chown -R devuser:devuser /home/devuser/.ssh
sudo chmod 700 /home/devuser/.ss
sudo chmod 700 /home/devuser/.ssh
sudo chmod 600 /home/devuser/.ssh/authorized_keys

# Disable Root Login: Attackers always try to brute-force the root account.
# Force users to log in as standard users and escalate privileges via sudo
PermitRootLogin no

# Disable Password Authentication: Force the use of SSH keys instead of passwords to eliminate
# brute-force attacks. (Ensure you have SSH keys set up before doing this!)
PasswordAuthentication no

# Restrict SSH Access to Specific Users: Only allow explicitly named users to connect.
AllowUsers ubuntu devuser adminuser


ClientAliveInterval 300   # Server sends a check every 300 seconds (5 minutes)
ClientAliveCountMax 2     # Disconnects if the client misses 2 checks

sudo systemctl restart ssh
sudo systemctl status ssh

# ----------------------------------------------------------------------------------------------------
# 4. Configure Password Policies
# ----------------------------------------------------------------------------------------------------

vi /etc/login.defs

PASS_MAX_DAYS   90   # Passwords expire after 90 days
PASS_MIN_DAYS   7    # Users must wait 7 days before changing it again
PASS_WARN_AGE   14   # Warn users 14 days before expiration


# Modify an existing user's password aging:
# Use the 'chage' command to apply these rules to existing accounts.

sudo chage -M 90 -m 7 -W 14 devuser

# Password Complexity (PAM):
# To enforce complexity (length, symbols, etc.),you use Pluggable Authentication Modules (PAM). 
# On Debian/Ubuntu, you can install 'libpam-pwquality'

sudo apt install libpam-pwquality

vi /etc/security/pwquality.conf 
# to enforce rules like "minlen = 12" (min. 12 chars) or "dcredit = -1" (requires at least 1 digit).

# ----------------------------------------------------------------------------------------------------
# 5. Audit Linux Permissions & Identify SUID Binaries
# ----------------------------------------------------------------------------------------------------

# SUID (Set owner User ID) and SGID (Set Group ID) are special permissions.
# If an executable has the "SUID bit set", it runs with the privileges of the file owner (often root)
# rather than the user running it. Attackers actively hunt for misconfigured SUID binaries to escalate 
# their privileges to root.

# | Value | Meaning                                    |
# | ----- | ------------------------------------------ |
# | 4000  | SUID (run as owner)                        |
# | 2000  | SGID (run as group)                        |
# | 1000  | Sticky bit (protect file deletion in dirs) |
# | 7000  | all three combined                         |

# Find all SUID binaries on the system:
find / -perm -4000 -type f 2>/dev/null

# Find all SGID binaries:
find / -perm -2000 -type f 2>/dev/null

# Files that anyone can write to are a massive security risk
find / -xdev -type f -perm -0002 2>/dev/null

# | Part          | Meaning                  |
# | ------------- | ------------------------ |
# | `find /`      | search entire system     |
# | `-xdev`       | stay on same filesystem  |
# | `-type f`     | only files               |
# | `-perm -0002` | files writable by anyone |
# | `2>/dev/null` | hide errors              |


# Who assigns them?
# 1. Package maintainers (most common)

# 2. Root / system administrator (manual)
sudo chmod 4755 file   # SUID
sudo chmod 2755 file   # SGID
sudo chmod 1777 dir    # sticky bit


# restrict deletion in directory means?

# What it means?

# Normally, if a directory is writable by multiple users:
# anyone can delete or rename any file inside it

# But with the sticky bit set:
# Only the file owner, directory owner, or root can delete/rename files inside it

