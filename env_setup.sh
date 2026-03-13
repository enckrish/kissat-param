#!/bin/bash
set -e

PROJECT_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Tell the venv script NOT to mess with our prompt
# export VIRTUAL_ENV_DISABLE_PROMPT=0

# Activate Python virtual environment
source "$PROJECT_ROOT/.venv/bin/activate"

# Add tools to PATH
export PATH="$PROJECT_ROOT/.tools/cadical/build:$PATH"
export PATH="$PROJECT_ROOT/.tools/abc:$PATH"
export PATH="$PROJECT_ROOT/.tools/oss-cad-suite/bin:$PATH"