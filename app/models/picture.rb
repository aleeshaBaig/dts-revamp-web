# == Schema Information
#
# Table name: pictures
#
#  id               :bigint           not null, primary key
#  before_picture   :string
#  after_picture    :string
#  pictureable_id   :integer
#  pictureable_type :string
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#
class Picture < ApplicationRecord
	## carrierwave
	mount_uploader :before_picture, PictureUploader
	mount_uploader :after_picture, PictureUploader
	## associations
	belongs_to :pictureable, :polymorphic => true
	
end
