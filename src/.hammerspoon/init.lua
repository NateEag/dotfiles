-- My personal Hammerspoon (https://www.hammerspoon.org) config.
--
-- I used to use Slate but it's been abandonware for a while now and it got
-- really laggy on my work machine, so I'm starting the move over to
-- Hammerspoon.
--
-- The world is too much with us; slate and spoon,
-- calling and binding we lay waste our powers;--


-- My personal keybinding namespace. If I ever change baseline OSes, this may
-- need to change, since Ctrl+Shift is a much more common combo on Linux and
-- Windows.
hyper_keys = {"ctrl", "shift"}


-- I don't like waiting for cute little window animations.
ANIMATION_DURATION = 0


--
-- Hammerspoon-specific configuration.
--


-- Give me a way to reload config when I want to. Auto-reloading is possible
-- but seems like it will cause unpredictable breakage when I'm working on the
-- config file.
hs.hotkey.bind(hyper_keys, "R", hs.reload)

-- This is a stupid shortcut but I want *something* that does this, and "E"
-- (for evaluate) and "L" (for Lua) are already taken.
hs.hotkey.bind(hyper_keys, "P", hs.openConsole)


--
-- Shortcuts for jumping straight to apps.
--

function bindAppToHotkey(app_name, keycode)
    hs.hotkey.bind(hyper_keys, keycode, function()
        local app = hs.appfinder.appFromName(app_name)

        -- Funny little dance to both start the app if it's not running but
        -- focus it *without bringing all windows forward* if it is running.
        --
        -- TODO File an issue to make launchOrFocus() support an optional arg
        -- for this like app:activate().
        if app == nil then
           hs.application.launchOrFocus(app_name)
        else
           app:activate()
        end
    end)
end

bindAppToHotkey("Emacs", "E")
bindAppToHotkey("Terminal", "T")
bindAppToHotkey("Google Chrome", "B")
bindAppToHotkey("Calendar", "C")
bindAppToHotkey("Finder", "F")
bindAppToHotkey("Slack", "I")
bindAppToHotkey("YakYak", "Y")
bindAppToHotkey("Signal", "S")


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


-- 'Divide' is a poor mnemonic for "Make window half-width, full-height", but
-- it's what I went with back in the day.
hs.hotkey.bind(hyper_keys, "D", function()
    local win = hs.window.focusedWindow()
    local win_frame = win:frame()

    local screen = win:screen()
    local screen_frame = screen:frame()

    win_frame.x = screen_frame.x
    win_frame.y = screen_frame.y
    win_frame.w = screen_frame.w / 2
    win_frame.h = screen_frame.h

    win:setFrame(win_frame, ANIMATION_DURATION)
end)


-- 'Quarter' is a slightly better mnemonic.
--
-- TODO Put the window in the corner it's closest to.
hs.hotkey.bind(hyper_keys, "Q", function()
    local win = hs.window.focusedWindow()
    local win_frame = win:frame()

    local screen = win:screen()
    local screen_frame = screen:frame()

    win_frame.x = screen_frame.x
    win_frame.y = screen_frame.y
    win_frame.w = screen_frame.w / 2
    win_frame.h = screen_frame.h / 2

    win:setFrame(win_frame, ANIMATION_DURATION)
end)


-- The following four rules just let me pin a window to one of the four corners
-- of the world.
--
-- I mean screen.
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


--
-- Set window size and position based on the currently-connected displays.
--

function layoutAppWindows(app_name, window_rect, screen)
   local app = hs.appfinder.appFromName(app_name)
   if app == nil then
      -- Don't try to adjust windows for an app that's not running.
      return
   end

   local windows = app:allWindows()

   for key, window in pairs(windows) do
      window:move(window_rect, screen, true, ANIMATION_DURATION)
   end
end

function layoutWindows()
    -- Tell Emacs to compute its frame size. I've taught it to size itself
    -- based on screen size, and it's where I spend much of my workday, so it
    -- becomes the point of reference for sizing and placing other windows.
    --
    -- TODO Do this after moving Emacs to the appropriate screen? I think this
    -- happens to work with my current setup but is not generally correct in
    -- principle.
    os.execute("/Applications/Emacs.app/Contents/MacOS/bin/emacsclient -e '(my-set-up-frame)'")

   local screens = hs.screen.allScreens()
   local num_screens = #screens

   local primary_screen = hs.screen.primaryScreen()
   local emacs = hs.appfinder.appFromName("Emacs")
   local windows = emacs:allWindows()

   for key, window in pairs(windows) do
      window:moveToScreen(primary_screen, false, true, ANIMATION_DURATION)

      -- Now make sure it's at the current screen's top corner.
      local window_frame = window:frame()
      screen_frame = window:screen():frame()

      window_frame.x = screen_frame.x
      window_frame.y = screen_frame.y

      window:setFrame(window_frame, ANIMATION_DURATION)
   end

   -- Move Terminal windows to the second monitor, taking up the left half.
   local second_screen = primary_screen:toEast()

   local left_half_screen_rect = hs.geometry.new(0, 0, 0.5, 1)

   layoutAppWindows("Terminal", left_half_screen_rect, second_screen)

   layoutAppWindows("Calendar", left_half_screen_rect, primary_screen)

   local right_half_screen_rect = hs.geometry.new(0.5, 0, 0.5, 1)
   layoutAppWindows("Google Chrome", right_half_screen_rect, second_screen)

   local lower_right_screen_rect = hs.geometry.new(0.5, 0.5, 0.5, 0.5)
   layoutAppWindows("Slack", lower_right_screen_rect, primary_screen)

   local upper_right_screen_rect = hs.geometry.new(0.5, 0, 0.5, 0.5)
   layoutAppWindows("Signal", upper_right_screen_rect, primary_screen)

   local upper_right_screen_rect = hs.geometry.new(0.5, 0, 0.5, 0.5)
   layoutAppWindows("YakYak", upper_right_screen_rect, primary_screen)
end

hs.hotkey.bind(hyper_keys, "1", layoutWindows)

-- Automatically re-layout screen when my available monitors change.

screen_watcher = hs.screen.watcher.newWithActiveScreen(layoutWindows)
screen_watcher:start()
