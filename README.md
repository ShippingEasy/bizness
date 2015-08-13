# Bizness

Get your bizness right and organize your business logic into operations.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'bizness'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install bizness

## Usage

## Why use this?

First of all, you need to buy into the idea that ActiveRecord is an egregious violator of the Single Responsibility Principle.
Breaking out its responsibilities into separate objects, such as Query, Policy, Form and Service objects, has been a trend for some time now. These objects allow you to better organize and isolate your business logic, leading to faster design and better testing. You spend less time wondering how a feature's classes should be organized and more time addressing the needs of your domain.

ShippingEasy adopted this strategy, but we opted to use the term Operation rather than the nebulous term "Service Object" (or Interactor for that matter).

As we wrote more and more operations, some insights emerged:

  1. We always ran an operation in a transaction
  2. An operation nearly always corresponded to an important system event ("Complete Registration")
  3. Logging these events into a dashboard like Kibana could provide us with valuable metrics and insight into how our system was performing at a business logic level

Bizness, therefore, allows you to create PORO operation objects and easily augment their business logic execution via a series of filters. Out of the box there are filters to wrap every operation in a transaction as well as automatically broadcasting every operation as a series of events.
 A filter is just a SimpleDelegator, so it's easy to create your own. Moving these responsbilities out of your operation classes keeps them lean and focused, and in the case of the event filters, automatically instruments every important business operation in your codebase (depending on how widely you adopt them).

### Writing your own operation

1. Ensure your class responds to the instance method `call`.

2. If you are using the `EventFilter` and want to customize the message that is published when your operation is run, write a `to_h` instance method that returns a hash.

3. You should raise all errors as runtime exceptions if your operation fails so the filters can rollback and react accordingly.

### Running an operation

The pipeline can be executed from `Bizness.run`. You can either pass in an object, or execute a block.

```ruby
Bizness.run(operation)
```

```ruby
Bizness.run do
  puts “foo”
end
```

By default, all filters that are globally configured on Bizness are run, but you may optionally pass in overrides as well:

```ruby
Bizness.run(filters: Bizness::Filters::EventFilter) do
  puts “foo”
end
```

### The Operation class

Though you don't need to use the `Bizness::Operation` class to define an operation, one is provided as a convenience. This class has several methods that make calling operations and running them through the pipeline more intuitive.

For example:

```ruby
op = CompleteRegistrationOperation.new(customer: customer)

op.call! # submits itself through the filter pipeline

op.error # Exceptions are caught and the message is set on error

op.successful? # True if error is nil

op.to_h
```

### Pubsub

#### Publishing

Automatically publishing operations as events via the `EventFilter` is one of the primary reasons we developed Bizness. The `EventFilter` will always publish two events. For example, if your operation class is named `CompleteRegistrationOperation`, these events will be published:

  * "operations:complete_registration:executed" - This event includes the start time, end time and duration of the operation
  * "operations:complete_registration:succeeded" or "operations:complete_registration:failed" depending on if an exception was raised or not

#### Subscribing

Once an operation is publishing events, we wanted to make it easy for other operations to subscribe to those events. To wire up a class to easily subscribe to these events, simply extend the `Bizness::Subscriber` module. That gives your class access to the `subscribe` method.

You can use the `subscribe` method in one of two ways: with or without a block. You can use the block as a builder for your operation, translating the values coming in from the message into the arguments necessary to initialize your operation. You should always return an initialized operation from this block.

For example, if your operation requires a model to initialize:

```ruby
class SendWelcomeEmailOperation
  extend Bizness::Subscriber

  subscribe(“operations.registration_complete”) do |event_data|
    customer = Customer.find(event_data[:customer_id])
    new(customer: customer)
  end

  def initialize(customer:)
    @customer = customer
  end

  # …. omitted for brevity
end
```

If no block is passed, the attributes from the event payload will be used directly to initialize and execute your operations:

```ruby
class SendWelcomeEmailOperation
  extend Bizness::Subscriber

  subscribe(“operations.registration_complete”)

  def initialize(customer_id:)
    @customer = Customer.find(customer_id)
  end

  # …. omitted for brevity
end
```

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/[USERNAME]/bizness.


## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).

