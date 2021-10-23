# A first attempt at a reproducible baseline working environment for myself,
# using the Nix package manager (currently with OS X as the base OS).
#
# This is based on
# https://nixos.org/manual/nixpkgs/stable/#sec-declarative-package-management
#
# I install the listed packages by running the bin/install-nix-pkgs command in
# this repository.

{
    # An attempt to get git-svn to install.
    #
    # TODO Remove these settings. I think they're from years ago and installing
    # the gitSVN package below is all I actually need to do.
    git = { svnSupport = true; };
    subversion = { perlBindings = true; };

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

          # Since I currently use Mac OS X as my operating system, I have
          # accumulated scripts that refer to BSD date as 'date' and GNU date
          # as 'gdate'. Therefore, make 'gdate' and friends available to me.
          coreutils-prefixed

          # Yay for diff coloration and prettiness!
          delta

          # Install Subversion so I have it when I need it.
          subversion

          # Life without git is difficult. Install the version that includes
          # git-svn, because I prefer that for dealing with Subversion when
          # feasible.
          gitSVN

          # Password safes are handy.
          pass

          # I sometimes use pass as the source for Git credentials.
          pass-git-helper

          # I try not to avoid AWS for my own personal infrastructure, but I
          # regularly work with it, so it's useful to have the official CLI
          # tool installed.
          awscli2

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

          # I use syncthing for keeping several files (and collections of
          # files) in sync across multiple devices. Thus, I want it installed
          # automatically.
          syncthing

          # Vagrant is my preferred dev environment creator. Therefore...
          vagrant
        ];
        pathsToLink = [ "/share" "/bin" "/etc" "/lib" "/Applications" ];
      };
    };
}
