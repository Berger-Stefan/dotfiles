export TERMINAL=xfce4-terminal
#export QT_QPA_PLATFORMTHEME=qt5ct

if [ -d "$HOME/.local/bin" ]; then
    PATH="$HOME/.local/bin:$PATH"
fi

if [ -f "$HOME/.cargo/env" ]; then
    . "$HOME/.cargo/env"
fi
