require 'rubygems'
require 'hoe'
require './lib/grit.rb'

Hoe.new('grit', Grit::VERSION) do |p|
  p.rubyforge_name = 'grit'
  # p.author = 'FIX'
  # p.email = 'FIX'
  # p.summary = 'FIX'
  # p.description = p.paragraphs_of('README.txt', 2..5).join("\n\n")
  # p.url = p.paragraphs_of('README.txt', 0).first.split(/\n/)[1..-1]
  p.changes = p.paragraphs_of('History.txt', 0..1).join("\n\n")
end

desc "Open an irb session preloaded with this library"
task :console do
  sh "irb -rubygems -r ./lib/grit.rb"
end

task :coverage do
  system("rm -fr coverage")
  system("rcov test/test_*.rb")
  system("open coverage/index.html")
end