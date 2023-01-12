class GpDengueUserSearchService

	def initialize(current_ability)
        @current_ability = current_ability
	end

	def run params=nil
        if params.nil?
            gp_dengue_users = gp_dengue_users_obj
        else
            #### filters ################
            gp_dengue_users = gp_dengue_users_obj.where(nil)
            filtering_params(params).each do |key, value|
                gp_dengue_users = gp_dengue_users.public_send(key, value) if value.present?
            end
        end

        gp_dengue_users
	end

    def gp_dengue_users_obj
        GpDengueUser.accessible_by(@current_ability)
    end

    def filtering_params(params)
        params.slice(:email, :gp_name, :clinic_name, :contact_no, :pmdc_number, :district_id, :tehsil_id, :uc_id, :city_name, :datefrom, :dateto)
    end
end
