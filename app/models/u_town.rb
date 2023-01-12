# == Schema Information
#
# Table name: u_towns
#
#  id            :bigint           not null, primary key
#  name          :string
#  townable_id   :integer
#  townable_type :string
#  tehsil_id     :integer
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#
class UTown < ApplicationRecord
	## associations
	belongs_to :townable, :polymorphic => true
	belongs_to :tehsil

	## validations
	# validates :name, presence: true

	## remove extra spaces 
	# auto_strip_attributes :name, squish: true

	# ## callbacks
	before_save :save_tehsil_name
	
	def save_tehsil_name
		puts "======#{tehsil.tehsil_name}"
		(self.tehsil_name = tehsil.tehsil_name) rescue nil
	end

end
