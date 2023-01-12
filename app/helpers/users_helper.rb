module UsersHelper
	def districts_list
		data = []
		data = District.accessible_by(current_ability, :read).order('district_name asc')
		return data
	end
	def hospitals_list(district_id)
		data = []
		data = Hospital.get_hospitals.accessible_by(current_ability, :read).where(district_id: district_id).order('hospital_name asc') if district_id.present?
		return data
	end
	def labs_list(dist_id)
		if dist_id.present?
			dist_query = "district_id = #{dist_id}"
		else
			dist_query = "true"
		end
		labs = Lab.accessible_by(current_ability, :read).where("#{dist_query}").order("lab_name").collect { | l | [l.lab_name, l.id] }
		return labs
		
	end
	def hospital_labs(district_id)
		data = []
		data = Hospital.get_labs.accessible_by(current_ability, :read).where(district_id: district_id).order('hospital_name asc')
		return data
	end
	def labs_list_new(dist_id)
		if dist_id.present?
			dist_query = "district_id = #{dist_id}"
		else
			dist_query = "true"
		end
		labs = Hospital.get_labs.accessible_by(current_ability, :read).where("#{dist_query}").order("hospital_name").collect { | l | [l.hospital_name, l.id] }
		return labs
		
	end
	def users_roles
		data = []
		data = User.accessible_by(current_ability, :read).order('role asc')
		return data
	end
	def status_list
		return [["Active",true],["Inactive",false]]
	end
	def audit_status_list
		return [["Active",true],["Inactive",false]]
	end
	def surveillance_status_list
		return [["Active",true],["Inactive",false]]
	end
end
