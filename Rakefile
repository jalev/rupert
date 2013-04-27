# encoding: utf-8

require 'rubygems'
require 'bundler'
begin
  Bundler.setup(:default, :development)
rescue Bundler::BundlerError => e
  $stderr.puts e.message
  $stderr.puts "Run `bundle install` to install missing gems"
  exit e.status_code
end
require 'rake'

require 'rake/testtask'
Rake::TestTask.new(:test) do |test|
  test.libs << 'lib' << 'test'
  test.pattern = 'test/**/test_*.rb'
  test.verbose = true
end

Rake::TestTask.new(:test_disk) do | test |
  test.libs << 'lib' << 'test'
  test.pattern = 'test/**/test_disk.rb'
  test.verbose = true
end

Rake::TestTask.new(:test_pool) do | test |
  test.libs << 'lib' << 'test'
  test.pattern = 'test/**/test_pool.rb'
  test.verbose = true
end

Rake::TestTask.new(:test_guest) do | test |
  test.libs << 'lib' << 'test'
  test.pattern = 'test/**/test_guest.rb'
  test.verbose = true
end

Rake::TestTask.new(:test_host) do | test |
  test.libs << 'lib' << 'test'
  test.pattern = 'test/**/test_host.rb'
  test.verbose = true
end

Rake::TestTask.new(:test_connection) do | test |
  test.libs << 'lib' << 'test'
  test.pattern = 'test/**/test_connection.rb'
  test.verbose = true
end


task :default => :test

require 'rdoc/task'
Rake::RDocTask.new do |rdoc|
  version = File.exist?('VERSION') ? File.read('VERSION') : ""

  rdoc.rdoc_dir = 'rdoc'
  rdoc.title = "rupert #{version}"
  rdoc.rdoc_files.include('README*')
  rdoc.rdoc_files.include('lib/**/*.rb')
end
