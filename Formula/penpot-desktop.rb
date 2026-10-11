# Rendered by .github/workflows/release.yml on tag pushes (2.17.1/d6e8f3cfab3e56c2a6795036691307acb6dd8885d8955900ed894254296fd840)
# and pushed to the agherasim/homebrew-tap repo.
class PenpotDesktop < Formula
  desc "Menu bar launcher for a self-hosted Penpot stack on Docker"
  homepage "https://github.com/agherasim/penpot-desktop"
  url "https://github.com/agherasim/penpot-desktop/archive/refs/tags/v2.17.1.tar.gz"
  sha256 "d6e8f3cfab3e56c2a6795036691307acb6dd8885d8955900ed894254296fd840"
  head "https://github.com/agherasim/penpot-desktop.git", branch: "main"

  depends_on :macos

  def install
    system "make", "assemble", "APP_DIR=#{prefix}/Penpot.app"
    (bin/"penpot").write <<~SH
      #!/bin/sh
      exec "#{opt_prefix}/Penpot.app/Contents/MacOS/Penpot" "$@"
    SH
  end

  def caveats
    <<~EOS
      Requires Docker Desktop:
        brew install --cask docker

      To add Penpot to your Applications folder (Spotlight, Launchpad, Dock):
        penpot install-app

      Before `brew uninstall penpot-desktop`, remove the launcher:
        penpot uninstall-app
    EOS
  end

  test do
    assert_match "No Penpot launcher", shell_output("#{bin}/penpot uninstall-app #{testpath}")
  end
end
