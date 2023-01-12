namespace :export_district_tehsils do
    desc 'Export Dengue DISTRICT TEHSIL...'
    require 'rubyXL'
    task :run => :environment do
        File.open("public/base_district_tehsil_data.xlsx" , "w" ) do |f|
            f.write("Province Id \t Province Name \t District ID \t District Name \t Tehsil Id \t Tehsil Name \r\n")
            Province.all.each do |p|
                p.districts.order("district_name asc").each do |dist|
                    dist.tehsils.each do |teh|
                        puts "========#{p.id} \t #{p.province_name} \t #{dist.id} \t #{dist.district_name} \t #{teh.id} \t #{teh.tehsil_name}"
                        f.write("#{p.id} \t #{p.province_name} \t #{dist.id} \t #{dist.district_name} \t #{teh.id} \t #{teh.tehsil_name} \r\n")
                    end
                end
            end
        end
    end
end