require "bizness/version"
require "active_record"
require "forwardable"
require "hey"

module Bizness
  def self.configure
    yield(configuration)
  end

  def self.configuration
    @configuration ||= Bizness::Configuration.new
  end

  def self.filters
    configuration.filters
  end
end

require "bizness/configuration"
require "bizness/context"
require "bizness/operation"
require "bizness/failure"
require "bizness/subscriber"
require "bizness/filters/base_filter"
require "bizness/filters/active_record_transaction_filter"
require "bizness/filters/event_filter"
