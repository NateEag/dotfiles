-- My personal Hammerspoon (https://www.hammerspoon.org) config.
--
-- I used to use Slate but it's been abandonware for a while now and it got
-- really laggy on my work machine, so I'm starting the move over to
-- Hammerspoon.
--
-- The world is too much with us; slate and spoon,
-- calling and binding we lay waste our powers;--

hyper_keys = {"ctrl", "shift"}

-- I don't like waiting for cute little window animations.
ANIMATION_DURATION = 0

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
        -- FIXME Only focus the frontmost window. Slate worked that way and I
        -- preferred it, as it was easier to leave a browser window and a
        -- terminal side-by-side that way, for example.
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
    hs.hotkey.bind(hyper_keys, keycode, function()
        os.execute(cmd)
    end)
end

-- Dismiss all notifications in a single key combo.
bindCommandToHotkey("~/dotfiles/bin/dismiss-notifications", "N")

-- Toggle whether my mic is on in a Slack call while I'm in a different app.
bindCommandToHotkey("~/dotfiles/bin/mute-slack", "M")

-- Start up a new Emacs instance. Useful when I'm writing init code and want to
-- test it.
bindCommandToHotkey("/usr/bin/open -n -a Emacs.app", "W")

-- Activate screensaver from keyboard. If your machine is set up to lock the
-- display on screensaver, this is a handy shortcut for locking the display.
bindCommandToHotkey("/Users/neagleson/dotfiles/bin/screensaver", "A")


--
-- Shortcuts for moving windows manually.
--

-- Note that Hammerspoon uses a window coordinate grid that covers all screens,
-- with the primary's upper-left corner at 0, 0. That means window placement
-- arithmetic is a bit fussier than it was under Slate, where each screen had
-- its own coordinate system.
hs.hotkey.bind(hyper_keys, "H", function()
    local win = hs.window.focusedWindow()
    local win_frame = win:frame()

    local screen = win:screen()
    local screen_frame = screen:frame()

    win_frame.x = screen_frame.x
    win_frame.y = screen_frame.y

    win:setFrame(win_frame, ANIMATION_DURATION)
end)

hs.hotkey.bind(hyper_keys, "J", function()
    local win = hs.window.focusedWindow()
    local win_frame = win:frame()

    local screen = win:screen()
    local screen_frame = screen:frame()

    win_frame.x = screen_frame.x + screen_frame.w - win_frame.w
    win_frame.y = screen_frame.y

    win:setFrame(win_frame, ANIMATION_DURATION)
end)

hs.hotkey.bind(hyper_keys, "K", function()
    local win = hs.window.focusedWindow()
    local win_frame = win:frame()

    local screen = win:screen()
    local screen_frame = screen:frame()

    win_frame.x = screen_frame.x
    win_frame.y = screen_frame.y + screen_frame.h - win_frame.h

    win:setFrame(win_frame, ANIMATION_DURATION)
end)

hs.hotkey.bind(hyper_keys, "L", function()
    local win = hs.window.focusedWindow()
    local win_frame = win:frame()

    local screen = win:screen()
    local screen_frame = screen:frame()

    win_frame.x = screen_frame.x + screen_frame.w - win_frame.w
    win_frame.y = screen_frame.y + screen_frame.h - win_frame.h

    win:setFrame(win_frame, ANIMATION_DURATION)
end)


-- Move window to next monitor. Yanked from here:
--
-- https://www.reddit.com/r/hammerspoon/comments/aexm45/request_move_between_multiple_monitors/
hs.hotkey.bind(hyper_keys, "O", function()
    -- Get the focused window, its window frame dimensions, its screen frame
    -- dimensions, and the next screen's frame dimensions.
    local focusedWindow = hs.window.focusedWindow()
    local focusedScreenFrame = focusedWindow:screen():frame()
    local nextScreenFrame = focusedWindow:screen():next():frame()
    local windowFrame = focusedWindow:frame()

    -- Calculate the coordinates of the window frame in the next screen and
    -- retain aspect ratio
    windowFrame.x = ((((windowFrame.x - focusedScreenFrame.x) / focusedScreenFrame.w) * nextScreenFrame.w) + nextScreenFrame.x)
    windowFrame.y = ((((windowFrame.y - focusedScreenFrame.y) / focusedScreenFrame.h) * nextScreenFrame.h) + nextScreenFrame.y)
    windowFrame.h = ((windowFrame.h / focusedScreenFrame.h) * nextScreenFrame.h)
    windowFrame.w = ((windowFrame.w / focusedScreenFrame.w) * nextScreenFrame.w)

    -- Set the focused window's new frame dimensions
    focusedWindow:setFrame(windowFrame, ANIMATION_DURATION)
end)
