module Proxysqlweightlifter
  # Lift is responsible for resolving current slaves from
  # mysql_replication_hostgroups table
  class Lift
    attr_reader :db, :weight

    def initialize(database, weight = 10)
      @db = database
      @weight = weight
    end

    def run
      # We reset all weights to 1 because during runs of
      # lift master might have switched
      reset_weight

      hostgroups.each do |hostgroup|
        find_slaves(hostgroup).map do |slave|
          slave.delete(:weight)
          update_weight(slave)
        end

        debug find_slaves(hostgroup)
      end

      begin
        db.query('LOAD MYSQL SERVERS TO RUNTIME;')
      rescue => e
        puts "LOAD MYSQL SERVERS TO RUNTIME error #{e}"
      end
    end

    def hostgroups
      db.query(%(
        SELECT writer_hostgroup,reader_hostgroup
        FROM mysql_replication_hostgroups;
      )).map { |slave| Hash[slave.map{|(k,v)| [k.to_sym,v]}] }
    end

    def find_master(writer_hostgroup)
      master = db.query(%(
        SELECT hostname
        FROM mysql_servers
        WHERE hostgroup_id IN (#{writer_hostgroup});
      ))
      if master.size > 1
        raise "More than 1 `writer` #{master} found in #{writer_hostgroup}"
      end
      master.map { |m| m['hostname'] }
    end

    def find_slaves(writer_hostgroup:, reader_hostgroup:)
      master = find_master(writer_hostgroup)
      master_ip = master.first

      slaves = db.query(%(
        SELECT hostgroup_id, hostname, port, weight
        FROM mysql_servers
        WHERE hostgroup_id IN (#{writer_hostgroup}, #{reader_hostgroup}) AND hostname != "#{master_ip}";
      ))
      if slaves.size.zero?
        debug "No readers #{slaves} found in hostgroup `writer` #{writer_hostgroup} `reader` #{reader_hostgroup}"
      end
      slaves.map { |slave| Hash[slave.map{|(k,v)| [k.to_sym,v]}] }
    end

    def reset_weight(weight = 1)
      db.query("UPDATE mysql_servers SET weight = #{weight};")
    end

    def update_weight(hostname:, port:, hostgroup_id:)
      db.query(%(
        UPDATE mysql_servers
        SET weight = #{weight || 1}
        WHERE hostname = "#{hostname}" AND port = "#{port}" AND hostgroup_id = "#{hostgroup_id}";
      ))
    end

    private

    def debug(s)
      return
      puts s
    end
  end
end
