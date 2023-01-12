namespace :update_labs_category do
    desc 'Update Lab Category ...'
    task :run => :environment do
        
        ## initially db clear all counts
        puts "Starting ....."

        errors = []
        Hospital.get_labs.each do |hospital|
            hospital.category = 'Lab'
            hospital.facility_type = 'Lab'
            if hospital.save
                puts "saved Labs"
            else
                errors << hospital.errors.full_messages
            end
        end
        puts "<<Errors>>"
        puts "#{errors}"
    end
end