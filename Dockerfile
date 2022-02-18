FROM ubuntu

# Update aptitude with new repo
RUN apt-get update

# Install software 
RUN apt-get install -y git


# Clone the conf files into the docker container
RUN git clone https://github.com/NoteDevil/Test-utility.git