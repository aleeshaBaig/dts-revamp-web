module HotspotFilterable
  extend ActiveSupport::Concern

  module ClassMethods
    def filters(params)
      results = self.where(nil)
      filtering_params(params).each do |key, value|
        results = results.public_send("filter_by_#{key}", value) if value.present?
      end
      results
    end
    def filters_sumary_wise_count(params)
      results = self.where(nil)
      summary_wise_filtering_params(params).each do |key, value|
        results = results.public_send("filter_by_#{key}", value) if value.present?
      end
      results
    end
    def filtering_params(params)
      params.slice(:tag_id, :tehsil_id, :status, :district_id, :uc_id, :from, :to, :uc, :hotspot_status, :h_name, :hotspot_from_archive, :hotspot_to_archive)
    end
    def summary_wise_filtering_params(params)
      params.slice(:hotspot_district_id, :hotspot_tag_id, :hotspot_tehsil_id, :hotspot_from, :hotspot_to, :uc, :hotspot_status, :hotspot_from_archive, :hotspot_to_archive)
    end
  end
end