# == Schema Information
#
# Table name: department_tags
#
#  id            :bigint           not null, primary key
#  department_id :integer
#  tag_id        :integer
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#
class DepartmentTag < ApplicationRecord
	belongs_to :department
	belongs_to :tag
	belongs_to :hotspot, :primary_key => 'tag_id', :foreign_key => "tag_id", :class_name => "Hotspot" , optional: true
end
