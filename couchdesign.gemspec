require 'rubygems'
require 'rake'

Gem::Specification.new do |spec|
  spec.name = 'couchdesign'
  spec.version = "0.0.1"
  spec.summary = "CouchDB Design Document Uploader"
  spec.description = ""
  spec.author = "Kim Dalsgaard"
  spec.email = "kim@kimdalsgaard.com"
  
  spec.add_dependency 'typhoeus'
  spec.add_dependency 'json'
  spec.files = FileList['lib/**/*.rb', 'lib/**/*js']
  spec.require_paths = ['lib']

  spec.executables = ['couchdesign']
end
