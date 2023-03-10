module SurveillanceActivityFilterable
    extend ActiveSupport::Concern
  
    module ClassMethods
      def filters(params)
        results = self.where(nil)
        filtering_params(params).each do |key, value|
          results = results.public_send("filter_by_#{key}", value) if value.present?
        end
        results
      end
      def filtering_params(params)
        params.slice(:tag_id, :district_id, :tehsil_id, :uc, :datefrom, :dateto)
      end
    end
  end