class ReviewGoose < Formula
  desc "Menubar for GitHub pull request tracking and notifications"
  homepage "https://codegroove.dev/products/goose/"

  url "https://github.com/codeGROOVE-dev/goose.git",
      tag:      "v0.9.3",
      revision: "7ed1d3a9f3904414b3c2c8999e88fde99f293ba6"
  license "GPL-3.0"
  head "https://github.com/codeGROOVE-dev/goose.git", branch: "main"

  # On macOS, use the cask instead (brew install --cask review-goose)
  # This formula is primarily for Linux support
  depends_on :linux

  depends_on "go" => :build
  depends_on "gh"

  def install
    system "make", "build"
    bin.install "out/review-goose"
  end

  test do
    output = shell_output("#{bin}/review-goose --version")
    assert_match version.to_s, output
  end
end
