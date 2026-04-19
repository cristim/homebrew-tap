class Killwindow < Formula
  desc "macOS xkill: click a window to SIGTERM/SIGKILL its owning process"
  homepage "https://github.com/cristim/killwindow"
  url "https://github.com/cristim/killwindow/releases/download/v0.3.0/killwindow-0.3.0-macos.tar.gz"
  sha256 "421d1266e7770a4efb683ff2265f361fd6097910c9c3c3e4794a6ddf6befe232"
  license "MIT"
  version "0.3.0"

  depends_on :macos

  def install
    # Tarball contains a .app bundle at the top level.
    # Install it under the keg prefix and expose the inner
    # binary as \`bin/killwindow\`. Running via the bundle
    # means macOS TCC tracks us by CFBundleIdentifier
    # (com.cristim.killwindow) so Accessibility / Input
    # Monitoring grants survive brew upgrades.
    prefix.install "killwindow.app"
    bin.install_symlink prefix/"killwindow.app/Contents/MacOS/killwindow"
  end

  service do
    run [opt_prefix/"killwindow.app/Contents/MacOS/killwindow", "daemon"]
    keep_alive true
    log_path var/"log/killwindow.log"
    error_log_path var/"log/killwindow.log"
  end

  def caveats
    <<~CAVEATS
      killwindow — click a window to kill it.

      One-off from terminal:
        killwindow                  # click to SIGTERM
        killwindow -h               # full help

      Background hotkey (default ⌃⌥⌘K, press anywhere):
        brew services start killwindow

      On first start the daemon registers killwindow with
      System Settings → Privacy & Security. Toggle it on in
      BOTH of these panes:
        • Accessibility    — to consume clicks
        • Input Monitoring — to listen to clicks
      Then: brew services restart killwindow

      Change the hotkey:
        killwindow setup --hotkey 'ctrl+opt+cmd+k'
        brew services restart killwindow
    CAVEATS
  end

  test do
    assert_match "killwindow", shell_output("#{bin}/killwindow --help")
  end
end
