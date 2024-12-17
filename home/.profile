#  ██████╗ ██████╗  ██████╗ ███████╗██╗██╗     ███████╗
#  ██╔══██╗██╔══██╗██╔═══██╗██╔════╝██║██║     ██╔════╝
#  ██████╔╝██████╔╝██║   ██║█████╗  ██║██║     █████╗  
#  ██╔═══╝ ██╔══██╗██║   ██║██╔══╝  ██║██║     ██╔══╝  
#  ██║     ██║  ██║╚██████╔╝██║     ██║███████╗███████╗
#  ╚═╝     ╚═╝  ╚═╝ ╚═════╝ ╚═╝     ╚═╝╚══════╝╚══════╝

if [ -n "$BASH_VERSION" ]; then
    if [ -f "$HOME/.bashrc" ]; then
        . "$HOME/.bashrc"
    fi
elif [ -n "$ZSH_VERSION" ]; then
    if [ -f "$HOME/.zshrc" ]; then
        . "$HOME/.zshrc"
    fi
fi

if [ -d "$HOME/bin" ] ; then
    PATH="$HOME/bin:$PATH"
fi

if [ -d "$HOME/.local/bin" ] ; then
    PATH="$HOME/.local/bin:$PATH"
fi
