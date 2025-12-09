class ReviewGoose < Formula
  desc "Menubar for GitHub pull request tracking and notifications"
  homepage "https://codegroove.dev/products/goose/"

  url "https://github.com/codeGROOVE-dev/goose.git",
      tag:      "v0.9.4",
      revision: "07c09f508c69b2ed0ea8b85ce2bf7a32cadec0ec"
  license "GPL-3.0"
  head "https://github.com/codeGROOVE-dev/goose.git", branch: "main"

  depends_on "go" => :build
  depends_on "gh"

  # On macOS, use the cask instead (brew install --cask review-goose)
  # This formula is primarily for Linux support
  depends_on :linux

  def install
    system "make", "build"
    bin.install "out/review-goose"
  end

  test do
    output = shell_output("#{bin}/review-goose --version")
    assert_match version.to_s, output
  end
end
