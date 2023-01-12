namespace :add_indoor_outdoor_tags do
    desc 'Add new tags and category'
    task :run => :environment do
        
        categories = [
            {
                category_name: 'Vector Surveillance',
                urdu: 'ویکٹر سرویلنس',
                category_name_en: 'Vector Surveillance',
                m_category_id: '6'
            }
        ]

        tags = [
            {
                tag_name: 'Indoor',
                urdu: 'ان ڈور',
                tag_image_url: 'indoor.png',
                tag_options: '14',
                tag_name_en: 'Indoor',
                option_name: 'SURVEILLANCE_INDOOR',
                m_option_id: '14',
                m_tag_id: '48'

            },
            {
                tag_name: 'Outdoor',
                urdu: 'آؤٹ ڈور',
                tag_image_url: 'outdoor.png',
                tag_options: '15',
                tag_name_en: 'Outdoor',
                option_name: 'SURVEILLANCE_OUTDOOR',
                m_option_id: '15',
                m_tag_id: '49'
            },
        ]
        
        departments = ["DHA Vehari","DHA Toba Tek Singh","DHA Sialkot","DHA Sheikhupura","DHA Sargodha","DHA Sahiwal","DHA Rawalpindi","DHA Rajanpur","DHA Rahim Yar Khan","DHA Pakpattan","DHA Okara","DHA Narowal","DHA Nankana","DHA Muzaffargarh","DHA Multan","DHA Mianwali","DHA Mandi Bahauddin","DHA Lodhran","DHA Layyah","DHA Lahore","DHA Khushab","DHA Khanewal","DHA Kasur","DHA Jhelum","DHA Jhang","DHA Hafizabad","DHA Gujrat","DHA Gujranwala","DHA Faisalabad","DHA Dera Ghazi Khan","DHA Chiniot","DHA Chakwal","DHA Bhakkar","DHA Bahawalpur","DHA Bahawalnagar","DHA Attock"]
        
        categories.each do |category|
            tag_category = TagCategory.where(category_name: category[:category_name]).last
            if tag_category.present?
                tag_category.update_attributes(category_name: category[:category_name], urdu: category[:urdu], m_category_id: category[:m_category_id], category_name_en: category[:category_name_en])
            else
                tag_category = TagCategory.create!(category_name: category[:category_name], urdu: category[:urdu], m_category_id: category[:m_category_id], category_name_en: category[:category_name_en])
            end

            tag_category_id = tag_category.id
            m_category_id   = tag_category.id
            
            tags.each do |tag|
                tag_option = TagOption.where(option_name: tag[:option_name]).last
                if tag_option.present?
                    tag_option.update_attributes(option_name: tag[:option_name], m_option_id: tag[:m_option_id])
                else
                    TagOption.create(option_name: tag[:option_name], m_option_id: tag[:m_option_id])
                end
                tag_obj = Tag.where(tag_name: tag[:tag_name]).last
                
                if tag_obj.present?
                    tag_obj.update_attributes(
                        tag_name: tag[:tag_name],
                        tag_category_id: tag_category_id,
                        tag_image_url: tag[:tag_image_url],
                        tag_options: tag[:tag_options],
                        urdu: tag[:urdu],
                        m_tag_id: tag[:m_tag_id],
                        m_category_id: m_category_id,
                        tag_name_en: tag[:tag_name_en]
                    )
                else
                    tag_obj = Tag.create!(
                        tag_name: tag[:tag_name],
                        tag_category_id: tag_category_id,
                        tag_image_url: tag[:tag_image_url],
                        tag_options: tag[:tag_options],
                        urdu: tag[:urdu],
                        m_tag_id: tag[:m_tag_id],
                        m_category_id: m_category_id,
                        tag_name_en: tag[:tag_name_en]
                    )
                end

                Department.where(department_name: departments).each do |department|
                    department_tag = DepartmentTag.where(tag_id: tag_obj.id, department_id: department.id)
                    if department_tag.present?
                        department_tag.update_attributes(tag_id: tag_obj.id, department_id:  department.id)
                    else
                        DepartmentTag.create(tag_id: tag_obj.id, department_id: department.id)
                    end
                end
            end
        end
    end
end