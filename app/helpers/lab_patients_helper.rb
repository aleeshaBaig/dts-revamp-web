module LabPatientsHelper
	def user_wise_districts
		districts = District.select("district_name").order('district_name asc').all
		return districts
	end

	def district_wise_tehsils(dist_id)
		if dist_id.present?
			tehsils = Tehsil.where("district_id = #{dist_id}").order("tehsil_name")
			return tehsils
		else
			return []
		end
	end

	def tehsil_wise_ucs(dist_id,teh_id)
		if dist_id.present? and teh_id.present?
			ucs = Uc.where("district_id = #{dist_id} and tehsil_id = #{teh_id}").order("uc_name")
			return ucs
		else
			return []
		end
	end	

	def lab_names
		# puts "=======#{current_user.get_hospitals_role_wise}"
	  return current_user.get_lab_name
	end
end
