FROM ubuntu

# Update aptitude with new repo
RUN apt-get update

# Install software 
RUN apt-get install -y git
RUN apt-get -y --no-install-recommends --no-install-suggests install \
    wget lib32gcc1 lib32stdc++6 ca-certificates libsdl2-2.0-0 screen vim tar bzip2 gzip unzip gdb

RUN apt-get clean
RUN rm -rf /tmp/* /var/lib/apt/lists/*

# SET STEAM USER
RUN useradd -d /home/gmod -m steam
USER steam
RUN mkdir /home/gmod/server && mkdir /home/gmod/steamcmd

# INSTALL STEAMCMD
RUN wget -P /home/gmod/steamcmd/ https://steamcdn-a.akamaihd.net/client/installer/steamcmd_linux.tar.gz \
    && tar -xvzf /home/gmod/steamcmd/steamcmd_linux.tar.gz -C /home/gmod/steamcmd \
    && rm -rf /home/gmod/steamcmd/steamcmd_linux.tar.gz

# SETUP STEAMCMD TO DOWNLOAD GMOD SERVER
COPY assets/update.txt /home/gmod/update.txt
RUN /home/gmod/steamcmd/steamcmd.sh +runscript /home/gmod/update.txt +quit

# Clone the conf files into the docker container
RUN git clone https://github.com/NoteDevil/Test-utility.git