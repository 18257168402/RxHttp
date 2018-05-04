
Pod::Spec.new do |s|
    s.name         = "RxHttp"
    s.version      = "1.0.0"
    s.summary      = "An iOS http utils."
    s.description  = <<-DESC
        it is a rxhttp utils
    DESC
    s.homepage     = 'xxxx'
    s.license      = 'MIT'
    s.author       = { 'lishusheng' => 'shusheng.li@outlook.com' }
    s.platform = :ios, '7.0'
    s.source       = { :git => "git@github.com:18257168402/RxHttp.git", :tag => s.version.to_s }
    s.ios.deployment_target = '7.0'
    s.requires_arc = true
    s.frameworks   = "Foundation","CFNetwork"
    s.source_files = 'source/**/*.{h,m}'
    s.exclude_files = ''
    s.requires_arc = true
    s.dependency 'RxOC','~> 1.0.1'
    s.dependency 'AFNetworking','~> 3.0'
    s.dependency 'MJExtension','~> 3.0.13'
end
