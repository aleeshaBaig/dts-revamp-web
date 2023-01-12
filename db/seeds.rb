# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)
## tags options added
# PROVINCE DIVISION DISTRICT TOWN TEHSIL UC DATA 

=begin
	(1..2500).to_a.each do |i|
		MobileUser.create!({"username"=>"dummyuser#{i}", "password"=>"123456", "password_confirmation"=>"123456", "district_id"=>"1", "tehsil_id"=> "1" , "department_id"=>"1",  "role"=>"Anti Dengue"})
		puts "dummyuser#{i} created"
	end
=end

=begin
	  puts "Seed Started"
  # -----------------
  # Create Admin User
  # -----------------
  role = "admin"
  username = "admin"
  password = "admin@12"
  email = "admin@revamp-dashboard-tracking.pitb.gov.pk"
  user = User.create!(username: username, email: email, password: password, password_confirmation: password, role: role)
  puts "User #{user.username} Created"
=end

begin
  # ---------------
  # Create Province
  # ---------------
  province = Province.create!(province_name: "Punjab")
  puts "Province #{province.province_name} Created"

  # ---------------
  # Create Division
  # ---------------
  division = province.divisions.create!(division_name: "Lahore")
  puts "Division #{division.division_name} Created"

  # ---------------
  # Create District
  # ---------------
  district = division.districts.create!(district_name: "Lahore", province_id: province.id, division_name: division.division_name)
  puts "District #{district.district_name} Created"

  # -------------
  # Create Tehsil
  # -------------
  tehsil = district.tehsils.create!(tehsil_name: "Samanabad")
  puts "Tehsil #{tehsil.tehsil_name} Created"

  # ---------
  # Create UC
  # ---------
  uc = tehsil.ucs.create!(uc_name: "UC 1", district_id: district.id, province_id: province.id)
  puts "UC #{uc.uc_name} Created"

  # ---------------
  # Create Hospital
  # ---------------
  hospital = district.hospitals.create!(hospital_name: "Jinnah Hospital, Lahore", facility_type: "DHQ", category: "Public", province_id: province.id)
  puts "Hospital #{hospital.hospital_name} Created"

  # -------------------
  # Create Tag Category
  # -------------------
  m_category_id = 1
  category_name = "Larve"
  category_name_en = "Larve"
  category_name_ur = "Larve"
  tag_category = TagCategory.create!(category_name: category_name, category_name_en: category_name_en, urdu: category_name_ur, m_category_id: m_category_id)
  puts "Tag Category #{tag_category.category_name} Created"

  # ----------
  # Create Tag
  # ----------
  m_tag_id = 1
  tag_name = "Irs"
  tag_name_en = "Irs"
  tag_name_ur = "Irs"
  tag_options = "13"
  tag_image_url = "irs.png"
  tag = tag_category.tags.create!(tag_name: tag_name, tag_image_url: tag_image_url, tag_options: tag_options, urdu: tag_name_ur, m_tag_id: m_tag_id, m_category_id: m_category_id, tag_name_en: tag_name_en)
  puts "Tag #{tag.tag_name} Created"

  # # ------------------
  # # Create Mobile User
  # # ------------------
  # username = "mobile_user"
  # password_digest = "12345678"
  # role = "Anti Dengue"
  # active_status = true
  # department_id = 1
  # mobile_user = MobileUser.create!(username: username, password_digest: password_digest, role: role, district: district.district_name, district_id: district.id, tehsil: tehsil.tehsil_name, tehsil_id: tehsil.id, uc: uc.uc_name, uc_id: uc.id, department_id: department_id, status: active_status)
  # puts "MobileUser #{mobile_user.username} Created"

  puts "P.S: Create DepartmentTag entry manually. Department is not created due to many to many association."
  puts "P.S: Create Mobile User manually."

  puts "Seed Completed"
end

