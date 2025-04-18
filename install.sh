#!/usr/bin/env bash
# setup.sh — minimal post‑install for Arch + bspwm on a “minimal” profile
# Run as your normal user (not root) after first reboot

set -e

# 0) Nuke any old xinitrc that came from /etc/skel
rm -f ~/.xinitrc

# 1) Update system
sudo pacman -Syu --noconfirm

# 2) Install only guaranteed‑existing core packages
sudo pacman -S --noconfirm \
  xorg-server xorg-xinit \
  nvidia nvidia-utils \
  networkmanager \
  pipewire pipewire-pulse wireplumber \
  alacritty rofi bspwm sxhkd picom plank nitrogen

# 3) Enable NetworkManager
sudo systemctl enable --now NetworkManager

# 4) Create config dirs
mkdir -p ~/.config/bspwm ~/.config/sxhkd ~/.config/picom

# 5) Copy & enable bspwm + sxhkd examples
cp /usr/share/doc/bspwm/examples/bspwmrc ~/.config/bspwm/bspwmrc
cp /usr/share/doc/bspwm/examples/sxhkdrc ~/.config/sxhkd/sxhkdrc
chmod +x ~/.config/bspwm/bspwmrc

# 6) Write a minimal picom.conf
cat > ~/.config/picom/picom.conf << 'EOF'
backend = "glx";
vsync = true;
shadow = true;
shadow-radius = 7;
shadow-opacity = 0.5;
EOF

# 7) Write a clean .xinitrc (no twm, no xclock)
cat > ~/.xinitrc << 'EOF'
#!/bin/sh
# restore your chosen wallpaper
nitrogen --restore &
# hotkeys, compositor, dock
sxhkd &
picom &
plank &
# launch bspwm
exec bspwm
EOF
chmod +x ~/.xinitrc

echo "All done! Type 'startx' to launch your bspwm desktop."
