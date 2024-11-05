FROM nvidia/cuda:12.4.1-devel-ubuntu22.04

COPY ./cmake-3.27.9-linux-x86_64.sh /home/

ARG DEBIAN_FRONTEND=noninteractive

RUN apt-get update && apt-get install -y gdb rsync zip make openssh-server ninja-build

RUN cd /home && chmod 777 cmake-3.27.9-linux-x86_64.sh && mkdir /opt/3.27.9 && ./cmake-3.27.9-linux-x86_64.sh --skip-license --prefix=/opt/3.27.9 && ln -s /opt/3.27.9/bin/* /usr/local/bin

RUN mkdir /var/run/sshd
RUN echo "root:ejik" | chpasswd
RUN sed -i 's/#PermitRootLogin prohibit-password/PermitRootLogin yes/' /etc/ssh/sshd_config
RUN sed -i 's/#PasswordAuthentication yes/PasswordAuthentication yes/' /etc/ssh/sshd_config

# RUN echo CUDACXX=/usr/local/cuda/bin/nvcc >> /etc/environment

RUN rm /home/cmake-3.27.9-linux-x86_64.sh

EXPOSE 22

CMD ["/usr/sbin/sshd", "-D"]
