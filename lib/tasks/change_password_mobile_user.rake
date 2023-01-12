namespace :change_password_mobile_user do

    desc "Update Mobile User Password"
	task :run => :environment do

        puts "Reading Excel File..."
        sheet = RubyXL::Parser.parse("doc/excel_files/base_data/Random/PEF_Users.xlsx")
        puts "Starting..."

        puts "Populate Users Data..."
        sheet_index = 0
        starting_row_index = 1
        ending_row_index = 6816

        errors = []
        (starting_row_index).upto(ending_row_index).each do |row|
            
            puts "Excuting Row: #{row}"

            username = sheet[sheet_index].sheet_data[row][0].present?? sheet[sheet_index].sheet_data[row][0].value.to_s.strip : nil
            password = sheet[sheet_index].sheet_data[row][1].present?? sheet[sheet_index].sheet_data[row][1].value.to_s.strip : nil

            mobile_user = MobileUser.where(username: username).first
            
            if mobile_user.present?
                if mobile_user.update_attributes!(password: password, password_confirmation: password, is_forgot: true)
                    puts "saved #{username}"
                else
                    errors << mobile_user.errors.full_messages    
                end
            else
                puts "Error : #{username}"
                errors << username
            end
        end
        puts "#{errors}"
    end
end