class SimpleActivityApi
  prepend SimpleCommand
  include ApplicationHelper
  include ActiveModel::Validations
  
  def initialize(params, before_picture, after_picture, current_api_user)
    @tag_category_id = params["category_id"]
    @tag_category_name = params["category_name"]

    ## YES/NO VALUE
    if params["mosquito_found"].present? || params['mosquito_key'].present?
      @larva_found = get_truefalse(params["mosquito_found"])
      @larva_type = params["mosquito_key"].try(:downcase)
    else
      @larva_found = get_truefalse(params["larva_found"])
      @larva_type = params["larva_type"].try(:downcase)
    end
    @io_action = params["io_action"].try(:downcase)
    @removal_water_stagnant = get_truefalse(params["removal_water_stagnant"])
    @removal_garbage = get_truefalse(params["removal_garbage"])
    @removal_rof_top_cleaned = get_truefalse(params["removal_rof_top_cleaned"])
    @old_record_sorted = get_truefalse(params["old_record_sorted"])
    @sops_follow = get_truefalse(params["sops_follow"])

    @comment = params["comment"]
    @tag_name = params["tag_name"]
    @tag_id = Tag.where("m_tag_id = ?", params["tag_id"]).last.id
    @app_version = params["app_version"]
    @latitude = params["latitude"]
    @longitude = params["longitude"]
    @activity_time = Time.parse("#{params["activity_time"]}").try(:to_datetime) rescue nil
    @os_version_number = params["os_version_number"]
    @os_version_name = params["os_version_name"]
    @user_id = params["user_id"]
    @hotspot_id = params["hotspot_id"]
    @uc_name = params["uc_name"]
    @uc_id = params["uc_id"]
    @tehsil_id = params["town_id"]
    @tehsil_name = params["town_name"]

    ## Picture Captured Time
    @pb_time = params["pb_time"]
    @pa_time = params["pa_time"]
    @pdif_time = params["pdif_time"] ## store in seconds

    @before_picture = before_picture
    @after_picture = after_picture
    @department_id = current_api_user.department_id
    @department_name = current_api_user.department.try(:department_name)
    @district_id = current_api_user.district_id
    @district_name = current_api_user.get_district.try(:district_name)


  end
  
  def call
    begin
      simple_activity = SimpleActivity.new(generate_json)
      if simple_activity.save
        picture = simple_activity.save_picture(before_picture, after_picture)
        simple_activity.before_picture = picture.before_picture.url
        simple_activity.after_picture = picture.after_picture.url
        simple_activity.save
        if hotspot_id.present?
          hotspot = simple_activity.hotspot
          if hotspot.present?
            hotspot.is_tagged = 1 #0 not tagged, 1 tagged but can be tagged again, 2 tagged but not tagged again
            if hotspot.save
              return simple_activity
            else
              errors.add :base, "#{hotspot.errors.full_messages.to_sentence}"
            end
          else
            errors.add :base, "Hotspot not exist against #{hotspot_id}"
          end
        else
          return simple_activity
        end
      else
        errors.add :base, "#{simple_activity.errors.full_messages.to_sentence}"
      end
    rescue => e
      errors.add :base, "#{e.message}"
    end
    nil
  end
  
  private
  
  attr_accessor :tag_category_id, :tag_category_name, :larva_found, :larva_type, :io_action, :removal_water_stagnant, :removal_garbage, :removal_rof_top_cleaned, :old_record_sorted, :sops_follow, :comment, :tag_name, :tag_id, :app_version, :latitude, :longitude, :activity_time, :os_version_number, :os_version_name, :user_id, :hotspot_id, :uc_name, :uc_id, :tehsil_name, :tehsil_id, :before_picture, :after_picture, :department_id, :department_name, :district_id, :district_name, :pb_time, :pa_time, :pdif_time
  def generate_json
    {
      tag_category_id: tag_category_id,
      tag_category_name: tag_category_name,
      larva_found: larva_found,
      larva_type: larva_type,
      io_action: io_action,
      removal_water_stagnant: removal_water_stagnant,
      removal_garbage: removal_garbage,
      removal_rof_top_cleaned: removal_rof_top_cleaned,
      old_record_sorted: old_record_sorted,
      sops_follow: sops_follow,
      comment: comment,
      tag_name: tag_name,
      tag_id: tag_id,
      app_version: app_version,
      latitude: latitude,
      longitude: longitude,
      activity_time: activity_time,
      os_version_number: os_version_number,
      os_version_name: os_version_name,
      user_id: user_id,
      hotspot_id: hotspot_id,
      tehsil_id: tehsil_id,
      tehsil_name: tehsil_name,
      uc_name: uc_name,
      uc_id: uc_id,
      department_id: department_id,
      department_name: department_name,
      district_id: district_id,
      district_name: district_name,
      pb_time: pb_time,
      pa_time: pa_time,
      pdif_time: pdif_time
    }
  end
  def get_before_picture_path(before_picture)
    if before_picture.present?
      uploader = ActivityUploader.new
      uploader.store!(before_picture)
      return uploader.url
    end
    nil
  end
  def get_after_picture_path(after_picture)
    if after_picture.present?
      uploader = ActivityUploader.new
      uploader.store!(after_picture)
      return uploader.url
    end
    nil
  end  
end