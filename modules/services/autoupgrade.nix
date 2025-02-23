{pkgs, ...}: {
  systemd.user = {
    services.home-manager-auto-upgrade = {
      Unit = {
        Description = "Home Manager Auto Upgrade";
        After = ["network-online.target"];
        Wants = ["network-online.target"];
      };

      Service = {
        Type = "oneshot";
        ExecStart = "${pkgs.home-manager}/bin/home-manager switch --impure";
      };
    };

    timers.home-manager-auto-upgrade = {
      Unit = {
        Description = "Home Manager Auto Upgrade Timer";
      };

      Timer = {
        OnCalendar = "04:30";
        Persistent = true;
        RandomizedDelaySec = "45min";
      };

      Install = {
        WantedBy = ["timers.target"];
      };
    };
  };
} 