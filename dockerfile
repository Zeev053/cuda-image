FROM nvidia/cuda:12.6.2-devel-ubuntu24.04

# ARG DEBIAN_FRONTEND=noninteractive

RUN echo run with apt-get && \
    echo ---------------- && \
    apt-get update && apt-get install -y gdb gdbserver rsync zip git vim nano \
    make openssh-server ninja-build libboost-all-dev googletest libgmock-dev gcc-13-x86-64-linux-gnu && \
    echo

RUN echo install cmake && \
    echo ------------- && \
    cd /tmp && \ 
    wget --no-check-certificate https://github.com/Kitware/CMake/releases/download/v3.30.5/cmake-3.30.5-linux-x86_64.tar.gz && \
    mkdir -p /opt/cmake/ && \
    tar -xvzf cmake-3.30.5-linux-x86_64.tar.gz -C /opt/cmake/ && \
    ln -s /opt/cmake/cmake-3.30.5-linux-x86_64/bin/* /usr/local/bin && \
    rm -f cmake-3.30.5-linux-x86_64.tar.gz

RUN mkdir /var/run/sshd && \
    echo "root:1" | chpasswd && \
    sed -i 's/#PermitRootLogin prohibit-password/PermitRootLogin yes/' /etc/ssh/sshd_config && \
    sed -i 's/#PasswordAuthentication yes/PasswordAuthentication yes/' /etc/ssh/sshd_config && \
    echo CUDACXX=/usr/local/cuda/bin/nvcc >> /etc/environment

EXPOSE 22

CMD ["/usr/sbin/sshd", "-D"]
