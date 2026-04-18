class Killwindow < Formula
  desc "macOS xkill: click a window to SIGTERM/SIGKILL its owning process"
  homepage "https://github.com/cristim/killwindow"
  url "https://github.com/cristim/killwindow/releases/download/v0.2.1/killwindow-0.2.1-macos.tar.gz"
  sha256 "d42e31bcb7d85f265b2a0f479cf9bd890d988113fb336f913364f663e60bdb98"
  license "MIT"
  version "0.2.1"

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
