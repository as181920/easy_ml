# frozen_string_literal: true

require "test_helper"

describe EasyMl do
  it "has a version number" do
    refute_nil EasyMl::VERSION
  end

  it "has logger" do
    assert_instance_of Logger, EasyMl.logger
  end
end
