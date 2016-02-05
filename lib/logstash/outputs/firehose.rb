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
#     access_key_id => "AWS ACCESS KEY"       (required)
#     secret_access_key => "AWS SECRET KEY"   (required)
#     region => "us-west-2"                   (required)
#     stream => "firehose-stream-name"        (required)
#     codec => "json_lines"                   (optional, default 'line')
#     aws_credentials_file => "/path/file"    (optional, default: none)
#     proxy_uri => "proxy URI"                (optional, default: none)
#     use_ssl => true|false                   (optional, default: ???)
#   }
# }
#

class LogStash::Outputs::Firehose < LogStash::Outputs::Base
  include LogStash::PluginMixins::AwsConfig

  TEMPFILE_EXTENSION = "txt"
  FIREHOSE_STREAM_VALID_CHARACTERS = /[\w\-]/

  config_name "firehose"

  # Output coder
  default :codec, "line"

  # Firehose stream info
  config :region, :validate => :string, :default => "us-west-2"
  config :stream, :validate => :string
  config :access_key_id, :validate => :string
  config :secret_access_key, :validate => :string

  #
  # Register plugin
  # TODO
  public
  def register
    require "aws-sdk"
    # required if using ruby version < 2.0
    # http://ruby.awsblog.com/post/Tx16QY1CI5GVBFT/Threading-with-the-AWS-SDK-for-Ruby
    AWS.eager_autoload!(AWS::Firehose)

    # Create Firehose API client
    @firehose = aws_firehose_client

    # Validate stream name
    if @stream.nil? || @stream.empty?
      @logger.error("S3: stream name is empty", :stream => @stream)
      raise LogStash::ConfigurationError, "Firehose: stream name is empty"
    end
    if @stream && @stream !~ FIREHOSE_STREAM_VALID_CHARACTERS
      @logger.error("Firehose: stream name contains invalid characters", :stream => @stream, :allowed => FIREHOSE_STREAM_VALID_CHARACTERS)
      raise LogStash::ConfigurationError, "Firehose: stream name contains invalid characters"
    end

    # Register coder: comma separated line -> JSON, call handler after encoded to deliver data to Firehose
    @codec.on_event do |event, encoded_event|
      handle_event(encoded_event)
    end
  end

  #
  # On event received handler: just wrap as JSON and pass it to handle_event method
  public
  def receive(event)
    @codec.encode(event)
  end # def event


  #
  # Helper methods
  #

  # Build AWS Firehose client
  private
  def aws_firehose_client
    @logger.info "Registering Firehose output", :stream => @stream, :region => @region
    @firehose = AWS::Firehose::Client.new(aws_full_options)
  end

  # Build and return AWS client options map
  private
  def aws_full_options
    aws_options_hash
  end

  # Evaluate AWS endpoint for Firehose based on specified @region option
  def aws_service_endpoint(region)
    return {
        :firehose_endpoint => "firehose.#{region}.amazonaws.com"
    }
  end

  # Handle encoded event, specifically deliver received event into Firehose stream
  private
  def handle_event(encoded_event)
    # TODO
    @logger.warn "TODO implement Firehose delivery"
    @logger.warn "encoded_event: #{encoded_event}"

    # if write_events_to_multiple_files?
    #   if rotate_events_log?
    #     @logger.debug("S3: tempfile is too large, let's bucket it and create new file", :tempfile => File.basename(@tempfile))
    #
    #     move_file_to_bucket_async(@tempfile.path)
    #     next_page
    #     create_temporary_file
    #   else
    #     @logger.debug("S3: tempfile file size report.", :tempfile_size => @tempfile.size, :size_file => @size_file)
    #   end
    # end
    #
    # write_to_tempfile(encoded_event)
  end

end # class LogStash::Outputs::Firehose
