flatpak remote-modify --system --prio=0 fedora
flatpak remote-modify --system --prio=1 flathub

flatpak install -y \
    it.mijorus.gearlever \
    com.usebottles.bottles \
    io.podman_desktop.PodmanDesktop \
    org.gnome.Music \
    io.github.celluloid_player.Celluloid