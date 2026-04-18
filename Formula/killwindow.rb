class Killwindow < Formula
  desc "macOS xkill: click a window to SIGTERM/SIGKILL its owning process"
  homepage "https://github.com/cristim/killwindow"
  url "https://github.com/cristim/killwindow/releases/download/v0.2.3/killwindow-0.2.3-macos.tar.gz"
  sha256 "74b944ba28444e7e948d9b1ebbee34e656debe5e5e35fc427626dc3e95f5be87"
  license "MIT"
  version "0.2.3"

  depends_on :macos

  def install
    bin.install "killwindow"
  end

  service do
    run [opt_bin/"killwindow", "daemon"]
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

      Grant Accessibility permission (required so killwindow can
      capture your next click) and optionally change the hotkey:
        killwindow setup
        killwindow setup --hotkey 'ctrl+opt+cmd+k'
        brew services restart killwindow
    CAVEATS
  end

  test do
    assert_match "killwindow", shell_output("#{bin}/killwindow --help")
  end
end
