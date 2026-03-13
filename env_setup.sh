#!/usr/bin/env bash

# Project root
export PROJECT_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Tools
export PATH="$PROJECT_ROOT/.tools/cadical/build:$PATH"
export PATH="$PROJECT_ROOT/.tools/abc:$PATH"
export PATH="$PROJECT_ROOT"/.tools/oss-cad-suite/bin:$PATH

# Python venv
source "$PROJECT_ROOT/.venv/bin/activate"