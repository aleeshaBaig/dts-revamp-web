Rails.application.routes.draw do
   #================================= Devise Authentication
  devise_for :users, controllers: { :sessions => "users/sessions", :registrations => "users"}
  resources :users do
    collection do
      post 'role_management', format: [:json]
      post 'change_password', format: [:json]
    end
  end
  devise_scope :user do
    root :to => 'devise/sessions#new'
  end

  #================================= Mobile Users
  resources :mobile_users do
    collection do
      post 'change_password', format: [:json]
    end
  end

  # root 'patients#index'

  #================================= Scaffolds defaults
  resources :labs, :hotspots,  :districts, :departments, :tehsils, :divisions, :provinces, :hospitals, :beds, :surveillance_tags
  resources :medicine_stocks, :ppe_stocks, :pcr_machines, :insecticide_stocks
  resources :gp_dengue_patients, only: %i[index]
  resources :gp_forms, only: %i[index]
  resources :gp_dengue_users, only: %i[index]
  resources :dengue_situations, only: %i[index]
  #================================= Mobile API routes start
  namespace :api, defaults: { format: :json } do
    namespace :v1 do
      post 'authenticate', to: 'authentication#authenticate'
      post 'signout', to: 'authentication#signout'
      resources :mobile_users do
        collection do
          post 'tags_data'
          post 'hotspots_data'
          post 'patients_data'
          post 'tagged_patients'
          post 'change_password', format: :json
        end
      end
      resources :tpv_users do
        collection do
          post 'save_audit_patient'
          post 'save_audit_larvae'
          post 'save_audit_surveillance'
          post 'get_audit_activity'
        end
      end
      resources :activities, only: [:submit_data] do
        collection do
          post 'submit_data'
        end
      end

      resources :surveillance_activities, only: [:submit_data] do
        collection do
          post 'submit_data'
        end
      end
    end

    namespace :v2 do
      post 'login', to: 'authentication#login'
      post 'signout', to: 'authentication#signout'
      get 'gp_sync', to: 'authentication#gp_sync'
      
      post 'change_password', to: 'register#change_password'
      post 'sign_up', to: 'register#sign_up'
      post 'search_cnic', to: 'gp_dengue_patients#search_cnic'
      resources :gp_dengue_patients, only: %i[create]
      resources :gp_forms
    end
    
    namespace :v3 do
      post 'login', to: 'authentication#login'
      post 'signout', to: 'authentication#signout'
      post 'lab_sync_data', to: 'authentication#lab_sync_data'
      post 'labs/create_patient', to: 'labs#create_patient'
    end
    
    namespace :v4 do
      post 'authenticate', to: 'authentication#authenticate'
      post 'signout', to: 'authentication#signout'
      resources :dengue_situations, only: [:submit_data, :line_listing] do
        collection do
          post 'submit_data'
          post 'line_listing'
        end
      end
    end

  end

 #================================= Slideshows
 resources :slideshows do 
  collection do
    get 'download_as_pdf'
    get 'download_as_image'
  end
 end
 #================================= Activities
 namespace :activities do
  resources :patients, only: [:line_list, :destroy] do
    collection do
      get :line_list
    end
  end
  resources :simples, only: [:line_list] do
    collection do
      get :line_list
    end
  end
  
  resources :vector_surveillances, only: [:line_list] do
    collection do
      get :line_list
    end
  end
 end

 #================================= Patients
  resources :patients do
    collection do
      get :mark_as_zero_patient
      get :patient_test_history
      get :search_patient
      get :diagnosis_change_log
    end
  end
  resources :lab_patients do
    collection do
       get :mark_lab_as_zero_patient
    end
  end

 #================================= Reports
 namespace :reports do
  resources :patient do
    collection do
      get :epidemiological
      get :monthly_patients
      get :zero_patient
      get :zero_lab_patient
      get :provisional_diagnosis_uc_wise
    end
  end

  resources :activities do
    collection do
      get :summary_of_activities_user_wise
      get :summary_of_activities_user_wise_archive
      get :legacy_data
      get :hotspot_visit_summary
      get :hotspot_visit_summary_list
      get :user_wise_larva_report
      get :department_wise_dormancy
      get :activity_duration
    end
  end

 end

 #================================= Graphs
  namespace :graphs do
    resources :patient, except: [:index, :edit, :update, :create, :destroy, :show, :new] do
      collection do
        get :confirmed_patient_month_wise
      end
    end
  end


 #================================= Third Party Audits
 resources :third_party_audits, defaults: {}, excepts: [:create, :update, :edit, :destroy, :show] do
  collection do
    get :generate_report
    get :audit_report
  end
 end

  #================================= Custom Routes

  # =======
  # Dashboard
  # =======
  
  get '/home_provincial', to: 'dashboard#provincial_user_dashboard'
  get '/district_wise_confirmed_cases', to: 'dashboard#district_wise_confirmed_cases'
  get '/district_wise_hotspot_coverage', to: 'dashboard#district_wise_hotspot_coverage'
  get '/hospital_compliance_report', to: 'dashboard#hospital_compliance_report'
  get '/dept_wise_compliance_report', to: 'dashboard#dept_wise_compliance_report'
  get '/home_hospital_users', to: 'dashboard#home_hospital_users'
  get '/home_lab_users', to: 'dashboard#home_lab_users'
  get '/combined_map', to: 'dashboard#combined_map'
  get '/heat_map', to: 'dashboard#heat_map'
  get '/case_response_evidence', to: 'dashboard#case_response_evidence'
  get '/audit_map', to: 'dashboard#audit_map'


  # =======
  # GP Apis
  # =======
  post '/disease_reporting_system', to: 'ajax#disease_reporting_system', format: :json
  post '/ajax/populate_hospital.json', to: 'ajax#populate_hospital', :format => 'json'
  get '/ajax/populate_hospital.json', to: 'ajax#populate_hospital', :format => 'json'
  get '/ajax/populate_lab', to: 'ajax#populate_lab', :format => 'json'
  get '/ajax/district_town_mapping.js' => 'ajax#district_town_mapping', :format => 'js', :as => :district_town_mapping
  post '/self_registration', to: 'ajax#self_registration', format: :json
  post '/auth_app_user', to: 'ajax#auth_app_user', format: :json
  get '/gp_patients_list' => 'gp_patients#gp_patients_list'
  get '/ajax/gp_patients_list.js' => 'ajax#gp_patients_list', :via => :get, :format => 'js'
  # =======

  ## OLD DENGUE MOBILE APPLICATION
  match '/ajax/get_audit_activity.js' => 'api/v1/tpv_users#get_audit_activity', :as => :get_audit_activity , :via => [:get, :post] , :format => 'js'
  match '/ajax/save_audit_patient.js' => 'api/v1/tpv_users#save_audit_patient', :as => :save_audit_patient , :via => :post , :format => 'js'
  match '/ajax/save_audit_larvae.js' => 'api/v1/tpv_users#save_audit_larvae', :as => :save_audit_larvae , :via => :post , :format => 'js'
  match '/ajax/save_audit_surveillance.js' => 'api/v1/tpv_users#save_audit_surveillance', :as => :save_audit_surveillance , :via => :post , :format => 'js'
  post '/ajax/dengue_mobile_app_sign_in', to: 'api/v1/authentication#authenticate', format: :json
  post '/ajax/dengue_api_sign_out', to: 'api/v1/authentication#signout', :format => 'json'


  get '/ajax/check_for_existing_patient', to: 'ajax#check_for_existing_patient', :format => 'json'
  get '/ajax/populate_tehsil', to: 'ajax#populate_tehsil', :format => 'json'
  get '/ajax/populate_uc', to: 'ajax#populate_uc', :format => 'json'
  get '/ajax/populate_province_district', to: 'ajax#populate_province_district', :format => 'json'
  get '/ajax/populate_district', to: 'ajax#populate_district', :format => 'json'
  get '/ajax/populate_district_hospital', to: 'ajax#populate_district_hospital', :format => 'json'
  get '/ajax/populate_hospital', to: 'ajax#populate_hospital', :format => 'json'
  get '/ajax/populate_division', to: 'ajax#populate_division', :format => 'json'
  get '/ajax/populate_p_outcome', to: 'ajax#populate_p_outcome', :format => 'json'
  get '/ajax/change_patient_activity_status', to: 'ajax#change_patient_activity_status', :format => 'json'
  get '/nfs_picture', to: 'ajax#nfs_picture'

  get '/refer_patients', to: 'patients#refer_patients'
  get '/release_patient', to: 'patients#release_patient'
  get '/released_patients', to: 'patients#released_patients'
  get '/transfer_patient', to: 'patients#transfer_patient'
  get '/google_map_popup_data', to: 'ajax#google_map_popup_data'
  get '/tpv_popup_data', to: 'ajax#tpv_popup_data'

  get '/mark_act_bogus', to: 'activities/simples#mark_act_bogus'
  get '/bogus_activities', to: 'activities/simples#bogus_activities'

  get '/summary_of_activities_dept_wise', to: 'reports/activities#summary_of_activities_dept_wise'
  get '/summary_of_activities_district_wise', to: 'reports/activities#summary_of_activities_district_wise'
  get '/summary_of_activities_town_wise', to: 'reports/activities#summary_of_activities_town_wise'
  get '/hotspot_visit_summary', to: 'reports/activities#hotspot_visit_summary'
  get '/user_wise_larva_report', to: 'reports/activities#user_wise_larva_report'
  
end
