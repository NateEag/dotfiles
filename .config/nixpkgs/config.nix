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

          # If you looked at my Emacs configuration, you'd probably expect me
          # to be a zsh user with a heavily-customized environment, but I stick
          # with bash because I regularly wind up working on systems without my
          # personal configuration - I don't want to get used to idioms I won't
          # have elsewhere.
          #
          # This is here mostly because I want to have a current version of
          # bash on OS X.
          bashInteractive
          bash-completion
          nix-bash-completions

          # bat is like cat + less + syntax coloration. It also includes some
          # git integration features that I have no use for.
          #
          # I'm almost embarrassed by the fact that I have it installed, but
          # sometimes it's nice to get syntax coloration when viewing a file
          # you do not want to edit accidentally.
          bat

          # In theory, nix could completely subsume direnv's purpose with
          # per-project Nix shells and configurations.
          #
          # In practice, a lot of projects without Nix setups have .envrc
          # files.
          direnv

          # In the same vein, apparently the CA SSL certs get deleted due to
          # the -r flag, rendering nix-env unable to fetch files from HTTPS
          # servers due to SSL cert verification failures. Therefore.
          cacert

          # Since I currently use Mac OS X as my operating system, I have
          # accumulated scripts that refer to BSD date as 'date' and GNU date
          # as 'gdate'. Therefore, make 'gdate' and friends available to me.
          coreutils-prefixed

          # I have a project or two that depends on fswatch being installed. If
          # I were a purist I would build out nix profiles for those projects,
          # but for the moment this should work.
          fswatch

          # Delta is a filter for prettifying unified diffs. It makes diffs
          # massively easier to read.
          #
          # By default it hides useful details for simplicity's sake, but it
          # can be configured to leave them intact for those of us used to
          # reading diffs.
          delta

          # Install Subversion so I have it when I need it.
          subversion

          # I used to be a heavy GNU screen user in my twenties. I'm giving
          # tmux a try, mainly to see if I like it better than using actual
          # terminal tabs (might be particularly helpful for using terminals in
          # Emacs with libvterm, which I hope to try soon).
          tmux

          # I need this to compile libvterm for use with Emacs, apparently.
          cmake

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

          # I use Signal for text chats with several people I care about. It's
          # my preferred medium for its open-source nature and because of the
          # reportedlyy-robust end-to-end encryption.
          #
          # I care about the encryption not because I'm obsessive about my
          # communications remaining completely secret, but because I do not
          # like nation-states being able to run mass surveillance programs on
          # their citizens easily.
          #
          # At a personal threat model level, I'd far rather risk someone
          # reading all my personal messages than risk losing all that history.
          #
          # Hence this tool, which does a good job of letting me archive my
          # messages decrypted. I do it for several reasons:
          #
          # 1) out of worry that I'll lose my encryption keys and lose all that
          # information to eternity, 2) out of a vague concern for future
          # historians, as our all-digital culture is all too likely to lose
          # every ounce of the ephemera that makes up our lives and which
          # historians find so valuable for reconstructing the gory details of
          # the past, and 3) that it is just conceivable my children might want
          # to see what my wife and I had to say to each other in the distant
          # future, and storing our chat logs decrypted at rest means it's not
          # a priori impossible.
          signalbackup-tools

          # Tools I use for synchronizing and managing email. Emacs is where I
          # do most of my email from - these are the CLI plumbing to make that
          # possible.
          notmuch
          isync

          # A collection to tools that can help with SSH
          ssh-tools

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

          # pdfgrep is occasionally handy for extracting text from PDFs (such
          # as PDF copies of financial statements).
          pdfgrep

          # Pandoc is a Swiss-army-knife for working with plain-text documents.
          # I have used it for a few jobs in a few different contexts.
          pandoc

          # Aspell isn't a perfect spellchecker, but it works reasonably well
          # for me. Note that I integrate this closely with my Emacs config.
          aspell
          aspellDicts.en

          # I use sdcv to look up words in the dictionary (I have a
          # copyright-free 1913 edition of Webster's for the actual dictionary)
          # I use sdcv toup words in the dictionary (I have a copyright-free
          # 1913 edition of Webster's for the actual dictionary).
          sdcv

          # Shellcheck saves me from dumb Bash mistakes on a regular basis. It,
          # too, is here primarily to support my Emacs configuration.
          shellcheck

          # I use syncthing for keeping several files (and collections of
          # files) in sync across multiple devices. Thus, I want it installed
          # automatically.
          syncthing

          # Syncthing is great, but I am a web developer and sometime
          # sysadmin/devoperator, so how can I live without rsync?
          rsync

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
      };
    };
}
