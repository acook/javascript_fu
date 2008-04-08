require 'rake/rdoctask'

desc 'Generate documentation for the plugin.'
Rake::RDocTask.new(:rdoc) do |rdoc|
  rdoc.rdoc_dir = 'rdoc' 
  rdoc.title    = 'JavaScript Fu' 
  rdoc.options << '--line-numbers' << '--inline-source' <<
    '--main' << 'README'
  rdoc.rdoc_files.include ['lib', 'README', 'TODO', 'MIT-LICENSE']
end