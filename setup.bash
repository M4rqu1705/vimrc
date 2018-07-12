if [ -d "/usr/share/vim/vim80/autoload" ]; then
    cp "plug.vim" "/usr/share/vim/vim80/autoload/plug.vim"
elif [ -d "/usr/share/vim/vim74/autoload" ]; then
    cp "plug.vim" "/usr/share/vim/vim74/autoload/plug.vim"
else
    read -p "Enter path to vim autoload directory: " autoloadDirectory
    cp "plug.vim" "$autoloadDirectory/plug.vim"
fi
