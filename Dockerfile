FROM ubuntu

RUN apt update -y && apt upgrade -y && apt install git -y && git clone https://github.com/ucpr/dotfiles

CMD ["/usr/bin/bash"]
