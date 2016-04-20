namespace :clean do
  desc 'Pack old releases to preserve space'
  task :old_releases do
    # -3 means left current and prev releases unpacked
    cleanup_date = 1.week.ago.strftime "%Y%m%d"

    Dir["../*"].sort[0..-3].each { |d|
      if File.basename(d) < cleanup_date
        puts "Remove #{File.basename(d)} outdated release"
        `rm -rf #{d}`
      elsif File.directory?(d)
        puts "Pack #{File.basename(d)} release"

        `tar zcvf #{d}.tar.gz #{d}`

        `rm -rf #{d}`
      end
    }
  end


  task :redis_cached => :environment do
    LinksLog.dump_cache!
    HitsLog.dump_cache!
  end
end
