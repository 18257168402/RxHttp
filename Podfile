platform:ios,'8.0'
workspace 'RxHttp.xcworkspace'
#禁止所有第三方库的警告
inhibit_all_warnings!
project 'RxHttp.xcodeproj'

def rxhttp_pod
    pod 'RxOC','~> 1.0.1'
    pod 'AFNetworking','~> 3.0'
    pod 'MJExtension','~> 3.0.13'
end

abstract_target 'abs_common' do
    target 'RxHttp' do
        rxhttp_pod
    end
end

