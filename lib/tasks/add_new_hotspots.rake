namespace :add_new_hotspots do
    desc 'Import Hotspot From Excel'
    task :run => :environment do
        p "Starting Process..."
        p "Reading Excel File..."

        version = "v3"
        sheet = RubyXL::Parser.parse("doc/excel_files/base_data/Random/Hotspot/Hotspots_Data_Updated_Final_v1.0.xlsx")
        # sheet = RubyXL::Parser.parse("doc/excel_files/base_data/Random/Hotspot/GujaranwalaSheet.xlsx")
        
        p "Creating Hotspots..."

        sheet_index = 0
        starting_row_index = 1
        ending_row_index = 84298
        # ending_row_index = 3035
        

        entry_count = 0
        already_present = []
        ############################################ RESET HOTSPOT ##########################################
        Hotspot.update_all(is_active: false, is_tagged: 0)
        ############################################ END HOTSPOT ############################################
        (starting_row_index).upto(ending_row_index).each_with_index do |row, index|
            puts "Row: #{index + 1}"
            entry_count = entry_count + 1

            hotspot_name = sheet[sheet_index].sheet_data[row][0].present?? sheet[sheet_index].sheet_data[row][0].value.to_s.strip : nil
            address = sheet[sheet_index].sheet_data[row][1].present?? sheet[sheet_index].sheet_data[row][1].value.to_s.strip : nil
            tag = sheet[sheet_index].sheet_data[row][2].present?? sheet[sheet_index].sheet_data[row][2].value.to_s.strip : nil
            district = sheet[sheet_index].sheet_data[row][3].present?? sheet[sheet_index].sheet_data[row][3].value.to_s.strip : nil
            tehsil = sheet[sheet_index].sheet_data[row][4].present?? sheet[sheet_index].sheet_data[row][4].value.to_s.strip : nil
            uc = sheet[sheet_index].sheet_data[row][5].present?? sheet[sheet_index].sheet_data[row][5].value.to_s.strip : nil
            description = sheet[sheet_index].sheet_data[row][6].present?? sheet[sheet_index].sheet_data[row][6].value.to_s.strip : nil

            district_record = District.where("lower(district_name) = ?", district.to_s.downcase).first
            if district_record.present?
                district_id = district_record.id
            else
                district_id = nil
                district = nil
            end

            tehsil_record = Tehsil.where("lower(tehsil_name) = ? and district_id =?", tehsil.to_s.downcase, district_id).first
            if tehsil_record.present?
                tehsil_id = tehsil_record.id
            else
                tehsil_id = nil
                tehsil = nil
            end

            uc_record = Uc.where("lower(uc_name) = ? and tehsil_id =? and district_id =?", uc.to_s.downcase, tehsil_id, district_id).first
            if uc_record.present?
                uc_id = uc_record.id
            else
                uc_id = nil
                uc = nil

                puts "====================================================================================================uc not exist #{uc}"
            end
            
            tag_obj = Tag.where('lower(tag_name) =?', "#{tag.downcase}").last
            if tag_obj.present?
                tag_id = tag_obj.id
            else
                category = TagCategory.find_by_category_name('Hotspots')
                tag = Tag.create(tag_name: tag, tag_category_id:  category.id, tag_image_url: "#{tag.downcase.gsub(" ", "")}.png", tag_options: '1,2,9,11,13', m_category_id: category.id)
                tag_id = tag.id
            end
            
            
            hotspot = Hotspot.create!(hotspot_name: hotspot_name, district: district, district_id: district_id, tehsil: tehsil, tehsil_id: tehsil_id, uc: uc, uc_id: uc_id, address: address, tag: tag, tag_id: tag_id, description: description, is_active: true, is_tagged: 0)
            # hotspot_record = Hotspot.where("lower(hotspot_name) = ? and district_id =? and tehsil_id =? and uc_id =?", hotspot_name.to_s.downcase, district_id, tehsil_id, uc_id).first
            # if hotspot_record.present?
            #     if hotspot_record.update_attributes(hotspot_name: hotspot_name, district: district, district_id: district_id, tehsil: tehsil, tehsil_id: tehsil_id, uc: uc, uc_id: uc_id, address: address, tag: tag, tag_id: tag_id, description: description, is_active: true, is_tagged: 0)
            #         puts "==== update #{index}"
            # 	    # already_present << hotspot_name
            #     end
            # else
            # 	hotspot = Hotspot.create!(hotspot_name: hotspot_name, district: district, district_id: district_id, tehsil: tehsil, tehsil_id: tehsil_id, uc: uc, uc_id: uc_id, address: address, tag: tag, tag_id: tag_id, description: description, is_active: true, is_tagged: 0)
            #     puts "==== created"
            # end
        end

        puts "Hotspots Created Successfully."
        # puts already_present
    end
end