# frozen_string_literal: true

class Ability
  include CanCan::Ability

  def initialize(user)
    alias_action :create, :read, :update, :destroy, :to => :crud
    alias_action :create, :read, :to => :cr
    alias_action :create, :read, :update, :to => :cru
    alias_action :update, :destroy, :to => :ud
    alias_action :create, :update, :destroy, :to => :cud
    
    user ||= User.new
    if user.admin?
      can :manage, :all
      can :admin_panel, :all
      cannot [:edit, :update], Patient, patient_outcome: 'Death'
      cannot :delete, Patient
      cannot :delete, PatientActivity
      cannot :delete, SimpleActivity

      cannot :cud, MedicineStock
      cannot :cud, PpeStock
      cannot :cud, PcrMachine
      cannot :cud, InsecticideStock
    elsif user.epc_user?
      can :manage, :all
      cannot :admin_panel, :all

      cannot :cud, MedicineStock
      cannot :cud, PpeStock
      cannot :cud, PcrMachine
      cannot :cud, InsecticideStock

      ## Hospital Cannot read Death Patient
      cannot [:edit, :update], Patient, patient_outcome: 'Death'
      
      ## User Wise Dormancy Report
      can :user_wise_larva_report, SimpleActivity
    elsif user.hospital_user?
      ## main
      can :read, District
      can :read, Tehsil
      # can :read, Department, id: user.department_id
      # can :read, District, id: user.district_id
      can :read, Uc
      ## patients
      can :patient_test_history, Patient

      can :create, Patient

      ## Hospital can read created/update record Data
      can :read, Patient, updated_id: user.id  ## OR
      can :read, Patient, user_id: user.id
      # can :read, Patient, updated_id: User.select(:id).epc_user.map(&:id)
      
      ## if patient outcome death
      can :show, Patient
      ## can update if patient status is not In Process
      can :update, Patient do |patient|
        (patient.updated_id == user.id and patient.patient_status == 'In Process') or 
        (['Closed', 'Lab'].include? patient.patient_status) 
        # or (patient.patient_status == 'In Process' and (patient.updated_by.present? and patient.updated_by.epc_user?))
      end

      can :search_patient, Patient
      can :release_patient, Patient, hospital_id: user.hospital_id
      can :transfer_patient, Patient
      can :mark_as_zero_patient, Patient

      ## BEDS
      can :cru, Bed, hospital_id: user.hospital_id
      can :cru, MedicineStock, hospital_id: user.hospital_id
      can :cru, PpeStock, hospital_id: user.hospital_id
      can :cru, PcrMachine, hospital_id: user.hospital_id

      ## Hospital Cannot read Death Patient
      cannot [:edit, :update], Patient, patient_outcome: 'Death'
      # can :zero_patient, Patient
    elsif user.dpc_user?
      can :read, Department
      # can :read, District, id: user.district_id
      can :read, District
      can :read, Tehsil
      can :read, Hospital
      can :read, Uc
      # can :read, Lab
 
      can :read, Patient, district_id: user.district_id
      can :update, Patient, district_id: user.district_id
      # can :cr, Patient, transfer_type: ['Not Transferred', 'DPC'], district_id: user.district_id
      # can :read, LabPatient, transfer_type: ['Not Transferred', 'DPC'], district_id: user.district_id
      # can :update, LabPatient, transfer_type: ['Not Transferred', 'DPC'], district_id: user.district_id
      # can :transfer_as_dpc, LabPatient, transfer_type: ['Not Transferred', 'DPC'], district_id: user.district_id

      can :read, InsecticideStock, district_id: user.district_id
      can :read, ContainerTag, district_id: user.district_id

    elsif user.lab_user?
      ## main
      can :read, District
      can :read, Tehsil
      # can :read, Lab, id: user.lab_id
      can :read, Hospital, id: user.lab_id
      can :read, Uc
      ## lab patient
      # can :cru, LabPatient, lab_id: user.lab_id
      # can :cr, Patient, lab_user_id: user.id
      # can :update, Patient, district_id: user.district_id
      # can :update, Patient do |p|
      #   (p.district_id == user.district_id) and (p.patient_outcome == 'Discharged' or p.patient_outcome == '' or p.patient_outcome == nil)
      # end
      can :create, Patient

      can :read, Patient, updated_id: user.id
      can :read, Patient, user_id: user.id
      # can :read, Patient, updated_id: User.select(:id).epc_user.map(&:id)
      
      can [:update, :show], Patient
      cannot :update, Patient, patient_status: 'In Process'
      can :search_patient, Patient

      can :mark_lab_as_zero_patient, LabPatient

      ## Hospital Cannot read Death Patient
      cannot [:edit, :update], Patient, patient_outcome: 'Death'

    elsif user.lab_supervisor?
      ## main
      can :read, District, id: user.district_id
      can :read, Tehsil, district_id: user.district_id
      # can :read, Lab, id: user.lab_id
      can :read, Hospital, id: user.lab_id
      can :read, Uc, district_id: user.district_id
      ## lab patient
      # can :read, LabPatient, lab_id: user.lab_id
      can :read, Patient, hospital_id: user.lab_id
      can :zero_lab_patient, LabPatient
      can :read, ZeroPatient, district_id: user.district_id
    
    elsif user.department_user?
      ## main
      can :read, Department, id: user.department_id
      can :read, District
      can :read, Tehsil
      can :read, Hospital
      can :read, Uc

      if user.can_manage_hotspot?
        can :create, Hotspot
        can :read, Hotspot , department_tags: { department_id: user.department_id}
        can :update, Hotspot
      else
        can :read, Hotspot , department_tags: { department_id: user.department_id}
      end

      ## patients
      # can :read, Patient, district_id: user.district_id
      # can :released_patients, Patient, district_id: user.district_id
      # can :transfer_patient, Patient, district_id: user.district_id

      ## gp patients
      # can :read, GpPatient, district: user.district.try(:district_name)

      ## zero patients
      can :zero_patient, Patient
      can :zero_lab_patient, LabPatient
      can :read, ZeroPatient
      can :hotspot_visit_summary, SimpleActivity
      ## reports
      can :heat_map, SimpleActivity, department_id: user.department_id
      can :case_response_evidence, Patient, department_id: user.department_id

      can :read, PatientActivity, department_id: user.department_id
      can :read, SimpleActivity, department_id: user.department_id
      # can :read, PatientActivity, district_id: user.district_id, department_id: user.department_id
      can :read, MobileUser, department_id: user.department_id

      can [:create, :read], TpvAudit, department_id: user.department_id
      
      ## User Wise Dormancy Report
      can :user_wise_larva_report, SimpleActivity
    elsif user.patient_department_user?
      ## main
      can :read, Department, id: user.department_id
      can :read, District, id: user.district_id
      can :read, Tehsil, district_id: user.district_id
      can :read, Hospital, district_id: user.district_id
      can :read, Uc, district_id: user.district_id

      # patients
      can :read, Patient, district_id: user.district_id
      can :released_patients, Patient, district_id: user.district_id
      can :transfer_patient, Patient, district_id: user.district_id

      # gp patients
      can :read, GpPatient, district: user.district.try(:district_name)
      can :read, GpDenguePatient, :current_address => {district_id: user.district_id}
      
      # zero patients
      can :zero_patient, Patient
      can :zero_lab_patient, LabPatient
      can :read, ZeroPatient, district_id: user.district_id
      ## reports
      # can :read, SimpleActivity, district_id: user.district_id, department_id: user.department_id
      can :read, PatientActivity, district_id: user.district_id, department_id: user.department_id
      can :case_response_evidence, Patient
      can :combined_map, Patient
      # can :read, MobileUser, district_id: user.district_id, department_id: user.department_id

      # can :create, TpvAudit, district_id: user.district_id, department_id: user.department_id

    elsif user.district_user?
      
      ## main
      
      can :read, Department
      can :read, Tehsil, district_id: user.district_id
      can :read, District, id: user.district_id
      can :read, Hospital, district_id: user.district_id
      can :read, Uc, district_id: user.district_id
      if user.can_manage_hotspot?
        can :create, Hotspot
        can :read, Hotspot, district_id: user.district_id
        can :update, Hotspot
      else
        can :read, Hotspot, district_id: user.district_id
      end
      ## patients
      can :read, Patient, district_id: user.district_id
      can :read, GpPatient, district_id: user.district_id
      can :read, GpDenguePatient, :current_address => {district_id: user.district_id}
      can :released_patients, Patient, district_id: user.district_id
      can :transfer_patient, Patient, district_id: user.district_id
      can :hotspot_visit_summary, SimpleActivity
      can :district_wise_hotspot_coverage, SimpleActivity, district_id: user.district_id
      can :read, ContainerTag, district_id: user.district_id
      ## gp patients
      # can :read, GpPatient, district: user.district.try(:district_name)
      can :zero_patient, Patient
      can :zero_lab_patient, LabPatient

      ## zero patients
      can :read, ZeroPatient, district_id: user.district_id

      ## reports
      can :read, SimpleActivity, district_id: user.district_id
      can :mark_act_bogus, SimpleActivity, district_id: user.district_id
      can :read, PatientActivity, district_id: user.district_id
      can :read, MobileUser, district_id: user.district_id
      can :heat_map, SimpleActivity, district_id: user.district_id
      can :case_response_evidence, Patient, district_id: user.district_id
      can [:create, :read], TpvAudit, district_id: user.district_id

      # Hospital Info
      can :cru, InsecticideStock, district_id: user.district_id
      
      ## User Wise Dormancy Report
      can :user_wise_larva_report, SimpleActivity
    elsif user.provisional_incharge?
      
      ## main
      can :read, :all
      cannot :read, GpPatient
      cannot :read, GpDenguePatient
      cannot :zero_patient, Patient
      cannot :released_patients, Patient

      can :provincial_user_dashboard, Patient
      can :combined_map, Patient
      can :case_response_evidence, Patient
      can :heat_map, SimpleActivity
      can :hotspot_visit_summary, SimpleActivity
      can :manage,  Slideshow
      can :read, ContainerTag

      ## User Wise Dormancy Report
      can :user_wise_larva_report, SimpleActivity
      can :diagnosis_change_log, Patient
      # can :read, Bed
      # can :read, MedicineStock
      # can :read, PpeStock
      # can :read, PcrMachine
      # can :read, InsecticideStock
    elsif user.hospital_supervisor?
      
      can :read, District, id: user.district_id
      can :read, Tehsil, district_id: user.district_id
      can :read, Hospital, id: user.hospital_id
      can :read, Uc, district_id: user.district_id
      ## patients
      # can :create, Patient
      can :read, Patient, hospital_id: user.hospital_id
      can :zero_patient, Patient
      can :zero_lab_patient, LabPatient
      can :read, ZeroPatient, district_id: user.district_id
      can :read, Bed, hospital_id: user.hospital_id
      # can :update, Patient
      # can :release_patient, Patient, hospital_id: user.hospital_id
      # can :transfer_patient, Patient
      # can :mark_as_zero_patient, Patient

      can :read, MedicineStock, hospital_id: user.hospital_id
      can :read, PpeStock, hospital_id: user.hospital_id
      can :read, PcrMachine, hospital_id: user.hospital_id

    elsif user.tehsil_user?
      can :read, Department
      can :read, District, id: user.district_id
      can :read, Hospital, district_id: user.district_id
      can :read, Tehsil, id: user.tehsil_id
      can :read, Uc, tehsil_id: user.tehsil_id
      ## patients
      can :read, SimpleActivity, tehsil_id: user.tehsil_id
      can :read, PatientActivity, tehsil_id: user.tehsil_id
      can :read, MobileUser, :tehsils => {:id => user.tehsil_id}
      can :read, ContainerTag, tehsil_id: user.tehsil_id
      
      ## User Wise Dormancy Report
      can :user_wise_larva_report, SimpleActivity
    elsif user.phc_user?
      # base data
      can :read, Department
      can :read, District
      can :read, Tehsil
      can :read, Hospital, facility_type: ["Private", "Lab"]
      can :read, Uc
      can :read, Lab

      # patients
      can :read, Patient, :admitted_hospital => {:facility_type => "Private"}
      # can :read, LabPatient
      can :read, GpPatient
      can :read, GpDenguePatient
      can :zero_patient, Patient
      can :zero_lab_patient, LabPatient
      can :read, ZeroPatient
      #activities
      can :read, PatientActivity
      can :released_patients, Patient, :admitted_hospital => {:facility_type => "Private"}

      #users
      can :read, GpUser
      can :read, GpDengueUser

      #reports
      can :combined_map, Patient
      can :case_response_evidence, Patient
      can :zero_patient, Patient
      can :zero_lab_patient, LabPatient
    end
  end
end
