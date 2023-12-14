#!/bin/sh -ex

# Set timezone (if provided)
if [ -n "$TZ" ]; then
	ln -sf "$TZ" /etc/localtime
fi

# Sources must come from an external mount
mountpoint "$(pwd)" || { echo "Usage: ./run.sh <chipwhisperer-jupyter_checkout_dir>" && exit 1; }

# Download `chipwhisperer-jupyter` if the user-provided checkout directory is empty
git clone --depth 1 "https://github.com/newaetech/chipwhisperer-jupyter.git" . || [ "$?" -eq 128 ]

# Patch IPython usage for JupyterLab
find . -name "*.ipynb" -exec sed -i "s/%matplotlib notebook/%matplotlib widget/g" "{}" \;

# Launch JupyterLab
exec jupyter lab --ip=0.0.0.0 --port=8888 --allow-root --no-browser --IdentityProvider.token='' --ServerApp.disable_check_xsrf=True
