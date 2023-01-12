module DashboardHelper
	def get_all_tags
		Tag.order(:tag_name)
	end
end
