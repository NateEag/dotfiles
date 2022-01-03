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

          # Delta is a filter for prettifying unified diffs. It makes diffs
          # massively easier to read.
          #
          # By default it hides useful details for simplicity's sake, but it
          # can be configured to leave them intact for those of us used to
          # reading diffs.
          delta

          # Install Subversion so I have it when I need it.
          subversion

          # Git is my preferred version control system (well, leaving aside the
          # system I slowly plan at https://github.com/NateEag/next-vcs).
          #
          # This is the version that includes git-svn, because I prefer it for
          # dealing with Subversion when feasible.
          gitSVN

          # pass is "the standard unix password manager". Your secrets are
          # stored locally as plain text and versioned in a Git repo, making
          # backup and sharing across multiple machines reasonably
          # straightforward. I use it every working day.
          pass

          # I sometimes use pass as a source for Git credentials.
          pass-git-helper

          # I try to avoid AWS for my own personal infrastructure, but I
          # regularly work with it, so it's useful to have the official CLI
          # tool installed.
          awscli2

          # MySQL is not my favorite database, but I need to work with it
          # pretty regularly.
          mysql-client

          # Tools I use for synchronizing and managing email. Emacs is where I
          # do most of my email from - these are the CLI plumbing to make that
          # possible.
          notmuch
          isync

          # jp is a tool for querying JSON documents using the JMESPath
          # language. The reasons I try to prefer jp to jq are:
          #
          # * jp is less powerful than jq, which means solutions written using
          #   it will likely be simpler
          #
          # * JMESPath is a standard with a test suite and independent
          #  implementations rather than just a program (and thus tools using
          #  it are at least theoretically vendor-independent)
          #
          # * AWS tools use JMESPath, so if you have its syntax in your head
          #   you'll be better at using AWS tools.
          jp

          # jq is an amazingly overpowered tool for querying JSON documents. It
          # is Turing-complete, as illustrated by this glorious bit of
          # insanity: https://github.com/andrewarchi/wsjq
          #
          # I try to use jp in preference to jq, but sometimes I do find I want
          # the chainsaw.
          jq

          # jid is an interactive tool for building JSON path queries. Isn't
          # strictly compatible with either jq or JMESPath, but is still handy
          # for exploring a fresh dump of JSON from somewhere.
          jid

          # nmap is my preferred tool for exploring networks. I'm not a
          # networking expert - there could well be better options for any
          # number of focused tasks, but it gets the job done for me.
          nmap

          # Send CLI notifications on OS X.
          #
          # TODO Only install this on OS X.
          terminal-notifier

          # Ledger is a wonderful CLI tool for managing financial data.
          ledger

          # Aspell isn't a perfect spellchecker, but it works reasonably well
          # for me. Note that I integrate this closely with my Emacs config.
          aspell
          aspellDicts.en

          # Shellcheck saves me from dumb Bash mistakes on a regular basis. It,
          # too, is here primarily to support my Emacs configuration.
          shellcheck

          # I use syncthing for keeping several files (and collections of
          # files) in sync across multiple devices. Thus, I want it installed
          # automatically.
          syncthing

          # I use a much-beloved ErgoDox EZ keyboard for typing. I run a custom
          # firmware so I can have the layout be what I want, and for that the
          # following tool is handy.
          qmk

          # pipx is a tool for running CLI Python tools in standalone
          # environments. It's here to support bin/install-python-commands.sh.
          python39Packages.pipx

          # Vagrant is my preferred dev environment creator. Therefore...
          vagrant
        ];
        pathsToLink = [ "/share" "/bin" "/etc" "/lib" "/Applications" ];
      };
    };
}
