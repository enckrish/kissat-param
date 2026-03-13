#!/bin/bash
echo "Running one-time setup script to install tools and dependencies..."

python -m venv .venv

mkdir -p .tools
cd .tools

git clone https://github.com/berkeley-abc/abc
cd abc && make -j$(nproc) 
cd ..

git clone https://github.com/arminbiere/cadical
cd cadical && ./configure && make -j$(nproc)
cd ..

wget https://github.com/YosysHQ/oss-cad-suite-build/releases/download/2026-03-11/oss-cad-suite-linux-x64-20260311.tgz
tar -xzf oss-cad-suite-linux-x64-20260311.tgz
rm oss-cad-suite-linux-x64-20260311.tgz

sh env_setup.sh