cask "review-goose" do
  version "0.9.4"
  sha256 :no_check  # Built from source, no pre-compiled binary

  url "https://github.com/codeGROOVE-dev/goose.git",
      tag:      "v#{version}",
      revision: "07c09f508c69b2ed0ea8b85ce2bf7a32cadec0ec"
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
