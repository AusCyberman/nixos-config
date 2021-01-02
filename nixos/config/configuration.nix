# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, lib, pkgs, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix     ];
  nix = {
    package = pkgs.nixFlakes;
    extraOptions = ''
        experimental-features = nix-command flakes
      '';
  };
  # Use the systemd-boot EFI boot loader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.loader.efi.efiSysMountPoint = "/boot/efi";
  boot.loader.grub.useOSProber = true;
  networking.hostName = "auspc"; # Define your hostname.
  networking.wireless = { enable = true;  # Enables wireless support via wpa_supplicant.
       networks.NeddySB.pskRaw = "e9331ef6ad7d0a1d67e81afaba284e4544cedb73b33f840c9812fc1991562dcc";
  };
  # Set your time zone.
  time.timeZone = "Australia/Melbourne";

  # The global useDHCP flag is deprecated, therefore explicitly set to false here.
  # Per-interface useDHCP will be mandatory in the future, so this generated config
  # replicates the default behaviour.
  networking.useDHCP = false;
  networking.interfaces.enp4s0.useDHCP = true;
  networking.interfaces.wlo1.useDHCP = true;
  networking.wireless.userControlled.enable = true;
  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_AU.UTF-8";
  # console = {
  #   font = "Lat2-Terminus16";
  #   keyMap = "us";
  # };


  # Configure keymap in X11
  # services.xserver.xkbOptions = "eurosign:e";

 fonts.fonts = with pkgs; [
	(nerdfonts.override { fonts = ["Inconsolata" "Hasklig" "RobotoMono"]; } )
  ];

  # Enable CUPS to print documents.
  # services.printing.enable = true;
  services.blueman.enable = true;
  # Enable sound.
  sound.enable = true;
 hardware.pulseaudio = {
    enable = true;

    # NixOS allows either a lightweight build (default) or full build of PulseAudio to be installed.
    # Only the full build has Bluetooth support, so it must be selected here.
    package = pkgs.pulseaudioFull;
  };

  hardware.bluetooth.enable = true;
  # Enable touchpad support (enabled default in most desktopManager).
  # services.xserver.libinput.enable = true;

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.defaultUserShell = pkgs.zsh;
  users.users.auscyber = {
    isNormalUser = true;
    extraGroups = ["audio" "libvirtd" "wheel" "video" ]; # Enable ‘sudo’ for the user.
    shell = pkgs.zsh;
  };

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    wget vim 
    chromium  python3 
    #Virtualisation
    qemu OVMF virtmanager dconf
    (haskellPackages.ghcWithPackages (pkgs: with pkgs; [xmonad-contrib] ))	
    
  ];

  programs.dconf.enable = true;
  

  nixpkgs.config.allowUnfree = true;
 services.xserver  = {
   layout = "us";
       enable = true;
   
   videoDrivers = [ "nvidia" ];
   displayManager.lightdm = {
   	enable = true;
   	greeter.enable = true;
   	
   };
   #displayManager.startx.enable = true;
   displayManager.defaultSession = "none+xmonad";
   displayManager.autoLogin = {
   	enable = true;
   	user = "auscyber";
   };
   windowManager.awesome = {
     enable = true;
     luaModules = with pkgs.luaPackages; [
       luarocks ];
   };
   windowManager.xmonad = {
   	enable = true;
           enableContribAndExtras = true;
   	extraPackages = haskellPackages:[
   		haskellPackages.xmonad-contrib
   		haskellPackages.xmonad-extras
   		haskellPackages.xmonad

   		];  		

   	};
 };
  hardware.opengl.driSupport32Bit = true;
  services.cron = {
    enable = true;
    systemCronJobs = [
    "0 0 1-31/2 * *  auscyber . /etc/profile' ${pkgs.bash}/bin/bash /home/auscyber/dotfiles/backup2.sh"
   ];
  };


  virtualisation.libvirtd.enable = true;


  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };

  # List services that you want to enable:

  # Enable the OpenSSH daemon.
  services.openssh.enable = true;

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "21.03"; # Did you read the comment?
  environment.etc."current-system-packages".text =

	let

	packages = builtins.map (p: "${p.name}") config.environment.systemPackages;

	sortedUnique = builtins.sort builtins.lessThan (lib.unique packages);

	formatted = builtins.concatStringsSep "\n" sortedUnique;

	in

	formatted;



	
}

