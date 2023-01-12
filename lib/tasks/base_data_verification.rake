namespace :base_data_verification do
    desc "Verification Base Data"
    task :run => :environment do
        p "Starting Process..."
        p "Reading Verification Base Data ..."

        version = "v3"
        sheet = RubyXL::Parser.parse("public/Uniq_Base_Data_Dengue_bData3.xlsx")
        p "Creating Mobile Users of ANTI DENGUE..."

        sheet_index = 0
        starting_row_index = 1
        ending_row_index = 160
        entry_count = 0

        tehsil_not_found = []
        district_error = []
        tehsil_error = []
        department_error = []
        category_error = []
        
        (starting_row_index).upto(ending_row_index).each_with_index do |row, index|
            puts "Row: #{index + 1}"
            entry_count = entry_count + 1

            password = "12344321"
            begin
            district_name = sheet[sheet_index].sheet_data[row][1].present?? sheet[sheet_index].sheet_data[row][1].value.to_s.strip : nil
            tehsil_name = sheet[sheet_index].sheet_data[row][2].present?? sheet[sheet_index].sheet_data[row][2].value.to_s.strip : nil
            department_name = sheet[sheet_index].sheet_data[row][3].present?? sheet[sheet_index].sheet_data[row][3].value.to_s.strip : nil
            category_names = sheet[sheet_index].sheet_data[row][4].present?? sheet[sheet_index].sheet_data[row][4].value.to_s.strip : nil


            if district_name.present?
                district = District.where("lower(district_name) =?", district_name.try(:downcase)).first
                unless district.present?
                    district_error << district_name
                end
            end

            if tehsil_name != 'All' and tehsil_name.present?
                tehsil = Tehsil.where("lower(tehsil_name) =?", tehsil_name.try(:downcase)).first
                unless tehsil.present?
                    tehsil_error << tehsil_name
                end
            end

            if category_names.present?
                category_names_ar = category_names.split(",").collect{ |e| e ? e.strip : e }
                tag_categories_ids = TagCategory.where(category_name: category_names_ar).map(&:id)

                puts " ===== #{category_names_ar},===== #{TagCategory.where(category_name: category_names_ar).map(&:category_name)}"
                unless tag_categories_ids.present? and (category_names_ar == TagCategory.where(category_name: category_names_ar).map(&:category_name))
                    category_error << category_names
                end
            end

            department = Department.where("lower(department_name) =?", department_name.try(:downcase)).first
            unless department.present?
                department_error << department_name
            end
            puts "#{index}"
        end

    rescue => error
        errors << error.inspect
    end
    # puts district_error
    # puts tehsil_error
    # puts department_error
    puts category_error
  end
end