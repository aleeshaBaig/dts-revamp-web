namespace :unvisited_hotspot do
    desc 'Export unvisited hotspot'
    require 'rubyXL'
    task :run => :environment do
        File.open("public/unvisited_hotspots.xlsx" , "w" ) do |f|
            f.write("District \t Town \t Tag \t UC \t Name/Address \r\n")
            
            params = { hotspot_district_id: "18", hotspot_from: "2022-03-14",  hotspot_to: "2022-03-20",  hotspot_status: "true", type: "unvisted_hotspots"}
            date_filters = (params[:hotspot_from].present? and params[:hotspot_to].present? ) ? "(simple_activities.created_at >= '#{params[:hotspot_from].to_datetime.beginning_of_day}') and (simple_activities.created_at <= '#{params[:hotspot_to].to_datetime.end_of_day}')" : true
			
            @hotspots = Hotspot
            .joins("LEFT JOIN simple_activities ON simple_activities.hotspot_id = hotspots.id and #{date_filters}")
            .where("simple_activities.id is null")
            .filters_sumary_wise_count(params.except(:hotspot_from).except(:hotspot_to))            

            @hotspots.each do |hotspot|
            f.write("#{hotspot.district} \t #{hotspot.tehsil} \t #{hotspot.tag} \t #{hotspot.uc} \t #{hotspot.hotspot_name}/#{hotspot.address} \r\n")
            end
        end
    end
end