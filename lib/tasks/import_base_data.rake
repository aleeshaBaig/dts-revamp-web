namespace :base_data do
	desc "Drop DB, Create DB, Migrate DB"
	task :resetdb => :environment do
		# Reset Database
		Rake::Task["db:drop"].invoke
		Rake::Task["db:create"].invoke
		Rake::Task["db:migrate"].invoke
	end

	desc 'Import Base Data'
	task :repopulate => :environment do
		# # Reset Database
		# Rake::Task["base_data:resetdb"].invoke

		# Admin User
		# Rake::Task["base_data:create_admin_user"].invoke

		# Province to UC Data
		# Rake::Task["base_data:import_p2uc"].invoke

		# Tags Data
		# Rake::Task["base_data:import_tag_options"].invoke
		# Rake::Task["base_data:import_tag_categories"].invoke
		# Rake::Task["base_data:import_tags"].invoke

		# Hospitals Data
		# Rake::Task["base_data:import_old_hospitals"].invoke
		# Rake::Task["base_data:import_new_hospitals"].invoke
		# Rake::Task["base_data:import_private_hospitals"].invoke

		# Labs Data
		# Rake::Task["base_data:import_labs"].invoke

		# Dapartments Data
		# Rake::Task["base_data:import_departments_with_tags"].invoke

		# Web Users Data
		# Rake::Task["base_data:create_web_users"].invoke

		# # Create Hotspots
		# Rake::Task["base_data:create_hotspots"].invoke

		# # # Mobile Users Data
		# Rake::Task["base_data:create_mobile_users_tpv"].invoke
		# Rake::Task["base_data:create_mobile_users_anti_dengue"].invoke
  end

	desc "Create Admin User"
  	task :create_admin_user => :environment do
  	role = "admin"
		username = "admin"
		password = "admin@12"
		email = "admin@revamp-dashboard-tracking.pitb.gov.pk"
		user = User.create!(username: username, email: email, password: password, password_confirmation: password, role: role)
		puts "User #{user.username} Created"
	end

	desc "Import Province to Union Councils Data"
	task :import_p2uc => :environment do
		p "Starting Process..."
		p "Reading Excel File..."

		version = "v3"
		sheet = RubyXL::Parser.parse("doc/excel_files/base_data/#{version}/province_to_uc/Step_1_Base_Data_Province_To_Union_Counciles.xlsx")
		p "Creating/Updating P2UC Data..."

		sheet_index = 0
		starting_row_index = 1
		ending_row_index = 4250

		entry_count = 0

		(starting_row_index).upto(ending_row_index).each_with_index do |row, index|
			puts "Row: #{index + 1}"
			entry_count = entry_count + 1

			province_name = sheet[sheet_index].sheet_data[row][1].present?? sheet[sheet_index].sheet_data[row][1].value.to_s.strip : nil
			division_name = sheet[sheet_index].sheet_data[row][2].present?? sheet[sheet_index].sheet_data[row][2].value.to_s.strip : nil
			district_name = sheet[sheet_index].sheet_data[row][3].present?? sheet[sheet_index].sheet_data[row][3].value.to_s.strip : nil
			tehsil_name = sheet[sheet_index].sheet_data[row][4].present?? sheet[sheet_index].sheet_data[row][4].value.to_s.strip : nil
			uc_name = sheet[sheet_index].sheet_data[row][5].present?? sheet[sheet_index].sheet_data[row][5].value.to_s.strip : nil

			# Find or Create Province
			province = Province.where("lower(province_name) = ?", province_name.to_s.downcase).first
			province = province.present?? province : Province.create!(province_name: province_name)

			# Find or Create Division
			division = Division.where("lower(division_name) = ?", division_name.to_s.downcase).first
			division = division.present?? division : province.divisions.create!(division_name: division_name)

			# Find or Create District
			district = District.where("lower(district_name) = ?", district_name.to_s.downcase).first
			district = district.present?? district : division.districts.create!(district_name: district_name, province_id: province.id, division_name: division.division_name)

			# Find or Create Tehsil
			tehsil = Tehsil.where("lower(tehsil_name) = ?", tehsil_name.to_s.downcase).first
			tehsil = tehsil.present?? tehsil : district.tehsils.create!(tehsil_name: tehsil_name)

			# Find or Create UC
			uc = Uc.where("lower(uc_name) = ?", uc_name.to_s.downcase).first
			uc = uc.present?? uc : tehsil.ucs.create!(uc_name: uc_name, district_id: district.id)
		end

		puts "Total Entry Count: #{entry_count}"
		p "Process Completed."
	end

	desc "Import TagOptions"
	task :import_tag_options => :environment do
		p "Starting Process..."
		p "Reading Excel File..."

		version = "v3"
		sheet = RubyXL::Parser.parse("doc/excel_files/base_data/#{version}/tags_data/Step_0.0_TagOptions.xlsx")
		p "Creating/Updating Base Data..."

		sheet_index = 0
		starting_row_index = 1
		ending_row_index = 13

		entry_count = 0
		already_present = []

		(starting_row_index).upto(ending_row_index).each_with_index do |row, index|
			puts "Row: #{index + 1}"
			entry_count = entry_count + 1

			option_name = sheet[sheet_index].sheet_data[row][1].present?? sheet[sheet_index].sheet_data[row][1].value.to_s.strip : nil
			m_option_id = sheet[sheet_index].sheet_data[row][2].present?? sheet[sheet_index].sheet_data[row][2].value.to_s.strip.to_i : nil

			tag_option = TagOption.where("lower(option_name) = ?", option_name.to_s.downcase).first
			if tag_option.present?
				already_present << option_name
			else
				tag_option = TagOption.create!(option_name: option_name, m_option_id: m_option_id)
			end
		end

		puts "Tag Option Names Created Successfully."
		puts already_present
	end

	desc "Import TagCategories"
	task :import_tag_categories => :environment do
		p "Starting Process..."
		p "Reading Excel File..."

		version = "v3"
		sheet = RubyXL::Parser.parse("doc/excel_files/base_data/#{version}/tags_data/Step_0.1_TagCategories.xlsx")
		p "Creating/Updating Base Data..."

		sheet_index = 0
		starting_row_index = 1
		ending_row_index = 5

		entry_count = 0
		already_present = []

		(starting_row_index).upto(ending_row_index).each_with_index do |row, index|
			puts "Row: #{index + 1}"
			entry_count = entry_count + 1

			category_name = sheet[sheet_index].sheet_data[row][1].present?? sheet[sheet_index].sheet_data[row][1].value.to_s.strip : nil
			urdu = sheet[sheet_index].sheet_data[row][2].present?? sheet[sheet_index].sheet_data[row][2].value.to_s.	strip : nil
			m_category_id = sheet[sheet_index].sheet_data[row][3].present?? sheet[sheet_index].sheet_data[row][3].value.to_s.strip.to_i : nil
			category_name_en = sheet[sheet_index].sheet_data[row][4].present?? sheet[sheet_index].sheet_data[row][4].value.to_s.strip : nil


			tag_category = TagCategory.where("lower(category_name) = ?", category_name.to_s.downcase).first
			if tag_category.present?
				already_present << category_name
			else
				tag_category = TagCategory.create!(category_name: category_name, urdu: urdu, m_category_id: m_category_id, category_name_en: category_name_en)
			end
		end

		puts "Tag Categories Created Successfully."
		puts already_present
	end

	desc "Import Tags"
	task :import_tags => :environment do
		p "Starting Process..."
		p "Reading Excel File..."

		version = "v3"
		sheet = RubyXL::Parser.parse("doc/excel_files/base_data/#{version}/tags_data/Step_0.2_Tags.xlsx")
		p "Creating/Updating Base Data..."

		sheet_index = 0
		starting_row_index = 1
		ending_row_index = 44

		entry_count = 0
		already_present = []

		(starting_row_index).upto(ending_row_index).each_with_index do |row, index|
			puts "Row: #{index + 1}"
			entry_count = entry_count + 1

			tag_name = sheet[sheet_index].sheet_data[row][1].present?? sheet[sheet_index].sheet_data[row][1].value.to_s.strip : nil

			tag_category_name = sheet[sheet_index].sheet_data[row][2].present?? sheet[sheet_index].sheet_data[row][2].value.to_s.strip : nil
			tag_category = TagCategory.where(category_name: tag_category_name).first
			tag_category_id = tag_category.id

			tag_image_url = sheet[sheet_index].sheet_data[row][3].present?? sheet[sheet_index].sheet_data[row][3].value.to_s.strip : nil
			tag_options = sheet[sheet_index].sheet_data[row][4].present?? sheet[sheet_index].sheet_data[row][4].value.to_s.strip : nil
			urdu = sheet[sheet_index].sheet_data[row][5].present?? sheet[sheet_index].sheet_data[row][5].value.to_s.strip : nil
			m_tag_id = sheet[sheet_index].sheet_data[row][6].present?? sheet[sheet_index].sheet_data[row][6].value.to_s.strip.to_i : nil
			m_category_id = sheet[sheet_index].sheet_data[row][7].present?? sheet[sheet_index].sheet_data[row][7].value.to_s.strip.to_i : nil
			tag_name_en = sheet[sheet_index].sheet_data[row][8].present?? sheet[sheet_index].sheet_data[row][8].value.to_s.strip.to_i : nil

			tag_name_record = Tag.where("lower(tag_name) = ?", tag_name.to_s.downcase).first
			if tag_name_record.present?
				already_present << tag_name
			else
				tag = Tag.create!(tag_name: tag_name, tag_category_id: tag_category_id, tag_image_url: tag_image_url, tag_options: tag_options, urdu: urdu, m_tag_id: m_tag_id, m_category_id: m_category_id, tag_name_en: tag_name_en)
			end
		end

		puts "Tag Created Successfully."
		puts already_present
	end

	desc "Import New Hospitals Data"
	task :import_new_hospitals => :environment do
		p "Starting Process..."
		p "Reading Excel File..."

		version = "v3"
		sheet = RubyXL::Parser.parse("doc/excel_files/base_data/#{version}/hospitals_data/Step_3.0_NewHospitalsData_New.xlsx")
		p "Creating/Updating Base Data..."

		sheet_index = 0
		starting_row_index = 1
		ending_row_index = 415

		entry_count = 0
		district_not_found = []
		hospital_already_present = []

		(starting_row_index).upto(ending_row_index).each_with_index do |row, index|
			puts "Row: #{index + 1}"
			entry_count = entry_count + 1

			district_name = sheet[sheet_index].sheet_data[row][1].present?? sheet[sheet_index].sheet_data[row][1].value.to_s.strip : nil
			hospital_name = sheet[sheet_index].sheet_data[row][2].present?? sheet[sheet_index].sheet_data[row][2].value.to_s.strip : nil
			category = sheet[sheet_index].sheet_data[row][3].present?? sheet[sheet_index].sheet_data[row][3].value.to_s.strip : nil
			facility = sheet[sheet_index].sheet_data[row][4].present?? sheet[sheet_index].sheet_data[row][5].value.to_s.strip : nil
			facility_type = sheet[sheet_index].sheet_data[row][5].present?? sheet[sheet_index].sheet_data[row][5].value.to_s.strip : nil

			# Find or Create District
			district = District.where("lower(district_name) = ?", district_name.to_s.downcase).first
			if district.present?
				hospital = Hospital.where("lower(hospital_name) = ?", hospital_name.to_s.downcase).first
				if hospital.present?
					hospital_already_present << { district_name: district_name, row: row, index: index, hospital_name: hospital_name }
				else
					hospital = district.hospitals.create!(hospital_name: hospital_name, category: category, facility: facility, facility_type: facility_type)
				end
			else
				district_not_found << { district_name: district_name, row: row, index: index }
			end
		end

		puts "Total Entry Count: #{entry_count}"
		puts "District Not Found Array"
		puts district_not_found
		puts "Hospital Already Present Array"
		puts hospital_already_present
		p "Process Completed."
	end

	desc "Import Old Hospitals Data"
	task :import_old_hospitals => :environment do
		p "Starting Process..."
		p "Reading Excel File..."

		version = "v3"
		sheet = RubyXL::Parser.parse("doc/excel_files/base_data/#{version}/hospitals_data/Step_3.1_OldHospitalsData.xlsx")
		p "Creating/Updating Base Data..."

		sheet_index = 0
		starting_row_index = 1
		ending_row_index = 1349

		entry_count = 0
		district_not_found = []
		hospital_already_present = []

		(starting_row_index).upto(ending_row_index).each_with_index do |row, index|
			puts "Row: #{index + 1}"
			entry_count = entry_count + 1

			hospital_id = sheet[sheet_index].sheet_data[row][1].present?? sheet[sheet_index].sheet_data[row][1].value.to_s.strip : nil
			hospital_name = sheet[sheet_index].sheet_data[row][2].present?? sheet[sheet_index].sheet_data[row][2].value.to_s.strip : nil
			address = sheet[sheet_index].sheet_data[row][3].present?? sheet[sheet_index].sheet_data[row][3].value.to_s.strip : nil
			status = sheet[sheet_index].sheet_data[row][4].present?? sheet[sheet_index].sheet_data[row][4].value.to_s.strip : nil
			district_name = sheet[sheet_index].sheet_data[row][5].present?? sheet[sheet_index].sheet_data[row][5].value.to_s.strip : nil
			code = sheet[sheet_index].sheet_data[row][6].present?? sheet[sheet_index].sheet_data[row][6].value.to_s.strip : nil
			facility_type = sheet[sheet_index].sheet_data[row][7].present?? sheet[sheet_index].sheet_data[row][7].value.to_s.strip : nil
			category = sheet[sheet_index].sheet_data[row][8].present?? sheet[sheet_index].sheet_data[row][8].value.to_s.strip : nil
			facility = sheet[sheet_index].sheet_data[row][9].present?? sheet[sheet_index].sheet_data[row][9].value.to_s.strip : nil

			# Find or Create District
			district = District.where("lower(district_name) = ?", district_name.to_s.downcase).first
			if district.present?
				hospital = Hospital.where("lower(hospital_name) = ?", hospital_name.to_s.downcase).first
				if hospital.present?
					hospital_already_present << { district_name: district_name, row: row, index: index, hospital_name: hospital_name }
				else
					hospital = district.hospitals.create!(hospital_name: hospital_name, category: category, facility: facility, facility_type: facility_type)
				end
			else
				district_not_found << { district_name: district_name, row: row, index: index }
			end
		end

		h_district_record = District.where(district_name: "Lahore").first
		h_district_record.hospitals.create!(hospital_name: "Home Treatment")

		puts "Total Entry Count: #{entry_count}"
		puts "District Not Found Array"
		puts district_not_found
		puts "Hospital Already Present Array"
		puts hospital_already_present
		p "Process Completed."
	end

	desc "Import Private Hospitals Data"
	task :import_private_hospitals => :environment do
		p "Starting Process..."
		p "Reading Excel File..."

		version = "v3"
		sheet = RubyXL::Parser.parse("doc/excel_files/base_data/#{version}/hospitals_data/Step_3.2_PrivateHospitalsData_New.xlsx")
		p "Creating/Updating Base Data..."

		sheet_index = 0
		starting_row_index = 1
		ending_row_index = 633

		entry_count = 0
		district_not_found = []
		hospital_already_present = []

		(starting_row_index).upto(ending_row_index).each_with_index do |row, index|
			puts "Row: #{index + 1}"
			entry_count = entry_count + 1

			district_name = sheet[sheet_index].sheet_data[row][1].present?? sheet[sheet_index].sheet_data[row][1].value.to_s.strip : nil
			hospital_name = sheet[sheet_index].sheet_data[row][2].present?? sheet[sheet_index].sheet_data[row][2].value.to_s.strip : nil
			category = sheet[sheet_index].sheet_data[row][3].present?? sheet[sheet_index].sheet_data[row][3].value.to_s.strip : nil
			facility_type = sheet[sheet_index].sheet_data[row][4].present?? sheet[sheet_index].sheet_data[row][4].value.to_s.strip : nil
			facility = sheet[sheet_index].sheet_data[row][5].present?? sheet[sheet_index].sheet_data[row][5].value.to_s.strip : nil

			# Find or Create District
			district = District.where("lower(district_name) = ?", district_name.to_s.downcase).first
			if district.present?
				hospital = Hospital.where("lower(hospital_name) = ?", hospital_name.to_s.downcase).first
				if hospital.present?
					hospital_already_present << { district_name: district_name, row: row, index: index, hospital_name: hospital_name }
				else
					hospital = district.hospitals.create!(hospital_name: hospital_name, category: category, facility: facility, facility_type: facility_type)
				end
			else
				district_not_found << { district_name: district_name, row: row, index: index }
			end
		end

		puts "Total Entry Count: #{entry_count}"
		puts "District Not Found Array"
		puts district_not_found
		puts "Hospital Already Present Array"
		puts hospital_already_present
		p "Process Completed."
	end

	desc "Import Labs Data"
	task :import_labs => :environment do
		p "Starting Process..."
		p "Reading Excel File..."

		version = "v3"
		sheet = RubyXL::Parser.parse("doc/excel_files/base_data/#{version}/labs_data/Step_7_LabsData.xlsx")
		p "Creating/Updating Base Data..."

		sheet_index = 0
		starting_row_index = 1
		ending_row_index = 1026

		entry_count = 0
		district_not_found = []
		lab_already_present = []

		(starting_row_index).upto(ending_row_index).each_with_index do |row, index|
			puts "Row: #{index + 1}"
			entry_count = entry_count + 1

			lab_id = sheet[sheet_index].sheet_data[row][1].present?? sheet[sheet_index].sheet_data[row][1].value.to_s.strip : nil
			lab_name = sheet[sheet_index].sheet_data[row][2].present?? sheet[sheet_index].sheet_data[row][2].value.to_s.strip : nil
			address = sheet[sheet_index].sheet_data[row][3].present?? sheet[sheet_index].sheet_data[row][3].value.to_s.strip : nil
			status = sheet[sheet_index].sheet_data[row][4].present?? sheet[sheet_index].sheet_data[row][4].value.to_s.strip : nil
			district_name = sheet[sheet_index].sheet_data[row][5].present?? sheet[sheet_index].sheet_data[row][5].value.to_s.strip : nil
			code = sheet[sheet_index].sheet_data[row][6].present?? sheet[sheet_index].sheet_data[row][6].value.to_s.strip : nil
			lab_type = sheet[sheet_index].sheet_data[row][7].present?? sheet[sheet_index].sheet_data[row][7].value.to_s.strip : nil

			# Find or Create District
			district = District.where("lower(district_name) = ?", district_name.to_s.downcase).first
			if district.present?
				lab = Lab.where("lower(lab_name) = ?", lab_name.to_s.downcase).first
				if lab.present?
					lab_already_present << { district_name: district_name, row: row, index: index, lab_name: lab_name }
				else
					lab = district.labs.create!(lab_name: lab_name, lab_type: lab_type)
				end
			else
				district_not_found << { district_name: district_name, row: row, index: index }
			end
		end

		puts "Total Entry Count: #{entry_count}"
		puts "District Not Found Array"
		puts district_not_found
		puts "Lab Already Present Array"
		puts lab_already_present
		p "Process Completed."
	end

	desc "Import Departments Data With Tags"
	task :import_departments_with_tags => :environment do
		p "Starting Process..."
		p "Reading Excel File..."

		version = "v3"
		sheet = RubyXL::Parser.parse("doc/excel_files/base_data/#{version}/departments_data/Step_4_DepartmentsData.xlsx")
		p "Creating/Updating Base Data..."

		sheet_index = 0
		starting_row_index = 1
		ending_row_index = 180

		entry_count = 0
		tag_not_found = []
		department_tag_already_present = []

		(starting_row_index).upto(ending_row_index).each_with_index do |row, index|
			puts "Row: #{index + 1}"
			entry_count = entry_count + 1

			# Get Data From Excel
			department_name = sheet[sheet_index].sheet_data[row][1].present?? sheet[sheet_index].sheet_data[row][1].value.to_s.strip : nil
			department_type = sheet[sheet_index].sheet_data[row][2].present?? sheet[sheet_index].sheet_data[row][2].value.to_s.strip : nil
			tag_name = sheet[sheet_index].sheet_data[row][3].present?? sheet[sheet_index].sheet_data[row][3].value.to_s.strip : nil

			# Find or Create Department
			department = Department.where("lower(department_name) = ? and department_type = ?", department_name.to_s.downcase, department_type).first
			if department.present?
				department = department
			else
				department = Department.create!(department_name: department_name, department_type: department_type)
			end

			# Assign Tags
			if tag_name == "All Tags"
				# Assign All Tags to Department
				Tag.all.each_with_index do |tag|
					department_tag = DepartmentTag.where(department_id: department.id, tag_id: tag.id).first
					if department_tag.present?
						department_tag_already_present << { department_tag_id: department_tag.id, row: row, index: index }
					else
						department_tag = DepartmentTag.create!(department_id: department.id, tag_id: tag.id)
					end
				end
			else
				# Assign Selected Tag to Department
				tag = Tag.where("lower(tag_name) = ?", tag_name.to_s.downcase).first
				if tag.present?
					department_tag = DepartmentTag.where(department_id: department.id, tag_id: tag.id).first
					if department_tag.present?
					department_tag_already_present << { department_tag_id: department_tag.id, row: row, index: index }
					else
					department_tag = DepartmentTag.create!(department_id: department.id, tag_id: tag.id)
					end
				else
					tag_not_found << tag_name
				end
			end
		end

		puts "Total Entry Count: #{entry_count}"
		puts department_tag_already_present
		puts tag_not_found.uniq.sort
		puts "DepartmentTag Already Present Count: (#{department_tag_already_present.count})"
		puts "Tag Not Found Count: (#{tag_not_found.uniq.count}/#{tag_not_found.count})"
		p "Process Completed."
	end

	desc "Create Web Users"
  	task :create_web_users => :environment do
  		p "Starting Process..."
		p "Reading Excel File..."

		version = "v3"
		# sheet = RubyXL::Parser.parse("doc/excel_files/base_data/#{version}/web_users_data/Step_5.0_WebUsersData.xlsx")
		sheet = RubyXL::Parser.parse("doc/excel_files/base_data/#{version}/web_users_data/V4.xlsx")
		p "Creating Web Users..."

		sheet_index = 0
		starting_row_index = 1
		ending_row_index = 2718

		districts_not_found = []
		tehsils_not_found = []
		departments_not_found = []
		hospitals_not_found = []
		labs_not_found = []

		entry_count = 0
		user_already_present = []
		mandatory_fields_missing = []

		(starting_row_index).upto(ending_row_index).each_with_index do |row, index|
			sr_no = sheet[sheet_index].sheet_data[row][0].present?? sheet[sheet_index].sheet_data[row][0].value.to_s.strip.to_i : nil
			# puts "Row: #{sr_no}"
			entry_count = entry_count + 1

			password = "12344321"

			user_id = sheet[sheet_index].sheet_data[row][1].present?? sheet[sheet_index].sheet_data[row][1].value.to_s.strip.to_i : nil
			username = sheet[sheet_index].sheet_data[row][2].present?? sheet[sheet_index].sheet_data[row][2].value.to_s.strip : nil
			district_name = sheet[sheet_index].sheet_data[row][3].present?? sheet[sheet_index].sheet_data[row][3].value.to_s.strip : nil
			tehsil_name = sheet[sheet_index].sheet_data[row][4].present?? sheet[sheet_index].sheet_data[row][4].value.to_s.strip : nil
			department_name = sheet[sheet_index].sheet_data[row][5].present?? sheet[sheet_index].sheet_data[row][5].value.to_s.strip : nil
			role = sheet[sheet_index].sheet_data[row][6].present?? sheet[sheet_index].sheet_data[row][6].value.to_s.strip : nil
			hospital_name = sheet[sheet_index].sheet_data[row][7].present?? sheet[sheet_index].sheet_data[row][7].value.to_s.strip : nil
			lab_name = sheet[sheet_index].sheet_data[row][8].present?? sheet[sheet_index].sheet_data[row][8].value.to_s.strip : nil

			district = District.where("lower(district_name) = ?", district_name.to_s.downcase).first
			tehsil = Tehsil.where("lower(tehsil_name) = ?", tehsil_name.to_s.downcase).first
			department = Department.where("lower(department_name) = ?", department_name.to_s.downcase).first
			hospital = Hospital.where("lower(hospital_name) = ?", hospital_name.to_s.downcase).first
			lab = Lab.where("lower(lab_name) = ?", lab_name.to_s.downcase).first

			dis_id = district.present?? district.id : 0
			teh_id = tehsil.present?? tehsil.id : 0
			dep_id = department.present?? department.id : 0
			hos_id = hospital.present?? hospital.id : 0
			lab_id = lab.present?? lab.id : 0

			user = User.where(username: username.downcase).first
			if user.present? or role == "divisional_user" or role == "hospital_user_private"
				user_already_present << user_id
			else
				if ["department_user", "dpc_user", "patient_department_user"].include? role
					if district.present? and department.present?
						User.create!(username: username, password: password, password_confirmation: password, role: role, department_id: dep_id, district_id: dis_id, tehsil_id: teh_id, hospital_id: hos_id, lab_id: lab_id)
					else
						puts "#{sr_no}-- Either District: #{district_name} or Department #{department_name} not found"
						mandatory_fields_missing << sr_no
					end

				# Create District User (District is mandatory for this user)
				elsif ["district_user"].include? role
					if district.present?
						User.create!(username: username, password: password, password_confirmation: password, role: role, department_id: dep_id, district_id: dis_id, tehsil_id: teh_id, hospital_id: hos_id, lab_id: lab_id)
					else
						puts "#{sr_no}--District: #{district_name} not found"
						mandatory_fields_missing << sr_no
					end

				# Create Tehsil User (District and Tehsil is mandatory for this user)
				elsif ["tehsil_user"].include? role
					if district.present? and tehsil.present?
						User.create!(username: username, password: password, password_confirmation: password, role: role, department_id: dep_id, district_id: dis_id, tehsil_id: teh_id, hospital_id: hos_id, lab_id: lab_id)
					else
						puts "#{sr_no}--Either District: #{district_name} or Tehsil #{tehsil_name} not found"
						mandatory_fields_missing << sr_no
					end

				# Create Hospital User
				elsif ["hospital_user", "hospital_supervisor"].include? role
					if district.present? and hospital.present?
						User.create!(username: username, password: password, password_confirmation: password, role: role, department_id: dep_id, district_id: dis_id, tehsil_id: teh_id, hospital_id: hos_id, lab_id: lab_id)
					else
						puts "#{sr_no}--Hospital: #{hospital_name} not found"
						mandatory_fields_missing << sr_no
					end

				# Create Lab User (District and Lab is mandatory for this user)
				elsif ["lab_user", "lab_supervisor"].include? role
					if district.present? and lab.present?
						User.create!(username: username, password: password, password_confirmation: password, role: role, department_id: dep_id, district_id: dis_id, tehsil_id: teh_id, hospital_id: hos_id, lab_id: lab_id)
					else
						puts "#{sr_no}--Either District: #{district_name} or Lab #{lab_name} not found"
						mandatory_fields_missing << sr_no
					end

				# Create Provisional Incharge User
				elsif ["provisional_incharge"].include? role
					User.create!(username: username, password: password, password_confirmation: password, role: role, department_id: dep_id, district_id: dis_id, tehsil_id: teh_id, hospital_id: hos_id, lab_id: lab_id)
				end
			end
		end

		puts mandatory_fields_missing
		puts "Mandatory Fields Missing: #{mandatory_fields_missing.count}"
	end

	desc "Create Hotspots Data"
	task :create_hotspots => :environment do
		p "Starting Process..."
		p "Reading Excel File..."

		version = "v3"
		sheet = RubyXL::Parser.parse("doc/excel_files/base_data/#{version}/hotspots/Step_9_Hotspots.xlsx")
		p "Creating Hotspots..."

		sheet_index = 0
		starting_row_index = 1
		ending_row_index = 84929

		entry_count = 0
		already_present = []

		(starting_row_index).upto(ending_row_index).each_with_index do |row, index|
			puts "Row: #{index + 1}"
			entry_count = entry_count + 1

			hotspot_name = sheet[sheet_index].sheet_data[row][3].present?? sheet[sheet_index].sheet_data[row][3].value.to_s.strip : nil
			district = sheet[sheet_index].sheet_data[row][4].present?? sheet[sheet_index].sheet_data[row][4].value.to_s.strip : nil
			tehsil = sheet[sheet_index].sheet_data[row][5].present?? sheet[sheet_index].sheet_data[row][5].value.to_s.strip : nil
			uc = sheet[sheet_index].sheet_data[row][6].present?? sheet[sheet_index].sheet_data[row][6].value.to_s.strip : nil
			address = sheet[sheet_index].sheet_data[row][7].present?? sheet[sheet_index].sheet_data[row][7].value.to_s.strip : nil
			tag = sheet[sheet_index].sheet_data[row][8].present?? sheet[sheet_index].sheet_data[row][8].value.to_s.strip : nil
			description = sheet[sheet_index].sheet_data[row][9].present?? sheet[sheet_index].sheet_data[row][9].value.to_s.strip : nil

			district_record = District.where("lower(district_name) = ?", district.to_s.downcase).first
			if district_record.present?
				district_id = district_record.id
			else
				district_id = nil
				district = nil
			end

			tehsil_record = Tehsil.where("lower(tehsil_name) = ?", tehsil.to_s.downcase).first
			if tehsil_record.present?
				tehsil_id = tehsil_record.id
			else
				tehsil_id = nil
				tehsil = nil
			end

			uc_record = Uc.where("lower(uc_name) = ?", uc.to_s.downcase).first
			if uc_record.present?
				uc_id = uc_record.id
			else
				uc_id = nil
				uc = nil
			end

			hotspot = Hotspot.create!(hotspot_name: hotspot_name, district: district, district_id: district_id, tehsil: tehsil, tehsil_id: tehsil_id, uc: uc, uc_id: uc_id, address: address, tag: tag, description: description)
			# hotspot_record = Hotspot.where("lower(hotspot_name) = ?", hotspot_name.to_s.downcase).first
			# if hotspot_record.present?
			# 	already_present << hotspot_name
			# else
			# 	hotspot = Hotspot.create!(hotspot_name: hotspot_name, district: district, district_id: district_id, tehsil: tehsil, tehsil_id: tehsil_id, uc: uc, uc_id: uc_id, address: address, tag: tag, description: description)
			# end
		end

		puts "Hotspots Created Successfully."
		puts already_present
	end

	desc "Create Mobile Users OF TPV"
  	task :create_mobile_users_tpv => :environment do
  		p "Starting Process..."
		p "Reading Excel File..."

		version = "v3"
		sheet = RubyXL::Parser.parse("doc/excel_files/base_data/#{version}/mobile_users_data/Step_6_MobileUsersData.xlsx")
		p "Creating Mobile Users of TPV..."

		sheet_index = 1
		starting_row_index = 1
		ending_row_index = 220

		entry_count = 0
		tehsil_not_found = []
		errors  = []
		(starting_row_index).upto(ending_row_index).each_with_index do |row, index|
			puts "Row: #{index + 1}"
			entry_count = entry_count + 1

			password = "12344321"
			begin
				user_id = sheet[sheet_index].sheet_data[row][1].present?? sheet[sheet_index].sheet_data[row][1].value.to_s.strip.to_i : nil
				username = sheet[sheet_index].sheet_data[row][2].present?? sheet[sheet_index].sheet_data[row][2].value.to_s.strip : nil
				district_name = sheet[sheet_index].sheet_data[row][3].present?? sheet[sheet_index].sheet_data[row][3].value.to_s.strip : nil
				tehsil_name = sheet[sheet_index].sheet_data[row][4].present?? sheet[sheet_index].sheet_data[row][4].value.to_s.strip : nil
				department_name = sheet[sheet_index].sheet_data[row][5].present?? sheet[sheet_index].sheet_data[row][5].value.to_s.strip : nil
				role = "TPV"

				district = District.where("lower(district_name) =?", district_name.try(:downcase)).first

				if tehsil_name == 'All'
					tehsil_ids = (district.present? and district.tehsils.present?) ? district.tehsils.map(&:id) : []
				else
					tehsil = Tehsil.where("lower(tehsil_name) =?", tehsil_name.try(:downcase)).first
					tehsil_ids =
					tehsil.present? ? [tehsil.id] : []
				end

				department = Department.where("lower(department_name) =?", department_name.try(:downcase)).first
				if department.present?
					department_id = department.id
				else
					department_id = 0
					puts "Department not exist = #{department_name}"
				end

				mob_user = {
					"username"=>"#{username}",
					"password"=>"#{password}",
					"password_confirmation"=>"#{password}",
					"department_id"=>"#{department_id}",
					"district_id"=>"#{district.try(:id)}",
					"role"=>"#{role}",
					"status"=>"true"
				}

				# puts "#{mob_user}"
				mobile_user = MobileUser.where(username: username).first

				if mobile_user.present?
					MobileUserTehsil.where(mobile_user_id: mobile_user.id).destroy_all
					mobile_user.delete
				end

				mobile_user = MobileUser.new(mob_user)
				if mobile_user.save(validate: false)
					tehsil_ids.each do |tehsil|
						MobileUserTehsil.create(mobile_user_id: mobile_user.id, tehsil_id: tehsil)
					end
					puts "saving.... ! #{index} = #{username} "
				else
					puts "====#{mobile_user.errors.full_message}"
					errors << mobile_user.id
				end
			rescue => error
				errors << error.inspect
			end
		end

		puts "Errors Found #{errors.count}"
		puts "#{errors}"
	end

	desc "Create Mobile Users OF ANTI DENGUE"
  	task :create_mobile_users_anti_dengue => :environment do
  		p "Starting Process..."
		p "Reading Excel File..."

		version = "v3"
		sheet = RubyXL::Parser.parse("doc/excel_files/base_data/#{version}/mobile_users_data/Step_6_MobileUsersData.xlsx")
		p "Creating Mobile Users of ANTI DENGUE..."

		sheet_index = 0
		starting_row_index = 1
		# ending_row_index = 200
		ending_row_index = 70884

		entry_count = 0
		tehsil_not_found = []
		errors  = []
		(starting_row_index).upto(ending_row_index).each_with_index do |row, index|
			puts "Row: #{index + 1}"
			entry_count = entry_count + 1

			password = "12344321"
			begin
				user_id = sheet[sheet_index].sheet_data[row][1].present?? sheet[sheet_index].sheet_data[row][1].value.to_s.strip.to_i : nil
				username = sheet[sheet_index].sheet_data[row][2].present?? sheet[sheet_index].sheet_data[row][2].value.to_s.strip : nil
				district_name = sheet[sheet_index].sheet_data[row][3].present?? sheet[sheet_index].sheet_data[row][3].value.to_s.strip : nil
				tehsil_name = sheet[sheet_index].sheet_data[row][4].present?? sheet[sheet_index].sheet_data[row][4].value.to_s.strip : nil
				department_name = sheet[sheet_index].sheet_data[row][5].present?? sheet[sheet_index].sheet_data[row][5].value.to_s.strip : nil
				category_names = sheet[sheet_index].sheet_data[row][6].present?? sheet[sheet_index].sheet_data[row][6].value.to_s.strip : nil

				role = "Anti Dengue"
				district = District.where("lower(district_name) =?", district_name.try(:downcase)).first

				if category_names.present?
					category_names_ar = category_names.split(",").collect{ |e| e ? e.strip.try(:downcase) : e }
					tag_categories_ids = TagCategory.where("lower(category_name) IN(?)", category_names_ar).map(&:id)
				else
					tag_categories_ids = []
				end

				if tehsil_name == 'All'
					tehsil_ids = (district.present? and district.tehsils.present?) ? district.tehsils.map(&:id) : []
				else
					tehsil = Tehsil.where("lower(tehsil_name) =?", tehsil_name.try(:downcase)).first
					tehsil_ids =
					tehsil.present? ? [tehsil.id] : []
				end

				department = Department.where("lower(department_name) =?", department_name.try(:downcase)).first
				if department.present?
					department_id = department.id
				else
					department_id = 0
					puts "Department not exist = #{department_name}"
				end

				mob_user = {
					"username"=>"#{username}",
					"password"=>"#{password}",
					"password_confirmation"=>"#{password}",
					"department_id"=>"#{department_id}",
					"district_id"=>"#{district.try(:id)}",
					"role"=>"#{role}",
					"status"=>"true"
				}

				# puts "#{mob_user}"
				mobile_user = MobileUser.where(username: username).first

				if mobile_user.present?
					MobileUserTehsil.where(mobile_user_id: mobile_user.id).destroy_all
					UserCategory.where(mobile_user_id: mobile_user.id).destroy_all
					mobile_user.delete
				end

				mobile_user = MobileUser.new(mob_user)
				if mobile_user.save(validate: false)
					tehsil_ids.each do |tehsil|
						MobileUserTehsil.create(mobile_user_id: mobile_user.id, tehsil_id: tehsil)
					end
					if tag_categories_ids.present?
						tag_categories_ids.each do |tag_category|
							UserCategory.create(mobile_user_id: mobile_user.id, tag_category_id: tag_category)
						end
					end
					puts "saving.... ! #{index} = #{username} "
				else
					puts "#{mobile_user.errors.full_messages}"
					errors << mobile_user.username
				end
			rescue => error
				errors << error.inspect
			end

		end

		puts "Errors Found #{errors.count}"
		puts "#{errors}"
	end

	desc "Create Hotspots Data"
	task :create_hotspots_v => :environment do
		p "Starting Process..."
		p "Reading Excel File..."

		version = "v3"
		sheet = RubyXL::Parser.parse("doc/excel_files/base_data/#{version}/hotspots/Missing Hotspot updated 1.3.xlsx")
		p "Creating Hotspots..."

		sheet_index = 0
		starting_row_index = 1
		ending_row_index = 6853

		entry_count = 0
		already_present = []

		(starting_row_index).upto(ending_row_index).each_with_index do |row, index|
			puts "Row: #{index + 1}"
			entry_count = entry_count + 1

			hotspot_name = sheet[sheet_index].sheet_data[row][3].present?? sheet[sheet_index].sheet_data[row][3].value.to_s.strip : nil
			district = sheet[sheet_index].sheet_data[row][4].present?? sheet[sheet_index].sheet_data[row][4].value.to_s.strip : nil
			tehsil = sheet[sheet_index].sheet_data[row][5].present?? sheet[sheet_index].sheet_data[row][5].value.to_s.strip : nil
			uc = sheet[sheet_index].sheet_data[row][6].present?? sheet[sheet_index].sheet_data[row][6].value.to_s.strip : nil
			address = sheet[sheet_index].sheet_data[row][7].present?? sheet[sheet_index].sheet_data[row][7].value.to_s.strip : nil
			tag = sheet[sheet_index].sheet_data[row][8].present?? sheet[sheet_index].sheet_data[row][8].value.to_s.strip : nil
			description = sheet[sheet_index].sheet_data[row][9].present?? sheet[sheet_index].sheet_data[row][9].value.to_s.strip : nil

			district_record = District.where("lower(district_name) = ?", district.to_s.downcase).first
			if district_record.present?
				district_id = district_record.id
			else
				district_id = nil
				district = nil
			end

			tehsil_record = Tehsil.where("lower(tehsil_name) = ?", tehsil.to_s.downcase).first
			if tehsil_record.present?
				tehsil_id = tehsil_record.id
			else
				tehsil_id = nil
				tehsil = nil
			end

			uc_record = Uc.where("lower(uc_name) = ?", uc.to_s.downcase).first
			if uc_record.present?
				uc_id = uc_record.id
			else
				uc_id = nil
				uc = nil
			end

			tag_record = Tag.where("lower(tag_name) = ?", tag.to_s.downcase).first
			if tag_record.present?
				tag_id = tag_record.id
			else
				tag_id = nil
				tag = nil
			end

			# hotspot = Hotspot.create!(hotspot_name: hotspot_name, district: district, district_id: district_id, tehsil: tehsil, tehsil_id: tehsil_id, uc: uc, uc_id: uc_id, address: address, tag: tag, description: description)
			hotspot_record = Hotspot.where("lower(hotspot_name) = ? and district_id = ? and tehsil_id = ?", hotspot_name.to_s.downcase, district_id,tehsil_id).first
			if hotspot_record.present?
				 already_present << hotspot_name
				# hotspot_record.update(tag: tag, tag_id: tag_id)
			else
				hotspot = Hotspot.create!(hotspot_name: hotspot_name, district: district, district_id: district_id, tehsil: tehsil, tehsil_id: tehsil_id, uc: uc, uc_id: uc_id, address: address, tag: tag, description: description, is_active: true, tag_id: tag_id)
			end
		end

		puts "Hotspots Created Successfully."
		puts already_present
	end



end
