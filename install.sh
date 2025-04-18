#!/usr/bin/env bash
# setup.sh — foolproof Arch + bspwm post‑install on a “minimal” profile
# Can be run as your normal user or with sudo; it will auto‑detect and write into the right home.

set -euo pipefail

# 0) Figure out where to write configs
if [ "$EUID" -eq 0 ]; then
  TARGET_USER=${SUDO_USER:-root}
  TARGET_HOME=/home/"$TARGET_USER"
else
  TARGET_USER=$USER
  TARGET_HOME=$HOME
fi

echo "→ Installing for user: $TARGET_USER (home: $TARGET_HOME)"

# 1) Full system update
pacman -Syu --noconfirm

# 2) Install core packages
pacman -S --noconfirm \
  xorg-server xorg-xinit \
  nvidia nvidia-utils \
  networkmanager \
  pipewire pipewire-pulse wireplumber \
  alacritty rofi bspwm sxhkd picom plank nitrogen

# 3) Enable NetworkManager now
systemctl enable --now NetworkManager

# 4) Create config dirs
mkdir -p "$TARGET_HOME"/.config/{bspwm,sxhkd,picom}
chown -R "$TARGET_USER":"$TARGET_USER" "$TARGET_HOME"/.config

# 5) Write bspwmrc
cat > "$TARGET_HOME"/.config/bspwm/bspwmrc << 'EOF'
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
chmod +x "$TARGET_HOME"/.config/bspwm/bspwmrc

# 6) Write sxhkdrc
cat > "$TARGET_HOME"/.config/sxhkd/sxhkdrc << 'EOF'
super + Return
    alacritty
super + d
    rofi -show drun
super + {h,j,k,l}
    bspc node -f {west,south,north,east}
super + q
    bspc node -c
EOF
chown "$TARGET_USER":"$TARGET_USER" "$TARGET_HOME"/.config/sxhkd/sxhkdrc

# 7) Write picom.conf
cat > "$TARGET_HOME"/.config/picom/picom.conf << 'EOF'
backend = "glx";
vsync = true;
shadow = true;
shadow-radius = 7;
shadow-opacity = 0.5;
EOF
chown "$TARGET_USER":"$TARGET_USER" "$TARGET_HOME"/.config/picom/picom.conf

# 8) Nuke any old xinitrc & recreate via printf
rm -f "$TARGET_HOME"/.xinitrc
printf '%s\n' \
  '#!/bin/sh' \
  'nitrogen --restore &' \
  'sxhkd &' \
  'picom &' \
  'plank &' \
  'exec bspwm' \
  > "$TARGET_HOME"/.xinitrc
chmod +x "$TARGET_HOME"/.xinitrc
chown "$TARGET_USER":"$TARGET_USER" "$TARGET_HOME"/.xinitrc

echo
echo "✅  Setup complete for $TARGET_USER!"
echo "   → SSH in or switch to $TARGET_USER and run: startx"