=begin
  p "Starting Process..."
  p "Reading Excel File for Base Data of Province, Division, District, Tehsil/Town and Union Counciles..."
  sheet = RubyXL::Parser.parse("doc/excel_files/base_data/Base_Data_Province_To_Union_Counciles_V1.xlsx")
  p "Creating/Updating Base Data..."

  sheet_index = 0
  starting_row_index = 1
  ending_row_index = 4242

  entry_count = 0

  (starting_row_index).upto(ending_row_index).each_with_index do |row, index|
  	puts "Row: #{index + 1}"
    entry_count = entry_count + 1

    province_name = sheet[sheet_index].sheet_data[row][1].present?? sheet[sheet_index].sheet_data[row][1].value.to_s.strip : nil
    division_name = sheet[sheet_index].sheet_data[row][2].present?? sheet[sheet_index].sheet_data[row][2].value.to_s.strip : nil
    district_name = sheet[sheet_index].sheet_data[row][3].present?? sheet[sheet_index].sheet_data[row][3].value.to_s.strip : nil
    tehsil_name = sheet[sheet_index].sheet_data[row][3].present?? sheet[sheet_index].sheet_data[row][3].value.to_s.strip : nil
    uc_name = sheet[sheet_index].sheet_data[row][3].present?? sheet[sheet_index].sheet_data[row][3].value.to_s.strip : nil

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
		uc = Tehsil.where("lower(uc_name) = ?", uc_name.to_s.downcase).first
    uc = uc.present?? uc : tehsil.ucs.create!(uc_name: uc_name, district_id: district.id)

  end

  puts "Total Entry Count: #{entry_count}"
  p "Process Completed."
=end

=begin
	e = RubyXL::Parser.parse("public/data/Base data.xlsx")

	(1).upto(4242).each do |i|

		if e[1].sheet_data[i][1].present?
			province = e[1].sheet_data[i][1].value.to_s.strip
		end

		if e[1].sheet_data[i][2].present?
			division = e[1].sheet_data[i][2].value.to_s.strip
		end

		if e[1].sheet_data[i][3].present?
			district = e[1].sheet_data[i][3].value.to_s.strip
		end

		if e[1].sheet_data[i][4].present?
			tehsil = e[1].sheet_data[i][4].value.to_s.strip
		end

		if e[1].sheet_data[i][5].present?
			uc = e[1].sheet_data[i][5].value.to_s.strip
		end


		p_record = Province.find_by_province_name(province)

	 	if p_record.present? 
	   		province_id = p_record.id
	   		puts "New province #{province} already present"
	 	else  
	   		new_p_case = Province.new(:province_name => province)
	   		if new_p_case.save
	   			province_id = new_p_case.id
	   			puts "New province #{province} created"
	   		end
	 	end

	 	div_record = Division.find_by_division_name(division)

	 	if div_record.present? 
	   		division_id = div_record.id
	   		puts "New division #{division} already present"
	 	else  
	   		new_div_case = Division.new(:division_name => division, :province_id => province_id)
	   		if new_div_case.save
	   			division_id = new_div_case.id
	   			puts "New division #{division} created"
	   		end
	 	end

	 	d_record = District.find_by_district_name(district)

	 	if d_record.present? 
	   		district_id = d_record.id
	   		puts "New district #{district} already present"
	 	else  
	   		new_d_case = District.new(:district_name => district, :province_id => province_id, :division_id => division_id)
	   		if new_d_case.save
	   			district_id = new_d_case.id
	   			puts "New district #{district} created"
	   		end
	 	end

	 	t_record = Tehsil.find_by_tehsil_name(tehsil)

	 	if t_record.present? 
	   		tehsil_id = t_record.id
	 	else  
	   		new_t_case = Tehsil.new(:tehsil_name => tehsil, :district_id => district_id)
	   		if new_t_case.save
	   			tehsil_id = new_t_case.id
	   			puts "New tehsil #{tehsil} created"
	   		end
	 	end
  
	   	new_uc_case = Uc.new(:uc_name => uc, :district_id => district_id, :tehsil_id => tehsil_id)

	   	if new_uc_case.save
	   		puts "New uc #{uc} created"
	   	end
	end
