Pod::Spec.new do |spec|
    spec.name          = 'VNTableView'
    spec.version       = '0.0.1'
    spec.license       = { :type => 'BSD' }
    spec.homepage      = 'https://github.com/hechen/VNTableView'
    spec.authors       = { 'Chen' => 'hechen.dream@gmail.com' }
    spec.summary       = 'NSTableView support multiple sections.'
    spec.source        = { :git => 'https://github.com/hechen/VNTableView.git', :tag => spec.version.to_s }
    spec.swift_version = '4.0'
    spec.osx.deployment_target  = '10.10'
    spec.osx.source_files   = 'Source/**/*.swift'    
  end
