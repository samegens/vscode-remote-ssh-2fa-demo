#!/bin/bash
set -euo pipefail

apt-get update

echo "Installing google-authenticator..."
apt-get install -y libpam-google-authenticator

echo "Enabling password authentication..."
sed -i 's/PasswordAuthentication no/PasswordAuthentication yes/' /etc/ssh/sshd_config

echo "Enabling 2FA on regular sshd..."
sed -i 's/ChallengeResponseAuthentication no/ChallengeResponseAuthentication yes/' /etc/ssh/sshd_config
echo "auth required pam_google_authenticator.so" >> /etc/pam.d/sshd

echo "Reloading sshd..."
systemctl reload sshd

echo "============================= IMPORTANT ==============================="
echo "Before you can use 2FA, you have to login as vagrant with 'vagrant ssh'"
echo "and add a token by running google-authenticator. Answer 'y' to all"
echo "questions. In FreeOTP you can scan the QR code and after this you will"
echo "receive a password request and a TOTP challenge when logging in with"
echo "ssh 192.168.13.49"
echo "============================= IMPORTANT ==============================="
