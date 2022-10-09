# gruf-rollbar - Rollbar reporting for gruf

Adds Rollbar error reporting support for [gruf](https://github.com/bigcommerce/gruf) 2.7.0+
and [rollbar](https://github.com/rollbar/rollbar-gem)

This gem will automatically report grpc failures and Gruf errors into Rollbar as they happen in servers and clients.

## Installation

Simply install the gem:

```ruby
gem 'gruf-rollbar'
```

Then after, in your gruf initializer:

```ruby
Gruf.configure do |c|
  c.interceptors.use(Gruf::Rollbar::ServerInterceptor)
end
```

It comes with a few more options as well:

| Option             | Description                                                                                    | Default                                                                                                                         | ENV Key                           |
| ------------------ | ---------------------------------------------------------------------------------------------- | ------------------------------------------------------------------------------------------------------------------------------- | --------------------------------- |
| ignore_methods     | A list of method names to ignore from logging. E.g. `['namespace.health.check']`               | `[]`                                                                                                                            | GRUF_ROLLBAR_IGNORE_METHODS       |
| grpc_error_classes | A list of gRPC error classes that will be used for detecting errors (as opposed to validation) | `GRPC::Unknown,GRPC::Internal,GRPC::DataLoss,GRPC::FailedPrecondition,GRPC::Unavailable,GRPC::DeadlineExceeded,GRPC::Cancelled` | GRUF_ROLLBAR_GRPC_ERROR_CLASSES   |
| default_error_code | The default gRPC error code to use (int value)                                                 | `GRPC::Core::StatusCodes::INTERNAL`                                                                                             | `GRUF_ROLLBAR_DEFAULT_ERROR_CODE` |

### Client Interceptors

To automatically report errors in your Gruf clients, pass the client interceptor to your `Gruf::Client` initializer:

```ruby
Gruf::Client.new(
  service: MyService,
  client_options: {
    interceptors: [Gruf::Rollbar::ClientInterceptor.new]
  }
)
```

This gem is inspired by https://github.com/bigcommerce/gruf-sentry.
