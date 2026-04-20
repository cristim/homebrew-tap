cask "killwindow" do
  version "0.4.4"
  sha256 "5b8715cf32ab464096d0ca19285dc57d4205a1cfc1b0b514cec04e71e56512e2"

  url "https://github.com/cristim/killwindow/releases/download/v#{version}/killwindow-#{version}-macos.tar.gz"
  name "killwindow"
  desc "Click a window to kill its owning process (macOS xkill)"
  homepage "https://github.com/cristim/killwindow"

  app "killwindow.app"
  binary "#{appdir}/killwindow.app/Contents/MacOS/killwindow"

  # Ad-hoc signed, not notarised — strip the quarantine xattr so
  # Gatekeeper doesn't block first launch with the "cannot verify
  # this app is free of malware" dialog.
  preflight do
    system_command "/usr/bin/xattr",
                   args: ["-cr", staged_path/"killwindow.app"]
  end

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
