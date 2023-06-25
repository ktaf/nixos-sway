{ config, pkgs, lib, inputs, user,  modulesPath, ... }:
{
  # Include the results of the hardware scan.
    imports = [ ./hardware-configuration.nix 
    ./modules/shell.nix
    ./modules/users.nix
    ./modules/nvidia.nix
    ./modules/gaming.nix
    ./modules/sway.nix
    ./modules/vm.nix];

  #fonts
    fonts.fonts = with pkgs; [
      font-awesome
     (nerdfonts.override { fonts = [ "IntelOneMono" "IBMPlexMono" "Hack" "FiraCode" "JetBrainsMono" ]; })
     ];
  #emojis
    services.gollum.emoji = true;

  # Bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.loader.efi.efiSysMountPoint = "/boot/efi";

  # Define your hostname
  networking.hostName = "nixos";

  # Enable networking
  networking.networkmanager.enable = true;

  # Set your time zone.
  time.timeZone = "Europe/Tallinn";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";
  i18n.extraLocaleSettings = {
    LC_ADDRESS = "en_GB.UTF-8";
    LC_IDENTIFICATION = "en_GB.UTF-8";
    LC_MEASUREMENT = "en_GB.UTF-8";
    LC_MONETARY = "en_GB.UTF-8";
    LC_NAME = "en_GB.UTF-8";
    LC_NUMERIC = "en_GB.UTF-8";
    LC_PAPER = "en_GB.UTF-8";
    LC_TELEPHONE = "en_GB.UTF-8";
    LC_TIME = "en_GB.UTF-8";
  };
  

  # # Enable the X11 windowing system.
  # services.xserver = {
  #   enable = true;
  #   displayManager = { 
  #     defaultSession = "hyprland";
  #     sessionPackages = [ pkgs.hyprland ];
  #   };
  # };
  
  # #sddm
  # services.xserver.displayManager.sddm = {
  #   enable = true;
  #   autoNumlock = true;
  #   autoLogin.relogin = true;
  #   theme = "elarun";
  #   settings = {
  #     Autologin = {
  #       Session = "hyprland.desktop";
  #       User = "${user}";
  #   };
  #   };};

#swaylock pass verify
  security.pam.services.swaylock = { };

  #Flatpak
  services.flatpak.enable = true;
  #locate
  services.locate.enable = true;

  # Enable sound with pipewire.
  sound.enable = true;
  hardware.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    # If you want to use JACK applications, uncomment this
    #jack.enable = true;

    #isDefault
    #wireplumber.enable= true;
  
    # use the example session manager (no others are packaged yet so this is enabled by default,
    # no need to redefine it in your config for now)
    #media-session.enable = true;
  };

 # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

services.dbus.enable = true;
# XDG Configuration
xdg.portal = {
  enable = true;
  extraPortals = with pkgs; [
    xdg-desktop-portal-wlr
    xdg-desktop-portal
    xdg-desktop-portal-gtk
  ];
  wlr.enable = true;
};

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  nix.settings.experimental-features = [ "nix-command" "flakes" ];
  environment.systemPackages = with pkgs; [
 # Do not forget to add an editor to edit configuration.nix! The Nano editor is also installed by default.
     hyprland
     vim
     wget
     git
     gh
  ];

# List services that you want to enable:

# Enable the OpenSSH daemon.
services.openssh.enable = true;

# Enable the Bluethooth daemon.
hardware.bluetooth.enable = true;
services.blueman.enable = true;

# Enable CUPS to print documents.
services.printing.enable = true;

# Enable touchpad support (enabled default in most desktopManager).
services.xserver.libinput.enable = true;

#tlp
services.tlp.enable = true;

#auto-cpufreq
services.auto-cpufreq.enable = true;

#upower dbus
services.upower.enable = true;
powerManagement = {
  enable = true;
  cpuFreqGovernor = "ondemand";
};

# Enable Firmware manager
services.fwupd = {
  enable = true;
  package = pkgs.fwupd;
};


  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
    #For Chromecast from chrome
#    networking.firewall.allowedUDPPortRanges = [ { from = 32768; to = 60999; } ];
  # Or disable the firewall altogether.
   networking.firewall.enable = false;

  system.autoUpgrade.enable = true;  
  system.autoUpgrade.allowReboot = true; 
  system.autoUpgrade.channel = "https://channels.nixos.org/nixos-23.05";
  system.stateVersion = "23.05"; # Did you read the comment?
}