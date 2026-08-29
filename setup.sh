#!/bin/bash

# Color codes for output
RED='\033[0;31m'
GREEN='\033[0;32m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Available tools
TOOLS=("abc" "cadical" "aiger" "oss-cad-suite" "cadiback" "kissat")
INSTALL_VENV=false
INSTALL_ENV_SETUP=false

print_help() {
    echo "Usage: ./setup.sh [OPTIONS]"
    echo ""
    echo "Installation options:"
    echo "  --all                 Install all tools and dependencies"
    echo "  --abc                 Install berkeley-abc"
    echo "  --cadical             Install cadical SAT solver"
    echo "  --aiger               Install aiger"
    echo "  --oss-cad-suite       Install oss-cad-suite"
    echo "  --cadiback            Install cadiback"
    echo "  --kissat              Install kissat SAT solver"
    echo "  --venv                Create Python virtual environment"
    echo "  --env-setup           Run environment setup (creates .venv/bin wrappers)"
    echo "  --help                Show this help message"
    echo ""
    echo "Examples:"
    echo "  ./setup.sh --all                 # Install everything"
    echo "  ./setup.sh --abc --kissat        # Install only abc and kissat"
    echo "  ./setup.sh --venv                # Only create Python venv"
}

# Parse command-line arguments
if [ $# -eq 0 ]; then
    echo -e "${RED}Error: No arguments provided${NC}"
    print_help
    exit 1
fi

INSTALL_TOOLS=()

for arg in "$@"; do
    case $arg in
        --help)
            print_help
            exit 0
            ;;
        --all)
            INSTALL_TOOLS=("${TOOLS[@]}")
            INSTALL_VENV=true
            INSTALL_ENV_SETUP=true
            ;;
        --venv)
            INSTALL_VENV=true
            ;;
        --env-setup)
            INSTALL_ENV_SETUP=true
            ;;
        --abc|--cadical|--aiger|--oss-cad-suite|--cadiback|--kissat)
            TOOL_NAME="${arg:2}"  # Remove leading "--"
            INSTALL_TOOLS+=("$TOOL_NAME")
            ;;
        *)
            echo -e "${RED}Error: Unknown option '$arg'${NC}"
            print_help
            exit 1
            ;;
    esac
done

# Remove duplicates from INSTALL_TOOLS
INSTALL_TOOLS=($(printf '%s\n' "${INSTALL_TOOLS[@]}" | sort -u))

echo -e "${BLUE}=== Starting Setup ===${NC}"

# Install Python venv if requested
if [ "$INSTALL_VENV" = true ]; then
    echo -e "${BLUE}Installing Python virtual environment...${NC}"
    python -m venv .venv
    if [ $? -eq 0 ]; then
        echo -e "${GREEN}✓ Python venv created${NC}"
    else
        echo -e "${RED}✗ Failed to create Python venv${NC}"
        exit 1
    fi
fi

# Create tools directory
mkdir -p .tools
cd .tools || exit 1

# Install individual tools
install_abc() {
    echo -e "${BLUE}Installing berkeley-abc...${NC}"
    if [ -d "abc" ]; then
        echo -e "${BLUE}  (abc already exists, skipping clone)${NC}"
        cd abc
    else
        git clone https://github.com/berkeley-abc/abc || return 1
        cd abc || return 1
    fi
    make -j$(nproc) && echo -e "${GREEN}✓ abc installed${NC}" || echo -e "${RED}✗ abc installation failed${NC}"
    cd ..
}

install_cadical() {
    echo -e "${BLUE}Installing cadical...${NC}"
    if [ -d "cadical" ]; then
        echo -e "${BLUE}  (cadical already exists, skipping clone)${NC}"
        cd cadical
    else
        git clone https://github.com/arminbiere/cadical || return 1
        cd cadical || return 1
    fi
    ./configure && make -j$(nproc) && echo -e "${GREEN}✓ cadical installed${NC}" || echo -e "${RED}✗ cadical installation failed${NC}"
    cd ..
}

install_aiger() {
    echo -e "${BLUE}Installing aiger...${NC}"
    if [ -d "aiger" ]; then
        echo -e "${BLUE}  (aiger already exists, skipping clone)${NC}"
        cd aiger
    else
        git clone https://github.com/arminbiere/aiger || return 1
        cd aiger || return 1
    fi
    ./configure.sh && make -j$(nproc) && echo -e "${GREEN}✓ aiger installed${NC}" || echo -e "${RED}✗ aiger installation failed${NC}"
    cd ..
}

install_oss_cad_suite() {
    echo -e "${BLUE}Installing oss-cad-suite...${NC}"
    OSS_FILE="oss-cad-suite-linux-x64-20260311.tgz"
    if [ ! -d "oss-cad-suite" ]; then
        wget https://github.com/YosysHQ/oss-cad-suite-build/releases/download/2026-03-11/$OSS_FILE || return 1
        tar -xzf $OSS_FILE || return 1
        rm $OSS_FILE
        echo -e "${GREEN}✓ oss-cad-suite installed${NC}"
    else
        echo -e "${BLUE}  (oss-cad-suite already exists, skipping)${NC}"
    fi
}

install_cadiback() {
    echo -e "${BLUE}Installing cadiback...${NC}"
    if [ -d "cadiback" ]; then
        echo -e "${BLUE}  (cadiback already exists, skipping clone)${NC}"
        cd cadiback
    else
        git clone https://github.com/arminbiere/cadiback || return 1
        cd cadiback || return 1
    fi
    ./configure && make && echo -e "${GREEN}✓ cadiback installed${NC}" || echo -e "${RED}✗ cadiback installation failed${NC}"
    cd ..
}

install_kissat() {
    echo -e "${BLUE}Installing kissat...${NC}"
    if [ -d "kissat" ]; then
        echo -e "${BLUE}  (kissat already exists, skipping clone)${NC}"
        cd kissat
    else
        git clone https://github.com/arminbiere/kissat || return 1
        cd kissat || return 1
    fi
    ./configure && make && echo -e "${GREEN}✓ kissat installed${NC}" || echo -e "${RED}✗ kissat installation failed${NC}"
    cd ..
}

# Install requested tools
for tool in "${INSTALL_TOOLS[@]}"; do
    case $tool in
        abc) install_abc ;;
        cadical) install_cadical ;;
        aiger) install_aiger ;;
        oss-cad-suite) install_oss_cad_suite ;;
        cadiback) install_cadiback ;;
        kissat) install_kissat ;;
    esac
done

# Return to project root
cd ..

# Run environment setup if requested
if [ "$INSTALL_ENV_SETUP" = true ]; then
    echo -e "${BLUE}Running environment setup...${NC}"
    sh env_setup.sh || echo -e "${RED}✗ env_setup.sh failed${NC}"
fi

echo "Creating datsets..."
python data_generator.py

echo "Creating training data for GNN..."
python gnn_datagen.py

echo -e "${GREEN}=== Setup Complete ===${NC}"
echo "You are ready to run training_and_test.ipynb now!"
