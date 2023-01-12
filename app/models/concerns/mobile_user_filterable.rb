module MobileUserFilterable
  extend ActiveSupport::Concern

  module ClassMethods
    def filters(params)
      results = self.where(nil)
      filtering_params(params).each do |key, value|
        results = results.public_send("filter_by_#{key}", value) if value.present?
      end
      results
    end

    def filters_by_users(params)
      results = self.where(nil)
      filtering_by_users_params(params).each do |key, value|
        results = results.public_send("filter_by_#{key}", value) if value.present?
      end
      results
    end
    
    def filter_by_user_wise_larva_report(params)
      results = self.where(nil)
      filterering_by_user_wise_larva_report(params).each do |key, value|
        results = results.public_send("filter_by_#{key}", value) if value.present?
      end
      results
    end

    def filtering_params(params)
      params.slice(:username, :district_id, :tehsil_id, :department, :status)
    end

    
    def filtering_by_users_params(params)
      params.slice(:username, :district_id, :tehsil_id, :department, :status, :tehsil_ids)
    end


    def filterering_by_user_wise_larva_report(params)
      params.slice(:district_id, :tehsil_id, :department, :status)
    end

  end
end