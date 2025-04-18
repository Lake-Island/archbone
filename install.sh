#!/usr/bin/env bash
# Minimal post-install Arch Linux setup for a bspwm desktop environment
# Run this as your normal user (not root) after your first reboot

set -e

# 1. Update system
sudo pacman -Syu --noconfirm

# 2. Install core packages
sudo pacman -S --noconfirm \
    xorg-server xorg-xinit \
    nvidia nvidia-utils \
    networkmanager \
    pipewire pipewire-pulse wireplumber \
    alacritty rofi bspwm sxhkd picom plank \
    ttf-dejavu ttf-iosevka-nerd

# 3. Enable networking service
sudo systemctl enable --now NetworkManager

# 4. Add current user to video and audio groups
sudo usermod -aG video,audio "$USER"

# 5. Create config directories
mkdir -p "$HOME/.config/bspwm" \
         "$HOME/.config/sxhkd" \
         "$HOME/.config/picom"

# 6. Copy default configs for bspwm and sxhkd
cp /usr/share/doc/bspwm/examples/bspwmrc "$HOME/.config/bspwm/bspwmrc"
cp /usr/share/doc/bspwm/examples/sxhkdrc "$HOME/.config/sxhkd/sxhkdrc"
chmod +x "$HOME/.config/bspwm/bspwmrc"

# 7. Write picom config
cat << 'EOF' > "$HOME/.config/picom/picom.conf"
backend = "glx"
vsync = true
shadow = true
shadow-radius = 7
shadow-opacity = 0.5
EOF

# 8. Set up X initialization
# Write .xinitrc to start bspwm
cat << 'EOF' > "$HOME/.xinitrc"
exec bspwm
EOF

# 9. Final instructions
cat << 'EOF'
Setup complete!
To start your bspwm desktop, run: startx

Default keybindings (in ~/.config/sxhkd/sxhkdrc):
  Super + Enter: Open Alacritty
  Super + d:      Open Rofi launcher
  Super + q:      Close focused window

You can install and configure themes later (e.g., arc-gtk-theme, papirus-icon-theme) and set fonts with lxappearance.
EOF
