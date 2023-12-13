FROM python:3.10-slim-bookworm

ENV DEBIAN_FRONTEND=noninteractive

# Use bash instead of dash
RUN ln -sf bash /bin/sh

# Install and upgrade base packages
RUN	apt-get update && apt-get -y full-upgrade && \
	apt-get -y install bash-completion curl nano tzdata && \
	pip install --upgrade pip

# Set timezone
RUN	ln -sf /usr/share/zoneinfo/Europe/Oslo /etc/localtime

# Prepare the ChipWhisperer stack
WORKDIR /opt/chipwhisperer

RUN	curl -sSL "https://github.com/newaetech/chipwhisperer/archive/refs/tags/5.7.0.tar.gz" | \
	tar xzv --strip-components 1

# Patch scipy version
RUN	sed -i "s/scipy==1.1.0/scipy>=1.1.0/" software/requirements.txt

# Install the ChipWhisperer stack
RUN	pip install numpy -r software/requirements.txt
RUN	python setup.py develop

# Install additional components
RUN	apt-get -y install libusb-1.0-0 gcc-arm-none-eabi gcc-avr make

# Install JupyterLab and dependencies
RUN	pip install -r <(\
	curl -sSL "https://github.com/newaetech/chipwhisperer-jupyter/archive/8b5b28e2fb9041608b015d5333a514197485b64f.tar.gz" | \
	tar xzO --wildcards --no-wildcards-match-slash "*/requirements.txt")

# Install additional components
RUN	pip install ipympl lascar

# Disable JupyterLab news popup
RUN	jupyter labextension disable "@jupyterlab/apputils-extension:announcements"

# Disable jupyter_nbextensions_configurator (not compatible with JupyterLab)
RUN	jupyter server extension disable jupyter_nbextensions_configurator

# Working directory for mounting user data
WORKDIR /data

# Install launch script
COPY launch.sh /
CMD ["/launch.sh"]
