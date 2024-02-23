{ config, pkgs, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
    ./hardware-configuration.nix
    ];

#######################
# Nettoyage du system #
#######################

	nix.optimise.automatic = true;
	nix.settings.auto-optimise-store = true;
	nix.gc = {
     	automatic = true;
     	dates = "weekly";
     	options = "--delete-older-than 7d";
   };


  # Bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  networking.hostName = "nixos"; # Define your hostname.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

  # Enable networking
  networking.networkmanager.enable = true;

  # Set your time zone.
  time.timeZone = "Europe/Paris";

  # Select internationalisation properties.
  i18n.defaultLocale = "fr_FR.UTF-8";

  i18n.extraLocaleSettings = {
    LC_ADDRESS = "fr_FR.UTF-8";
    LC_IDENTIFICATION = "fr_FR.UTF-8";
    LC_MEASUREMENT = "fr_FR.UTF-8";
    LC_MONETARY = "fr_FR.UTF-8";
    LC_NAME = "fr_FR.UTF-8";
    LC_NUMERIC = "fr_FR.UTF-8";
    LC_PAPER = "fr_FR.UTF-8";
    LC_TELEPHONE = "fr_FR.UTF-8";
    LC_TIME = "fr_FR.UTF-8";
  };

  # Enable the X11 windowing system.
  services.xserver.enable = true;

  # Enable the GNOME Desktop Environment.
  services.xserver.displayManager.gdm.enable = true;
  services.xserver.desktopManager.gnome.enable = true;

  # Configure keymap in X11
  services.xserver = {
    layout = "fr";
    xkbVariant = "";
  };

  # Configure console keymap
  console.keyMap = "fr";

  # Enable CUPS to print documents.
  services.printing.enable = true;

  # Enable sound with pipewire.
  sound.enable = true;
  hardware.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
  };

  # Enable touchpad support (enabled default in most desktopManager).
  # services.xserver.libinput.enable = true;

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.david = {
    isNormalUser = true;
    description = "David";
    extraGroups = [ "networkmanager" "wheel" ];
  };

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [

##################
# Mes programmes #
##################
remmina
teamviewer 		# Ne pas oublier de demarrer le service
keepassxc
vscode
google-chrome
firefox 		# Le passer en français dans les options de Firefox
discord
openfortivpn
filezilla
libreoffice
git
tilix 			# Terminal 
gnome.gnome-tweaks 	# Pour modifier Gnome 3
cifs-utils 		# Pour monter les partage samba
dnsutils 		# pour Dig et nslookup

# Gnome Extensions
gnomeExtensions.dash-to-dock
gnomeExtensions.executor
gnomeExtensions.tray-icons-reloaded

];

################
# Mes Services #
################
services.teamviewer.enable = true;

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "23.11"; # Did you read the comment?


###############################
# Parametres des applications #
###############################

programs.bash.shellAliases = {
	nix-switch = "sudo nixos-rebuild switch";
	nix-up = "/bin/sh ~/Scripts/nix-up.sh";
	nix-git= "curl -L 'https://raw.githubusercontent.com/DavidBrigand/nixos/main/nix-config-update.sh' | /bin/sh ";
  };
}
