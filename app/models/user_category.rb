# == Schema Information
#
# Table name: user_categories
#
#  id              :bigint           not null, primary key
#  mobile_user_id  :integer
#  tag_category_id :integer
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#
class UserCategory < ApplicationRecord
	belongs_to :mobile_user
	belongs_to :tag_category
end
