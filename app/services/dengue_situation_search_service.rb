class DengueSituationSearchService

	def initialize(current_ability)
        @current_ability = current_ability
	end

	def run params=nil
        if params.nil?
            dengue_situation = dengue_situation_obj
        else
            #### filters ################
            dengue_situation = dengue_situation_obj.where(nil)
            filtering_params(params).each do |key, value|
                dengue_situation = dengue_situation.public_send("filter_by_#{key}", value) if value.present?
            end
        end

        dengue_situation
	end

    def dengue_situation_obj
        DengueSituation.accessible_by(@current_ability)
    end

    def filtering_params(params)
        params.slice(:datefrom, :dateto, :district_id)
    end
end