=end

# HOSPITAL DATA 
=begin
	e = RubyXL::Parser.parse("public/data/Base data.xlsx")

	(1).upto(3705).each do |i|

		if e[0].sheet_data[i][0].present?
			province = e[0].sheet_data[i][0].value.to_s.strip
		end

		if e[0].sheet_data[i][1].present?
			division = e[0].sheet_data[i][1].value.to_s.strip
		end

		if e[0].sheet_data[i][2].present?
			district = e[0].sheet_data[i][2].value.to_s.strip
		end

		if e[0].sheet_data[i][3].present?
			tehsil = e[0].sheet_data[i][3].value.to_s.strip
		end

		if e[0].sheet_data[i][4].present?
			hospital = e[0].sheet_data[i][4].value.to_s.strip
		end

		if e[0].sheet_data[i][5].present?
			h_category = e[0].sheet_data[i][5].value.to_s.strip
		end

		if e[0].sheet_data[i][6].present?
			h_type = e[0].sheet_data[i][6].value.to_s.strip
		end


		p_record = Province.find_by_province_name(province)

	 	if p_record.present? 
	   		province_id = p_record.id
	   		province_name = p_record.province_name
	   	end

	 	div_record = Division.find_by_division_name(division)

	 	if div_record.present? 
	   		division_id = div_record.id
	   		division_name = div_record.division_name
	 	end

	 	d_record = District.find_by_district_name(district)

	 	if d_record.present? 
	   		district_id = d_record.id
	   		district_name = d_record.district_name
	 	end

	 	t_record = Tehsil.find_by_tehsil_name(tehsil)

	 	if t_record.present? 
	   		tehsil_id = t_record.id
	   		tehsil_name = t_record.tehsil_name
	 	end
  	
  		hospital = Hospital.new(hospital_name: hospital, district_id: district_id, facility_type: h_type, category: h_category)
  		if hospital.save
  			puts "Hospital #{hospital} created"
  		else
  			puts "Hospital could not be created"
  		end
	end
=end

#DEPARTMENTS BASE DATA
=begin
	e = RubyXL::Parser.parse("public/data/Base data.xlsx")

	(1).upto(113).each do |i|
		if e[2].sheet_data[i][0].present?
			province = e[2].sheet_data[i][0].value.to_s.strip
		end

		if e[2].sheet_data[i][1].present?
			dept = e[2].sheet_data[i][1].value.to_s.strip
		end

		if dept.present?
			Department.create(department_name: dept)
			puts "Department #{dept} Created"
		end
	end
=end

## save mobile user temp
=begin
	 mobile_user = MobileUser.new(username: 'mobile_user', password: 'ubuntu1122', role: 'admin', department_id: Department.last.id, uc_id: Uc.first.id, district_id: Distict.first.id, tehsil_ids: ['1','2','3'])
	 mobile_user.save
	 UserCategory.create!(mobile_user_id: mobile_user.id, tag_category_id: TagCategory.first.id)
rescue Exception => e
	puts "===== #{e.inspect}"	
=end

## tags option
=begin
	#seed for tag options
	tag_options = ["CATEGORY_YES_NO_LARVAE", "CATEGORY_POSITIVE_NEGATIVE_LARVAE", "CATEGORY_INDOOR_OUTDOOR", "CATEGORY_PUBLIC_PRIVATE", "CATEGORY_PATIENT", "CATEGORY_YES_NO_MOSQUITO", "CATEGORY_POSITIVE_NEGATIVE_MOSQUITO", "CATEGORY_IS_INSPECTOR", "CATEGORY_GPS_LOCATION", "CATEGORY_IRS_PATIENT", "CATEGORY_LARVAE_TAGGING_CSR", "CATEGORY_POSITIVE_LARVAE"]
	tag_options.each do |t|
		TagOption.create(option_name: t)
		puts "Tag Option #{t} created"
	end
