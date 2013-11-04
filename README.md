# AWS S3 support for Mina

You can use mina now to deploy static websites to AWS S3.

## Installation

Add this line to your application's Gemfile:

    gem 'mina-s3'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install mina-s3

## Usage

Use mina to generate the config file:

    $ bundle exec mina init

Load the S3 task:

```ruby
require 'mina/s3'
```

Add some settings to the `config/deploy.rb` file.

```ruby
set :s3_bucket_name, 'mina'
set :aws_access_key_id, 'YOUR_KEY'
set :aws_secret_access_key, 'YOUR_SECRET'
set :s3_files_pattern, ['assets/**/**', '*.html']
set :s3_region, 'eu-west-1'
```

Update `deploy` task to invoke `aws:s3:deploy` task:

```ruby
task :deploy do
  invoke :'aws:s3:deploy'
end
```

Deploy it!

    $ bundle exec mina deploy

Use `--verbose` flag if you want to see the AWS logger calls.

To clear the bucket, use the `aws:s3:empty` task:

    $ bundle exec mina aws:s3:empty

Thats it.

## Todo

Write some tests.

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request

## Thanks and credits

This was inspired from Josh Delsman work on [s3-static-site](https://github.com/voxxit/s3-static-site) gem.

Huge thanks to [mina](https://github.com/nadarei/mina) developers for the awesome tool.
