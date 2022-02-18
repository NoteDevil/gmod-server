FROM ubuntu

# Install software 

RUN apt-get update && apt-get install -y wget lib32ncurses5 lib32gcc1 lib32stdc++6 lib32tinfo5 ca-certificates screen tar bzip2 gzip unzip gdb
RUN apt-get install -y git

# Clone the conf files into the docker container
RUN git clone https://github.com/NoteDevil/Test-utility.git