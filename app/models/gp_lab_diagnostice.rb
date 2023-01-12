class GpLabDiagnostice < ApplicationRecord
    audited associated_with: :gp_dengue_patient
    belongs_to :gp_dengue_patient

    ## enums
    enum dengue_fever_type: { "DF": 0, "DHF": 1, "DSS": 2}
    enum ns1: {"Positive": 0, "Negative": 1}, _prefix: :ns1_status
    enum pcr: {"Positive": 0, "Negative": 1}, _prefix: :pcr_status
    enum igm: {"Positive": 0, "Negative": 1}, _prefix: :igm_status
    enum igg: {"Positive": 0, "Negative": 1}, _prefix: :igg_status
    ## validations
    validates :ns1, presence: {message: "NS1 Ag can't be blank"}
    validates :pcr, presence: {message: "PCR Ag can't be blank"}
    validates :sero_type, presence: {message: "SeroType can't be blank"}
    validates :igm, presence: {message: "IGM AB can't be blank"}
    validates :igg, presence: {message: "IGG AB can't be blank"}

    validates :dengue_fever_type, presence: {message: "Dengue Fever not exist" }

end
