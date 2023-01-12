class CurrentAddress < ApplicationRecord
    audited associated_with: :gp_dengue_patient
    ## associations
    belongs_to :gp_dengue_patient
    belongs_to :district
    belongs_to :tehsil
    belongs_to :province, optional: true
    belongs_to :uc, optional: true

    ## trim white spaces
    auto_strip_attributes :address, squish: true

    ## callback functions
    before_save :auto_assign_province_id

    def auto_assign_province_id
        self.province_id = (self.district.present? ?  self.district.province.id : nil)
    end
end
