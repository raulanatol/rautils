class Rautils < Formula
  desc "macOS utility CLI tool collection"
  homepage "https://github.com/raulanatol/rautils"
  url "https://github.com/raulanatol/rautils/archive/refs/tags/v0.1.0.tar.gz"
  sha256 "PLACEHOLDER_SHA256"
  version "0.1.0"
  license "MIT"

  def install
    # Install the main executable
    bin.install "bin/rautils"

    # Install the libexec directory with subcommands
    prefix.install "libexec"

    # Install the VERSION file (needed by rautils at runtime)
    prefix.install "VERSION"
  end

  test do
    # Verify the help command works and shows the correct version
    assert_match version.to_s, shell_output("#{bin}/rautils help")
  end
end
