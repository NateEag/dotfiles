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
          # The invocation I use to install my packages mean the nix tools get
          # nuked if I don't explicitly include them.
          nix

          # Make SSL certificates available? Apparently they get deleted if I
          # don't explicitly install them, rendering nix-env unable to fetch
          # files from HTTPS servers due to SSL cert verification failures.
          # Therefore.
          cacert

          # Yay for diff coloration and prettiness!
          delta

          # Password safes are handy.
          pass

          # I sometimes use pass as the source for Git credentials.
          pass-git-helper

          # Tools I use for synchronizing and managing email.
          notmuch
          isync

          # Send CLI notifications on OS X.
          #
          # TODO Only install this on OS X.
          terminal-notifier

          # Aspell isn't a perfect spellchecker, but it works reasonably well
          # for me.
          aspell
        ];
        pathsToLink = [ "/share" "/bin" "/etc" "/Applications" ];
      };
    };
}
