class Reports::ActivitiesController < Reports::ApplicationController
	include ReportsHelper
	include ApplicationHelper

	## Activities duration before and after picture |  pdif_time should be greather than 0
	def activity_duration

		## variables initializer
		@data = []
		if params[:activity_date].present?

			_q_date = "SA.CREATED_AT::DATE = '#{params[:activity_date]}'"
			params[:tag_id] = [] if params[:tag_id].present? and params[:tag_id].all? &:blank?

			# _q_TAG_CATEGORY = params[:hotspot_status] == "true" ? "SA.tag_category_id = '#{TagCategory.find_by_category_name('Hotspots').id}'" : true
			q_tag_id = params[:tag_id].present? ? "SA.tag_id IN(#{params[:tag_id].reject(&:blank?).join(",")})" : true
			tags_ids = Tag.select(:id).where("tag_name IN(?)", ["Housekeeping", "Patient", "Patient Irs", "Indoor", "Outdoor"]).map(&:id).join(',')
			except_tags = "SA.tag_id NOT IN(#{tags_ids})"

			@data = SimpleActivity.find_by_sql("SELECT DS.DISTRICT_NAME, SUM(CASE when (SA.pdif_time > 0 AND SA.pdif_time <= 60) then 1 else 0 end) AS less_than_one_minute, SUM(CASE when (SA.pdif_time > 60 AND SA.pdif_time <= 120) then 1 else 0 end) AS one_to_two_minute, SUM(CASE when (SA.pdif_time > 120 AND SA.pdif_time <= 300) then 1 else 0 end) AS two_to_five_minute, SUM(CASE when (SA.pdif_time > 300 AND SA.pdif_time <= 600) then 1 else 0 end) AS five_to_ten_minute, SUM(CASE when (SA.pdif_time > 600 AND SA.pdif_time <= 900) then 1 else 0 end) AS ten_to_fifteen_minute, SUM(CASE when (SA.pdif_time > 900 AND SA.pdif_time <= 1200) then 1 else 0 end) AS fifteen_to_twenty_minute, SUM(CASE when SA.pdif_time > 1200 then 1 else 0 end) AS more_than_twenty_minute FROM simple_activities AS SA INNER JOIN DISTRICTS DS ON DS.ID = SA.DISTRICT_ID AND (SA.pdif_time > 0 and DS.district_name != 'Islamabad' AND #{except_tags}) WHERE #{_q_date} AND #{q_tag_id} GROUP BY DS.DISTRICT_NAME ORDER BY DS.DISTRICT_NAME")
		end
		respond_to do |format|
			format.html
			format.xls
		end
	end
	## Legacy Activities District & Department Wise Count
	def legacy_data
		authorize! :read, LegacyActivity
		unless params[:from].present? and params[:to].present?
			params[:from] = '2021-01-01'
			params[:to] = '2021-01-31'
		end

		@legacy_activities =
			LegacyActivity
		.select("districts.district_name, departments.department_name, act_date")
		.joins("LEFT JOIN districts ON districts.id = legacy_activities.district_id")
		.joins("LEFT JOIN departments ON departments.id = legacy_activities.department_id")
		.group("act_date, districts.district_name, departments.department_name")
		.filters(params)
		.order(:act_date)
		.pluck('act_date, districts.district_name, departments.department_name, sum(count)')

	end


	def summary_of_activities_dept_wise

		authorize! :read, SimpleActivity
		if params[:multi_department].present?
			@departments = Department.accessible_by(current_ability, :read).select("department_name").where("id IN (?)",params[:multi_department].split(',')).pluck(:id, :department_name)
		else
			@departments = Department.accessible_by(current_ability, :read).select("department_name").pluck(:id, :department_name)
		end

		@tags = Tag.where("m_category_id != ?", 2).pluck(:id, :tag_name, :m_category_id)
		@results = Hash.new

		@results = SimpleActivity.accessible_by(current_ability, :read).filters(params).group("department_id","tag_id","larva_type").count

		respond_to do |format|
			format.html
			format.xls
		end
	end

	def summary_of_activities_district_wise
		authorize! :read, SimpleActivity

		if params[:department].present?
			@departments1 = Department.accessible_by(current_ability, :read).select("department_name").where("id IN (?)",params[:department].split(',')).pluck(:id, :department_name)
		else
			@departments1 = Department.accessible_by(current_ability, :read).select("department_name").pluck(:id, :department_name)
		end
		@tags = Tag.where("m_category_id != ?", 2).pluck(:id, :tag_name, :m_category_id)

		@district1 = []

		@results = Hash.new
		user_district = current_user.district_id

		if params[:district].present?
			@district1 = District.where("id = ?",params[:district]).pluck(:id, :district_name)
		elsif user_district.present?
			@district1 = District.where("id = ?",user_district).pluck(:id, :district_name)
		end

		_date_from  = "#{ ((params[:d_from].present?)? ('created_at::DATE >= ' + '\'' + params[:d_from] + '\'') : ('created_at::DATE >= '  + '\'' + 1.week.ago.to_date.to_s + '\'')) }"
		_date_to    = "#{ ((params[:d_to].present?)? ('created_at::DATE <= ' + '\'' + params[:d_to] + '\'') : 'true') }"


		if (params[:d_from].present? and params[:d_to].present?) or (params[:department].present?) or (params[:district].present?)

			@results = SimpleActivity.accessible_by(current_ability, :read).where("#{_date_from} and #{_date_to} and district_id IN (?) and department_id IN (?)", params[:district].split(','), params[:department].split(',')).group("district_id", "department_id", "tag_id", "larva_type").count
		end

		respond_to do |format|
			format.html # result.html.erb
			format.xls
		end

	end


	def summary_of_activities_town_wise
		authorize! :read, SimpleActivity

		if params[:department].present?
			@departments1 = Department.accessible_by(current_ability, :read).select("department_name").where("id = ?", params[:department]).pluck(:id, :department_name)
		else
			@departments1 = Department.accessible_by(current_ability, :read).select("department_name").pluck(:id, :department_name)
		end

		@tags = Tag.where("m_category_id != ?", 2).pluck(:id, :tag_name, :m_category_id)
		@towns = []

		@results = Hash.new

		if params[:district].present?
			@towns = Tehsil.accessible_by(current_ability, :read).select("tehsil_name").where("district_id IN (?)",params[:district].split(',')).pluck(:id, :tehsil_name)
		end



		if params[:d_from].present? and params[:d_to].present?
			_dates = "created_at::DATE between '#{params[:d_from].to_date}' and  '#{params[:d_to].to_date}'"
		else
			_dates = "created_at::DATE >= '#{1.week.ago.to_s.to_date}'"
		end

		if (params[:d_from].present? and params[:d_to].present?) or (params[:department].present?) or (params[:district].present?)

			@results = SimpleActivity.accessible_by(current_ability, :read).where("#{_dates} and department_id IN (?) and district_id IN (?)", params[:department].split(','), params[:district].split(',')).group("tehsil_id", "department_id", "tag_id", "larva_type").count
		end

		respond_to do |format|
			format.html # result.html.erb
			format.xls
		end

	end


	## summary of activities user wise

	def summary_of_activities_user_wise
		authorize! :read, SimpleActivity
		if params[:datefrom].present? and params[:dateto].present?
		# if params[:district_id].present?
			## collect non patient tags
			@tags_list = Tag.order("tag_name").collect{|tag| [tag.tag_name, tag.id]}

			## get all mobile users
			@mobile_users = MobileUser.select("distinct(mobile_users.id) as id, username").accessible_by(current_ability, :read).is_not_tpv.filters_by_users(params).order('username')

			if params[:download_excel].present?
				@mobile_users = @mobile_users.paginate(:page => params[:page], :per_page => 50000)
				mobile_user_ids = @mobile_users.map(&:id)
			else
				@mobile_users = @mobile_users.paginate(:page => params[:page], :per_page => 50)
				mobile_user_ids = @mobile_users.map(&:id)
			end

			if params[:datefrom].present? and params[:datefrom].to_datetime.year == 2021
				@activities = Archived21SimpleActivity.accessible_by(current_ability, :read)
			else
				@activities = SimpleActivity.accessible_by(current_ability, :read)
			end
			## query
			# @activities_user_wise = @activities.filters_user_wise_activities(params).filter_by_mobile_user_ids(mobile_user_ids).group(:user_id, :tag_id).count
			# @patient_activities_user_wise = PatientActivity.accessible_by(current_ability, :read).filters_user_wise_activities(params).filter_by_mobile_user_ids(mobile_user_ids).group(:user_id, :tag_id).count
			@activities_user_wise = @activities.filters_user_wise_activities(params).group(:user_id, :tag_id).count
			@patient_activities_user_wise = PatientActivity.accessible_by(current_ability, :read).filters_user_wise_activities(params).group(:user_id, :tag_id).count
		else
			@tags_list = []
			@mobile_users = []
			@activities_user_wise = []
		end
	end

	def user_wise_larva_report
		authorize! :user_wise_larva_report, SimpleActivity
		@per_page = per_page_items(1000000)

		if params[:to].present? and params[:from].present?
			## Default Active Users Display
			params[:status] = true unless params[:status].present?
			## Mobile Users Filters
			q_username = params[:username].present? ? "lower(MOBILE_USERS.username) = '#{params[:username]}'" : "true"

			## SimpleActivities Filters
			date_query = (params[:to].present? and params[:from].present?) ? "SA.CREATED_AT >= '#{Time.parse(params[:from]).beginning_of_day}' AND SA.CREATED_AT <= '#{Time.parse(params[:to]).end_of_day}'" : 'true'

			## if user district wise
			params[:district_id] = current_user.district_id if current_user.district_user?
			q_district = params[:district_id].present? ? "SA.district_id = #{params[:district_id]}" : 'true'

			## Tehsil
			params[:tehsil_id] = current_user.tehsil_id if current_user.tehsil_user?
			q_tehsil = params[:tehsil_id].present? ? "SA.tehsil_id = #{params[:tehsil_id]}" : 'true'

			## if user department wise
			params[:department] = current_user.department_id if current_user.department_user?
			q_department = params[:department].present? ? "SA.department_id = #{params[:department]}" : 'true'

			## Total Mobile Users Department Wise Count

			if params[:username].present?
				mobile_users = MobileUser.select("mobile_users.id, mobile_users.district, mobile_users.district_id, mobile_users.department_id, departments.department_name as department_name, mobile_users.username, mobile_users.status").is_not_tpv.is_status_not_null.accessible_by(current_ability, :read).filter_by_user_wise_larva_report(params).where("#{q_username}").joins(:department)
				stats_mobile_users = mobile_users
				@mobile_users = mobile_users
			else
				mobile_users = MobileUser.select("mobile_users.id, mobile_users.district, mobile_users.district_id, mobile_users.department_id, departments.department_name as department_name, mobile_users.username, mobile_users.status").is_not_tpv.is_status_not_null.accessible_by(current_ability, :read).filter_by_user_wise_larva_report(params).joins(:department).order("departments.department_name ASC")
				stats_mobile_users = mobile_users
				@mobile_users = mobile_users
			end

			## join query
			q_simple_activities_where = "#{date_query} AND #{q_district} AND #{q_department} AND #{q_tehsil}"
			
			## if status active/inactive get spcific ids
			if stats_mobile_users.size < 500
				q_mobile_user_id = (stats_mobile_users.present? and params[:status].present?) ? "SA.USER_ID IN(#{stats_mobile_users.map(&:id).join(',')})" : "true"
			else
				q_mobile_user_id = "true"
			end

			## On Click Counts Dormant having count 0 get
			@activities = SimpleActivity
			.select("SA.department_id, SA.district_id, SA.user_id, SA.larva_type")
			.from("simple_activities SA")						
			.where("#{q_simple_activities_where}")
			.where("#{q_mobile_user_id}")
			.group("SA.department_id", "SA.district_id", "SA.user_id", "SA.larva_type")
			.count("SA")
			
			
			## Calculate Stats
			@data_stats = {}
			active_users = 0
			inactive_users = 0
			total_users = 0
			dormant_users = 0
			dormant_users_ids = []

			stats_mobile_users.each do |m_u|
				positive_larva = @activities[[m_u.department_id, m_u.district_id, m_u.id, 'positive']]
				negative_larva = @activities[[m_u.department_id, m_u.district_id, m_u.id, 'negative']]
				repat_larva = @activities[[m_u.department_id, m_u.district_id, m_u.id, 'repeat']]
				nil_larva = @activities[[m_u.department_id, m_u.district_id, m_u.id, nil]]
				
				if m_u.status == true
					total_activities_count = (positive_larva.to_i + negative_larva.to_i + repat_larva.to_i + nil_larva.to_i)
					active_users =  active_users + 1

					if total_activities_count == 0
						dormant_users = dormant_users + 1
						dormant_users_ids << m_u.id
					end
				else
					inactive_users =  inactive_users + 1
				end
				
				total_users = active_users + inactive_users
			end
			@data_stats = {active: active_users, inactive: inactive_users, dormant: dormant_users, total_users: total_users }
		
			## if dormant user
			@mobile_users = @mobile_users.where("mobile_users.id IN(?)", dormant_users_ids) if params[:is_dormant] == "true"
			## download excel show all records without pagination
			@mobile_users = @mobile_users.paginate(:page => params[:page], :per_page => @per_page) if request.format != "xls"
		else
			params[:line_listing] = "true"
		end
		
		respond_to do |format|
			format.html 
			excel_name = params[:title].present? ? "#{params[:title].downcase}_wise_dormancy_report" : 'user_wise_dormancy_report'
			format.xls { headers["Content-Disposition"] = "attachment; filename=\"#{excel_name}.xls\"" }
		end
	end

	def department_wise_dormancy
		@total_users = []
		@dormance_dp_users = []
		if params[:to].present? and params[:from].present?
			## filters
			date_query = (params[:to].present? and params[:from].present?) ? "SA.CREATED_AT >= '#{Time.parse(params[:from]).beginning_of_day}' AND SA.CREATED_AT <= '#{Time.parse(params[:to]).end_of_day}'" : 'true'

			params[:status] = true
			is_active_query = params[:status].present? ? "MOBILE_USERS.status = #{params[:status]}" : "true"

			## Total Mobile Users Department Wise Count
			@total_users = MobileUser.is_not_tpv.joins("INNER JOIN DEPARTMENTS DP ON DP.ID = MOBILE_USERS.DEPARTMENT_ID AND #{is_active_query}").group("DP.department_name").order("DP.department_name ASC").count

			## Total Dormancy(whose activities 0) Users Count

			@activities = MobileUser.is_not_tpv.joins(:department).joins("LEFT OUTER JOIN SIMPLE_ACTIVITIES AS SA ON SA.USER_ID = MOBILE_USERS.ID AND #{date_query}").group("departments.department_name").where("SA is null AND #{is_active_query}").order("departments.department_name").count

		end

	end


	def hotspot_visit_summary
		authorize! :hotspot_visit_summary, SimpleActivity
		@visited_hotspots = Hash.new
		@hotspots = Hash.new

		if params[:tag_id].present?
			@tags = Tag.where("m_category_id = ? and id IN (?)", 1, params[:tag_id]).order("tag_name").collect{|tag| [tag.tag_name, tag.id]}
		else
			@tags = Tag.where("m_category_id = ?", 1).order("tag_name").collect{|tag| [tag.tag_name, tag.id]}
		end

		if params[:district_id].present?
			@districts = District.accessible_by(current_ability, :read).select("district_name").where("id = ?",params[:district_id]).order("district_name ASC").pluck(:id, :district_name)
			@towns = Tehsil.accessible_by(current_ability, :read).select("tehsil_name").where("district_id IN (?)",params[:district_id].split(',')).order("tehsil_name ASC").pluck(:id, :tehsil_name)
		else
			@districts = []
		end

		if params[:tehsil_id].present?
			@towns = Tehsil.accessible_by(current_ability, :read).select("tehsil_name").where("district_id IN (?) and id = ?",params[:district_id].split(','),params[:tehsil_id]).order("tehsil_name ASC").pluck(:id, :tehsil_name)
		end

		if params[:district_id].present?
			@hotspots = Hotspot.accessible_by(current_ability, :read).filters(params.except(:datefrom).except(:dateto)).group("district_id","tag_id","tehsil_id").count

			if params[:datefrom].present? and params[:datefrom].to_datetime.year == 2021
				v_hotspots = Archived21SimpleActivity.accessible_by(current_ability, :read).select("archived21_simple_activities.district_id, archived21_simple_activities.tehsil_id, archived21_simple_activities.tag_id, count( DISTINCT archived21_simple_activities.hotspot_id) as unique_visited_hotspots, count(archived21_simple_activities.hotspot_id) as total_visits, count(DISTINCT (case when archived21_simple_activities.larva_type = 0 then hotspot_id else null end)) as positive").joins(:hotspot).filters(params).group("archived21_simple_activities.district_id", "archived21_simple_activities.tehsil_id", "archived21_simple_activities.tag_id")
			else
				v_hotspots = SimpleActivity.accessible_by(current_ability, :read).select("simple_activities.district_id, simple_activities.tehsil_id, simple_activities.tag_id, count( DISTINCT simple_activities.hotspot_id) as unique_visited_hotspots, count(simple_activities.hotspot_id) as total_visits, count(DISTINCT (case when simple_activities.larva_type = 0 then hotspot_id else null end)) as positive").joins(:hotspot).filters(params).group("simple_activities.district_id", "simple_activities.tehsil_id", "simple_activities.tag_id")
			end

			v_hotspots.each do |vh|
				@visited_hotspots[[vh.district_id,vh.tag_id,vh.tehsil_id]] = [vh.unique_visited_hotspots, vh.total_visits,vh.positive]
			end
		else
			@hotspots = []
			@visited_hotspots = []
		end

	end

	def hotspot_visit_summary_list
		per_page = 2500
		authorize! :hotspot_visit_summary, SimpleActivity

		if params[:type] === 'total_hotspots'

			if params[:hotspot_from].present? and params[:hotspot_from].to_datetime.year == 2021
				@hotspots = Hotspot.accessible_by(current_ability, :read).includes(:archived21_activities).filters_sumary_wise_count(params.except(:hotspot_from).except(:hotspot_to)).paginate(:page => params[:page], :per_page => per_page)
			else
				@hotspots = Hotspot.accessible_by(current_ability, :read).includes(:activities).filters_sumary_wise_count(params.except(:hotspot_from).except(:hotspot_to)).paginate(:page => params[:page], :per_page => per_page)
			end
		elsif params[:type] === 'unique_visited'

			## Date Filters
			if params[:hotspot_from].present? and params[:hotspot_from].to_datetime.year == 2021
				@hotspots = Archived21SimpleActivity.accessible_by(current_ability, :read)
						.select("hotspots.hotspot_name, hotspots.address, archived21_simple_activities.district_name, archived21_simple_activities.tehsil_name, archived21_simple_activities.tag_name,archived21_simple_activities.uc_name, count(DISTINCT(archived21_simple_activities.hotspot_id)), count(archived21_simple_activities.hotspot_id) as total_visits, hotspots.last_visited")
			else
				@hotspots = SimpleActivity.accessible_by(current_ability, :read)
						.select("hotspots.hotspot_name, hotspots.address, simple_activities.district_name, simple_activities.tehsil_name, simple_activities.tag_name,simple_activities.uc_name, count(DISTINCT(simple_activities.hotspot_id)), count(simple_activities.hotspot_id) as total_visits, hotspots.last_visited")
			end

			##Query
			@hotspots = @hotspots.joins(:hotspot)
						.filters_hotspots(params)
						.group('district_name', 'tehsil_name', 'tag_name','uc_name', 'hotspot_id', 'last_visited', 'hotspot_name', 'address')
						.paginate(:page => params[:page], :per_page => per_page)
		elsif params[:type] === 'total_visited'

			## Date Filters
			if params[:hotspot_from].present? and params[:hotspot_from].to_datetime.year == 2021
				@hotspots = Archived21SimpleActivity.accessible_by(current_ability, :read)
			else
				@hotspots = SimpleActivity.accessible_by(current_ability, :read)
			end

			##Query
			@hotspots = @hotspots.joins(:hotspot)
						.filters_hotspots(params)
						.paginate(:page => params[:page], :per_page => per_page)
		elsif params[:type] == 'unvisted_hotspots'

			if params[:hotspot_from].present? and params[:hotspot_from].to_datetime.year == 2021
				date_filters = (params[:hotspot_from].present? and params[:hotspot_to].present? ) ? "(archived21_simple_activities.created_at >= '#{params[:hotspot_from]}') and (archived21_simple_activities.created_at <= '#{params[:hotspot_to]}')" : true
				@hotspots = Hotspot.accessible_by(current_ability, :read)
						.joins("LEFT JOIN archived21_simple_activities ON archived21_simple_activities.hotspot_id = hotspots.id and #{date_filters}")
						.where("archived21_simple_activities.id is null")
						.filters_sumary_wise_count(params.except(:hotspot_from).except(:hotspot_to))
						.paginate(:page => params[:page], :per_page => per_page)
			else
				date_filters = (params[:hotspot_from].present? and params[:hotspot_to].present? ) ? "(simple_activities.created_at >= '#{params[:hotspot_from]}') and (simple_activities.created_at <= '#{params[:hotspot_to]}')" : true
				@hotspots = Hotspot.accessible_by(current_ability, :read)
						.joins("LEFT JOIN simple_activities ON simple_activities.hotspot_id = hotspots.id and #{date_filters}")
						.where("simple_activities.id is null")
						.filters_sumary_wise_count(params.except(:hotspot_from).except(:hotspot_to))
						.paginate(:page => params[:page], :per_page => per_page)
			end




		elsif params[:type] == 'positive_hotspots'
			if params[:hotspot_from].present? and params[:hotspot_from].to_datetime.year == 2021
				@hotspots = Archived21SimpleActivity.accessible_by(current_ability, :read)
							.select("distinct(hotspots.*), archived21_simple_activities.district_name, archived21_simple_activities.tehsil_name, archived21_simple_activities.uc_name, archived21_simple_activities.tag_name, archived21_simple_activities.hotspot_id")
							.joins(:hotspot)
							.positive
							.filters_hotspots(params)
							.paginate(:page => params[:page], :per_page => per_page)
			else
				@hotspots = SimpleActivity.accessible_by(current_ability, :read)
							.select("distinct(hotspots.*), simple_activities.district_name, simple_activities.tehsil_name, simple_activities.uc_name, simple_activities.tag_name, simple_activities.hotspot_id")
							.joins(:hotspot)
							.positive
							.filters_hotspots(params)
							.paginate(:page => params[:page], :per_page => per_page)
			end
		end
	end

	# def hotspot_visit_summary_list
	# 	per_page = 2500
	# 	authorize! :hotspot_visit_summary, SimpleActivity

	# 	if params[:type] === 'total_hotspots'
	# 	@hotspots = Hotspot.accessible_by(current_ability, :read).includes(:activities).filters_sumary_wise_count(params.except(:hotspot_from).except(:hotspot_to)).paginate(:page => params[:page], :per_page => per_page)
	# 	elsif params[:type] === 'unique_visited'
	# 		@hotspots = SimpleActivity.accessible_by(current_ability, :read)
	# 					.select("hotspots.hotspot_name, hotspots.address, simple_activities.district_name, simple_activities.tehsil_name, simple_activities.tag_name,simple_activities.uc_name, count(DISTINCT(simple_activities.hotspot_id)), count(simple_activities.hotspot_id) as total_visits, hotspots.last_visited")
	# 					.joins(:hotspot)
	# 					.filters_hotspots(params)
	# 					.group('district_name', 'tehsil_name', 'tag_name','uc_name', 'hotspot_id', 'last_visited', 'hotspot_name', 'address')
	# 					.paginate(:page => params[:page], :per_page => per_page)
	# 	elsif params[:type] === 'total_visited'
	# 		@hotspots = SimpleActivity.accessible_by(current_ability, :read)
	# 					.joins(:hotspot)
	# 					.filters_hotspots(params)
	# 					.paginate(:page => params[:page], :per_page => per_page)
	# 	elsif params[:type] == 'unvisted_hotspots'

	# 		date_filters = (params[:hotspot_from].present? and params[:hotspot_to].present? ) ? "(simple_activities.created_at >= '#{params[:hotspot_from]}') and (simple_activities.created_at <= '#{params[:hotspot_to]}')" : true
	# 		@hotspots = Hotspot.accessible_by(current_ability, :read)
	# 					.joins("LEFT JOIN simple_activities ON simple_activities.hotspot_id = hotspots.id and #{date_filters}")
	# 					.where("simple_activities.id is null")
	# 					.filters_sumary_wise_count(params.except(:hotspot_from).except(:hotspot_to))
	# 					.paginate(:page => params[:page], :per_page => per_page)

	# 	elsif params[:type] == 'positive_hotspots'
	# 		@hotspots = SimpleActivity.accessible_by(current_ability, :read)
	# 					.select("distinct(hotspots.*), simple_activities.district_name, simple_activities.tehsil_name, simple_activities.uc_name, simple_activities.tag_name, simple_activities.hotspot_id")
	# 					.joins(:hotspot)
	# 					.positive
	# 					.filters_hotspots(params)
	# 					.paginate(:page => params[:page], :per_page => per_page)
	# 	end
	# end


end