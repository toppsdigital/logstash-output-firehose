# encoding: utf-8
require "logstash/outputs/base"
require "logstash/namespace"
require "logstash/plugin_mixins/aws_config"
require "stud/temporary"
require "stud/task"
require "socket" # for Socket.gethostname
require "thread"
require "tmpdir"
require "fileutils"

# INFORMATION:
#
# This plugin sends logstash events to Amazon Kinesis Firehose.
# To use it you need to have the proper write permissions and a valid Firehose stream.
# Make sure you have permissions to put records into Firehose stream.
# Also be sure to run logstash as super user to establish a connection.
#
# #### Usage:
# This is an example of logstash config:
# [source,ruby]
# output {
#   firehose {
#     codec => "json_lines"                   (required)
#     access_key_id => "AWS ACCESS KEY"       (required)
#     secret_access_key => "AWS SECRET KEY"   (required)
#     endpoint_region => "us-west-2"          (required)
#     cluster_name => "firehose-cluster-name" (required)
#   }
# }
#

class LogStash::Outputs::Firehose < LogStash::Outputs::Base
  include LogStash::PluginMixins::AwsConfig

  config_name "firehose"

  public
  def register
    # TODO

  end # def register

  public
  def receive(event)
    # TODO

    return "TODO Event received"
  end # def event
end # class LogStash::Outputs::Firehose
