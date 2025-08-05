# Frigate NVR Installation Guide for Raspberry Pi

This guide will help you install Frigate NVR on your Raspberry Pi using Docker Compose.

## Prerequisites

- Raspberry Pi 4 (recommended) or Pi 3B+
- At least 8GB microSD card (16GB+ recommended)
- USB camera or IP camera
- Internet connection

## Step 1: Prepare Raspberry Pi

### 1.1 Install Raspberry Pi OS
1. Download Raspberry Pi OS Lite (64-bit recommended)
2. Flash to microSD card using Raspberry Pi Imager
3. Enable SSH during setup

### 1.2 Update System
```bash
sudo apt update && sudo apt upgrade -y
```

### 1.3 Install Docker and Docker Compose
```bash
# Install Docker
curl -fsSL https://get.docker.com -o get-docker.sh
sudo sh get-docker.sh
sudo usermod -aG docker $USER

# Install Docker Compose
sudo apt install docker-compose-plugin -y

# Reboot to apply changes
sudo reboot
```

## Step 2: Setup Frigate

### 2.1 Clone or Download Files
```bash
# Create project directory
mkdir ~/frigate-nvr
cd ~/frigate-nvr

# Copy the docker-compose.yml and config files to this directory
```

### 2.2 Configure Cameras
Edit `config/frigate.yml` and update the camera configuration:

```yaml
cameras:
  your_camera_name:
    ffmpeg:
      inputs:
        - path: rtsp://username:password@camera_ip:554/stream1
          roles:
            - detect
            - record
```

### 2.3 Create Required Directories
```bash
mkdir -p config media
```

## Step 3: Start Frigate

### 3.1 Start Services
```bash
docker-compose up -d
```

### 3.2 Check Status
```bash
docker-compose ps
docker-compose logs frigate
```

## Step 4: Access Frigate Web Interface

1. Open your web browser
2. Navigate to: `http://your_raspberry_pi_ip:5000`
3. Default login: No authentication required initially

## Step 5: Configuration

### 5.1 Camera Setup
1. Go to Settings > Cameras
2. Add your cameras with proper RTSP URLs
3. Configure detection zones if needed

### 5.2 Motion Detection
- Adjust motion threshold in the web interface
- Set up detection zones
- Configure object filters

### 5.3 Recording Settings
- Enable/disable recording per camera
- Set retention periods
- Configure snapshot settings

## Step 6: Optional Services

### 6.1 Home Assistant Integration
Uncomment the homeassistant service in docker-compose.yml:
```yaml
homeassistant:
  container_name: homeassistant
  image: ghcr.io/home-assistant/home-assistant:stable
  # ... rest of configuration
```

### 6.2 MQTT Broker
Uncomment the mosquitto service in docker-compose.yml:
```yaml
mosquitto:
  container_name: mosquitto
  image: eclipse-mosquitto:latest
  # ... rest of configuration
```

## Troubleshooting

### Common Issues

1. **Camera not showing**
   - Check RTSP URL format
   - Verify camera credentials
   - Test with VLC player

2. **High CPU usage**
   - Reduce detection FPS
   - Use lower resolution streams
   - Optimize motion detection settings

3. **Storage issues**
   - Check available disk space
   - Adjust retention settings
   - Use external storage

### Useful Commands

```bash
# View logs
docker-compose logs -f frigate

# Restart services
docker-compose restart

# Stop all services
docker-compose down

# Update Frigate
docker-compose pull
docker-compose up -d
```

## Performance Optimization

### For Raspberry Pi 4:
- Use 720p streams for detection
- Set FPS to 5-10 for detection
- Use CPU detection (included in config)

### For Raspberry Pi 3:
- Use 480p streams for detection
- Set FPS to 3-5 for detection
- Consider using Coral USB accelerator

## Security Considerations

1. Change default passwords
2. Use HTTPS in production
3. Restrict network access
4. Regular updates
5. Backup configurations

## Backup and Restore

### Backup Configuration
```bash
tar -czf frigate-backup-$(date +%Y%m%d).tar.gz config/
```

### Restore Configuration
```bash
tar -xzf frigate-backup-YYYYMMDD.tar.gz
```

## Support

- [Frigate Documentation](https://docs.frigate.video/)
- [Frigate GitHub](https://github.com/blakeblackshear/frigate)
- [Community Forum](https://github.com/blakeblackshear/frigate/discussions)

## License

This setup is provided as-is for educational purposes. Please refer to Frigate's license for usage terms. 