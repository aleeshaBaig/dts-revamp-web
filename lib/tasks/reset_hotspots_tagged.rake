namespace :reset_hotspots_tagged do
    desc 'Reset Hotspots Is Tagged ...'
    task :run => :environment do
        Hotspot.update_all(is_tagged: 0)
    end
end