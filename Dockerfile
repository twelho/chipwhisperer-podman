FROM python:3.10-slim-bookworm

ENV DEBIAN_FRONTEND=noninteractive

# Use bash instead of dash
RUN ln -sf bash /bin/sh

# Install and upgrade base packages
RUN	apt-get update && apt-get -y full-upgrade && \
	apt-get -y install bash-completion git nano tzdata && \
	pip install --upgrade pip

# Prepare the ChipWhisperer stack
WORKDIR /opt/chipwhisperer

# Install `chipwhisperer`
RUN	git clone --depth 1 https://github.com/newaetech/chipwhisperer.git . && \
	pip install -e .

# Install `chipwhisperer-jupyter` & JupyterLab
RUN	git submodule update --init jupyter && \
	pip install -r jupyter/requirements.txt jupyterlab && \
	git submodule deinit jupyter # To be provided by user

# Install additional OS packages
RUN	apt-get -y install libusb-1.0-0 gcc-arm-none-eabi gcc-avr make

# Install/update addditional Python packages
RUN	pip install --upgrade panel nbstripout ipympl lascar

# Disable JupyterLab news popup
RUN	jupyter labextension disable "@jupyterlab/apputils-extension:announcements"

# Switch to the user-provided Jupyter source directory
WORKDIR /opt/chipwhisperer/jupyter

# Install launch script
COPY launch.sh /
CMD ["/launch.sh"]
