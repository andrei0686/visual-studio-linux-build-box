FROM ubuntu:18.04
MAINTAINER andrei

RUN apt-get update && \
	apt-get install -y openssh-server gdb gdbserver sudo build-essential git zip rsync cmake && \
	mkdir /var/run/sshd && \
	echo 'root:root' | chpasswd && \
	sed -i -E 's/#\s*PermitRootLogin.*/PermitRootLogin yes/' /etc/ssh/sshd_config && \
	sed 's@session\s*required\s*pam_loginuid.so@session optional pam_loginuid.so@g' -i /etc/pam.d/sshd && \
	git clone https://github.com/catchorg/Catch2.git && \
    cd Catch2 && \
    cmake -Bbuild -H. -DBUILD_TESTING=OFF && \
    cmake --build build/ --target install && \
	apt-get clean

VOLUME /usr/src
WORKDIR /usr/src

EXPOSE 22
CMD ["/usr/sbin/sshd", "-D"]
