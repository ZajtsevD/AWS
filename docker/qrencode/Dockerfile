FROM debian:9

RUN apt-get update
RUN apt-get install -y git-core python-virtualenv qrencode
RUN git clone https://github.com/chubin/qrenco.de
RUN cd qrenco.de && virtualenv ve/ && ve/bin/pip install -r requirements.txt

EXPOSE 8003

CMD cd qrenco.de && ve/bin/python bin/srv.py
