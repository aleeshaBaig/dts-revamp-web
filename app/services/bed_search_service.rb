class BedSearchService

	def initialize(current_ability)
        @current_ability = current_ability
	end

	def run params=nil
        if params.nil?
            beds = beds_obj
        else
            #### filters ################
            beds = beds_obj.where(nil)
            filtering_params(params).each do |key, value|
                beds = beds.public_send(key, value) if value.present?
            end
        end

        beds
	end

    def beds_obj
        Bed.accessible_by(@current_ability).includes(:hospital).joins(:hospital)
    end

    def filtering_params(params)
        params.slice(:district_id, :category, :facility_type, :hospital_id)
    end
end
