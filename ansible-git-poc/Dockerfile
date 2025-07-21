# Dockerfile for the target Ansible machine
FROM ubuntu:22.04

# Install SSH server and other basics
RUN apt-get update && \
    apt-get install -y openssh-server sudo && \
    rm -rf /var/lib/apt/lists/*

# Create a user for Ansible to connect with
RUN useradd -m -s /bin/bash ansible && \
    echo "ansible:password" | chpasswd && \
    adduser ansible sudo

# Create SSH directory and authorize a public key
RUN mkdir -p /home/ansible/.ssh && \
    chmod 700 /home/ansible/.ssh

# This key will be authorized for the 'ansible' user
# We will generate this key in the next step
COPY id_rsa.pub /home/ansible/.ssh/authorized_keys
RUN chown -R ansible:ansible /home/ansible/.ssh && \
    chmod 600 /home/ansible/.ssh/authorized_keys

# Expose SSH port and start the service
EXPOSE 22
CMD ["/usr/sbin/sshd", "-D"]
