# frozen_string_literal: true

$LOAD_PATH.unshift File.expand_path("../lib", __dir__)
require "easy_ml"

require "minitest/autorun"
require "minitest/mock"
require "mocha/minitest"

require "minitest/reporters"
Minitest::Reporters.use!

EasyMl.logger = Logger.new(nil)
