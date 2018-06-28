Pod::Spec.new do |s|
s.name         = 'WMCurrencyTextField'
s.version      = '1.0.0'
s.summary      = 'Price TextField input control, default number formatter is en_US@currency=USD'
s.homepage     = 'https://github.com/cloudhm/CurrencyTextField'
s.license      = 'LICENSE'
s.authors      = { 'cloudhm' => 'cloud.huang@whatsmode.com'}
s.platform     = :ios, '9.0'
s.source       = { :git => 'https://github.com/cloudhm/CurrencyTextField.git',:tag =>s.version}
s.source_files  = 'Classes/**/*.{swift}'
s.requires_arc  = true
s.swift_version = '4.0'
end
