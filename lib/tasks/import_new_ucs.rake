namespace :import_new_ucs do
    desc 'Import New Ucs'
    task :run => :environment do
        p "Starting Process..."
        p "Reading Excel File..."
        
        version = "v3"
        # sheet = RubyXL::Parser.parse("doc/excel_files/base_data/Random/Hotspot/UCS_DATA/NEW_UCS v0.3.xlsx")
        sheet = RubyXL::Parser.parse("doc/excel_files/base_data/Random/Hotspot/UCS_DATA/Islamabad Rural UCs.xlsx")
        p "Creat New Ucs"
        
        sheet_index = 0
        starting_row_index = 1
        ending_row_index = 21

        # starting_row_index = 192
        # ending_row_index = 254
        uniq_ucs = []
        
        entry_count = 0
        already_present = []
        (starting_row_index).upto(ending_row_index).each_with_index do |row, index|
            district = sheet[sheet_index].sheet_data[row][2].present?? sheet[sheet_index].sheet_data[row][2].value.to_s.strip : nil
            tehsil = sheet[sheet_index].sheet_data[row][3].present?? sheet[sheet_index].sheet_data[row][3].value.to_s.strip : nil
            uc = sheet[sheet_index].sheet_data[row][4].present?? sheet[sheet_index].sheet_data[row][4].value.to_s.strip : nil


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

            uc_record = Uc.where("lower(uc_name) = ? and district_id =? and tehsil_id =?", uc.to_s.downcase, district_id, tehsil_id).first
            if uc_record.present?
                uc_id = uc_record.id
            else
                Uc.create(uc_name: uc, district_id: district_id, tehsil_id: tehsil_id)
                uniq_ucs << uc
            end

        end
        puts "#{uniq_ucs}"
    end
end