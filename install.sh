#!/usr/bin/env bash
# setup.sh — minimal Arch + bspwm on a “minimal” profile
# Run as your normal user (not root) after first reboot
set -euo pipefail

# 1) Full system update
sudo pacman -Syu --noconfirm

# 2) Install core packages
sudo pacman -S --noconfirm \
  xorg-server xorg-xinit \
  nvidia nvidia-utils \
  networkmanager \
  pipewire pipewire-pulse wireplumber \
  alacritty rofi bspwm sxhkd picom plank nitrogen

# 3) Enable NetworkManager now
sudo systemctl enable --now NetworkManager

# 4) Create config dirs
mkdir -p ~/.config/bspwm ~/.config/sxhkd ~/.config/picom

# 5) Write bspwmrc
cat > ~/.config/bspwm/bspwmrc << 'EOF'
#!/bin/sh
bspc config border_width 2
bspc config window_gap   8
bspc config normal_border_color "#444444"
bspc config focused_border_color "#777777"
sxhkd &
picom &
plank &
exec bspwm
EOF
chmod +x ~/.config/bspwm/bspwmrc

# 6) Write sxhkdrc
cat > ~/.config/sxhkd/sxhkdrc << 'EOF'
super + Return
    alacritty
super + d
    rofi -show drun
super + {h,j,k,l}
    bspc node -f {west,south,north,east}
super + q
    bspc node -c
EOF

# 7) Write picom.conf
cat > ~/.config/picom/picom.conf << 'EOF'
backend = "glx";
vsync = true;
shadow = true;
shadow-radius = 7;
shadow-opacity = 0.5;
EOF

# 8) Nuke any old ~/.xinitrc and recreate via printf
rm -f ~/.xinitrc
printf '%s\n' \
  '#!/bin/sh' \
  'nitrogen --restore &' \
  'sxhkd &' \
  'picom &' \
  'plank &' \
  'exec bspwm' \
  > ~/.xinitrc
chmod +x ~/.xinitrc

echo
echo "✅  Setup complete! Run 'startx' to launch bspwm."
