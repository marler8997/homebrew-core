class Anyzig < Formula
  desc "Universal zig executable that runs any version of zig"
  homepage "https://github.com/marler8997/anyzig"
  url "https://github.com/marler8997/anyzig/archive/refs/tags/v2025_08_13.tar.gz"
  sha256 "13511963d0dc570f5fe47ec83a23ff2982b53f1516076014aab6ec54638c0f3e"
  license "MIT"

  # TODO: add conflicts_with zig here after this formula is accepted

  # Don't update this unless this version cannot bootstrap the new version.
  resource "bootstrap" do
    checksums = {
      "aarch64-macos" => "562b57571873ab9a609cc1f4e09c603a878a9218bcd6ccbda085b6cd69e57b74",
      "x86_64-macos"  => "2d157b80eb0b28ec995232282d6049ddb30e02e206505e9cb8bb9fac01a04571",
      "aarch64-linux" => "d732ce1ef4bb2479bc1e64429c3cdc3779953ca34e3cc0848effc546301c04de",
      "x86_64-linux"  => "49cac16c4621dd52a80e9d94ff190f7320db3bb74959ef207f47fb694bf3b546",
    }

    on_macos do
      on_arm do
        url "https://github.com/marler8997/anyzig/releases/download/v2025_08_13/anyzig-aarch64-macos.tar.gz"
        sha256 checksums["aarch64-macos"]
      end
      on_intel do
        url "https://github.com/marler8997/anyzig/releases/download/v2025_08_13/anyzig-x86_64-macos.tar.gz"
        sha256 checksums["x86_64-macos"]
      end
    end

    on_linux do
      on_arm do
        url "https://github.com/marler8997/anyzig/releases/download/v2025_08_13/anyzig-aarch64-linux.tar.gz"
        sha256 checksums["aarch64-linux"]
      end
      on_intel do
        url "https://github.com/marler8997/anyzig/releases/download/v2025_08_13/anyzig-x86_64-linux.tar.gz"
        sha256 checksums["x86_64-linux"]
      end
    end
  end

  def install
    resource("bootstrap").stage do |r|
      bootstrap_zig = r.staging.tmpdir/"zig"
      args = ["-Dforce-version=v2025_08_13"]
      Dir.chdir(buildpath) do
        system bootstrap_zig, "build", *args, *std_zig_args
      end
    end
  end

  test do
    output = shell_output("#{bin}/zig any version")
    assert_match "v2025_08_13", output.strip
  end
end
