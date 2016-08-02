############################################################
# Dockerfile to build Eclipse container images
# Based on Ubuntu
# $ docker build -t declipse .
# $ docker run -p 5901:5901 declipse
############################################################

# Set the base image to Ubuntu
FROM ubuntu:14.04
ENV DEBIAN_FRONTEND noninteractive

# File Author / Maintainer
MAINTAINER Ercan Can "ercanxcan@gmail.com"

# Create ubuntu user
RUN useradd -m -d /home/developer -s /bin/bash -c "Development User" -U developer

# Set environment variables
ENV USER developer
ENV HOME /home/developer
WORKDIR /home/developer

# Install ubuntu desktop and vnc server
RUN apt-get update && \
	apt-get install -y xvfb && \
    apt-get install -y --no-install-recommends ubuntu-desktop && \
    apt-get install -y gnome-panel gnome-settings-daemon metacity nautilus gnome-terminal && \
    apt-get install -y tightvncserver && \
    mkdir /home/developer/.vnc

# Add vnc settings 	
ADD xstartup /home/developer/.vnc/xstartup

# Create vnc password
RUN echo "developer" | vncpasswd -f > /home/developer/.vnc/passwd && \
    chmod 600 /home/developer/.vnc/passwd

# Java installation	
RUN add-apt-repository ppa:webupd8team/java && \
    apt-get update -y && \
    echo oracle-java8-installer shared/accepted-oracle-license-v1-1 select true | debconf-set-selections && \
    apt-get install oracle-java8-installer libxext-dev libxrender-dev libxtst-dev -y

# Download and installation Eclipse
RUN wget http://eclipse.bluemix.net/packages/neon/data/eclipse-jee-neon-R-linux-gtk-x86_64.tar.gz -O /tmp/eclipse.tar.gz &&\
    tar -xf /tmp/eclipse.tar.gz -C /home/developer &&\
    rm /tmp/eclipse.tar.gz &&\
    apt-get install libwebkitgtk-1.0-0 -y

# Install firefox and net tools
RUN apt-get install firefox -y && \
    apt-get install -y net-tools

# Start vnc server	
CMD /usr/bin/vncserver :1 -geometry 1920x1080 -depth 24 && tail -f /home/developer/.vnc/*:1.log

# Container listens on the 5901 at runtime.
EXPOSE 5901