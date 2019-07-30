Pod::Spec.new do |s|
s.name             = "PrehookExample"
s.version          = '2.0.0'
s.summary          = "PrehookExample"
s.description      = <<-DESC
PrehookExample container.
DESC
s.homepage         = "https://github.com/applicaster/ZappRootPlugin2LevelRNMenu-iOS"
s.license          = 'CMPS'
s.author           = "Applicaster LTD."
s.source           = { :git => "git@github.com:applicaster/PreHookExample-iOS.git", :tag => s.version.to_s }
s.platform         = :ios, '10.0'
s.requires_arc = true
s.static_framework = false

s.source_files  = 'PrehookExample/**/*.{h,m,swift}'
s.resources = [ 'PrehookExample/**/*.xib']

s.xcconfig =  { 'CLANG_ALLOW_NON_MODULAR_INCLUDES_IN_FRAMEWORK_MODULES' => 'YES',
    'ENABLE_BITCODE' => 'YES',
    'SWIFT_VERSION' => '5.0',
    'OTHER_CFLAGS'  => '-fembed-bitcode'
}

s.dependency 'ZappGeneralPluginsSDK'
s.dependency 'ZappPlugins'
end
