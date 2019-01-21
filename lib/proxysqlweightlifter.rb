require 'mysql2'
require 'proxysqlweightlifter/version'
require 'proxysqlweightlifter/lift'

module Proxysqlweightlifter
  class Error < StandardError; end

  def self.run(argv)
    host, port, user, pass, weight, custom_weight = argv
    Lift.new(
      Mysql2::Client.new(
        host: host,
        port: port,
        username: user,
        password: pass,
        database: 'main'
      ),
      weight || 9,
      custom_weight
    ).run
  end
end
