# Apparently you can't use Dockerfiles as input.
# Build the base terrier Docker image and upload it to Docker Hub.
FROM wanshenl/terrier

RUN apt-get update && \
    # Packages for CLion remote debugging.
    apt-get install -y \
      gdb \
      gdbserver \
      openssh-server \
      && \
    # Setup user accounts.
    useradd -ms /bin/bash debugger && \
    echo 'root:TerrierDb' | chpasswd && \
    echo 'debugger:BugsAreBad' | chpasswd && \
    # Create a folder for sshd to run in.
    mkdir /var/run/sshd && \
    # Allow the root user to ssh in.
    sed -i 's/#PermitRootLogin prohibit-password/PermitRootLogin yes/' /etc/ssh/sshd_config && \
    # Workaround for ssh kicking the user off.
    sed 's@session\s*required\s*pam_loginuid.so@session optional pam_loginuid.so@g' -i /etc/pam.d/sshd

# 22 = sshd, 7777 = gdbserver
EXPOSE 22 7777

# Run sshd.
CMD ["/usr/sbin/sshd", "-D"]

