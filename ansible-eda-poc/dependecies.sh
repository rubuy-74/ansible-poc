#!/bin/bash
set -e

# --- Configuration ---
PORT=8080
VENV_DIR="eda_poc_venv"

# --- Helper Functions for Colored Output ---
info() {
    echo -e "\033[1;34m[INFO]\033[0m $1"
}
success() {
    echo -e "\033[1;32m[SUCCESS]\033[0m $1"
}
warn() {
    echo -e "\033[1;33m[WARNING]\033[0m $1"
}

# --- Main Functions ---

install_dependencies() {
    info "Installing system and Python dependencies..."
    brew install curl

    info "Installing Cloudflare Tunnel (cloudflared)..."
    if ! command -v cloudflared &> /dev/null; then
        brew install cloudflared
    else
        info "Cloudflared is already installed."
    fi

    info "Setting up Python virtual environment in './${VENV_DIR}'..."
    python3 -m venv "${VENV_DIR}"
    source "${VENV_DIR}/bin/activate"

    info "Installing Ansible and EDA components..."
    pip install --upgrade pip > /dev/null
    pip install ansible-core ansible-rulebook > /dev/null
    ansible-galaxy collection install ansible.eda > /dev/null
    deactivate
    success "All dependencies installed."
}


# --- Main Execution ---
main() {
    install_dependencies

    warn "\n--- Next Steps ---"
    echo "The setup is complete. Now, you need to run the services."
    echo "1. In a NEW terminal window, start the Cloudflare tunnel:"
    echo -e "\033[1;32m   cloudflared tunnel --url http://localhost:${PORT}\033[0m"
    echo "   Log in if prompted, then copy the public '*.trycloudflare.com' URL it provides."
    echo ""
    echo "2. Use the copied URL to create a webhook in your GitHub repo's settings."
    echo "   - Set 'Content type' to 'application/json'."
    echo "   - Choose to trigger on 'Just the push event'."
    echo ""
    echo "3. In THIS terminal window, activate the environment and start the EDA listener:"
    echo -e "\033[1;32m   source ${VENV_DIR}/bin/activate\033[0m"
    echo -e "\033[1;32m   ansible-rulebook --rulebook rulebook.yml -i inventory.yml\033[0m"
    echo ""
    info "After you 'git push' to your repo, you will see the playbook output in this terminal."
}

main
