# encoding: utf-8
require "logstash/devutils/rspec/spec_helper"
require "logstash/outputs/firehose"
require "logstash/codecs/json_lines"
require "logstash/event"

describe LogStash::Outputs::Firehose do
  let(:sample_event) { LogStash::Event.new }
  let(:output) { LogStash::Outputs::Firehose.new }

  before do
    output.stream = "aws-test-stream"
    output.access_key_id = "TODO Key ID"
    output.secret_access_key = "TODO Secret key"
    output.register
  end

  describe "receive message" do
    subject { output.receive(sample_event) }

    it "returns a string" do
      expect(subject).to eq("Event received")
    end
  end
end
