cask "killwindow" do
  version "0.4.6"
  sha256 "7834f27d7b4a46762d76a1ab71968ff2772a35b2241b6c9a173a30f8e46d6ce6"

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

  # Ad-hoc signing ties the TCC grant to the binary's cdhash,
  # which changes on every release. After the upgrade, reset
  # our Accessibility entry so the new daemon can register a
  # fresh one, and re-bootstrap the user's LaunchAgent (if
  # they have it enabled) so it picks up the new binary.
  postflight do
    system_command "/usr/bin/tccutil",
                   args: ["reset", "Accessibility", "com.cristim.killwindow"]
    plist = File.expand_path("~/Library/LaunchAgents/com.cristim.killwindow.plist")
    if File.exist?(plist)
      system_command "/bin/launchctl",
                     args: ["bootout", "gui/#{Process.uid}", plist]
      system_command "/bin/launchctl",
                     args: ["bootstrap", "gui/#{Process.uid}", plist]
    end
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
