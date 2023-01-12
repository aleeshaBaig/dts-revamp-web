class GpForm < ApplicationRecord
    ## history save
	audited

    ## enums
    enum provisional_diagnosis: { "Non-Dengue": 0, "Probable": 1, "Suspected": 2, "Confirmed": 3}
    ## associations
    belongs_to :gp_dengue_user, optional: true
    has_one :picture, :as => :pictureable, :dependent => :destroy

    has_associated_audits
    ## validations
    validates :provisional_diagnosis, presence: {message: "Provisional Diagnosis not exist" }
    validates :gp_dengue_user_id, presence: {message: "User not exist" }
    validates :before_picture, presence: {message: "Pleaes Attach Picture" }, on: :update

	## scopes
	default_scope {order("gp_forms.id DESC")}
    scope :form_id, ->(data){where("gp_forms.id =?", data)}
    scope :provisional_diagnosis, ->(data){where("gp_forms.provisional_diagnosis =?", provisional_diagnoses["#{data}"])}
	scope :entered_by, ->(data){where("lower(gp_dengue_users.name) like ?", "%#{data.try(:downcase)}%" )}
    scope :datefrom, ->(data){data.present? ? (where("gp_forms.activity_time >= ?", data) ) : where("true")}
	scope :dateto, ->(data){data.present? ? (where("gp_forms.activity_time <= ?", data) ) : where("true")}


    def save_picture(m_before_picture = nil, m_after_picture = nil)
        if create_picture(before_picture: m_before_picture, after_picture: m_after_picture)
            return reload_picture
        end
        nil
    end
    # def before_picture
    #     picture.present? ? get_realtive_path_image(picture.before_picture.url) : ''
    # end
    # def after_picture
    #     picture.present? ? get_realtive_path_image(picture.after_picture.url) : ''
    # end
    
    def get_realtive_path_image(url)
        return url.present? ? "#{url}" : ""
    end
end
