{ ... }: {
  home.sessionVariables = {
    # Audio fixes for Wine/Proton
    PULSE_LATENCY_MSEC = "60";
    WINE_DISABLE_FAST_SYNC = "1";
    WINEDLLOVERRIDES = "xaudio2_7=n,b";
  };
}