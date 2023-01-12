namespace :lab_to_patient_form do
    desc 'Lab To Patient Form'


    task :import_labs => :environment do
        ActiveRecord::Base.transaction do 
            Lab.all.each do |lab|
                puts "new#{lab.id}"
                hospital = Hospital.new(hospital_name: lab.lab_name, district_id: lab.district_id, facility_type: lab.lab_type, h_type: 'Lab')
                if hospital.save
                    lab_users = User.where(lab_id: lab.id)
                    if lab_users.update_all(lab_id: hospital.id)
                        puts "updates  labs"
                    else
                        puts "=========#{lab_users.errors.full_messages}"
                    end
                end
            end
        end
    end
end