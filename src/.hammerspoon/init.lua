-- My personal Hammerspoon (https://www.hammerspoon.org) config.
--
-- I used to use Slate but it's been abandonware for a while now and it got
-- really laggy on my work machine, so I'm starting the move over to
-- Hammerspoon.
--
-- The world is too much with us; slate and spoon,
-- calling and binding we lay waste our powers;--

hyper_keys = {"ctrl", "shift"}

-- Give me a way to reload config when I want to. There are ways to be smarter
-- but this is what I want.
hs.hotkey.bind(hyper_keys, "R", function()
      hs.reload()
end)

--
-- Shortcuts for jumping straight to apps.
--

function bindAppToHotkey(app, keycode)
    hs.hotkey.bind(hyper_keys, keycode, function()
        hs.application.launchOrFocus(app)
    end)
end

bindAppToHotkey("Emacs", "E")
bindAppToHotkey("Terminal", "T")
bindAppToHotkey("Google Chrome", "B")
bindAppToHotkey("Calendar", "C")
bindAppToHotkey("Finder", "F")
bindAppToHotkey("Slack", "I")
bindAppToHotkey("YakYak", "Y")


--
-- Shortcuts for running commands with keybindings.
--

function bindCommandToHotkey(cmd, keycode)
    hs.hotkey.bind(hyper_keys, "N", function()
        os.execute(cmd)
    end)
end

-- Dismiss all notifications in a single key combo.
bindCommandToHotkey("~/dotfiles/bin/dismiss-notifications", "N")

-- Toggle whether my mic is on in a Slack call while I'm in a different app.
bindCommandToHotkey("~/dotfiles/bin/mute-slack", "M")
