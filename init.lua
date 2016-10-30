------------------------------------------------
-- NECESSARY FUNCTIONS, DON'T REMOVE
------------------------------------------------

-- A global variable for the Hyper Mode
k = hs.hotkey.modal.new({}, "F17")

------------------------------------------------
-- SYSTEM FUNCTIONALITY
------------------------------------------------

-- Start screensaver and lock computer
k:bind({}, 'l', hs.caffeinate.startScreensaver)

-- Clipboard Manager
require "tools/clipboard"

------------------------------------------------
-- SHOWING/HIDING APPLICATIONS
------------------------------------------------

-- Show/Hide app by bundleID
showHide = function(bundleID)
  front = hs.application.frontmostApplication()
  if front:bundleID() == bundleID then
    front:hide()
  else
    hs.application.launchOrFocusByBundleID(bundleID)
  end
  k.triggered = true
end

-- Apps for show hide
-- Example to get bundleID:
-- mdls -name kMDItemCFBundleIdentifier -r Fantastical\ 2.app/
singleapps = {
  {'a', 'com.syntevo.smartsvn'},
  {'c', 'com.apple.iChat'},
  {'d', 'com.sequelpro.SequelPro'},
  {'g', 'com.github.GitHub'},
  {'i', 'com.jetbrains.intellij'},
  {'k', 'com.stairways.keyboardmaestro.editor'},
  {'m', 'com.spotify.client'},
  {'n', 'com.flexibits.fantastical2.mac'},
  {'p', 'com.postmanlabs.mac'},
  {'r', 'com.apple.reminders'},
  {'s', 'com.sublimetext.2'},
  {'t', 'com.googlecode.iterm2'},
  {'u', 'com.bittorrent.uTorrent'},
  {'w', 'com.google.Chrome'},
  {'x', 'com.tinyspeck.slackmacgap'},
  {'z', 'me.rsms.fbmessenger'}
}

-- Bind apps
for i, app in ipairs(singleapps) do
  k:bind({}, app[1], function() showHide(app[2]); end)
end

------------------------------------------------
-- WINDOW SNAPPING LEFT, RIGHT, AND MAXIMIZE
------------------------------------------------

-- Hyper + Left = Snap Left
-- https://gist.github.com/spartanatreyu/850788a0441e1c5565668a35ed9a1dfc
k:bind({}, 'Left', function()
  local win = hs.window.focusedWindow()
  local f = win:frame()
  local screen = win:screen()
  local max = screen:frame()

  f.x = max.x
  f.y = max.y
  f.w = max.w / 2
  f.h = max.h
  win:setFrame(f)
end)

-- Hyper + Right = Snap Right
-- https://gist.github.com/spartanatreyu/850788a0441e1c5565668a35ed9a1dfc
k:bind({}, 'Right', function()
  local win = hs.window.focusedWindow()
  local f = win:frame()
  local screen = win:screen()
  local max = screen:frame()

  f.x = max.x + (max.w / 2)
  f.y = max.y
  f.w = max.w / 2
  f.h = max.h
  win:setFrame(f)
end)

-- Hyper + Up = Maximize
-- https://gist.github.com/spartanatreyu/850788a0441e1c5565668a35ed9a1dfc
k:bind({}, 'Up', function()
  local win = hs.window.focusedWindow()
  local f = win:frame()
  local screen = win:screen()
  local max = screen:frame()

  f.x = max.x
  f.y = max.y
  f.w = max.w
  f.h = max.h
  win:setFrame(f)
end)

------------------------------------------------
-- NECESSARY FUNCTIONS FROM HERE DOWN
------------------------------------------------

-- Enter Hyper Mode when F18 (Hyper/Capslock) is pressed
pressedF18 = function()
  k.triggered = false
  k:enter()
end

-- Leave Hyper Mode when F18 (Hyper/Capslock) is pressed,
--   send ESCAPE if no other keys are pressed.
releasedF18 = function()
  k:exit()
  if not k.triggered then
    hs.eventtap.keyStroke({}, 'ESCAPE')
  end
end

-- Bind the Hyper key
f18 = hs.hotkey.bind({}, 'F18', pressedF18, releasedF18)
