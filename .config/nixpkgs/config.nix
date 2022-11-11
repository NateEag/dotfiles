# A first attempt at a reproducible baseline working environment for myself,
# using the Nix package manager (currently with OS X as the base OS).
#
# This is based on
# https://nixos.org/manual/nixpkgs/stable/#sec-declarative-package-management
#
# I install the listed packages by running the bin/install-nix-pkgs command in
# this repository.

{
    # TODO Uncomment Linux-only packages if I start using Nix on Linux. That
    # may require me to figure out how to choose packages based on platform.

    # TODO Remove svnSupport flag and Subversion config. I think I added them
    # based on information from years ago and installing the gitSVN package
    # below is all I actually needed to have a working git-svn.
    #
    # That said, the osxkeychainSupport = false invocation is an attempt to
    # keep git from using OS X's Keychain by default. It had no effect I could
    # see, so presumably I need to figure out how to actually specify it.
    #
    # For the moment, I worked around that issue by manually running sudo git
    # config --system --unset credential.helper, but that cheap trick may not
    # be sustainable.
    git = { svnSupport = true; osxkeychainSupport = false; };
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

          # Let's see if I can get working native compilation in Emacs via Nix.
          emacs28NativeComp

          # I like ASCII art. Let the cow speak, and the proclamations ring
          # forth.
          cowsay
          figlet

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

          # A dependency for building Colossal Cave Adventure. Yes, the right
          # thing is to submit a PR to https://gitlab.com/esr/open-adventure
          # telling it how to do this, but I just wanted to get it working.
          libedit

          # Who doesn't like Zork?
          frotz

          # Delta is a filter for prettifying unified diffs. It makes diffs
          # massively easier to read.
          #
          # By default it hides useful details for simplicity's sake, but it
          # can be configured to leave them intact for those of us used to
          # reading diffs.
          delta

          # Difftastic is a syntax-aware diffing tool based on tree-sitter.
          # It's apparently early days for it yet, but I'm definitely going to
          # give it a shot and see how it does as my git-diff driver.
          difftastic

          # Install Subversion so I have it when I need it.
          subversion

          # I used to be a heavy GNU screen user in my twenties. I'm giving
          # tmux a try, mainly to see if I like it better than using actual
          # terminal tabs (might be particularly helpful for using terminals in
          # Emacs with libvterm, which I hope to try soon).
          tmux

          # This is here solely to support the
          # bin/fix-tmux-terminal-not-fully-functional-macos script, which is a
          # workaround for an issue I had with tmux on macOS 12.6 / Terminal
          # 2.12.7.
          ncurses6

          # tmate is a fork of tmux that lets you easily share terminal
          # sessions over the internet between desktops (at the price of
          # depending on its website).
          tmate

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

          # I tend to avoid AWS for my own personal infrastructure, but I
          # regularly work with it, so it's useful to have the official CLI
          # tool installed.
          awscli2

          # MySQL is not my favorite database, but I need to work with it
          # pretty regularly.
          mysql-client

          # Having nginx installed locally can occasionally be useful for
          # testing. That said, you have to be pretty careful about the
          # specific version you're using, so it might be pointless...
          #
          # TODO Figure out how to configure Nix-installed nginx. So far I've
          # just used it for syntax-checking nginx conf files, so I haven't
          # needed to.
          nginx

          # oha seems to be a decent CLI tool for load-testing HTTP servers.
          # Installing it so I can give it a whirl.
          oha

          # xsv is a great tool to have around for wrangling CSVs.
          xsv

          # I use Signal for text chats with several people I care about. It's
          # my preferred medium for its open-source nature and because of the
          # reportedly-robust end-to-end encryption.
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

          # A collection of tools that can help with SSH
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

          # pup is a CLI HTML query tool. Use CSS selectors to select elements.
          # Answering questions about HTML-bound data is massively easier this
          # way.
          pup

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

          # I'd like to try using diffpdf, but as of 2022-06-28 it isn't
          # supported on Darwin. I think it might be useful as a Git diff
          # driver for PDFs, though.
          #
          #diffpdf

          # Ripgrep is a fast tool for searching code.
          ripgrep

          # fd is for finding files in a directory that meet certain criteria.
          # It's mostly a friendlier, faster alternative to the venerable find
          # command.
          #
          # I'm not sure I'll really use fd much at all, because find is highly
          # portable, but fd does look interesting, so I'm installing it.
          fd

          # plocate is a faster implementation of the standardish Linux tool
          # locate. Commented out because it's only available on Linux and I'm
          # too lazy to figure out how to say "do not install on macOS" atm.
          #plocate

          # Pandoc is a Swiss-army-knife for working with plain-text documents.
          # I have used it for a few jobs in a few different contexts.
          pandoc

          # Aspell isn't a perfect spellchecker, but it works reasonably well
          # for me. Note that I integrate this closely with my Emacs config.
          aspell
          aspellDicts.en

          # I use sdcv to look up words in the dictionary (I have a
          # copyright-free 1913 edition of Webster's for the actual dictionary)
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

          # Dog is a DNS lookup tool, essentially dig with a nicer UI. I'll
          # probably always use dig as it's installed almost everywhere by
          # default, but dog looks like it could be nicer for several purposes.
          dogdns

          # Sometimes people use xz to compress things. Emacs tarballs, even.
          xz

          # I use a much-beloved ErgoDox EZ keyboard for typing. I run a custom
          # firmware so I can have the layout be what I want, and for that the
          # following tool is handy.
          qmk

          # pipx is a tool for running CLI Python tools in standalone
          # environments. It's here to support bin/install-python-commands.sh.
          python39Packages.pipx

          # Go is a programming language.
          go

          # Gopls is a language server for the Go programming language. By
          # having it installed, I gain decent Go intelligence while editing in
          # Emacs.
          gopls

          # I don't love PHP, but I've spent a lot of my career being paid to
          # use it. Thus...
          php81
          php81Packages.psysh

          # Vagrant is my preferred dev environment creator. Therefore...
          vagrant

          # These are all to support building my own Emacs.
          #
          # TODO Move these to a separate 'build-emacs' repo.
          # Needed for fast JSON parsing (good for LSP support)
          jansson
          # Native compilation of Emacs Lisp for speed
          libgccjit
          # Needed so compressed .el files in core Emacs build can be processed
          # by native compilation
          zlib
          # Various image formats I want support for.
          librsvg
          libjpeg
          libpng
          giflib
          # Native XML parsing for xml-mode.
          libxml2
          # Is this all I need to get Emacs to build with ImageMagick support?
          imagemagick

        ];
      };
    };
}
