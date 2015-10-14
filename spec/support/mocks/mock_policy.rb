module Mocks
  class MockPolicy
    include Bizness::Policy
    policy_enforces :alphanumeric?, :all_caps?

    attr_reader :foo

    def initialize(foo:)
      @foo = foo
    end

    private

    def alphanumeric?
      foo.match(/^[[:alpha:]]+$/)
    end

    def all_caps?
      foo == foo.upcase
    end
  end
end
