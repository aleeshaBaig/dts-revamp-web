class GpSymptom < ApplicationRecord
    audited associated_with: :gp_dengue_patient
    belongs_to :gp_dengue_patient

    ## enums
    enum associate_symptom: { "Headche": 0, "Flu": 1, "Shoulder Pain": 2}
    ## validations
    validates :fever, presence: {message: "Fever can't be blank"}
    validates :fever_date, presence: {message: "Fever Date can't be blank"}, if: Proc.new{|f| f.fever?}
    validates :associate_symptom, presence: {message: "Associate Symptoms not exist" }
end
