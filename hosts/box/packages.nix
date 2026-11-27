{ pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    python3
    nh
    # Runs the chrome-devtools MCP server: the coding agent drives the
    # Chromium on the host through it.
    nodejs
  ];
}
