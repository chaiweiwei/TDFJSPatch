# coding: utf-8
Pod::Spec.new do |s|

  s.name         = "TDFJSPatch"
  s.version      = "0.0.1"
  s.summary      = "JSPatch for fire"

  s.description  = <<-DESC
JSPatch 补丁
                   DESC

  s.homepage     = "https://github.com/chaiweiwei/TDFJSPatch"

  s.license      = "2dfire"

  s.author             = { "chaiweiwei" => "1119191759@qq.com" }

  s.platform     = :ios, "8.0"
 
  s.source       = { :git => "https://github.com/chaiweiwei/TDFJSPatch.git", :tag => "0.0.1" }

  s.source_files  = "TDFJSPatch", "TDFJSPatch/**/*.{h,m}"

  s.dependency "JSPatch"
  s.dependency "SSZipArchive"
  s.dependency "Nimbus"

end
