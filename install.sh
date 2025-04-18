#!/usr/bin/env bash
# Minimal post-install Arch Linux setup for a bspwm desktop environment
# Run as your normal user (not root) after first reboot

set -e

# 1. Update system
sudo pacman -Syu --noconfirm

# 2. Install core packages
sudo pacman -S --noconfirm \
    xorg-server xorg-xinit \
    nvidia nvidia-utils \
    networkmanager \
    pipewire pipewire-pulse wireplumber \
    alacritty rofi bspwm sxhkd picom plank nitrogen

# 3. Enable networking
sudo systemctl enable --now NetworkManager

# 4. Create config dirs
mkdir -p ~/.config/bspwm ~/.config/sxhkd ~/.config/picom

# 5. Copy bspwm & sxhkd examples
cp /usr/share/doc/bspwm/examples/bspwmrc ~/.config/bspwm/bspwmrc
cp /usr/share/doc/bspwm/examples/sxhkdrc ~/.config/sxhkd/sxhkdrc
chmod +x ~/.config/bspwm/bspwmrc

# 6. Picom config
cat > ~/.config/picom/picom.conf << 'EOF'
backend = "glx";
vsync = true;
shadow = true;
shadow-radius = 7;
shadow-opacity = 0.5;
EOF

# 7. Fresh .xinitrc (no twm)
cat > ~/.xinitrc << 'EOF'
#!/bin/sh
nitrogen --restore &
sxhkd &
picom &
plank &
exec bspwm
EOF
chmod +x ~/.xinitrc

echo "Setup complete! Run 'startx' to launch bspwm."
