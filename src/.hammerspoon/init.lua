-- My personal Hammerspoon (https://www.hammerspoon.org) config.
--
-- I used to use Slate but it's been abandonware for a while now and it got
-- really laggy on my work machine, so I'm starting the move over to
-- Hammerspoon.
--
-- The world is too much with us; slate and spoon,
-- calling and binding we lay waste our powers;--


-- Set up the logger so I can debug things in my config.
--
-- logger.i('Message here')
--
-- will output to the Hammerspoon Console (which has a display
-- keybinding elsewhere in this file - search for openConsole).
logger = hs.logger.new('ne-debugger', 'info');

home_dir = os.getenv('HOME')

-- My personal keybinding namespace. If I ever change baseline OSes, this may
-- need to change, since Ctrl+Shift is a much more common combo on Linux and
-- Windows.
hyper_keys = {"ctrl", "shift"}


-- I don't like waiting for cute little window animations.
ANIMATION_DURATION = 0

cli_installed = hs.ipc.cliStatus()


-- A little-known OS X builtin keybinding I rely on extensively is
-- Control-F2. It focuses the menu bar, from which you can navigate by
-- typing the next name you want to focus. Windows users will know how much
-- better this is.
--
-- There is an unfortunate issue with this keybinding, which is that sometimes
-- it just mysteriously fails to do anything. So far I have discerned no
-- pattern, but I do have a (ridiculous) workaround:
--
-- Do Control-F3 first. That focuses the Dock, and for some reason, once
-- the Dock is focused, Control-F2 works consistently.
--
-- And now you know why the following bizarre function exists - because I hate
-- doing two keyboard shortcuts to get the effect of one.
--
-- (Bonus - I don't have to hold down the Fn modifier to trigger the menubar [I
-- use it on both my laptop's internal keyboard and in my ErgoDox EZ layout for
-- triggering Fkeys]).
--
-- Note that an arguably-better feature in OS X is the Command-Shift-? keyboard
-- shortcut, which lets you search across menus.
function focusMenuBar()
    hs.eventtap.keyStroke({"ctrl"}, "f3", 100)
    hs.eventtap.keyStroke({"ctrl"}, "f2", 100)
end

function focusApp(app_name, keycode)
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
end


function runCommand(cmd)
   os.execute(cmd)
end


--
-- Functions for manipulating windows.
--

-- Move window to next monitor. Yanked from here:
--
-- https://www.reddit.com/r/hammerspoon/comments/aexm45/request_move_between_multiple_monitors/
--
-- Note that Hammerspoon uses a window coordinate grid that covers all screens,
-- with the primary's upper-left corner at 0, 0. That means window placement
-- arithmetic is a bit fussier than it was under Slate, where each screen had
-- its own coordinate system.
function moveFocusedWindowToNextScreen()
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
end

function positionFocusedWindow(x,
                               y,
                               screen_width_fraction,
                               screen_height_fraction,
                               keycode)
   local win = hs.window.focusedWindow()
   local win_frame = win:frame()

   local screen = win:screen()
   local screen_frame = screen:frame()

   win_frame.x = screen_frame.x
   win_frame.y = screen_frame.y
   win_frame.w = screen_frame.w * screen_width_fraction
   win_frame.h = screen_frame.h * screen_height_fraction

   win:setFrame(win_frame, ANIMATION_DURATION)
end

function moveFocusedWindowToTopLeft()
   local win = hs.window.focusedWindow()
   local win_frame = win:frame()

   local screen = win:screen()
   local screen_frame = screen:frame()

   win_frame.x = screen_frame.x
   win_frame.y = screen_frame.y

   win:setFrame(win_frame, ANIMATION_DURATION)
end

function moveFocusedWindowToTopRight()
   local win = hs.window.focusedWindow()
   local win_frame = win:frame()

   local screen = win:screen()
   local screen_frame = screen:frame()

   win_frame.x = screen_frame.x + screen_frame.w - win_frame.w
   win_frame.y = screen_frame.y

   win:setFrame(win_frame, ANIMATION_DURATION)
end

