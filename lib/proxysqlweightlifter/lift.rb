module Proxysqlweightlifter
  # Lift is responsible for resolving current slaves from
  # mysql_replication_hostgroups table
  class Lift
    attr_reader :db, :default_weight

    def initialize(database, default_weight = 10, custom_weight = '')
      @db = database
      @default_weight = default_weight
      @custom_weight = custom_weight.to_s
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

    def hostgroup_weights
      @hostgroup_weights ||= @custom_weight.split(',').map do |cs|
        hostgroup_id, group_id, weight = cs.split(':')
        raise 'Invalid or unsupported format: hostgroup_id:9100:70' if hostgroup_id != 'hostgroup_id'
        {
          group_id.to_i => weight.to_i
        }
      end.reduce(&:merge) || {}
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
      weight = hostgroup_weights[hostgroup_id] || hostgroup_weights[hostgroup_id.to_i] || default_weight || 1
      db.query(%(
        UPDATE mysql_servers
        SET weight = #{weight}
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
