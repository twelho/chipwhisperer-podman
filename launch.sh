#!/bin/sh -ex

# Sources must come from an external mount
mountpoint "$(pwd)" || { echo "Usage: ./run.sh <chipwhisperer-jupyter-checkout-dir>" && exit 1; }

# Patch IPython usage for JupyterLab
sed -i "s/%matplotlib notebook/%matplotlib widget/" "ChipWhisperer Setup Test.ipynb"

# Launch JupyterLab
exec jupyter lab --ip=0.0.0.0 --port=8888 --allow-root --no-browser --IdentityProvider.token='' --NotebookApp.disable_check_xsrf=True
