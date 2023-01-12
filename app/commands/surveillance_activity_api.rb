class SurveillanceActivityApi
    prepend SimpleCommand
    include ApplicationHelper
    include ActiveModel::Validations
    
    def initialize(params, current_api_user)

        ## Basic information
        @name = params["name"]
        @shop_or_house = params["shop_or_house"]
        @address = params["address"]
        @activity_type = params["activity_type"].try(:downcase) ## indoor / outdoor

        ## District/Tehsil/Uc
        @district_id = current_api_user.district_id
        @tehsil_id = params["town_id"]
        @uc_id = params["uc_id"]
        @district_name = current_api_user.get_district.try(:district_name)
        @tehsil_name = params["town_name"]
        @uc_name = params["uc_name"]

        ## Locations
        @lat = params["latitude"]
        @lng = params["longitude"]
        @location = "#{@lat},#{@lng}"

        ## Tags
        @tag_category_id = params["category_id"]
        @tag_category_name = params["category_name"]
        @tag_id = Tag.find_by_m_tag_id(params["tag_id"]).try(:id)
        @tag_name = params["tag_name"].try(:titleize)

        ## Containers value
        # @checked_val = params["checked_val"]
        # @positive_val = params["positive_val"]
        # @total_checked = params["total_checked"]
        # @total_positive = params["total_positive"]

        ## Mobile Version
        @mobile_user_id = params["user_id"]
        @os_version_number = params["os_version_number"]
        @os_version_name = params["os_version_name"]
        @app_version = params["app_version"]
        
        @container_info = params["container_info"]

        ## Datetime
        @activity_time = Time.parse("#{params["activity_time"]}").try(:to_datetime) rescue Time.now.datetime
     
    end
    
    def call
      begin
        ## Transactions
        ActiveRecord::Base.transaction do
        surveillance_activity = SurveillanceActivity.new(generate_json)
        if surveillance_activity.save
          surveillance_activity_id = surveillance_activity.id
          if container_info.present?
            container_info.each do |container_tag|
                container_tag = ContainerTag.new(
                  checked_val: container_tag['checked_val'],
                  positive_val: container_tag['positive_val'],
                  surveillance_tag_id: container_tag['surveillance_tag_id'],
                  surveillance_tag_name: container_tag['surveillance_tag_name'],
                  uc_id: uc_id,
                  uc_name: uc_name,
                  tehsil_id: tehsil_id,
                  tehsil_name: tehsil_name,
                  district_id: district_id,
                  district_name: district_name,
                  surveillance_activity_id: surveillance_activity_id,
                  mobile_user_id: mobile_user_id,
                  activity_type: activity_type
                )
                if container_tag.save
                else
                  errors.add :base, "#{container_tag.errors.full_messages.to_sentence}"
                end
              end ## Loop
            else
              errors.add :base, "Container Details should be mandatory."
            end
          else
            errors.add :base, "#{surveillance_activity.errors.full_messages.to_sentence}"
          end
        end
      rescue => e
        errors.add :base, "#{e.message}"
      end
      nil ## return nil instead error
    end
    
    private
    
        attr_accessor :name,
                      :shop_or_house, 
                      :address, 
                      :activity_type, 
                      :district_id,
                      :tehsil_id,
                      :uc_id,
                      :district_name,
                      :tehsil_name,
                      :uc_name,
                      :lat,
                      :lng,
                      :location,
                      :tag_category_id,
                      :tag_category_name,
                      :tag_id,
                      :tag_name,
                      :mobile_user_id,
                      :os_version_number,
                      :os_version_name,
                      :app_version,
                      :activity_time,
                      :container_info
        def generate_json
        {
            name: name,
            shop_or_house: shop_or_house,
            address: address,
            activity_type: activity_type,
            district_id: district_id,
            tehsil_id: tehsil_id,
            uc_id: uc_id,
            district_name: district_name,
            tehsil_name: tehsil_name,
            uc_name: uc_name,
            lat: lat,
            lng: lng,
            location: location,
            tag_category_id: tag_category_id,
            tag_category_name: tag_category_name,
            tag_id: tag_id,
            tag_name: tag_name,
            mobile_user_id: mobile_user_id,
            os_version_number: os_version_number,
            os_version_name: os_version_name,
            app_version: app_version,
            activity_time: activity_time
        }
    end
  end