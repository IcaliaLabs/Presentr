Pod::Spec.new do |spec|
  spec.name = "Presentr"
  spec.version = "0.1.0"
  spec.summary = "Micro framework for custom view controller presentations."
  spec.homepage = "https://github.com/icalialabs/Presentr"
  spec.license = { type: 'MIT', file: 'LICENSE' }
  spec.authors = { "Daniel Lozano" => 'dan@danielozano.com' }
  spec.social_media_url = "http://twitter.com/danlozanov"

  spec.platform = :ios, "8.0"
  spec.requires_arc = true
  spec.source = { git: "https://github.com/icalialabs/Presentr.git", tag: "v#{spec.version}", submodules: true }
  spec.source_files = "Presentr/**/*.{h,swift}"
end
