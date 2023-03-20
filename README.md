# Increase

A Ruby API client for [Increase](https://increase.com/), a platform for Bare-Metal Banking APIs!

## Installation

Install the gem and add to the application's Gemfile by executing:

```sh
$ bundle add increase
```

If bundler is not being used to manage dependencies, install the gem by executing:

```sh
$ gem install increase
```

## Usage

```ruby
require 'increase'

# Grab your API key from https://dashboard.increase.com/developers/api_keys
Increase.api_key = 'my_api_key'
Increase.base_url = 'https://api.increase.com'

# List transactions
Increase::Transactions.list

# Retrieve a transaction
Increase::Transactions.retrieve('transaction_1234abcd')

# Create an ACH Transfer
Increase::AchTransfers.create(
  account_id: 'account_1234abcd',
  amount: 100_00, # 10,000 cents ($100 dollars)
  routing_number: '123456789',
  account_number: '9876543210',
  statement_descriptor: 'broke the bank for some retail therapy'
)
```

### Per-request Configuration

By default, the client will use the global API key and configurations. However, you can define a custom client to be
used for per-request configuration.

For example, you may want to have access to production and sandbox data at the same.

```ruby
sandbox = Increase::Client.new(
  api_key: 'time_is_money',
  base_url: 'https://sandbox.increase.com'
)

# This request will use the `sandbox` client and its configurations
Increase::Transactions.with_config(sandbox).list
# => [{some sandbox transactions here}, {transaction}, {transaction}]

# This request will still use the global configurations (where the API key is a production key)
Increase::Transactions.list
# => [{some production transactions here}, {transaction}, {transaction}]
```

See the [Configuration](#configuration) section for more information on the available configurations.

### Pagination

When listing resources (e.g. transactions), **Increase** limits the number of results per page to 100. Luckily, the
client will automatically paginate through all the results for you!

```ruby
Increase::Transactions.list(limit: :all) do |transactions|
  # This block will be called once for each page of results
  puts "I got #{transactions.count} transactions!"
end

# Or, if you'd like a gargantuan array of all the transactions
Increase::Transactions.list(limit: :all)
Increase::Transactions.list(limit: 2_000)
```

Watch out for the rate limit!

### Error Handling

Whenever you make an oopsies, the client will raise an error! Errors originating from the API will be a subclass
of `Increase::ApiError`.

```ruby

begin
  Increase::Transactions.retrieve('transaction_1234abcd')
rescue Increase::ApiError => e
  puts e.message # "[404: object_not_found_error] Could not find the specified object. No resource of type ..."
  puts e.title # "Could not find the specified object."
  puts e.detail # "No resource of type transaction was found with ID transaction_1234abcd."
  puts e.status # 404

  puts e.response # This contains the full response from the API, including headers! (its a Faraday::Response object)

  puts e.class # Increase::ObjectNotFoundError (it's a subclass of Increase::ApiError!)
end
```

To disable this behavior, set `Increase.raise_api_errors = false`. Errors will then be returned as a normal response.

```ruby
Increase.raise_api_errors = false # Default: true

Increase::Transactions.retrieve('transaction_1234abcd')
# => {"status"=>404, "type"=>"object_not_found_error", ... }
```

### Configuration

| Name                 | Description                                                                                                                                                                                                                                                     | Default                      |
|----------------------|-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|------------------------------|
| **api_key**          | Your Increase API Key. Grab it from https://dashboard.increase.com/developers/api_keys                                                                                                                                                                          | `nil`                        |
| **base_url**         | The base URL for Increase's API. You can use `:production` (https://api.increase.com), `:sandbox` (https://sandbox.increase.com), or set an actual URL                                                                                                          | `"https://api.increase.com"` |
| **raise_api_errors** | Whether to raise an error when the API returns a non-2XX status. Learn more about Increase's errors [here](https://increase.com/documentation/api#errors). See error classes [here](https://github.com/garyhtou/increase-ruby/blob/main/lib/increase/errors.rb) | `true`                       |

There are multiple syntaxes for configuring the client. Choose your favorite!

```ruby
# Set the configurations directly
Increase.api_key = 'terabytes_of_cash' # Default: nil (you'll need one tho!)
Increase.base_url = :production # Default: :production
Increase.raise_api_errors = true # Default: true

# Or, you can pass in a hash
Increase.configure(api_key: 'just_my_two_cents')

# Or, you can use a block!
Increase.configure do |config|
  config.api_key = 'digital_dough'
  config.base_url = :sandbox # Default: :production
  config.raise_api_errors = false # Default: true
end
```

If you are using Rails, the recommended way is to set your configurations as a block in an initializer.

```ruby
# config/initializers/increase.rb

Increase.configure do |config|
  config.api_key = 'money_cant_buy_happiness'
  config.base_url = :production
end
```

### Webhooks

**Increase**'s webhooks include a `Increase-Webhook-Signature` header for securing your webhook endpoint. Although not
required, it's strongly recommended that you verify the signature to ensure the request is coming from **Increase**.

Here is an example for Rails.

```ruby

class IncreaseController < ApplicationController
  protect_from_forgery except: :webhook # Ignore CSRF checks

  def webhook
    payload = request.body.read
    sig_header = request.headers['Increase-Webhook-Signature']
    secret = Rails.application.credentials.dig(:increase, :webhook_secret)

    Increase::Webhook::Signature.verify?(
      payload: payload,
      signature_header: sig_header,
      secret: secret
    )

    # It's a valid webhook! Do something with it...

    render json: {success: true}
  rescue Increase::WebhookSignatureVerificationError => e
    render json: {error: 'Webhook signature verification failed'}, status: :bad_request
  end
end
```

### Idempotency

**Increase** supports [idempotent requests](https://increase.com/documentation/api#idempotency) to allow for safely
retrying requests without accidentally performing the same operation twice.

```ruby
card = Increase::Cards.create(
  {
    # Card parameters
    account_id: 'account_1234abcd',
    description: 'My Chipotle card'
  },
  {
    # Request headers
    'Idempotency-Key': 'use a V4 UUID here'
  }
)
# => {"id"=>"card_1234abcd", "type"=>"card", ... }

idempotent_replayed = card.response.headers['Idempotent-Replayed']
# => "false"
```

Reusing the key in subsequent requests will return the same response code and body as the original request along with an
additional HTTP header (Idempotent-Replayed: true). This applies to both success and error responses. In situations
where your request results in a validation error, you'll need to update your request and retry with a new idempotency
key.

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can
also run `bin/console` for an interactive prompt that will allow you to experiment.

You can also run `INCREASE_API_KEY=my_key_here INCREASE_BASE_URL=https://sandbox.increase.com bin/console` to run the
console with your Increase sandbox API key pre-filled.

To install this gem onto your local machine, run `bundle exec rake install`.

To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will
create a git tag for the version, push git commits and the created tag, and push the `.gem` file
to [rubygems.org](https://rubygems.org).

Alternatively, use [`gem-release`](https://github.com/svenfuchs/gem-release) and
run `gem bump --version patch|minor|major`. Then release the gem by running `bundle exec rake release`.

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/garyhtou/increase.

## License

The gem is available as open source under the terms of
the [MIT License](https://github.com/garyhtou/increase-ruby/blob/main/LICENSE.txt).

---

Please note that this is not an official library written by **Increase**. Its written and maintained
by [Gary Tou](https://garytou.com/) who just uses Increase at work!
