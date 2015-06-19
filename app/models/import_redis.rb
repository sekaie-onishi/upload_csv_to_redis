require 'json'
class ImportRedis
  include ActiveModel::Model

  def initialize
    @redis_value_keys = ["page_name", "title", "h1", "description", "keyword",
                         "pan1", "pan2", "pan3", "pan4", "pan5"]
  end

  def import(file)
    @text = "keys:"
    @redis = Redis.new(:host => "#{Settings.redis_setting.host}", :port => Settings.redis_setting.port)
    CSV.foreach(file.path, {headers: true, quote_char: "'"}) do |row|
      key = "#{Settings.redis_setting.host_prefix}#{Settings.redis_common.key_separator}#{Settings.redis_common.data_type_key}#{Settings.redis_common.key_separator}#{row['theme']}#{row['controller']}#{row['action']}"
      value = JSON.generate(create_value(row))
      @redis.set(key, value);
    end
    return @text
  end

  def create_value(row)
    value = Hash.new()
    @redis_value_keys.each{|key|
      value[key] = row[key]
    }
    return value
  end

end
