Pod::Spec.new do |s|
    s.name          = 'VNTableView'
    s.version       = '0.0.1'
    s.homepage      = 'https://github.com/hechen/VNTableView'
    s.authors       = { 'Chen' => 'hechen.dream@gmail.com' }
    s.summary       = 'NSTableView support multiple sections.'
    s.source        = { :git => 'https://github.com/hechen/VNTableView.git', :tag => '0.0.1' }
    s.swift_version = '4.0'
    s.platform      = :osx, '10.10'
    s.source_files  = 'Source/**/**'
    s.license      = {
      :type => 'MIT',
      :file => 'LICENSE',
      :text => 'Permission is hereby granted ...'
    }
  end
