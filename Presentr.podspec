Pod::Spec.new do |s|
  s.name         = "Presentr"
  s.version      = "1.3.2"
  s.summary      = "A simple Swift wrapper for custom view controller presentations."
  s.description  = <<-DESC
                    Simplifies creating custom view controller presentations. Specially the typical ones we use which are a popup, an alert, or a any non-full-screen modal. Abstracts having to deal with custom presentation controllers and transitioning delegates
                   DESC
  s.homepage     = "http://github.com/icalialabs/Presentr"
  s.license      = { :type => "MIT", :file => "LICENSE" }
  s.author       = { "Daniel Lozano" => "dan@danielozano.com" }
  s.social_media_url   = "http://twitter.com/danlozanov"
  s.platform     = :ios, "9.0"
  s.swift_version = "4.0"
  s.source       = { :git => "https://github.com/icalialabs/Presentr.git", :tag => s.version.to_s }
  s.source_files = "Presentr/**/*.{swift}"
  s.resources    = "Presentr/**/*.{xib,ttf}"
end
