FROM ubuntu:22.04

ENV container=docker

# Install required packages
RUN apt-get update && \
    apt-get upgrade -y && \
    apt-get install -y arpwatch ssmtp mailutils vim sudo systemd iproute2 && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

# Add configurations for arpwatch
RUN echo "ens224 -a -n 192.168.1.0/24 -m pushover@mailrise.xyz\n\
ens256 -a -n 10.3.33.0/24 -m pushover@mailrise.xyz\n\
ens161 -a -n 10.2.22.0/24 -m pushover@mailrise.xyz\n\
ens192 -a -n 10.1.11.0/24 -m pushover@mailrise.xyz" \
    >> /etc/arpwatch.conf

# Use sed to replace the INTERFACES line
RUN sed -i 's/^INTERFACES=".*"/INTERFACES="ens192 ens224 ens256 ens161"/' /etc/default/arpwatch

# Add configurations for ssmtp
RUN echo "root:pushover@mailrise.xyz:10.1.11.19:8025" >> /etc/ssmtp/revaliases

RUN echo "# Config file for sSMTP sendmail\n\
#\n\
# The person who gets all mail for userids < 1000\n\
# Make this empty to disable rewriting.\n\
root=pushover@mailrise.xyz\n\
# The place where the mail goes. The actual machine name is required no\n\
# MX records are consulted. Commonly mailhosts are named mail.domain.com\n\
mailhub=10.1.11.19:8025\n\
# Where will the mail seem to come from?\n\
#rewriteDomain=gmail.com\n\
# The full hostname\n\
hostname=netwatch\n\
# Use SSL/TLS before starting negotiation\n\
#UseTLS=No\n\
#UseSTARTTLS=No\n\
# Are users allowed to set their own From: address?\n\
# YES - Allow the user to specify their own From: address\n\
# NO - Use the system generated From: address\n\
FromLineOverride=YES" > /etc/ssmtp/ssmtp.conf

# Ensure permissions for log directory
RUN mkdir -p /var/log && chown -R root:root /var/log

# Create a systemd service file to handle arpwatch initialization
RUN echo "[Unit]\n\
Description=Arpwatch Initialization Service\n\
After=network.target\n\
\n\
[Service]\n\
Type=oneshot\n\
ExecStart=/bin/bash -c 'systemctl enable arpwatch@ens192 && systemctl enable arpwatch@ens224 && systemctl enable arpwatch@ens256 && systemctl enable arpwatch@ens161 && systemctl start arpwatch@ens192 && systemctl start arpwatch@ens224 && systemctl start arpwatch@ens256 && systemctl start arpwatch@ens161'\n\
RemainAfterExit=yes\n\
\n\
[Install]\n\
WantedBy=multi-user.target" > /etc/systemd/system/arpwatch-init.service

# Enable the initialization service
RUN systemctl enable arpwatch-init.service

# Configure systemd
STOPSIGNAL SIGRTMIN+3
CMD ["/lib/systemd/systemd"]
ENTRYPOINT ["/lib/systemd/systemd"]