function moveFocusedWindowToBottomLeft()
    local win = hs.window.focusedWindow()
    local win_frame = win:frame()

    local screen = win:screen()
    local screen_frame = screen:frame()

    win_frame.x = screen_frame.x
    win_frame.y = screen_frame.y + screen_frame.h - win_frame.h

    win:setFrame(win_frame, ANIMATION_DURATION)
end

function moveFocusedWindowToBottomRight()
    local win = hs.window.focusedWindow()
    local win_frame = win:frame()

    local screen = win:screen()
    local screen_frame = screen:frame()

    win_frame.x = screen_frame.x + screen_frame.w - win_frame.w
    win_frame.y = screen_frame.y + screen_frame.h - win_frame.h

    win:setFrame(win_frame, ANIMATION_DURATION)
end


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
   -- First make sure Emacs is running. If not, gently remind the user/author
   -- that the logic to lay out windows does not actually work unless Emacs is
   -- running, as Emacs is central to it.
   local emacs = hs.appfinder.appFromName("Emacs")
   if emacs == nil then
      hs.dialog.alert(0, 0, nil, "Cannot position windows if Emacs is not running.")
      return
   end

    -- Tell Emacs to compute its frame size. I've taught it to size itself
    -- based on screen size, and it's where I spend much of my workday, so it
    -- becomes the point of reference for sizing and placing other windows.
    --
    -- FIXME Try to at least position other windows when Emacs is not running.
    -- Conceptually that's difficult when the logic is centered around Emacs
    -- windows. I have not really worried about this bug since I don't really
    -- use computers without running Emacs, but I have bumped into it once or
    -- twice.
    --
    -- TODO Do this after moving Emacs to the appropriate screen? I think this
    -- happens to work with my current setup but is not generally correct in
    -- principle.
    os.execute("/Applications/Emacs.app/Contents/MacOS/bin/emacsclient -e '(my-set-up-frame)'")

   local screens = hs.screen.allScreens()
   local num_screens = #screens

   -- Sometimes no primary screen is returned. I *think* this happens when the
   -- screen watcher triggers an event before OS X has finished adjusting to
   -- the new monitor - sometimes I see only the laptop screen active but it
   -- has no menubar, which seems to suggest there would be no primary screen
   -- at that point.
   local primary_screen = hs.screen.primaryScreen()
   if primary_screen == nil then
      logger.i('Primary screen not found!')

      return
   end
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

   -- Move terminal windows to the second monitor, taking up the left half.
   --
   -- Non-obvious fact: second_screen and primary_screen are the same if
   -- there's one display.
   --
   -- TODO Keep them on main monitor if the Emacs window has left enough space
   -- to reasonably put it there?
   local second_screen = primary_screen:toEast()
   local third_screen = nil

   -- If I have three displays, it almost certainly means my laptop display is
   -- open while hooked up to two externals, as I don't usually use three
   -- external monitors (my experiments with triple 27"s at MapQuest taught me
   -- I couldn't reasonably use that much space).
   --
   -- I position the laptop display logically beneath my two main displays and
   -- centered between them, which means it's the next display "toEast()" from
   -- primary.
   --
   -- Semantically, I want to treat it as an optional third screen - hence this
   -- odd dance.
   if num_screens == 3 then
      third_screen = second_screen
      second_screen = second_screen:toEast()
   end

   local left_side_screen_rect = hs.geometry.new(0, 0, 0.5, 1)
   local right_side_screen_rect = hs.geometry.new(0.5, 0, 0.5, 1)
   local lower_right_screen_rect = hs.geometry.new(0.5, 0.5, 0.5, 0.5)
   local upper_right_screen_rect = hs.geometry.new(0.5, 0, 0.5, 0.5)
   local full_screen_rect = hs.geometry.new(0, 0, 1, 1)

   -- I don't use a desktop computer with one display these days, so this is a
   -- decent proxy for "am I running on a laptop with no external display?"
   local using_only_laptop_display = num_screens == 1

   if using_only_laptop_display then
      -- Since there's just one display, everything is on the same display as
      -- Emacs. Therefore, size windows to fit around it.
      --
      -- TODO Apply similar logic when using multiple monitors large enough that
      -- there's space for more than just Emacs on the primary display.
      local current_emacs_window = emacs:focusedWindow()
      local emacs_window_rect = current_emacs_window:frame()
      local primary_screen_frame = primary_screen:frame()

      left_side_screen_rect = emacs_window_rect

      -- I originally computed this as absolute pixel-based rects, but that
      -- resulted in the menubar not being accounted for somehow.
      --
      -- I had the empirical data that my older, dumber setup worked. It used
      -- unit rects, so I tried that as a workaround.
      --
      -- It worked, and so the following code came to be.
      --
      -- TODO Understand the pixel logic failure and file bug if appropriate.

      local remaining_space_rect = hs.geometry.new(
         emacs_window_rect.x2 / primary_screen_frame.w,
         emacs_window_rect.y / primary_screen_frame.h,
         (primary_screen_frame.x2 - emacs_window_rect.w) / primary_screen_frame.w,
         1
      )

      lower_right_screen_rect = hs.geometry.new(
         remaining_space_rect.x,
         remaining_space_rect.h / 2,
         remaining_space_rect.w,
         remaining_space_rect.h / 2
      )

      upper_right_screen_rect = hs.geometry.new(
         remaining_space_rect.x,
         0,
         remaining_space_rect.w,
         remaining_space_rect.h / 2
      )

      right_side_screen_rect = remaining_space_rect
   end

   if using_only_laptop_display then
      layoutAppWindows("cool-retro-term", upper_right_screen_rect, primary_screen)
   else
      layoutAppWindows("cool-retro-term", left_side_screen_rect, second_screen)
   end

   layoutAppWindows("Calendar", left_side_screen_rect, primary_screen)

   layoutAppWindows("Google Chrome", right_side_screen_rect, second_screen)

   layoutAppWindows("Slack", lower_right_screen_rect, primary_screen)

   layoutAppWindows("Signal", upper_right_screen_rect, primary_screen)

   layoutAppWindows("Pandora", upper_right_screen_rect, primary_screen)

   -- As noted elsewhere, if I have three screens it almost certainly means I'm
   -- using my laptop display while hooked up to two external screens.
   --
   -- I mainly do this for video calls and maybe sometimes screenshares, which
   -- is why Slack goes there in this case.
   if num_screens == 3 then
      layoutAppWindows("Slack", full_screen_rect, third_screen)
   end
end

-- Automatically re-layout screen when my available monitors change or I change
-- spaces (since inactive spaces will not be updated on monitor setup change)

screen_watcher = hs.screen.watcher.newWithActiveScreen(layoutWindows)
screen_watcher:start()

-- This setting is only reasonable if you turn off "each display has its own
-- space" in System Preferences.
--
-- Otherwise, relayout happens when I switch between apps on different
-- displays, and since I don't have a completely automated window sizing /
-- positioning setup for every situation I encounter, it mangles things I've
-- done manually.
space_watcher = hs.spaces.watcher.new(layoutWindows)
space_watcher:start()

-- FIXME Get this to actually fire. It doesn't and I don't know why. This guy
-- appears to have a test that may not be working either.
--
-- https://github.com/zzamboni/hammerspoon-config/blob/master/audio/headphones_watcher.lua
hs.audiodevice.watcher.setCallback(function(event)
   logger.i('An event occurred! %s', event)
end)
hs.audiodevice.watcher.start()


-- Register my keybindings.
--
-- We do this last so all defined functions are available.

-- My personal keybindings. Currently all defined to be a key combo of the form
-- Control-Shift-<key>. Maybe someday I'll expand beyond that.
key_bindings = {
   --
   -- App hotkeys.
   --

   E = {focusApp, "Emacs"},
   T = {focusApp, "cool-retro-term"},
   B = {focusApp, "Google Chrome"},
   C = {focusApp, "Calendar"},
   F = {focusApp, "Finder"},
   I = {focusApp, "Slack"},
   S = {focusApp, "Signal"},
   P = {focusApp, "Pandora"},
   G = {focusApp, "Anki"},
   -- This isn't a mnemonic at all. It's one of the few letters I haven't bound
   -- yet.
   --
   -- TODO Figure out a more long-term sustainable keybinding strategy, since
   -- I'm almost out of available ones.
   U = {focusApp, "Timer"},

   -- Hammerspoon-specific keybindings.

   -- Give me a way to reload config when I want to. Auto-reloading is possible
   -- but seems like it will cause unpredictable breakage when I'm working on
   -- the config file.
   R = {hs.reload},

   -- This is a stupid shortcut but I want *something* that does this, and "E"
   -- (for evaluate) and "L" (for Lua) are already taken.
   ["'"] = {hs.openConsole},


   --
   -- CLI tools I have bound to a hotkey.
   --

   -- Activate screensaver from keyboard. If your machine is set up to lock the
   -- display on screensaver, this is a handy shortcut for locking the display.
   A = {runCommand, home_dir .. "/dotfiles/bin/screensaver"},

   -- Dismiss all notifications in a single key combo.
   N = {runCommand, "~/dotfiles/bin/dismiss-notifications"},

   -- Toggle whether my mic is on in a Slack call while I'm in a different app.
   M = {runCommand, "~/dotfiles/bin/mute-slack"},

   -- Start up a new Emacs instance. Useful when I'm writing init code and want
   -- to test it.
   W = {runCommand, "/usr/bin/open -n -a Emacs.app"},


   --
   -- Window management hotkeys.
   --

   Q = {positionFocusedWindow, 0, 0, 0.5, 0.5},

   -- 'Divide' is a poor mnemonic for "Make window half-width, full-height", but
   -- it's what I went with back in the day.
   D = {positionFocusedWindow, 0, 0, 0.5, 1},

   -- The following aren't mnemonically reasonable - I misapplied vim keyindings
   -- because I wanted these under my fingers.
   --
   -- In retrospect, I actually don't use these that often, but now they're
   -- reflexive, so I guess I'll live with it.
   H = {moveFocusedWindowToTopLeft},
   J = {moveFocusedWindowToTopRight},
   K = {moveFocusedWindowToBottomLeft},
   L = {moveFocusedWindowToBottomRight},

   O = {moveFocusedWindowToNextScreen},

   -- Force screen layout. I used to have more of these and had them assigned to a
   -- few different numkeys, but then the logic defining my screen layout got a
   -- lot smarter.
   ["1"] = {layoutWindows},

   -- ';' is not a mnemonic for maximizing a window, but it's next to my other
   -- window manipulation keys.
   --
   -- Note that I dislike OS X's "full screen" functionality. I almost never
   -- want to make all my other windows vanish, which is why I do it this way.
   [";"] =  {positionFocusedWindow, 0, 0, 1, 1},

   -- "," is not a great mnemonic, but it'll work.
   [","] = {focusMenuBar}
}

for mnemonic, callback_info in pairs(key_bindings) do
   logger.i('Registering %s for %s', mnemonic, callback_info[1])
   hs.hotkey.bind(hyper_keys, mnemonic, function()
      callback_info = key_bindings[mnemonic]

      callback = callback_info[1]
      args = { table.unpack(callback_info, 2) }

      callback(table.unpack(args))
   end)
end

-- Log unused Hammerspoon keybindings so I can easily see what's available.
function getUnusedKeybindings()
   local keyboard_chars = {",", "-", "=", "\\", "/", "[", "]", ".", "'", " ", '`'}
   local unused_chars = {}

   for ascii = 65, 65 + 25 do
      table.insert(keyboard_chars, string.char(ascii))
   end

   for ascii = 48, 57 do
      table.insert(keyboard_chars, string.char(ascii))
   end

   table.insert(keyboard_chars, ",")

   for i, char in pairs(keyboard_chars) do
      local char_used = false
      for mnemonic, callback_info in pairs(key_bindings) do
         if mnemonic == char then
            char_used = true
         end
      end

      if char_used == false then
         table.insert(unused_chars, char)
      end
   end

   logger.i('Unused keys are:')
   for i, char in pairs(unused_chars) do
      logger.i(char)
   end
end
getUnusedKeybindings()
