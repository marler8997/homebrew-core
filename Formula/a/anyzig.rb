class Anyzig < Formula
  desc "A universal zig executable that runs any version of zig"
  homepage "https://github.com/marler8997/anyzig"
  version "v2025_08_03"
  url "https://github.com/marler8997/anyzig/archive/refs/tags/#{version}.tar.gz"
  sha256 "2600445976486c41944bbc73fc0f91d2bf91a5f5c4e56e394767722da934249b"
  license "MIT"

  conflicts_with "zig", because: "both install the `zig` executable"

  def install
    bootstrap_zig = fetch_bootstrap_zig
    args = []
    args << "-Dcpu=#{cpu}" if build.bottle?
    system bootstrap_zig, "build", *args, *std_zig_args
  end

  private

  def arch_name
    case Hardware::CPU.arch
    when :arm64
      "aarch64"
    else
      Hardware::CPU.arch.to_s
    end
  end

  def os_name
    if OS.mac?
      "macos"
    elsif OS.linux?
      "linux"
    else
      raise "Unsupported operating system: #{OS.kernel_name}"
    end
  end

  def fetch_bootstrap_zig
    bootstrap_url = "https://github.com/marler8997/anyzig/releases/download/#{version}/anyzig-#{arch_name}-#{os_name}.tar.gz"
    archive = buildpath/"bootstrap.tar.gz"
    system "curl", "--fail", "--location", "--output", archive, bootstrap_url
    system "tar", "--extract", "--file", archive, "--directory", buildpath
    buildpath/"zig"
  end

  test do
    system bin/"zig", "any"
    output = shell_output("#{bin}/zig any #{version}")
    assert_match version, output
  end
end
