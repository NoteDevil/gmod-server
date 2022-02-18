FROM ubuntu

# Update aptitude with new repo
RUN apt-get update

# Install software 
RUN apt-get install -y git
RUN apt-get -y --no-install-recommends --no-install-suggests install \
    wget lib32gcc1 lib32stdc++6 ca-certificates screen tar bzip2 gzip unzip gdb


# Clone the conf files into the docker container
RUN git clone https://github.com/NoteDevil/Test-utility.git