=end

## import urdu formate tag category and tags data
=begin
	file_data = JSON.parse(File.open("public/data/predefined_data.txt").read)
	data = file_data["data"]
	form_options = data["form_options"]
	form_options.each{|data| TagOption.create(m_option_id: data['option_id'], option_name: data["option_name"])}

	e = RubyXL::Parser.parse("public/data/BASE_DATA_FINAL2021.xlsx")
	_UPTO_ = 44

	(1).upto(_UPTO_).each do |i|
		(category_id  = e[0].sheet_data[i][2].value.to_s.strip) if e[0].sheet_data[i][2].present?
		(category_name  = e[0].sheet_data[i][3].value.to_s.strip) if e[0].sheet_data[i][3].present?
		category_name_en  = category_name
		(category_name_ur  = e[0].sheet_data[i][4].value.to_s.strip) if e[0].sheet_data[i][4].present?
		
		tag_category = TagCategory.new
		
		tag_category.category_name = category_name
		tag_category.category_name_en = category_name_en
		tag_category.urdu = category_name_ur
		tag_category.m_category_id = category_id
		tag_category.save
	end

	(1).upto(_UPTO_).each do |i|
		(tag_id = e[0].sheet_data[i][0].value.to_s.strip) if e[0].sheet_data[i][0].present?
		(tag_name  = e[0].sheet_data[i][1].value.to_s.strip) if e[0].sheet_data[i][1].present?
		(category_id  = e[0].sheet_data[i][2].value.to_s.strip) if e[0].sheet_data[i][2].present?
		(category_name  = e[0].sheet_data[i][3].value.to_s.strip) if e[0].sheet_data[i][3].present?
		(category_urdu  = e[0].sheet_data[i][4].value.to_s.strip) if e[0].sheet_data[i][4].present?
		(tag_name_ur  = e[0].sheet_data[i][5].value.to_s.strip) if e[0].sheet_data[i][5].present?

		(tag_image  = e[0].sheet_data[i][6].value.to_s.strip) if e[0].sheet_data[i][6].present?
		(tag_options  = e[0].sheet_data[i][7].value.to_s.strip) if e[0].sheet_data[i][7].present?

		tag_category = TagCategory.find_by_m_category_id(category_id)
		tag_category_id = tag_category.id
		m_category_id = tag_category.m_category_id

		tag_obj = Tag.new

    tag_obj.m_tag_id = tag_id
    tag_obj.tag_name = tag_name
    tag_obj.tag_name_en = tag_name
    tag_obj.urdu = tag_name_ur

    tag_obj.tag_category_id = tag_category_id
    tag_obj.m_category_id = m_category_id
    
    tag_obj.tag_image_url = tag_image
    tag_obj.tag_options = tag_options

    tag_obj.save
	end
=end

## tag updated
=begin
	t_h = {"1,2,11" => ["Ovi Trap", "Hotels"], "3,6,7" => ["Adult Mosquito"], "3" => ["Patient"], "1,2,3,8,11" => ["Larviciding", "Tyre Shops"], "2" => ["Fogging", "Garbage"], "9" => ["Patient IRS", "Patient Surveillance"], "1,2,8,11" => ["Junkyards", "Nursery", "Graveyards", "Mosques/ Religious Places/ Shrines", "Abandoned Buildings", "Factories", "Marriage Halls", "Godowns", "Swimming Pools", "Service Stations", "Water Ponding"], "1,2,4,11" => ["Schools"], "1,2,11" => ["Hotels"], "1,2,8" => ["Parks"]} 

	t_options = t_h.keys
	t_options.each do |t|
		tags = t_h[t]
		tags.each do |a|
			puts "====#{a}, #{t}"
			s_tag = Tag.where("lower(tag_name) = ? ", "#{a.downcase}").last
			if s_tag.present?
				s_tag.update_attributes(:tag_options => t)
				puts "Tag #{a} updated with #{t}"
			else
				puts"Tag #{a} not found"
			end

		end
		
	end
