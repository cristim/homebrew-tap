class Killwindow < Formula
  desc "macOS xkill: click a window to SIGTERM/SIGKILL its owning process"
  homepage "https://github.com/cristim/killwindow"
  url "https://github.com/cristim/killwindow/releases/download/v0.1.0/killwindow-0.1.0-macos.tar.gz"
  sha256 "47900c878e2af4ee8259d39caaa4959fd8981c17661c00ddf2bcd48e335eb58f"
  license "MIT"
  version "0.1.0"

  depends_on :macos

  def install
    bin.install "killwindow"
  end

  test do
    assert_match "killwindow", shell_output("#{bin}/killwindow --help")
  end
end
