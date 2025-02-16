#!/bin/bash
#
# Script to install project using uv
#

set -e

if ! command -v uv &> /dev/null; then
    echo "Installing uv"
    curl -LsSf https://astral.sh/uv/install.sh | sh
    # Add uv to path to run this script (should be injected into shell profile for subsequent sessions)
    export PATH=$PATH:$HOME/.local/bin
fi

# Create uv venv
uv venv --seed --python=3.11 --python-preference=only-managed

source .venv/bin/activate

# Clone and install sd-scripts requirements
if [ ! -d sd-scripts ]; then
    git clone -b sd3 https://github.com/kohya-ss/sd-scripts
fi
cd sd-scripts
git pull
uv pip install -r requirements.txt

# Install fluxgym requirements
cd ..
uv pip install -r requirements.txt

# Install CUDA torch requirements
uv pip install --pre torch torchvision torchaudio --index-url https://download.pytorch.org/whl/cu121
