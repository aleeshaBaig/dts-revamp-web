# == Schema Information
#
# Table name: labs
#
#  id          :bigint           not null, primary key
#  lab_name    :string
#  district_id :integer
#  lab_type    :string
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#
class Lab < ApplicationRecord
	belongs_to :district

	# FIlter Scopes
	# scope :district_id, ->(district_id_v) { where("labs.district_id = ?", "#{district_id_v}") }
	scope :lab_type, ->(lab_type_v) { where("lower(labs.lab_type) like ?", "#{lab_type_v.try(:downcase)}%") }

	validates :lab_name, presence: {message: "Lab Name can't be blank"}
	scope :filter_by_district_id, ->(data){data.present? ? (where("labs.district_id =?", data) ) : where("true")}
	scope :filter_by_district, ->(data){data.present? ? (where("labs.district_id =?", data) ) : where("true")}
	scope :filter_by_lab_id, ->(data){data.present? ? (where("labs.id =?", data) ) : where("true")}

end
