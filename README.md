# Proxysqlweightlifter

ProxySQL mysql_servers table automatic weight lifter for reader hosts

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'proxysqlweightlifter'
```

And then execute:

```
$ bundle
```

Or install it yourself as:

```
$ gem install proxysqlweightlifter
```

## Usage

```
$ proxysqlweightlifter 127.0.0.1 3306 username password 99 hostgroup_id:9100:70,hostgroup_id:1100:20
```

Arguments:

 - hostname
 - port
 - username
 - password
 - global `readers` weight
 - custom `reader` weight per `hostgroup_id`

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

Start docker to run MySQL 5.7

```
$ docker run --name=proxysqldocker -e MYSQL_USER="puser" -e MYSQL_PASSWORD="pass" -e MYSQL_DATABASE="lifter" -p 3306:3306 -d mysql/mysql-server:5.7
```

```
bundle exec rspec
```

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/vinted/proxysqlweightlifter. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [Contributor Covenant](http://contributor-covenant.org) code of conduct.

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).

## Code of Conduct

Everyone interacting in the Proxysqlweightlifter project’s codebases, issue trackers, chat rooms and mailing lists is expected to follow the [code of conduct](https://github.com/vinted/proxysqlweightlifter/blob/master/CODE_OF_CONDUCT.md).
