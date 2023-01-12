# == Schema Information
#
# Table name: tag_options
#
#  id          :bigint           not null, primary key
#  option_name :string
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  m_option_id :integer
#
class TagOption < ApplicationRecord
	## callbacks
	before_save :titleize_data
		
	def titleize_data
		self.option_name = self.option_name.try(:upcase)
	end

end
