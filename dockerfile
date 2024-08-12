FROM ubuntu:22.04

# Set up locales
RUN apt-get update && DEBIAN_FRONTEND=noninteractive apt-get install -y locales \
    && locale-gen en_US.UTF-8 \
    && apt-get clean

ENV LANG en_US.UTF-8
ENV LANGUAGE en_US:en
ENV LC_ALL en_US.UTF-8
ENV TERM dumb
ENV PYTHONIOENCODING=utf-8

# Add deadsnakes PPA and install Python 3.8
RUN apt-get update && DEBIAN_FRONTEND=noninteractive apt-get install -y \
    software-properties-common \
    && add-apt-repository -y ppa:deadsnakes/ppa \
    && apt-get update && DEBIAN_FRONTEND=noninteractive apt-get install -y \
    python3.8 python3.8-dev python3-pip \
    && apt-get clean

# Install other necessary packages
RUN apt-get update && DEBIAN_FRONTEND=noninteractive apt-get install -y \
    git curl unzip libgtk-3-dev libboost-all-dev build-essential cmake libffi-dev firefox \
    && apt-get clean

# Clone the repository
RUN git clone https://github.com/ThoughtfulDev/EagleEye
WORKDIR /EagleEye

# Install Python dependencies
RUN pip3 install -r requirements.txt \
    && pip3 install --upgrade beautifulsoup4 html5lib spry

# Install geckodriver
ADD https://github.com/mozilla/geckodriver/releases/download/v0.27.0/geckodriver-v0.27.0-linux64.tar.gz /EagleEye/
RUN tar -xvf geckodriver-v0.27.0-linux64.tar.gz \
    && mv geckodriver /usr/bin/geckodriver \
    && chmod +x /usr/bin/geckodriver \
    && rm geckodriver-v0.27.0-linux64.tar.gz

# Ensure /entry.sh is present
COPY entry.sh /entry.sh

ENTRYPOINT ["bash", "/entry.sh"]
