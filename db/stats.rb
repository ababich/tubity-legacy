ActiveRecord::Base.logger = nil

def stats
  links = TubityLink.all
  parents = links.select{|l| l.parent.nil?}

  puts "Links count: #{links.count}"
  puts "Links hits: #{links.map(&:hits).sum}"
  puts

  puts "Parents count: #{parents.count}"
  puts "Parents hits: #{parents.map(&:hits).sum}"
  puts
  puts

  puts "Permanently logged hits count: #{HitsLog.count}"
  puts "Uniq IPs logged: #{HitsLog.all.map(&:remote_ip).uniq.count}"
  puts

  puts "Cached links count: #{Ohm.redis.llen(LinksLog::REDIS_KEY)}"
  puts "Cached hits count: #{Ohm.redis.llen(HitsLog::REDIS_KEY)}"
  puts
  puts

  puts "Filesize of sqlite logger db: #{File.size ActiveRecord::Base.connection.instance_variable_get(:@config)[:database]}"
  puts "Redis dbsize (number of keys): #{Ohm.redis.dbsize}"
  puts "Redis used memory: #{Ohm.redis.info['used_memory_human']}"
  puts "Redis RSS memory: #{Ohm.redis.info['used_memory_rss']}"
  puts
  puts
  puts

  puts "Popularity (global):"
  top_viewed = links.max_by{|l| l.hits}
  top_parent = top_viewed.parent
  puts "Most shown TubityLink #{"thumb" if top_parent}: #{top_viewed.id}|#{top_viewed.hash} #{top_viewed.title} (http://tubity.com/#{top_viewed.hash}) #hits: #{top_viewed.hits}"
  puts "        of TubityLink parent: #{top_parent.id}|#{top_parent.hash} #{top_parent.title} (http://tubity.com/#{top_parent.hash}) #hits: #{top_parent.hits}" if top_parent
  top_hit = parents.max_by{|l| l.hits}
  puts "Most played TubityLink: #{top_hit.id}|#{top_hit.hash} #{top_hit.title} (http://tubity.com/#{top_hit.hash}) #hits: #{top_hit.hits}"
  puts
  puts

  puts "Popularity (last 2 weeks):"
  top_viewed_id = HitsLog.where("created_at > ?", 2.weeks.ago).group(:tubity_link_id).count(:id).max_by{|k, v| v}
  top_viewed = TubityLink[top_viewed_id.first]
  top_parent = top_viewed.parent
  puts "Most shown TubityLink #{"thumb" if top_parent}: #{top_viewed.id}|#{top_viewed.hash} #{top_viewed.title} (http://tubity.com/#{top_viewed.hash}) #hits #{top_viewed_id.last}"
  puts "        of TubityLink parent: #{top_parent.id}|#{top_parent.hash} #{top_parent.title} (http://tubity.com/#{top_parent.hash})" if top_parent

  top_hit_id = HitsLog.where("created_at > ?", 2.weeks.ago).group(:tubity_link_id).count(:id).select{|k, v| TubityLink[k].parent.nil?}.max_by{|k, v| v}
  top_hit = TubityLink[top_hit_id.first]
  puts "Most played TubityLink: #{top_hit.id}|#{top_hit.hash} #{top_hit.title} (http://tubity.com/#{top_hit.hash}) #hits #{top_hit_id.last}"
end

stats