=end


# begin
# 	duplicate_row_values = Department.select('department_name, count(*)').group('department_name').having('count(*) > 1').pluck(:department_name)
# 	duplicate_row_values.each do |department_name|
# 		Department.where(department_name: department_name).order(id: :desc)[1..-1].map(&:destroy)
# 	end
# end

# begin
# 	dco_deps = Department.where("lower(department_name) like ?", "%dco%")
# 	non_dco_deps = Department.where("lower(department_name) not like ?", "%dco%")

# 	dco_deps.each do |d|
# 		d.update_attribute(:department_type, "DCO")
# 		puts "Department type DCO updated for department #{d.department_name}"
# 	end

# 	non_dco_deps.each do |d|
# 		d.update_attribute(:department_type, "Allied")
# 		puts "Department type Allied update for department #{d.department_name}"
# 	end
# end



=begin
  p "Starting Process..."
  p "Reading Excel File of Activities of District & Department Wise Count for Legacy System  ..."
  sheet = RubyXL::Parser.parse("doc/legacy_activities_district_department_wise_count v1.2.xlsx")
  p "Activities of District & Department wise Count..."


  sheet_index = 0
  starting_row_index = 1
  ending_row_index = 365142

  entry_count = 0

  error_a = []
  
  #not exist department
  not_dep = []
  not_dist = []

  (starting_row_index).upto(ending_row_index).each_with_index do |row, index|
  	puts "Row: #{index + 1}"
    entry_count = entry_count + 1

    act_count = sheet[sheet_index].sheet_data[row][0].present?? sheet[sheet_index].sheet_data[row][0].value.to_s.strip : nil
    created_at = sheet[sheet_index].sheet_data[row][1].present?? sheet[sheet_index].sheet_data[row][1].value.to_s.strip : nil
    district_name = sheet[sheet_index].sheet_data[row][2].present?? sheet[sheet_index].sheet_data[row][2].value.to_s.strip : nil
	department_name = sheet[sheet_index].sheet_data[row][3].present?? sheet[sheet_index].sheet_data[row][3].value.to_s.strip : nil
	
    # Find or Create District
    district = District.where("lower(district_name) = ?", district_name.to_s.downcase).first
	department = Department.where("lower(department_name) = ?", department_name.to_s.downcase).first
	
	if district.present? or department.present?
		act_date = Time.parse("#{created_at}").to_date
		district_id = district.try(:id)
		department_id = department.try(:id)

		
		LegacyActivity.create(district_id: district_id, department_id: department_id, act_date: act_date, count: act_count)

		puts "========== act acount #{act_count}"
		puts "========== created_at #{created_at}"
		puts "========== district_name #{district_name}"
		puts "========== department_name #{department_name}"
	
		# leg_act = LegacyActivity.where(district_id: district.id).last
		# if leg_act.present?
		# 	sum_act_count = leg_act.count + act_count
		# 	leg_act.update_attributes(count: sum_act_count)
		# else
		# 	LegacyActivity.create(district_id: district_id, act_date: act_date, count: act_count)
		# end
	else
		(not_dep << department_name) unless department.present?
		(not_dist << district_name) unless district.present?
		puts "=== not Added #{index}"
		error_a << "#{index+1}"
	end
  end

  puts "Total Entry Count: #{entry_count}"
  puts "Not Saved: Total Count: #{error_a.count}"
  puts "Not Saved Ids: #{error_a}"


  puts "not saved District"
  puts not_dist.uniq
  puts "not saved Department"
  puts not_dep.uniq

  p "Process Completed."
=end


