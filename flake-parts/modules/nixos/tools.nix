{
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.fuyuNoKosei.tools;
in {
  options = {
    fuyuNoKosei.tools = {
      enable = lib.mkOption {
        type = lib.types.bool;
        default = true;
      };
    };
  };

  config = lib.mkIf cfg.enable {
    environment.systemPackages = with pkgs; [
      # Essential utilities
      which # Locate a command
      vim # Text editor
      curl # Transfer data from or to a server
      tmux # Terminal multiplexer
      htop # Interactive process viewer
      killall # Kill processes by name
      findutils # Basic file search utilities
      ripgrep # Line-oriented search tool (faster than grep)
      fd # Simple, fast file search tool
      procs # Process viewer

      # System utilities and hardware monitoring
      cifs-utils # CIFS (SMB) file system utilities
      rsync # Remote file and directory synchronization
      sysstat # System performance tools (e.g., iostat, mpstat)
      iotop # Display I/O usage by processes
      iftop # Display bandwidth usage on an interface
      btop # Resource monitor (similar to top)
      nmon # Performance monitoring tool
      sysbench # Benchmarking tool
      lm_sensors # Hardware monitoring (temperature, fan speed)
      psmisc # Utilities like `fuser` and `pstree`
      dmidecode # Dump system DMI (SMBIOS) data
      parted # A partitioning tool
      ethtool # Ethernet device settings and diagnostics
      acpilight # ACPI backlight control

      # Disk and file management
      pciutils # PCI device listing
      usbutils # USB device listing
      du-dust # A tool to find disk usage by directories
      just # Command runner with easy-to-write scripts

      # Miscellaneous tools
      age # Simple, secure, modern encryption tool
      fx # Command-line JSON processor
      bottom # Resource monitor (alternative to htop)
      alchemy # Drawing application
      act # Run your Github actions locally
      # _5etools # package does not build

      # Network tools
      tcpdump # CLI packet analyzer
      nmap # Ttility for network discovery
      nmapsi4 # Qt frontend for nmap
      netcat
      traceroute
      wireshark
      termshark
      iperf # Measure IP bandwidth
      netboot # Portable PXE server
      nettools # Swiss army knife of AD troubleshooting
      ipcalc
      python312Packages.scapy # Interactive packet manipulation and shell
      tcpreplay
      udpreplay
      mtr # ping + traceroute
      dig
      whois
      arp-scan
      asn # OSINT CLI tool for investigating network data
    ];
    programs = {
      fish = {
        enable = true;
      };
      zsh = {
        enable = true;
      };
    };
  };
}
