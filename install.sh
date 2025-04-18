#!/usr/bin/env bash
# Minimal post-install Arch Linux setup for a bspwm desktop environment
# Run this as your normal user (not root) after your first reboot

set -e

# 1. Update system
sudo pacman -Syu --noconfirm

# 2. Install required packages
sudo pacman -S --noconfirm \
    xorg-server xorg-xinit \
    nvidia nvidia-utils \
    networkmanager \
    pipewire pipewire-pulse wireplumber \
    alacritty rofi bspwm sxhkd picom plank \
    arc-gtk-theme papirus-icon-theme \
    ttf-dejavu ttf-liberation ttf-iosevka-nerd \
    nitrogen lxappearance

# 3. Enable networking
sudo systemctl enable --now NetworkManager

# 4. Add current user to groups
sudo usermod -aG video,audio "$USER"

# 5. Create config directories
mkdir -p "$HOME/.config/bspwm" \
         "$HOME/.config/sxhkd" \
         "$HOME/.config/picom"

# 6. Copy bspwm and sxhkd default configs
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
# Restore wallpaper and start bspwm
cat << 'EOF' > "$HOME/.xinitrc"
nitrogen --restore &
exec bspwm
EOF

# 9. Final message
cat << 'EOF'
Setup complete! To start your bspwm desktop, run: startx
- Super+Enter: Alacritty terminal
- Super+d: Rofi launcher
- Right-click Plank’s hidden edge to pin apps
- Run lxappearance to set Arc-Dark theme & Papirus icons
EOF
