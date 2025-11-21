{ pkgs, ... }: {

  # nix自体の設定
  nix = {
    optimise.automatic = true;
    settings = {
      experimental-features = "nix-command flakes";
      max-jobs = 8;
    };
  };

  system = {
    stateVersion = 6;
    primaryUser = "yoshitaka";

    defaults = {
      dock = {
        autohide = true;
        show-recents = false;
      };
    };
  };

  homebrew = {
    enable = true;
    onActivation = {
      autoUpdate = true;
      # cleanup = "uninstall";
    };
    casks = [
      "figma"
      "obsidian"
      "visual-studio-code"
      "zed"
    ];
  };
}
