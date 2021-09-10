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
#
# The -r flag has forced me to explicitly list some packages I otherwise
# wouldn't need to. I'm using it to increase the odds of a cleanly-reproducible
# evironment, so that I don't do anything interactively at some point that I
# come to depend on without realizing it.

{
    allowUnfree = true;
    packageOverrides = pkgs: with pkgs; {
      myPackages = pkgs.buildEnv {
        name = "my-packages";
        paths = [
          # The invocation I use to install my packages mean the nix tools get
          # nuked if I don't explicitly include them.
          nix
          # In the same vein, apparently the CA SSL certs get deleted due to
          # the -r flag, rendering nix-env unable to fetch files from HTTPS
          # servers due to SSL cert verification failures. Therefore.
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

          # I'm not a big networking guy, but nmap sure can be handy.
          nmap

          # Send CLI notifications on OS X.
          #
          # TODO Only install this on OS X.
          terminal-notifier

          # Aspell isn't a perfect spellchecker, but it works reasonably well
          # for me.
          aspell
          aspellDicts.en
        ];
        pathsToLink = [ "/share" "/bin" "/etc" "/Applications" ];
      };
    };
}
