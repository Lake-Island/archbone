#!/usr/bin/env bash
# Minimal post-install Arch setup for bspwm desktop
# Usage: run as your user (not root) after first reboot

set -e

# 1. Install packages
sudo pacman -Syu --noconfirm \
  xorg-server xorg-xinit \
  nvidia nvidia-utils \
  networkmanager \
  pipewire pipewire-pulse wireplumber \
  alacritty rofi bspwm sxhkd picom plank \
  arc-gtk-theme papirus-icon-theme \
  ttf-dejavu ttf-liberation ttf-iosevka-nerd \
  nitrogen lxappearance

# 2. Enable NetworkManager
sudo systemctl enable --now NetworkManager

# 3. Add user to needed groups
sudo usermod -aG video,audio $USER

# 4. Create config directories
mkdir -p ~/.config/bspwm ~/.config/sxhkd ~/.config/picom

# 5. Copy example configs
cp /usr/share/doc/bspwm/examples/bspwmrc ~/.config/bspwm/bspwmrc
cp /usr/share/doc/bspwm/examples/sxhkdrc ~/.config/sxhkd/sxhkdrc
cp /usr/share/doc/picom/example.conf ~/.config/picom/picom.conf

# 6. Make bspwmrc executable
chmod +x ~/.config/bspwm/bspwmrc

# 7. Wallpaper restore
# Appends if not already present
grep -qxF "nitrogen --restore &" ~/.config/bspwm/bspwmrc || \
  echo "nitrogen --restore &" >> ~/.config/bspwm/bspwmrc

# 8. Set up xinit
echo "exec bspwm" > ~/.xinitrc

# 9. Set ownership
chown -R $USER: ~/.config ~/.xinitrc

# Done
cat <<EOF
Setup complete!
To start your new desktop, run:
  startx
EOF
