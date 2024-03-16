# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).
{
  config,
  pkgs,
  inputs,
  ...
}: {
  imports = [
    # Include the results of the hardware scan.
    ./hardware-configuration.nix
    inputs.xremap-flake.nixosModules.default
    ./modules/hosts.nix # if u have any websites to block
  ];

  services.xremap = {
    withWlroots = true;
    userName = "shone";
    config = {
      modmap = [
        {
          name = "Global";
          remap = {"CapsLock" = "Esc";}; # globally remap CapsLock to Esc
        }
      ];
    };
  };

  # Bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  virtualisation.libvirtd.enable = true;
  programs.virt-manager.enable = true;

  environment.variables.EDITOR = "hx";
  nixpkgs.config.chromium.commandLineArgs = "--enable-features=UseOzonePlatform --ozone-platform=wayland";

  networking.hostName = "nixos"; # Define your hostname.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Enable networking
  networking.networkmanager.enable = true;

  hardware.bluetooth.enable = true; # enables support for Bluetooth
  # hardware.bluetooth.powerOnBoot = true; # powers up the default Bluetooth controller on boot
  # services.blueman.enable = true;

  # Set your time zone.
  time.timeZone = "Asia/Kolkata";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_IN";

  i18n.extraLocaleSettings = {
    LC_ADDRESS = "en_IN";
    LC_IDENTIFICATION = "en_IN";
    LC_MEASUREMENT = "en_IN";
    LC_MONETARY = "en_IN";
    LC_NAME = "en_IN";
    LC_NUMERIC = "en_IN";
    LC_PAPER = "en_IN";
    LC_TELEPHONE = "en_IN";
    LC_TIME = "en_IN";
  };

  # Enable the X11 windowing system.
  services.xserver.enable = true;
  services.xserver.displayManager.sddm.enable = true;
  services.xserver.desktopManager.plasma6.enable = true;

  # services.gvfs.enable = true;
  # services.udisks2.enable = true;

  # Configure keymap in X11
  services.xserver = {
    layout = "us";
    xkbVariant = "";
  };

  services = {
    syncthing = {
      enable = true;
      user = "shone";
      dataDir = "/home/shone/journal"; # this holds my journal entries, synced b/w desk, lap and mob
      configDir = "/home/shone/.config/syncthing";
    };
  };

  services.printing = {
    enable = true;
    drivers = [pkgs.brlaser];
  }; # system-config-printer - install to configure printer

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

    # use the example session manager (no others are packaged yet so this is enabled by default,
    # no need to redefine it in your config for now)
    #media-session.enable = true;
  };

  programs.kdeconnect.enable = true;

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.shone = {
    isNormalUser = true;
    description = "Shone Binu";
    extraGroups = ["networkmanager" "wheel" "libvirtd"];
    #packages = with pkgs; [];
  };

  fonts = {
    enableDefaultPackages = true;
    packages = with pkgs; [
      noto-fonts
      noto-fonts-cjk
      noto-fonts-emoji
      fira
      roboto
      ubuntu_font_family
      (nerdfonts.override {fonts = ["FiraCode" "JetBrainsMono"];})
    ];

    fontconfig = {
      defaultFonts = {
        serif = ["Roboto"];
        sansSerif = ["Fira Sans"];
        monospace = ["JetBrainsMono Nerd Font"];
      };
    };
  };

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    vim # Do not forget to add an editor to edit configuration.nix! The Nano editor is also installed by default.
    python3
    brlaser
    jq
    wget
    mpv
    celluloid
    neofetch
    neovim
    tree
    git
    gimp
    kdenlive
    pcmanfm
    ripgrep
    lsd
    bat
    fish
    stremio
    brave
    htop
    bc
    chromium
    vscodium
    sshfs
    libgcc
    nodejs
    helix
    dprint #formatting code, defined here to access dprint init on global
    wl-clipboard
    zellij
    system-config-printer
    thunderbird
  ];

  users.defaultUserShell = pkgs.fish;
  programs.fish.enable = true;

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };

  # List services that you want to enable:

  # Enable the OpenSSH daemon.
  services.openssh = {
    enable = true;
    settings = {
      PasswordAuthentication = false;
      KbdInteractiveAuthentication = false;
    };
  };

  networking.firewall = {
    enable = true;
    # allowedTCPPorts = [ 80 443 8000 ];
    # allowedUDPPortRanges = [
    #   { from = 4000; to = 4007; }
    #   { from = 8000; to = 8010; }
    # ];
  };

  nixpkgs.config.packageOverrides = pkgs: {
    intel-vaapi-driver = pkgs.intel-vaapi-driver.override {enableHybridCodec = true;};
  };
  hardware.opengl = {
    enable = true;
    extraPackages = with pkgs; [
      intel-media-driver # LIBVA_DRIVER_NAME=iHD
      intel-vaapi-driver # LIBVA_DRIVER_NAME=i965 (older but works better for Firefox/Chromium)
      vaapiVdpau
      libvdpau-va-gl
    ];
  };
  environment.sessionVariables = {LIBVA_DRIVER_NAME = "iHD";}; # Force intel-media-driver

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "unstable"; # Did you read the comment?

  nix.settings.experimental-features = ["nix-command" "flakes"];
}
