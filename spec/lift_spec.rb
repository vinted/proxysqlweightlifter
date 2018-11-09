require 'mysql2'

RSpec.describe Proxysqlweightlifter::Lift do
  def db
    @db ||= Mysql2::Client.new(
      host: '172.17.0.1',
      port: 3306,
      username: 'puser',
      password: 'pass',
      database: 'lifter'
    )
  end

  after :all do
    db.query('DROP DATABASE lifter; ')
    db.query('CREATE DATABASE lifter; ')
  end

  before :all do
    db.query <<-SQL
      CREATE TABLE mysql_servers (
          `hostgroup_id` int(10) NOT NULL DEFAULT '0',
          `hostname` varchar(300) NOT NULL,
          `port` int(10) NOT NULL DEFAULT '3306',
          `status` varchar(300) NOT NULL DEFAULT 'ONLINE',
          `weight` int(10) NOT NULL DEFAULT '1',
          `compression` int(10) NOT NULL DEFAULT '0',
          `max_connections` int(10) NOT NULL DEFAULT '1000',
          `max_replication_lag` int(10) NOT NULL DEFAULT '0',
          `use_ssl` int(10) NOT NULL DEFAULT '0',
          `max_latency_ms` int(10) UNSIGNED NOT NULL DEFAULT '0',
          `comment` varchar(300) NOT NULL DEFAULT '',
          PRIMARY KEY (`hostgroup_id`, `hostname`, `port`) );
    SQL

    db.query <<-SQL
      INSERT INTO `mysql_servers` VALUES ('1100','20.0.10.93','3306','ONLINE','1','0','200','1','0','0','Proxying `uk` for pp-uk'),('1000','20.0.10.95','3306','ONLINE','1','0','200','1','0','0','Proxying `uk` for pp-uk'),('1100','20.0.10.95','3306','ONLINE','1','0','200','1','0','0','Proxying `uk` for pp-uk'),('2100','30.30.30.66','3306','ONLINE','1','0','200','1','0','0','Proxying `pl` for pp-pl'),('2000','30.30.30.23','3306','ONLINE','1','0','200','1','0','0','Proxying `pl` for pp-pl'),('2100','30.30.30.23','3306','ONLINE','1','0','200','1','0','0','Proxying `pl` for pp-pl'),('3100','30.30.30.152','3306','ONLINE','1','0','200','1','0','0','Proxying `de_b` for pp-de_b'),('3000','30.30.30.159','3306','ONLINE','1','0','200','1','0','0','Proxying `de_b` for pp-de_b'),('3100','30.30.30.159','3306','ONLINE','1','0','200','1','0','0','Proxying `de_b` for pp-de_b'),('4100','30.30.30.65','3306','ONLINE','1','0','200','1','0','0','Proxying `cz` for pp-cz'),('4000','30.30.30.193','3306','ONLINE','1','0','200','1','0','0','Proxying `cz` for pp-cz'),('4100','30.30.30.193','3306','ONLINE','1','0','200','1','0','0','Proxying `cz` for pp-cz'),('5100','20.0.10.73','3306','ONLINE','1','0','200','1','0','0','Proxying `us` for pp-us'),('5000','30.30.30.158','3306','ONLINE','1','0','200','1','0','0','Proxying `us` for pp-us'),('5100','30.30.30.158','3306','ONLINE','1','0','200','1','0','0','Proxying `us` for pp-us'),('6100','20.0.10.167','3306','ONLINE','1','0','200','1','0','0','Proxying `nl` for pp-nl'),('6000','30.30.30.146','3306','ONLINE','1','0','200','1','0','0','Proxying `nl` for pp-nl'),('6100','30.30.30.146','3306','ONLINE','1','0','200','1','0','0','Proxying `nl` for pp-nl'),('7100','20.0.10.129','3306','ONLINE','1','0','200','1','0','0','Proxying `lt` for pp-lt'),('7000','30.30.30.198','3306','ONLINE','1','0','200','1','0','0','Proxying `lt` for pp-lt'),('7100','30.30.30.198','3306','ONLINE','1','0','200','1','0','0','Proxying `lt` for pp-lt'),('8100','30.30.30.199','3306','ONLINE','1','0','200','1','0','0','Proxying `lt_b` for pp-lt_b'),('8000','20.0.10.131','3306','ONLINE','1','0','200','1','0','0','Proxying `lt_b` for pp-lt_b'),('8100','20.0.10.131','3306','ONLINE','1','0','200','1','0','0','Proxying `lt_b` for pp-lt_b'),('9100','30.30.30.97','3306','ONLINE','1','0','200','1','0','0','Proxying `gr` for pp-fr'),('9000','20.0.10.9','3306','ONLINE','1','0','200','1','0','0','Proxying `gr` for pp-fr'),('9100','20.0.10.9','3306','ONLINE','1','0','200','1','0','0','Proxying `gr` for pp-fr'),('10100','30.30.30.194','3306','ONLINE','1','0','200','1','0','0','Proxying `es` for pp-es'),('10000','20.0.10.168','3306','ONLINE','1','0','200','1','0','0','Proxying `es` for pp-es'),('10100','20.0.10.168','3306','ONLINE','1','0','200','1','0','0','Proxying `es` for pp-es'),('11100','30.30.30.153','3306','ONLINE','1','0','200','1','0','0','Proxying `dd` for pp-de'),('11000','30.30.30.157','3306','ONLINE','1','0','200','1','0','0','Proxying `dd` for pp-de'),('11100','30.30.30.157','3306','ONLINE','1','0','200','1','0','0','Proxying `dd` for pp-de'),('1110','20.0.10.93','3306','ONLINE','1','0','200','1','0','0','Proxying `ha-uk` for pp-uk'),('1010','20.0.10.95','3306','ONLINE','1','0','200','1','0','0','Proxying `ha-uk` for pp-uk'),('1110','20.0.10.95','3306','ONLINE','1','0','200','1','0','0','Proxying `ha-uk` for pp-uk'),('2110','30.30.30.66','3306','ONLINE','1','0','200','1','0','0','Proxying `ha-pl` for pp-pl'),('2010','30.30.30.23','3306','ONLINE','1','0','200','1','0','0','Proxying `ha-pl` for pp-pl'),('2110','30.30.30.23','3306','ONLINE','1','0','200','1','0','0','Proxying `ha-pl` for pp-pl'),('3110','30.30.30.152','3306','ONLINE','1','0','200','1','0','0','Proxying `ha-de_b` for pp-de_b'),('3010','30.30.30.159','3306','ONLINE','1','0','200','1','0','0','Proxying `ha-de_b` for pp-de_b'),('3110','30.30.30.159','3306','ONLINE','1','0','200','1','0','0','Proxying `ha-de_b` for pp-de_b'),('4110','30.30.30.65','3306','ONLINE','1','0','200','1','0','0','Proxying `ha-cz` for pp-cz'),('4010','30.30.30.193','3306','ONLINE','1','0','200','1','0','0','Proxying `ha-cz` for pp-cz'),('4110','30.30.30.193','3306','ONLINE','1','0','200','1','0','0','Proxying `ha-cz` for pp-cz'),('5110','20.0.10.73','3306','ONLINE','1','0','200','1','0','0','Proxying `ha-us` for pp-us'),('5010','30.30.30.158','3306','ONLINE','1','0','200','1','0','0','Proxying `ha-us` for pp-us'),('5110','30.30.30.158','3306','ONLINE','1','0','200','1','0','0','Proxying `ha-us` for pp-us'),('6110','20.0.10.167','3306','ONLINE','1','0','200','1','0','0','Proxying `ha-nl` for pp-nl'),('6010','30.30.30.146','3306','ONLINE','1','0','200','1','0','0','Proxying `ha-nl` for pp-nl'),('6110','30.30.30.146','3306','ONLINE','1','0','200','1','0','0','Proxying `ha-nl` for pp-nl'),('7110','20.0.10.129','3306','ONLINE','1','0','200','1','0','0','Proxying `ha-lt` for pp-lt'),('7010','30.30.30.198','3306','ONLINE','1','0','200','1','0','0','Proxying `ha-lt` for pp-lt'),('7110','30.30.30.198','3306','ONLINE','1','0','200','1','0','0','Proxying `ha-lt` for pp-lt'),('8110','30.30.30.199','3306','ONLINE','1','0','200','1','0','0','Proxying `ha-lt_b` for pp-lt_b'),('8010','20.0.10.131','3306','ONLINE','1','0','200','1','0','0','Proxying `ha-lt_b` for pp-lt_b'),('8110','20.0.10.131','3306','ONLINE','1','0','200','1','0','0','Proxying `ha-lt_b` for pp-lt_b'),('9110','30.30.30.97','3306','ONLINE','1','0','200','1','0','0','Proxying `ha-fr` for pp-fr'),('9010','20.0.10.9','3306','ONLINE','1','0','200','1','0','0','Proxying `ha-fr` for pp-fr'),('9110','20.0.10.9','3306','ONLINE','1','0','200','1','0','0','Proxying `ha-fr` for pp-fr'),('10110','30.30.30.194','3306','ONLINE','1','0','200','1','0','0','Proxying `ha-es` for pp-es'),('10010','20.0.10.168','3306','ONLINE','1','0','200','1','0','0','Proxying `ha-es` for pp-es'),('10110','20.0.10.168','3306','ONLINE','1','0','200','1','0','0','Proxying `ha-es` for pp-es'),('11110','30.30.30.153','3306','ONLINE','1','0','200','1','0','0','Proxying `ha-de` for pp-de'),('11010','30.30.30.157','3306','ONLINE','1','0','200','1','0','0','Proxying `ha-de` for pp-de'),('11110','30.30.30.157','3306','ONLINE','1','0','200','1','0','0','Proxying `ha-de` for pp-de'),('9101','30.30.30.56','3306','ONLINE','1','0','200','1','0','0','Proxying `fr_old` for pp-olddb-fr'),('9001','20.0.10.15','3306','ONLINE','1','0','200','1','0','0','Proxying `fr_old` for pp-olddb-fr'),('9101','20.0.10.15','3306','ONLINE','1','0','200','1','0','0','Proxying `fr_old` for pp-olddb-fr'),('11101','30.30.30.154','3306','ONLINE','1','0','200','1','0','0','Proxying `de_old` for pp-olddb-de'),('11001','20.0.10.48','3306','ONLINE','1','0','200','1','0','0','Proxying `de_old` for pp-olddb-de'),('11101','20.0.10.48','3306','ONLINE','1','0','200','1','0','0','Proxying `de_old` for pp-olddb-de'),('12101','30.30.30.94','3306','ONLINE','1','0','200','1','0','0','Proxying `fr_abdb` for pp-abdb-fr'),('12001','20.0.10.229','3306','ONLINE','1','0','200','1','0','0','Proxying `fr_abdb` for pp-abdb-fr'),('12101','20.0.10.229','3306','ONLINE','1','0','200','1','0','0','Proxying `fr_abdb` for pp-abdb-fr');
    SQL

    db.query <<-SQL
    CREATE TABLE mysql_replication_hostgroups (
        writer_hostgroup int(10) NOT NULL PRIMARY KEY,
        reader_hostgroup int(10) NOT NULL,
        comment varchar(300) NOT NULL DEFAULT '');
    SQL

    db.query <<-SQL
      INSERT INTO `mysql_replication_hostgroups` VALUES ('1000','1100','Proxying `uk` for pp-uk'),('2000','2100','Proxying `pl` for pp-pl'),('3000','3100','Proxying `de_b` for pp-de_b'),('4000','4100','Proxying `cz` for pp-cz'),('5000','5100','Proxying `us` for pp-us'),('6000','6100','Proxying `nl` for pp-nl'),('7000','7100','Proxying `lt` for pp-lt'),('8000','8100','Proxying `lt_b` for pp-lt_b'),('9000','9100','Proxying `gr` for pp-fr'),('10000','10100','Proxying `es` for pp-es'),('11000','11100','Proxying `dd` for pp-de'),('1010','1110','Proxying `ha-uk` for pp-uk'),('2010','2110','Proxying `ha-pl` for pp-pl'),('3010','3110','Proxying `ha-de_b` for pp-de_b'),('4010','4110','Proxying `ha-cz` for pp-cz'),('5010','5110','Proxying `ha-us` for pp-us'),('6010','6110','Proxying `ha-nl` for pp-nl'),('7010','7110','Proxying `ha-lt` for pp-lt'),('8010','8110','Proxying `ha-lt_b` for pp-lt_b'),('9010','9110','Proxying `ha-fr` for pp-fr'),('10010','10110','Proxying `ha-es` for pp-es'),('11010','11110','Proxying `ha-de` for pp-de'),('9001','9101','Proxying `fr_old` for pp-olddb-fr'),('11001','11101','Proxying `de_old` for pp-olddb-de'),('12001','12101','Proxying `fr_abdb` for pp-abdb-fr');
    SQL
  end

  it 'setups dummy data correctly' do
    expect(db.query('SELECT * FROM mysql_replication_hostgroups').size).to eq(25)
    expect(db.query('SELECT * FROM mysql_servers').size).to eq(75)
  end

  let(:instance) { described_class.new(db) }

  context '#hostgroups' do
    it 'first 9 records matches' do
      expect(instance.hostgroups.first(9)).to eq(
        [
          { 'writer_hostgroup': 1000, 'reader_hostgroup': 1100 },
          { 'writer_hostgroup': 1010, 'reader_hostgroup': 1110 },
          { 'writer_hostgroup': 2000, 'reader_hostgroup': 2100 },
          { 'writer_hostgroup': 2010, 'reader_hostgroup': 2110 },
          { 'writer_hostgroup': 3000, 'reader_hostgroup': 3100 },
          { 'writer_hostgroup': 3010, 'reader_hostgroup': 3110 },
          { 'writer_hostgroup': 4000, 'reader_hostgroup': 4100 },
          { 'writer_hostgroup': 4010, 'reader_hostgroup': 4110 },
          { 'writer_hostgroup': 5000, 'reader_hostgroup': 5100 },
        ]
      )
    end
  end

  context '#find_master' do
    let(:hostgroups) { described_class.new(db).hostgroups }

    it 'finds master of 1000 writer_hostgroup' do
      expect(instance.find_master(1000)).to eq(['20.0.10.95'])
    end

    it 'finds master of 9000 writer_hostgroup' do
      expect(instance.find_master(9000)).to eq(['20.0.10.9'])
    end
  end

  context '#find_slaves' do
    let(:hostgroups) { described_class.new(db).hostgroups }

    context 'finds slaves for 8110 reader_hostgroup' do
      let(:slave) { instance.find_slaves(writer_hostgroup: 8010, reader_hostgroup: 8110) }
      it { expect(slave).to eq([{hostgroup_id: 8110, hostname: '30.30.30.199', port: 3306, weight: 1}]) }
    end

    context 'finds slaves for 3110 reader_hostgroup' do
      let(:slave) { instance.find_slaves(writer_hostgroup: 3010, reader_hostgroup: 3110) }
      it { expect(slave).to eq([hostgroup_id: 3110, hostname: '30.30.30.152', port: 3306, weight: 1]) }
    end

    context 'finds slaves for 10100 reader_hostgroup' do
      let(:slave) { instance.find_slaves(writer_hostgroup: 10000, reader_hostgroup: 10100) }
      it { expect(slave).to eq([hostgroup_id: 10100, hostname: '30.30.30.194', port: 3306, weight: 1]) }
    end
  end

  context '#run' do
    it { expect(instance.run).to be_nil }
  end
end
