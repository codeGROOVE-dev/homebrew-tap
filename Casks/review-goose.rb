cask "review-goose" do
  version "0.9.3"
  sha256 :no_check  # Built from source, no pre-compiled binary

  url "https://github.com/codeGROOVE-dev/goose.git",
      tag:      "v#{version}",
      revision: "7ed1d3a9f3904414b3c2c8999e88fde99f293ba6"
  name "Review Goose"
  desc "Menubar for GitHub pull request tracking and notifications"
  homepage "https://codegroove.dev/products/goose/"

  depends_on formula: "go"
  depends_on formula: "gh"

  preflight do
    system_command "make",
                   args: ["app-bundle"],
                   chdir: staged_path,
                   env: {
                     "PATH" => "#{HOMEBREW_PREFIX}/bin:#{ENV["PATH"]}",
                   }
  end

  app "out/Review Goose.app"

  zap trash: [
    "~/Library/Preferences/dev.codegroove.goose.plist",
    "~/Library/Application Support/goose",
  ]
end
