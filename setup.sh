#!/bin/bash

# Frigate NVR Setup Script for Raspberry Pi
# This script automates the installation process

set -e

echo "🚀 Starting Frigate NVR Setup for Raspberry Pi..."

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Function to print colored output
print_status() {
    echo -e "${GREEN}[INFO]${NC} $1"
}

print_warning() {
    echo -e "${YELLOW}[WARNING]${NC} $1"
}

print_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

# Check if running on Raspberry Pi
check_raspberry_pi() {
    if ! grep -q "Raspberry Pi" /proc/cpuinfo 2>/dev/null; then
        print_warning "This script is designed for Raspberry Pi. Continue anyway? (y/N)"
        read -r response
        if [[ ! "$response" =~ ^[Yy]$ ]]; then
            exit 1
        fi
    fi
}

# Update system
update_system() {
    print_status "Updating system packages..."
    sudo apt update && sudo apt upgrade -y
}

# Install Docker
install_docker() {
    print_status "Installing Docker..."
    
    if command -v docker &> /dev/null; then
        print_status "Docker is already installed"
    else
        curl -fsSL https://get.docker.com -o get-docker.sh
        sudo sh get-docker.sh
        sudo usermod -aG docker "$USER"
        rm get-docker.sh
    fi
}

# Install Docker Compose
install_docker_compose() {
    print_status "Installing Docker Compose..."
    
    if command -v docker-compose &> /dev/null; then
        print_status "Docker Compose is already installed"
    else
        sudo apt install docker-compose-plugin -y
    fi
}

# Create directories
create_directories() {
    print_status "Creating required directories..."
    mkdir -p config media
    mkdir -p mosquitto/config mosquitto/data mosquitto/log
}

# Set permissions
set_permissions() {
    print_status "Setting proper permissions..."
    sudo chown -R "$USER:$USER" config media
    sudo chown -R "$USER:$USER" mosquitto
}

# Check Docker service
check_docker_service() {
    print_status "Checking Docker service..."
    if ! sudo systemctl is-active --quiet docker; then
        print_status "Starting Docker service..."
        sudo systemctl start docker
        sudo systemctl enable docker
    fi
}

# Validate configuration
validate_config() {
    print_status "Validating configuration files..."
    
    if [ ! -f "docker-compose.yml" ]; then
        print_error "docker-compose.yml not found!"
        exit 1
    fi
    
    if [ ! -f "config/frigate.yml" ]; then
        print_error "config/frigate.yml not found!"
        exit 1
    fi
}

# Start services
start_services() {
    print_status "Starting Frigate services..."
    docker-compose up -d
    
    print_status "Waiting for services to start..."
    sleep 10
    
    # Check service status
    if docker-compose ps | grep -q "Up"; then
        print_status "Services started successfully!"
    else
        print_error "Some services failed to start. Check logs with: docker-compose logs"
        exit 1
    fi
}

# Display information
display_info() {
    echo ""
    echo "🎉 Frigate NVR Setup Complete!"
    echo ""
    echo "📋 Next Steps:"
    echo "1. Access the web interface at: http://$(hostname -I | awk '{print $1}'):5000"
    echo "2. Configure your cameras in the web interface"
    echo "3. Edit config/frigate.yml for advanced settings"
    echo ""
    echo "📚 Useful Commands:"
    echo "- View logs: docker-compose logs -f frigate"
    echo "- Restart: docker-compose restart"
    echo "- Stop: docker-compose down"
    echo "- Update: docker-compose pull && docker-compose up -d"
    echo ""
    echo "📖 Documentation: https://docs.frigate.video/"
    echo ""
}

# Main execution
main() {
    print_status "Starting Frigate NVR installation..."
    
    check_raspberry_pi
    update_system
    install_docker
    install_docker_compose
    create_directories
    set_permissions
    check_docker_service
    validate_config
    start_services
    display_info
}

# Run main function
main "$@" 