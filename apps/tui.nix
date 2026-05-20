{ pkgs, ... }:

let
  tui = pkgs.writeShellScriptBin "fulfran-tui"
    (builtins.readFile ../tui/bootstrap.sh);
in {
  tui = {
    type = "app";
    program = "${tui}/bin/fulfran-tui";
  };
}
