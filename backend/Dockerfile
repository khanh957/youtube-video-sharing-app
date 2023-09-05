FROM ruby:3

ENV DEBIAN_FRONTEND noninteractive
ENV DEBCONF_NONINTERACTIVE_SEEN true

RUN apt-get update -y && \
  apt-get install -y unzip xvfb \
  libqt5webkit5-dev \
  gstreamer1.0-plugins-base \
  gstreamer1.0-tools gstreamer1.0-x \
  freetds-dev \
  libnss3 libxi6 libgconf-2-4

WORKDIR /usr/src/app

# Install app
COPY ./backend/Gemfile ./backend/Gemfile.lock ./
RUN gem install bundler:2.4
RUN bundle install

# Init script
COPY ./backend/init.sh /
RUN apt-get update -y && \
  apt-get install -y dos2unix
RUN dos2unix /init.sh
ENTRYPOINT [ "/init.sh" ]

EXPOSE 3000
