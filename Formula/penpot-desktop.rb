# Rendered by .github/workflows/release.yml on tag pushes (2.17.1.2/2489d5426875283eef7dfad1db14abff4be6d88758c70e263758d5c5a9168a3b)
# and pushed to the agherasim/homebrew-tap repo.
class PenpotDesktop < Formula
  desc "Menu bar launcher for a self-hosted Penpot stack on Docker"
  homepage "https://github.com/agherasim/penpot-desktop"
  url "https://github.com/agherasim/penpot-desktop/archive/refs/tags/v2.17.1.2.tar.gz"
  sha256 "2489d5426875283eef7dfad1db14abff4be6d88758c70e263758d5c5a9168a3b"
  head "https://github.com/agherasim/penpot-desktop.git", branch: "main"

  depends_on :macos

  def install
    system "make", "assemble", "APP_DIR=#{prefix}/Penpot.app", "APP_VERSION=#{version}"
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
    assert_match "penpot-desktop #{version}", shell_output("#{bin}/penpot version")
  end
end
