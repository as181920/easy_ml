require "active_support/all"
require_relative "easy_ml/version"
require_relative "easy_ml/expectation_maximization_clustering"

module EasyMl
  Error = Class.new StandardError

  class << self
    attr_writer :logger

    def logger
      @logger ||= defined?(Rails) ? Rails.logger : Logger.new($stdout)
    end
  end
end
