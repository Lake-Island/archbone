#!/usr/bin/env bash
# setup.sh — minimal Arch + bspwm on a “minimal” profile
# Run as your normal user (not root) after first reboot

set -e

# 1) Full system update
sudo pacman -Syu --noconfirm

# 2) Install core packages
sudo pacman -S --noconfirm \
  xorg-server xorg-xinit \
  nvidia nvidia-utils \
  networkmanager \
  pipewire pipewire-pulse wireplumber \
  alacritty rofi bspwm sxhkd picom plank nitrogen

# 3) Enable NetworkManager immediately
sudo systemctl enable --now NetworkManager

# 4) Make config dirs
mkdir -p ~/.config/bspwm ~/.config/sxhkd ~/.config/picom

# 5) Write a minimal bspwmrc
cat > ~/.config/bspwm/bspwmrc << 'EOF'
#!/bin/sh
# bspwm border/gaps
bspc config border_width 2
bspc config window_gap   8
bspc config normal_border_color "#444444"
bspc config focused_border_color "#777777"
# Autostart
sxhkd &
picom &
plank &
exec bspwm
EOF
chmod +x ~/.config/bspwm/bspwmrc

# 6) Write a minimal sxhkdrc
cat > ~/.config/sxhkd/sxhkdrc << 'EOF'
# launch terminal
super + Return
    alacritty
# launch rofi
super + d
    rofi -show drun
# focus windows
super + {h,j,k,l}
    bspc node -f {west,south,north,east}
# close window
super + q
    bspc node -c
EOF

# 7) Write a minimal picom.conf
cat > ~/.config/picom/picom.conf << 'EOF'
backend = "glx";
vsync = true;
shadow = true;
shadow-radius = 7;
shadow-opacity = 0.5;
EOF

# 8) Write your ~/.xinitrc (no twm/xclock, ever)
cat > ~/.xinitrc << 'EOF'
#!/bin/sh
# restore last wallpaper
nitrogen --restore &
# start hotkeys, compositor, dock
sxhkd &
picom &
plank &
# finally: your WM
exec bspwm
EOF
chmod +x ~/.xinitrc

echo
echo "✅  All done! Just run: startx"
