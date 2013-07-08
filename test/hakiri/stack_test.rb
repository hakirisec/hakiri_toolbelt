require "test_helper"

describe Hakiri::Stack do
  subject { Hakiri::Stack.new }

  it { subject.must_respond_to :technologies }
  it { subject.must_respond_to :technologies= }
  it { subject.must_respond_to :default_command }
  it { subject.must_respond_to :default_command= }

  describe "#build_from_json_file" do
  end

  describe "#build_from_input" do
  end

  describe "#fetch_versions" do
  end

end
