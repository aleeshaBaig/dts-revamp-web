namespace :patient_beds do
    desc 'Patient Beds Generate ...'
    task :generate => :environment do
        
        ## initially db clear all counts
        puts "Starting ....."
        Bed.all.update_all(occupied_ward_beds: 0, occupied_hdu_beds: 0)
        puts "Reset Occupied Ward & HDU count 0"

        errors = []
        puts "Starting Seed Patient outcome Admitted"
        Patient.is_beds_patients.each_with_index do |patient, index|
            hospital_id = patient.hospital_id
            bed = Bed.find_by_hospital_id(hospital_id)
            bed = Bed.new(hospital_id: hospital_id) unless bed.present?

            provisional_diagnosis = patient.provisional_diagnosis
            patient_condition = patient.patient_condition

            if provisional_diagnosis == 'Confirmed'
                puts "<<provisional_diagnosis =#{provisional_diagnosis}>>"
                if patient_condition == 'Critical'
                    puts "Ocuupied HDU BEDS #{index}"
                    bed.occupied_hdu_beds = bed.occupied_hdu_beds + 1  ## go to stable condition
                elsif patient_condition == 'Stable'
                    puts "Ocuupied Ward BEDS #{index}"
                    bed.occupied_ward_beds = bed.occupied_ward_beds + 1 ## go to critical condition
                end
            elsif ['Probable', 'Suspected'].include?(provisional_diagnosis)
                puts "<<provisional_diagnosis =#{provisional_diagnosis}>>"
                puts "Ocuupied Ward BEDS #{index}"
                bed.occupied_ward_beds = bed.occupied_ward_beds + 1
            end
            
            
            if bed.save
                puts "saved"
            else
                errors << patient.id
                puts "not saved... #{bed.errors.full_messages}"
            end
        end
        puts "<<Errors>>"
        puts "#{errors}"
    end
end