class GpLabResult < ApplicationRecord
    audited associated_with: :gp_dengue_patient
    belongs_to :gp_dengue_patient

    ## enums
    enum warning_sign: { "Headche": 0, "Flu": 1, "Shoulder Pain": 2}
    ## validations
    validates :hct_first_reading, presence: {message: "HCT First Reading can't be blank"}
    validates :wbc_first_reading, presence: {message: "WBC First Reading can't be blank"}
    validates :platelet_first_reading, presence: {message: "Platelet First Reading can't be blank"}
    validates :warning_sign, presence: {message: "Warning Sign not exist" }

end
