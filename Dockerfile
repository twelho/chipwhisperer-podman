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
RUN sed -i "s/scipy==1.1.0/scipy>=1.1.0/" software/requirements.txt

# Install the ChipWhisperer stack
RUN	pip install numpy -r software/requirements.txt
RUN	python setup.py develop

# Prepare the Jupyter stack for ChipWhisperer
WORKDIR /opt/chipwhisperer-jupyter

RUN	curl -sSL "https://github.com/newaetech/chipwhisperer-jupyter/archive/8b5b28e2fb9041608b015d5333a514197485b64f.tar.gz" | \
	tar xzv --strip-components 1

# Install JupyterLab and dependencies
RUN	pip install -r requirements.txt

# Install additional components
RUN	apt-get -y install libusb-1.0-0 gcc-arm-none-eabi gcc-avr make
RUN	pip install ipympl

# Patch IPython usage for JupyterLab
RUN	sed -i "s/%matplotlib notebook/%matplotlib widget/" "ChipWhisperer Setup Test.ipynb"

# Disable JupyterLab news popup
RUN	jupyter labextension disable "@jupyterlab/apputils-extension:announcements"

# Disable jupyter_nbextensions_configurator (not compatible with JupyterLab)
RUN	jupyter server extension disable jupyter_nbextensions_configurator

# Configure JupyterLab to start automatically
CMD	jupyter lab --ip=0.0.0.0 --port=8888 --allow-root --no-browser --IdentityProvider.token=''
