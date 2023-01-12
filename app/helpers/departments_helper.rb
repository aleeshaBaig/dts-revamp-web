module DepartmentsHelper
	def tags_collections
		Tag.includes(:tag_category).all
	end
end
