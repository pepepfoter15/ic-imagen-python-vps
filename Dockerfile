FROM python:3

MAINTAINER Pepe Rodríguez Cañas "pepepfoter15@gmail.com"
WORKDIR /usr/src/app

COPY django_tutorial /usr/src/app/

RUN pip install --root-user-action=ignore --upgrade pip && pip install --root-user-action=ignore django mysqlclient && pip install -r requirements.txt

RUN test -d static || mkdir static
ADD polls.sh /usr/src/app/
RUN chmod +x /usr/src/app/polls.sh

COPY polls.sh /usr/local/bin/polls.sh
RUN chmod +x /usr/local/bin/polls.sh
CMD /usr/local/bin/polls.sh