# begin
# 		version = "v3"
# 		sheet = RubyXL::Parser.parse("doc/excel_files/base_data/#{version}/SED with  Attached Dept v1.1.xlsx")
# 		p "Creating Hotspots..."

# 		sheet_index = 0
# 		starting_row_index = 1
# 		ending_row_index = 59975

		
# 		already_present = []

# 		(starting_row_index).upto(ending_row_index).each_with_index do |row, index|
# 			# puts "Row: #{index + 1}"
			

# 			user_name = sheet[sheet_index].sheet_data[row][2].present?? sheet[sheet_index].sheet_data[row][2].value.to_s.strip : nil
# 			dept = sheet[sheet_index].sheet_data[row][5].present?? sheet[sheet_index].sheet_data[row][5].value.to_s.strip : nil

# 			dept_record = Department.where("lower(department_name) = ?", dept.to_s.downcase).first
# 			if dept_record.present?
# 				dept_id = dept_record.id
# 				user_record = MobileUser.where("username = ?", user_name.downcase).first
# 				if user_record.present?
# 					if dept_id.present?
# 						user_record.update(department_id: dept_id)
# 						puts "User #{user_record.username} updated"
# 						SimpleActivity.where("user_id = ?",user_record.id).each do |activity|
# 							activity.update(department_id: dept_id, department_name: dept)
# 						end
# 					else
# 						p "Dept not found"
# 					end
# 				else
# 					p "User not found with id:" + "#{user_name}"
# 				end
# 			else
# 				dept_id = nil
# 				dept = nil
# 			end
# 		end
# 		puts "Users Updated Successfully."
# end

=begin
	fac_types = ["Government", "Social Security"]
	hospitals = Hospital.where("facility_type IN (?)", fac_types)
	hospitals.each do |h|
		h.category = "Government"
		h.save
		puts "Hospital Category updated to govt"
	end

	fac_types = ["THQ", "BHU", "RHC", "DHQ"]
	hospitals = Hospital.where("facility_type IN (?)", fac_types)
	hospitals.each do |h|
		h.category = "P&SHD"
		h.save
		puts "Hospital Category updated to pshd"
	end

	fac_types = ["Private", "Teaching Hospital"]
	hospitals = Hospital.where("facility_type IN (?)", fac_types)
	hospitals.each do |h|
		h.category = "Private"
		h.save
		puts "Hospital Category updated to private"
	end

	fac_types = ["Tertiary Hospital"]
	hospitals = Hospital.where("facility_type IN (?)", fac_types)
	hospitals.each do |h|
		h.category = "SHC&MED"
		h.save
		puts "Hospital Category updated to shcmed"
	end

=end

=begin
	tags_indoor = ["Air Condition Water", "Leaking Water Taps", "Tire", "Flower Pots", "Container for Drinking Water", "Container for Washing", "Construction Debris", "Bird Pots", "Animal Pots", "Garbage", "Water Tanks", "Refrigerator Tray", "Main hole Cover", "House Stagnant Water", "Room Cooler", "Household Junk", "Roof Top Junk", "Other"]
	
	tags_indoor.each do |tag|
		SurveillanceTag.create!(tag_type: 'indoor', name: tag)
	end

	tags_outdoor = ["Road Side Bushes", "Park Bushes", "Tire", "Tree hole", "Garbage", "Construction Waste", "Flower Pots", "Bird Pots", "Air Cooler", "Air Conditioner Outlet", "Leaky Water Taps", "Water Tanks", "Open Gutter/ Drain", "Stagnant Water", "Water Pots at Puncture shop", "Roadside Fountains", "Ceramic Waste", "Other"]
	tags_outdoor.each do |tag|
		SurveillanceTag.create!(tag_type: 'outdoor', name: tag)
	end
=end

=begin
	PpeStock.where("ppe_name =?",'NS1').update_all(ppe_name: 'NS1 Rapid')
=end