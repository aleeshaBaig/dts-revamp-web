class ThirdPartyAuditsController < ApplicationController
	layout 'adminpanel'
	before_action :is_department_user?, only: %i(generate_report)
	## 3RD PARTY AUDIT
	def index
		flash[:message] = ''
			authorize! :read, PatientActivity
			
			if params[:datefrom].present? and params[:dateto].present?
				@result = []
				@tags = ["Patient Irs"]
				district_q = params[:district].present? ? "district_id = '#{params[:district]}'" : 'true'

				if is_patient_activity?
					if params[:town].present?
						@result = PatientActivity.accessible_by(current_ability, :read).group("district_name","created_at::date","tehsil_name").where("tehsil_id= ? and #{district_q} and tag_name IN (?) and created_at::DATE >= ? AND created_at::DATE <= ? and provisional_diagnosis = ? and patient_place != 0",params[:town], @tags, params[:datefrom].to_date,params[:dateto].to_date, 3).order("created_at::date DESC").count
					elsif params[:department].present?
						@result = PatientActivity.accessible_by(current_ability, :read).group("district_name","created_at::date","department_name").where("department_id = ? and #{district_q} and tag_name IN (?) and created_at::DATE >= ? AND created_at::DATE <= ? and provisional_diagnosis = ? and patient_place != 0", params[:department], @tags, params[:datefrom].to_date,params[:dateto].to_date, 3).order("created_at::date DESC").count
					end
					
					authorize! :read, PatientActivity

				elsif params[:type] == "rest"
					if params[:town].present?
						@result = SimpleActivity.accessible_by(current_ability, :read).is_larva_found.positive.group("district_name","created_at::date","tehsil_name").where("tehsil_id = ? and #{district_q} and created_at::DATE >= ? AND created_at::DATE <= ?",params[:town], params[:datefrom].to_date, params[:dateto].to_date).order("created_at::date DESC").count
					elsif params[:department].present?
						@result = SimpleActivity.accessible_by(current_ability, :read).is_larva_found.positive.group("district_name","created_at::date","department_name").where("department_id = ? and #{district_q} and created_at::DATE >= ? AND created_at::DATE <= ?",params[:department], params[:datefrom].to_date, params[:dateto].to_date).order("created_at::date DESC").count
					end

					authorize! :read, SimpleActivity

				elsif params[:type] == "indoor"
					if params[:town].present?
						@result = SimpleActivity.accessible_by(current_ability, :read).group("district_name","created_at::date","tehsil_name").where("tehsil_id = ? and #{district_q} and created_at::DATE >= ? AND created_at::DATE <= ? and io_action =? AND tag_name NOT IN (?)", params[:town], params[:datefrom].to_date,params[:dateto].to_date, '0', @tags).order("created_at::date DESC").count
					elsif params[:department].present?
						@result = SimpleActivity.accessible_by(current_ability, :read).group("district_name","created_at::date","department_name").where("department_id = ? and #{district_q} and created_at::DATE >= ? AND created_at::DATE <= ? and io_action =? AND tag_name NOT IN (?)", params[:department], params[:datefrom].to_date,params[:dateto].to_date, '0', @tags).order("created_at::date DESC").count
					end

					authorize! :read, SimpleActivity

				elsif params[:type] == "outdoor"
					if params[:town].present?
						@result = SimpleActivity.accessible_by(current_ability, :read).group("district_name","created_at::date","tehsil_name").where("tehsil_id = ? and #{district_q} and created_at::DATE >= ? AND created_at::DATE <= ? and io_action =? AND tag_name NOT IN (?)", params[:town], params[:datefrom].to_date,params[:dateto].to_date, '1', @tags).order("created_at::date DESC").count
					elsif params[:department].present?
						@result = SimpleActivity.accessible_by(current_ability, :read).group("district_name","created_at::date","department_name").where("department_id = ? and #{district_q} and created_at::DATE >= ? AND created_at::DATE <= ? and io_action =? AND tag_name NOT IN (?)", params[:department], params[:datefrom].to_date,params[:dateto].to_date, '1', @tags).order("created_at::date DESC").count
					end
				end
			end
	end
	def generate_report
		authorize! :read, PatientActivity
		
		params[:district] = District.find_by_district_name(params[:district]).id if params[:district].present?
		params[:town] = Tehsil.select(:id).where("lower(tehsil_name) =?", params[:town].try(:downcase)).last.id if params[:town].present?
		params[:department] = Department.find_by_department_name(params[:department]).id if params[:department].present?

		activity_type = :simple_activity
		@result = []
		@tags = ["Patient Irs"]
		@activity_wise_type = {}
		
		if params[:town].present?
			tpv_audit = TpvAudit.accessible_by(current_ability, :read).where("tehsil_id = ? and audit_date::DATE = ? and audit_type =?", params[:town], params[:datefrom].to_date, params[:type])
			tpv_audit = tpv_audit.where("user_id =?", current_user.id)
		elsif params[:department].present?
			tpv_audit = TpvAudit.accessible_by(current_ability, :read).where("department_id = ? and audit_date::DATE = ? and audit_type =?", params[:department], params[:datefrom].to_date, params[:type])
			tpv_audit = tpv_audit.where("user_id =?", current_user.id)
		end

		if tpv_audit.present?
			tpv_audit.each{|ta| @activity_wise_type["#{ta.dep_category}"] = ta.activity_ids.split(",") }
			
			ids = tpv_audit.first.activity_ids
			ids = ids + tpv_audit.second.activity_ids if tpv_audit.second.present?

			id_array = ids.split(",")
			flash[:message] = "Audit record already created for selected date and town"
			if is_patient_activity?
				activity_type = :patient_activity
				@result = PatientActivity.accessible_by(current_ability, :read).where("id IN (?)", id_array)
			else
				if params[:type] == "rest"
					@result = SimpleActivity.accessible_by(current_ability, :read).is_larva_found.positive.where("id IN (?)", id_array)
				else
					@result = SimpleActivity.accessible_by(current_ability, :read).where("id IN (?)", id_array)
				end
			end
		else
			if is_patient_activity?
				activity_type = :patient_activity
				if params[:town].present?
					@result = PatientActivity.accessible_by(current_ability, :read).where("tehsil_id = ? and district_id = ? and tag_name IN (?) and created_at::DATE between ? and ? and provisional_diagnosis = ? and patient_place != 0", params[:town], params[:district], @tags, params[:datefrom].to_date, params[:datefrom].to_date, 3).order("RANDOM()")
				elsif params[:department].present?
					@result = PatientActivity.accessible_by(current_ability, :read).where("department_id = ? and district_id = ? and tag_name IN (?) and created_at::DATE between ? and ? and provisional_diagnosis = ? and patient_place != 0", params[:department], params[:district], @tags, params[:datefrom].to_date, params[:datefrom].to_date, 3).order("RANDOM()")
				end
			elsif params[:type] == "rest"
				if params[:town].present?
					@result = SimpleActivity.accessible_by(current_ability, :read).is_larva_found.positive.where("tehsil_id = ? and district_id = ? and tag_name NOT IN (?) and created_at::DATE between ? and ?", params[:town], params[:district], @tags, params[:datefrom].to_date, params[:datefrom].to_date).order("RANDOM()")
				elsif params[:department].present?
					@result = SimpleActivity.accessible_by(current_ability, :read).is_larva_found.positive.where("department_id= ? and district_id = ? and tag_name NOT IN (?) and created_at::DATE between ? and ?", params[:department], params[:district], @tags, params[:datefrom].to_date, params[:datefrom].to_date).order("RANDOM()")
				end
			elsif params[:type] == "indoor"
				if params[:town].present?
					@result = SimpleActivity.accessible_by(current_ability, :read).where("tehsil_id = ? and district_id = ? and tag_name NOT IN (?) and created_at::DATE between ? and ? and io_action =?", params[:town], params[:district], @tags, params[:datefrom].to_date, params[:datefrom].to_date, 0).order("RANDOM()")
				elsif params[:department].present?
					@result = SimpleActivity.accessible_by(current_ability, :read).where("department_id= ? and district_id = ? and tag_name NOT IN (?) and created_at::DATE between ? and ? and io_action =?", params[:department], params[:district], @tags, params[:datefrom].to_date, params[:datefrom].to_date, 0).order("RANDOM()")
				end
			elsif params[:type] == "outdoor"
				if params[:town].present?
					@result = SimpleActivity.accessible_by(current_ability, :read).where("tehsil_id = ? and district_id = ? and tag_name NOT IN (?) and created_at::DATE between ? and ? and io_action =?", params[:town], params[:district], @tags, params[:datefrom].to_date, params[:datefrom].to_date, 1).order("RANDOM()")
				elsif params[:department].present?
					@result = SimpleActivity.accessible_by(current_ability, :read).where("department_id = ? and district_id = ? and tag_name NOT IN (?) and created_at::DATE between ? and ? and io_action =?", params[:department], params[:district], @tags, params[:datefrom].to_date, params[:datefrom].to_date, 1).order("RANDOM()")
				end
			end
			tpv_activity_ids = tpv_audit.map(&:activity_ids)
			if tpv_activity_ids.present?
				activities_ids = @result.map(&:id)
				ids = activities_ids - tpv_activity_ids
				@result = @result.where("id IN(?)", ids)
			end
			if @result.present?
				if @result.size > 10
					if params[:type] == "indoor" or params[:type] == "outdoor"
						num = @result.size / 25
					else
						num = @result.size / 5
					end
					
					num = (num - 1).to_i
					@result = @result[0..num]
				else
					num = @result.size
				end
			end

			agri_ids = ""
			lgcd_ids = ""
			
			if @result.present?
				divid_results = (@result.count/2.0).round
			
				@result[0..(divid_results-1)].each do |r|
					agri_ids = agri_ids + r.id.to_s + ","
				end
				@result[divid_results..(@result.size-1)].each do |r|
					lgcd_ids = lgcd_ids + r.id.to_s + ","
				end
			
				agri_ids = agri_ids[0..agri_ids.length-2]
				lgcd_ids = lgcd_ids[0..lgcd_ids.length-2]
				
				@activity_wise_type["Agriculture"] = agri_ids.split(",")
				@activity_wise_type["LGCD"] = lgcd_ids.split(",")

				if agri_ids.present?
					TpvAudit.create(:tehsil_id => params[:town], :district_id => params[:district], :audit_date => params[:datefrom].to_date, :dep_category => 'Agriculture', :activity_ids => agri_ids, :department_id => params[:department], :audit_type => params[:type], activity_type: activity_type, user_id: current_user.id, user_department_id: current_user.department_id)
				end
				if lgcd_ids.present?
					TpvAudit.create(:tehsil_id => params[:town], :district_id => params[:district], :audit_date => params[:datefrom].to_date, :dep_category => 'LGCD', :activity_ids => lgcd_ids, :department_id => params[:department], :audit_type => params[:type], activity_type: activity_type, user_id: current_user.id, user_department_id: current_user.department_id)
				end
			else
				flash[:message] = "Audit record already created for selected date and town/department"
			end
		end
			# puts "=======#{flash[:message]}"
			# redirect_back(fallback_location: root_path)
	end
	
	## AUDIT REPORT
	def audit_report

			if params[:pagination] == "No"
				@per_page = 100000
			else
				@per_page = 20
			end
			
			if params[:type].present? and params[:type] == "rest"
				
				if params[:response].present?
					if params[:response] == "satisfactory"
						response_str = "AND larvae_auditeds.larviciding is true"
					elsif params[:response] == "noncompliance"
						response_str = "AND larvae_auditeds.larviciding is not true"
					else
						response_str = "AND true"
					end
				else
					response_str = "AND true"
				end

				@result = LarvaeAudited.paginate_by_sql("SELECT larvae_auditeds.lat as latitude, larvae_auditeds.lng as longitude, larvae_auditeds.simple_activity_id as activity_id, CAST(larvae_auditeds.created_at as DATE) as a_date, activities.tehsil_name, activities.uc_name, larvae_auditeds.larviciding as larviciding, larvae_auditeds.comments, users.username as auditor, users.department_id as auditor_dep, activities.user_id as auditee, activities.department_name as auditee_dep, larvae_auditeds.larvae_found, larvae_auditeds.larvae_found_before, larvae_auditeds.larviciding_type, larvae_auditeds.remarks,visited_before, visit_adjacent_house, mechanical_option, larvaciding_conducted, mechanical_option, biological_selected, larva_found_from, chemical_selected, awareenss_session, mechanical_selected, last_visited, supervisor_visited, activities.district_name FROM larvae_auditeds INNER JOIN simple_activities as activities on larvae_auditeds.simple_activity_id = activities.id INNER JOIN mobile_users as users on users.id = larvae_auditeds.mobile_user_id WHERE #{((params[:town].present?)? ('activities.tehsil_id = ' + '\'' + params[:town].to_s + '\'') : 'true')} and #{((params[:district].present?)? ('activities.district_id = ' + '\'' + params[:district].to_s.downcase + '\'') : 'true')} and #{((params[:department].present?)? ('activities.department_id = ' + '\'' + params[:department].to_s + '\'') : 'true')} AND #{((params[:from].present?)? ('larvae_auditeds.created_at::DATE >= ' + '\'' + params[:from].to_date.to_s + '\'') : 'true')} AND #{((params[:to].present?)? ('larvae_auditeds.created_at::DATE <= ' + '\'' + (params[:to].to_date).to_s + '\'') : 'true') } #{response_str} ORDER BY larvae_auditeds.created_at DESC", :page => params[:page], :per_page => @per_page)
				elsif(params[:type].present? and params[:type] == "cr")
					if params[:response].present?
						if params[:response] == "satisfactory"
							response_str = "AND patient_auditeds.conduction_place is true AND patient_auditeds.sop_followed is true"
						elsif params[:response] == "noncompliance"
							response_str = "AND (patient_auditeds.conduction_place is not true OR patient_auditeds.sop_followed is not true)"
						end
					else
						response_str = "AND true"
					end
					@result = PatientAudited.paginate_by_sql("SELECT patient_auditeds.lat as latitude, patient_auditeds.lng as longitude, patient_auditeds.patient_activity_id as activity_id, CAST(patient_auditeds.created_at as DATE) as a_date, activities.tehsil_name, activities.uc_name, patient_auditeds.conduction_place as conduction_place, patient_auditeds.sop_followed as sop_followed, patient_auditeds.comments, users.username as auditor, users.department_id as auditor_dep, activities.user_id as auditee, activities.department_name as auditee_dep,patient_auditeds.larvae_found, patient_auditeds.response_conducted_at_place,visited_before, visit_adjacent_house, mechanical_option, larvaciding_conducted, mechanical_option, biological_selected, larva_found_from, chemical_selected, awareenss_session, mechanical_selected, last_visited, supervisor_visited, activities.district_name FROM patient_auditeds INNER JOIN patient_activities as activities on patient_auditeds.patient_activity_id = activities.id INNER JOIN mobile_users as users on users.id = patient_auditeds.mobile_user_id WHERE #{((params[:town].present?)? ('activities.tehsil_id = ' + '\'' + params[:town].to_s + '\'') : 'true')} and #{((params[:district].present?)? ('activities.district_id = ' + '\'' + params[:district].to_s + '\'') : 'true')} and #{((params[:department].present?)? ('activities.department_id = ' + '\'' + params[:department].to_s + '\'') : 'true')} AND #{((params[:from].present?)? ('patient_auditeds.created_at::DATE >= ' + '\'' + params[:from].to_date.to_s + '\'') : 'true')} AND #{((params[:to].present?)? ('patient_auditeds.created_at::DATE <= ' + '\'' + (params[:to].to_date).to_s + '\'') : 'true') } #{response_str} ORDER BY patient_auditeds.created_at DESC", :page => params[:page], :per_page => @per_page)
				elsif params[:type].present? and (params[:type] == "indoor" or params[:type] == "outdoor")
					if params[:response].present?
						if params[:response] == "satisfactory"
							response_str = "AND surveillance_audits.visited_before is true AND surveillance_audits.material_provided is true AND surveillance_audits.no_of_containers_checked > 0 AND time_taken = 2 AND larva_found is false AND (rooftop_checked is true or rooftop_checked IS NULL)"
						elsif params[:response] == "noncompliance"
							response_str = "AND (surveillance_audits.visited_before is not true OR surveillance_audits.material_provided is not true OR surveillance_audits.no_of_containers_checked = 0 OR rooftop_checked is not true OR rooftop_checked is not NULL AND time_taken < 2 OR larva_found is not true)"
						end
					else
						response_str = " AND true"
					end
					if params[:type] == "indoor"
						indoor_str = "surveillance_audits.is_indoor is true"
					elsif params[:type] == "outdoor"
						indoor_str = "surveillance_audits.is_indoor is false"
					end
					@result = SurveillanceAudit.paginate_by_sql("SELECT surveillance_audits.*, surveillance_audits.lat as latitude, surveillance_audits.lng as longitude, surveillance_audits.simple_activity_id as activity_id, surveillance_audits.remarks as comments, CAST(surveillance_audits.created_at as DATE) as a_date, activities.tehsil_name, activities.uc_name, users.username as auditor, users.department_id as auditor_dep, activities.user_id as auditee, activities.department_name as auditee_dep, activities.district_name FROM surveillance_audits INNER JOIN simple_activities as activities on surveillance_audits.simple_activity_id = activities.id INNER JOIN mobile_users users on users.id = surveillance_audits.mobile_user_id WHERE #{indoor_str} AND #{((params[:town].present?)? ('activities.tehsil_id = ' + '\'' + params[:town].to_s + '\'') : 'true')} and #{((params[:district].present?)? ('activities.district_id = ' + '\'' + params[:district].to_s + '\'') : 'true')} and #{((params[:department].present?)? ('activities.department_id = ' + '\'' + params[:department].to_s + '\'') : 'true')} AND #{((params[:from].present?)? ('surveillance_audits.created_at::DATE >= ' + '\'' + params[:from].to_date.to_s + '\'') : 'true')} AND #{((params[:to].present?)? ('surveillance_audits.created_at::DATE <= ' + '\'' + (params[:to].to_date).to_s + '\'') : 'true') } #{response_str} ORDER BY surveillance_audits.created_at DESC", :page => params[:page], :per_page => @per_page)
				end
	end



  private
	def is_patient_activity?
		params[:type] == "cr"
	end
	def is_department_user?
		redirect_back(fallback_location: root_path, notice: "you are not authrozied this action") unless current_user.valid_generate_tpv?
	end
end
