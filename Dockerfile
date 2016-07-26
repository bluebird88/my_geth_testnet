FROM ethereum/client-go
MAINTAINER yanhk<bluebird88@qq.com>

ENV DEBIAN_FRONTEND noninteractive
WORKDIR /root/

## add aliyun apt source
RUN mv /etc/apt/sources.list /etc/apt/sources.list.org
ADD ./sources.list /etc/apt/sources.list
#RUN apt-get -y -qq install software-properties-common && \
RUN apt-get update

#RUN add-apt-repository ppa:ethereum/ethereum && \
RUN apt-get -y install python-software-properties 
RUN apt-get -y install software-properties-common 
RUN add-apt-repository ppa:ethereum/ethereum 
RUN apt-get update


RUN apt-get -y install vim && \
apt-get -y install python2.7 && \
apt-get -y install git && \
apt-get -y install curl wget && \
apt-get -y install screen ssh 

##install solc
RUN apt-get -y -qq install solc
## install nodejs nvm .....

###构建三个测试节点：
RUN mkdir -p /root/workspace/ethereum/testnet
RUN echo 'export testnet_root=/root/workspace/ethereum/testnet' >> ~/.bashrc && export testnet_root=/root/workspace/ethereum/testnet
WORKDIR /root/workspace/ethereum/testnet
RUN mkdir -p node0/dev && mkdir -p node1/dev && mkdir -p node2/dev
ADD ./dev/genesis.json node0/dev/genesis.json
ADD ./dev/genesis.json node1/dev/genesis.json
ADD ./dev/genesis.json node2/dev/genesis.json
## init nodes .....
RUN geth --datadir node0/.ethereum_private init node0/dev/genesis.json
RUN geth --datadir node1/.ethereum_private init node1/dev/genesis.json
RUN geth --datadir node2/.ethereum_private init node2/dev/genesis.json

ADD ./install_nvm.sh /root/
RUN chmod +x /root/*.sh 
#RUN /root/install_nvm.sh

##install python pip 
#RUN wget https://bootstrap.pypa.io/get-pip.py
ADD ./get-pip1.py /root/get-pip.py
#RUN python get-pip.py

ADD ./ipc_console.sh ./ipc_console.sh
ADD ./launchNode.sh ./launchNode.sh
RUN chmod +x /root/*.sh && chmod +x ./*.sh

ADD ./Dockerfile ./

EXPOSE 8545
EXPOSE 30303

##ENTRYPOINT ["/usr/bin/geth"]
## config ssh service for root remote login...,then start ssh service
ADD ./sshd_config /etc/ssh/
CMD service ssh start
