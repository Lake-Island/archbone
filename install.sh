#!/usr/bin/env bash
# Minimal post-install Arch Linux setup for a bspwm desktop environment
# Run this as your normal user (not root) after your first reboot

set -e

# 1. Update system and install packages
sudo pacman -Syu --noconfirm
sudo pacman -S --noconfirm \
  xorg-server xorg-xinit \ 
  nvidia nvidia-utils \ 
  networkmanager \ 
  pipewire pipewire-pulse wireplumber \ 
  alacritty rofi bspwm sxhkd picom plank \ 
  arc-gtk-theme papirus-icon-theme \ 
  ttf-dejavu ttf-liberation ttf-iosevka-nerd \ 
  nitrogen lxappearance

# 2. Enable and start NetworkManager for networking
sudo systemctl enable --now NetworkManager

# 3. Add current user to necessary groups
sudo usermod -aG video,audio "$USER"

# 4. Create configuration directories
mkdir -p "$HOME/.config/bspwm" \
         "$HOME/.config/sxhkd" \
         "$HOME/.config/picom"

# 5. Copy default configuration files
cp /usr/share/doc/bspwm/examples/bspwmrc "$HOME/.config/bspwm/bspwmrc"
cp /usr/share/doc/bspwm/examples/sxhkdrc "$HOME/.config/sxhkd/sxhkdrc"
chmod +x "$HOME/.config/bspwm/bspwmrc"

# 6. Create a basic picom config
cat << 'EOF' > "$HOME/.config/picom/picom.conf"
backend = "glx"
vsync = true
shadow = true
shadow-radius = 7
shadow-opacity = 0.5
EOF

# 7. Set up X initialization
# Restore your nitrogen wallpaper (if you've set one via nitrogen)
echo 'nitrogen --restore &' > "$HOME/.xinitrc"
# Launch bspwm
echo 'exec bspwm' >> "$HOME/.xinitrc"

# 8. Final instructions
cat << 'EOF'
Setup complete!
- To start the desktop, run: startx
- Use Super+Enter for terminal (Alacritty), Super+d for launcher (rofi).
- Right-click the hidden edge of Plank to pin apps.
- Run lxappearance to adjust GTK theme (Arc-Dark) and icons (Papirus-Dark).
EOF
