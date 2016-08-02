# Eclipse Ubuntu Desktop Dockerfile
# Install docker according to this link https://docs.docker.com/engine/getstarted/step_one/
# Build and run dockerfile
$ docker build -t declipse .
$ docker run -p 5901:5901 declipse

# Connect knime container via vnc (host:192.168.99.100 <docker_host_ip>) password:developer
vnc://<docker_host_ip>:5901
