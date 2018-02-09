Gem::Specification.new do |s|
  s.name = 'logstash-output-firehose'
  s.version         = "0.0.2"
  s.licenses = ["Apache License (2.0)"]
  s.summary = "Output plugin to push data into AWS Kinesis Firehose stream."
  s.description = "This gem is a logstash plugin required to be installed on top of the Logstash core pipeline using $LS_HOME/bin/plugin install gemname. This gem is not a stand-alone program"
  s.authors = ["Valera Chevtaev"]
  s.email = "myltik@gmail.com"
  s.homepage = "https://github.com/chupakabr/logstash-output-firehose"
  s.require_paths = ["lib"]

  # Files
  s.files = Dir['lib/**/*','spec/**/*','vendor/**/*','*.gemspec','*.md','Gemfile','LICENSE']

  # Tests
  s.test_files = s.files.grep(%r{^(test|spec|features)/})

  # Special flag to let us know this is actually a logstash plugin
  s.metadata = { "logstash_plugin" => "true", "logstash_group" => "output" }

  # Gem dependencies
  s.add_runtime_dependency "stud", "~> 0.0.22"
  s.add_runtime_dependency "logstash-core", ">= 2.0.0", "< 3.0.0"
  s.add_runtime_dependency "logstash-mixin-aws", ">= 2.0.2"
  s.add_runtime_dependency "logstash-codec-line"
  s.add_runtime_dependency "logstash-codec-json_lines"
  s.add_development_dependency "logstash-devutils"
end
