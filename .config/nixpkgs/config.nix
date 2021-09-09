# A first attempt at a reproducible baseline working environment for myself,
# using the Nix package manager (currently with OS X as the base OS).
#
# This is based on
# https://nixos.org/manual/nixpkgs/stable/#sec-declarative-package-management
#
# I've been able to install the listed packages by running
#
# nix-env -irA nixpkgs.myPackages
#
# which I may eventually get around to adding a dumb shell script for.

{
    allowUnfree = true;
    packageOverrides = pkgs: with pkgs; {
      myPackages = pkgs.buildEnv {
        name = "my-packages";
        paths = [
          delta
          pass-git-helper
        ];
        pathsToLink = [ "/share" "/bin" "/Applications" ];
      };
    };
}
