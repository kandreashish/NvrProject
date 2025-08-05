# Quick Start Guide - Frigate NVR on Raspberry Pi

## 🚀 Quick Installation

1. **Copy files to your Raspberry Pi**
   ```bash
   # On your Raspberry Pi
   mkdir ~/frigate-nvr
   cd ~/frigate-nvr
   # Copy all files from this directory
   ```

2. **Run the setup script**
   ```bash
   ./setup.sh
   ```

3. **Access Frigate**
   - Open browser: `http://192.168.1.5:5000`
   - No login required initially

## 📝 Manual Setup (if script fails)

### Install Docker
```bash
curl -fsSL https://get.docker.com -o get-docker.sh
sudo sh get-docker.sh
sudo usermod -aG docker $USER
sudo reboot
```

### Install Docker Compose
```bash
sudo apt install docker-compose-plugin -y
```

### Start Frigate
```bash
mkdir -p config media
docker-compose up -d
```

## 🔧 Basic Configuration

### 1. Add Your Camera
Edit `config/frigate.yml`:
```yaml
cameras:
  front_door:
    ffmpeg:
      inputs:
        - path: rtsp://AshishWar:ashish123@192.168.1.11:554/stream1
          roles:
            - detect
            - record
```

### 2. Common Camera URLs
- **Hikvision**: `rtsp://username:password@ip:554/Streaming/Channels/101`
- **Dahua**: `rtsp://username:password@ip:554/cam/realmonitor?channel=1&subtype=0`
- **Generic IP Camera**: `rtsp://username:password@ip:554/stream1`

### 3. Restart After Changes
```bash
docker-compose restart
```

## 🎯 Essential Settings

### Motion Detection
- **Threshold**: 25 (adjust based on environment)
- **Min Area**: 1000 (smaller = more sensitive)
- **FPS**: 5-10 for detection

### Recording
- **Retention**: 7 days (adjust based on storage)
- **Mode**: motion (only record when motion detected)

### Objects to Detect
```yaml
objects:
  track:
    - person
    - car
    - dog
    - cat
```

## 🔍 Troubleshooting

### Camera Not Showing?
1. Test URL in VLC: `vlc rtsp://your_camera_url`
2. Check credentials
3. Verify network connectivity

### High CPU Usage?
1. Reduce detection FPS to 3-5
2. Use lower resolution streams
3. Disable unnecessary object types

### Storage Issues?
1. Check available space: `df -h`
2. Adjust retention in web interface
3. Use external storage

## 📊 Performance Tips

### Raspberry Pi 4
- Use 720p streams for detection
- 5-10 FPS detection
- CPU detection works well

### Raspberry Pi 3
- Use 480p streams for detection
- 3-5 FPS detection
- Consider Coral USB accelerator

## 🔐 Security

1. **Change default password** in web interface
2. **Use HTTPS** in production
3. **Restrict network access**
4. **Regular updates**: `docker-compose pull && docker-compose up -d`

## 📱 Mobile Access

- **Local network**: `http://pi_ip:5000`
- **Remote access**: Set up port forwarding or VPN
- **Mobile app**: Use web browser or PWA

## 🔄 Updates

```bash
# Update Frigate
docker-compose pull
docker-compose up -d

# Backup before updates
tar -czf backup-$(date +%Y%m%d).tar.gz config/
```

## 📞 Support

- **Documentation**: https://docs.frigate.video/
- **GitHub**: https://github.com/blakeblackshear/frigate
- **Community**: https://github.com/blakeblackshear/frigate/discussions

---

**Need help?** Check the full README.md for detailed instructions! 