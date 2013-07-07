require "test_helper"

describe Hakiri::HttpClient do
  subject { Hakiri::HttpClient.new }

  it { subject.must_respond_to :auth_token }
  it { subject.must_respond_to :auth_token= }
  it { subject.must_respond_to :api_url }
  it { subject.must_respond_to :api_url= }

  describe "#get_issues" do
  end

  describe "#check_versions_diff" do
  end

  describe "#sync_project_versions" do
  end

end
