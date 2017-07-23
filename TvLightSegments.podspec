Pod::Spec.new do |s|
  s.name         = "TvLightSegments"
  s.version      = "0.2.2"
  s.summary      = "Clean, simple and beautiful segment bar for your AppleTv app"
  s.homepage     = "https://github.com/brunomacabeusbr/TvLightSegments"
  s.license      = { :type => "MIT", :file => "LICENSE" }
  s.author       = { "Bruno Macabeus" => "bruno.macabeus@gmail.com" }

  s.tvos.deployment_target = "10.0"

  s.source       = { :git => "https://github.com/brunomacabeusbr/TvLightSegments.git", :tag => s.version }
  s.source_files = "TvLightSegments/TvLightSegments/*.swift", "TvLightSegments/TvLightSegments/*.xib"

  s.dependency 'Cartography', '~> 1.1'
end
