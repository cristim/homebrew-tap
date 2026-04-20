class Killwindow < Formula
  desc "macOS xkill: click a window to SIGTERM/SIGKILL its owning process"
  homepage "https://github.com/cristim/killwindow"
  url "https://github.com/cristim/killwindow/releases/download/v0.3.4/killwindow-0.3.4-macos.tar.gz"
  sha256 "20008f9344a600af4928de6240d73541c461c99b98931794e21c596a5212e6a1"
  license "MIT"
  version "0.3.4"

  depends_on :macos

  def install
    # Tarball stages a killwindow-<version>/ directory whose
    # only child is killwindow.app. Homebrew auto-cd's into
    # that wrapper, so killwindow.app is in CWD.
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

      On first start the daemon registers killwindow in
      System Settings → Privacy & Security → Accessibility.
      Toggle it on, then: brew services restart killwindow

      Change the hotkey:
        killwindow setup --hotkey 'ctrl+opt+cmd+k'
        brew services restart killwindow
    CAVEATS
  end

  test do
    assert_match "killwindow", shell_output("#{bin}/killwindow --help")
  end
end
