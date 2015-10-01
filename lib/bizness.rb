require "bizness/version"
require "active_record"
require "forwardable"
require "hey"
require "i18n"

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

  def self.run(operation = nil, filters: self.filters, &block)
    operation = block if block_given?
    filters.reduce(operation) { |filtered_op, filter| filter.new(filtered_op) }.call
  end
end

require "bizness/configuration"
require "bizness/operation"
require "bizness/policy"
require "bizness/subscriber"
require "bizness/filters/base_filter"
require "bizness/filters/active_record_transaction_filter"
require "bizness/filters/event_filter"
