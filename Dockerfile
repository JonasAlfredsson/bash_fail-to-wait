FROM debian:buster

# Get some dependencies.
RUN apt-get update && apt-get install -y \
    build-essential \
    nano \
    wget

# Download Bash 5.1 and build it.
RUN wget http://ftp.gnu.org/gnu/bash/bash-5.1.tar.gz && \
    tar xf bash-5.1.tar.gz && \
    rm -f bash-5.1.tar.gz && \
    cd bash-5.1 && \
    ./configure && \
    make && \
# Create symlinks to the executables for easier differentiating.
    ln -s /bin/bash /usr/bin/bash5.0 && \
    ln -s /bash-5.1/bash /usr/bin/bash5.1

# Copy over our example script.
COPY fail_to_wait.sh .
