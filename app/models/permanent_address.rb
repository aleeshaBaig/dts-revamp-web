class PermanentAddress < ApplicationRecord
    audited associated_with: :gp_dengue_patient
    ## associations
    belongs_to :gp_dengue_patient
    belongs_to :district
    belongs_to :tehsil
    belongs_to :uc

    ## trim white spaces
    auto_strip_attributes :address, squish: true
end
