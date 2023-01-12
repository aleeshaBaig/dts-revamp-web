namespace :export_dengue_ucs do
    desc 'Export Dengue Ucs ...'
    require 'rubyXL'
    task :run => :environment do
        File.open("doc/excel_files/base_data/Random/dengue_ucs.xlsx" , "w" ) do |f|
            f.write("ID \t Name \t District \t Town \r\n")
            Uc.order("uc_name asc").each do |uc|
                puts "#{uc.uc_name}"
                f.write("#{uc.id} \t #{uc.uc_name} \t #{uc.district.try(:district_name)} \t #{uc.tehsil.try(:tehsil_name)} \r\n")
            end
        end
    end
end