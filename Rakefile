require 'rubygems'
require 'cucumber/rake/task'
require 'spec/rake/spectask'

task :default => [:spec]

Spec::Rake::SpecTask.new(:spec) do |t|
  t.spec_opts = ['--options', 'spec/spec.opts']
  t.spec_files = FileList['spec/**/*_spec.rb']
end

