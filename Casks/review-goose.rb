cask "review-goose" do
  version "0.9.8"
  sha256 :no_check # Built from source, no pre-compiled binary

  url "https://github.com/codeGROOVE-dev/goose.git",
      tag:      "v#{version}",
      revision: "15ad233489b698e5a0f05db6f120fd3032813a13",
      verified: "github.com/codeGROOVE-dev/goose"
  name "reviewGOOSE"
  desc "Menubar for GitHub pull request tracking and notifications"
  homepage "https://codegroove.dev/products/goose/"

  depends_on formula: "go"
  depends_on formula: "gh"

  app "out/reviewGOOSE.app"

  preflight do
    system_command "make",
                   args:  ["app-bundle"],
                   chdir: staged_path,
                   env:   {
                     "PATH" => "#{HOMEBREW_PREFIX}/bin:#{ENV.fetch("PATH", nil)}",
                   }
  end

  zap trash: [
    "~/Library/Application Support/goose",
    "~/Library/Preferences/dev.codegroove.goose.plist",
  ]
end
