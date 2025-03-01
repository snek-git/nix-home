{...}: {
  programs.ssh = {
    enable = true;
    
    matchBlocks = {
      "lambda-headnode.picsart.tools" = {
        proxyCommand = "cloudflared access ssh --hostname %h";
      };
    };
  };
} 