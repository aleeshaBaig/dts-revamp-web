class GpFormSearchService

	def initialize(current_ability)
        @current_ability = current_ability
	end

	def run params=nil
        if params.nil?
            gp_forms = gp_form_obj
        else
            #### filters ################
            gp_forms = gp_form_obj.where(nil)
            filtering_params(params).each do |key, value|
                gp_forms = gp_forms.public_send(key, value) if value.present?
            end
        end

        gp_forms
	end

    def gp_form_obj
        GpForm.accessible_by(@current_ability).includes(:gp_dengue_user).joins(:gp_dengue_user)
    end

    def filtering_params(params)
        params.slice(:form_id, :provisional_diagnosis, :datefrom, :dateto, :entered_by)
    end
end
