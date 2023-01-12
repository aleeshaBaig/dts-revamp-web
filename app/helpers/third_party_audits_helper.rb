module ThirdPartyAuditsHelper
	def get_username(id)
		if id.present? 
			begin
				MobileUser.find(id).try(:username)
			end
		end
	end
	def get_department_name(id)
		if id.present? 
			begin
				Department.find(id).try(:department_name)
			end
		end
	end
end
