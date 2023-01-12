namespace :import_gp_users do
    desc 'Import GP Users ...'
    task :run => :environment do
        
        errors = []
        created = []
        GpUser.all.each do |gp_user|
            gp_dengue_user = GpDengueUser.new
            gp_dengue_user.email = gp_user.email
            gp_dengue_user.password = "12344321"
            gp_dengue_user.password_confirmation = "12344321"
            gp_dengue_user.name = gp_user.doctor_name
            gp_dengue_user.clinic_name = gp_user.clinic
            gp_dengue_user.contact_no = gp_user.contact_no
            gp_dengue_user.pmdc_number = gp_user.pmdc_number
            gp_dengue_user.role = 'do'

            district_obj = District.where("lower(district_name) like ?", "%#{gp_user.district.try(:downcase)}%").last
            gp_dengue_user.district_id = district_obj.try(:id)
            gp_dengue_user.district_name = district_obj.try(:district_name)
            
            
            tehsil_obj = Tehsil.where("lower(tehsil_name) like ?", "%#{gp_user.tehsil.try(:downcase)}%").last
            gp_dengue_user.tehsil_id = tehsil_obj.try(:id)
            gp_dengue_user.tehsil_name = tehsil_obj.try(:tehsil_name)


            hospital_obj = Hospital.where("lower(hospital_name) like ?", "%#{gp_user.hospital.try(:downcase)}%").last
            gp_dengue_user.hospital_id = hospital_obj.try(:id)
            gp_dengue_user.hospital_name = hospital_obj.try(:tehsil_name)

            gp_dengue_user.address = gp_user.address
            gp_dengue_user.city_name = gp_user.city_name
            gp_dengue_user.lat = gp_user.lat.present? ?  gp_user.lat : '0.000000'
            gp_dengue_user.lng = gp_user.lng.present? ?  gp_user.lng : '0.000000'
            gp_dengue_user.is_logged_in = true


            if gp_dengue_user.save
                puts "#{gp_user.id}"
                created << gp_user.id
            else
                puts "Error: #{gp_dengue_user.errors.full_messages}"
                errors << gp_user.email
            end

        end

        puts ".......Stats ......"
        puts "Total created #{created.count}"
        puts "Not created #{errors.count}"
        puts "#{errors}"
    end
end