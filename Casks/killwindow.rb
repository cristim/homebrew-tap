cask "killwindow" do
  version "0.4.1"
  sha256 "e842c65e669a1fb3b2c47f5787b90f8d65b89041388cf4166a9003fee7f32726"

  url "https://github.com/cristim/killwindow/releases/download/v#{version}/killwindow-#{version}-macos.tar.gz"
  name "killwindow"
  desc "Click a window to kill its owning process (macOS xkill)"
  homepage "https://github.com/cristim/killwindow"

  app "killwindow.app"
  binary "#{appdir}/killwindow.app/Contents/MacOS/killwindow"

  uninstall launchctl: "com.cristim.killwindow"

  zap trash: [
    "~/Library/Application Support/killwindow",
    "~/Library/LaunchAgents/com.cristim.killwindow.plist",
    "/tmp/killwindow.log",
  ]

  caveats <<~CAVEATS
    killwindow — click a window to kill it.

    One-off from terminal:
      killwindow                      # click to SIGTERM
      killwindow -h                   # full help

    Grant Accessibility and enable the background hotkey
    daemon (default ⌃⌥⌘K):
      killwindow setup
      killwindow setup --enable-daemon

    The Accessibility grant persists across upgrades because the
    .app's bundle ID (com.cristim.killwindow) stays constant.
  CAVEATS
end
