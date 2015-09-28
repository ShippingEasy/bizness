# Adds convenience methods for defining a policy object and recording its violations. To take use this module, do the
# following:
#
# 1. Write one or more private predicate methods that define your policies requirements
# 2. Define violation messages in your corresponding I18n locale YAML files
#
# -- string_format_policy.rb
#
# class StringFormatPolicy
#   include Bizness::Policy
#
#   def initialize(string)
#     @string = string
#   end
#
#   private
#
#   attr_reader :string
#
#   def all_caps?
#    string.upcase == string
#   end
# end
#
# -- en.yml
#
# en:
#   policies:
#     string_format_policy:
#       violations:
#         all_caps: "Must be an uppercase string"
#
# Example usage:
#
# policy = StringFormatPolicy.new("abcd")
# policy.successful?
# => false
#
# policy.violations
# => ["Must be an uppercase string"]
#
module Bizness::Policy
  def self.included(base)
    base.extend(ClassMethods)
  end

  def violations
    @violations || []
  end

  def successful?
    self.violations = []
    self.class.__requirements__.each do |m|
      self.violations << self.class.violation_message(m) unless send(m)
    end
    violations.empty?
  end

  module ClassMethods
    def violation_message(method)
      policy = self.name.gsub(/(.)([A-Z])/,'\1_\2').downcase
      message_key = "policies.#{policy}.violations.#{method.to_s.delete("?")}"
      I18n.t(message_key)
    end

    def __requirements__
      @__requirements__ ||= begin
        private_instance_methods(false).select { |m| m.to_s[/\?$/] }
      end
    end
  end

  private

  attr_writer :violations
end