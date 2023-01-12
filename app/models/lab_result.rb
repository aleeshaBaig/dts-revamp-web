# == Schema Information
#
# Table name: lab_results
#
#  id                           :bigint           not null, primary key
#  hct_first_reading            :integer
#  wbc_first_reading            :integer
#  platelet_first_reading       :integer
#  hct_second_reading           :integer
#  wbc_second_reading           :integer
#  platelet_second_reading      :integer
#  warning_signs                :boolean
#  ns1                          :string
#  pcr                          :string
#  igm                          :string
#  igg                          :string
#  diagnosis                    :string
#  dengue_virus_type            :string
#  patient_id                   :integer
#  created_at                   :datetime         not null
#  updated_at                   :datetime         not null
#  hct_first_reading_date       :date
#  hct_second_reading_date      :date
#  hct_third_reading_date       :date
#  hct_third_reading            :integer
#  wbc_first_reading_date       :date
#  wbc_second_reading_date      :date
#  wbc_third_reading_date       :date
#  wbc_third_reading            :integer
#  platelet_first_reading_date  :date
#  platelet_second_reading_date :date
#  platelet_third_reading_date  :date
#  platelet_third_reading       :integer
#  lab_patient_id               :integer
#
class LabResult < ApplicationRecord
	belongs_to :patient
	# belongs_to :lab_patient
	serialize :advised_test, Array

	validates :hct_first_reading, presence: {message: "Please enter HCT first reading"}, if: Proc.new{|obj| obj.patient.provisional_diagnosis == "Confirmed" and is_hospital_user?(obj)}
	validates :wbc_first_reading, presence: {message: "Please enter WBC first reading"}, if: Proc.new{|obj| obj.patient.provisional_diagnosis == "Confirmed" and is_hospital_user?(obj)}
	validates :platelet_first_reading, presence: {message: "Please enter platelet first reading"}, if: Proc.new{|obj| obj.patient.provisional_diagnosis == "Confirmed" and is_hospital_user?(obj)}
	
	
	validates :warning_signs, inclusion: {in: [true, false], message: "Please select presence of warning signs"}, if: Proc.new{|obj| obj.patient.provisional_diagnosis == "Confirmed" and obj.patient.lab_user_id.nil?}, on: :create

	# validates :igg, presence: {message: "Please enter IGG"}, if: Proc.new{|obj| obj.patient.provisional_diagnosis == "Confirmed" and is_lab_user?(obj)}
	# validates :ns1, presence: {message: "Please enter NS1"}, if: Proc.new{|obj| (!obj.igm.present? and !obj.pcr.present?) and (obj.patient.provisional_diagnosis == "Confirmed")}
	# validates :pcr, presence: {message: "Please enter PCR"}, if: Proc.new{|obj| !obj.ns1.present? and !obj.igm.present? and (obj.patient.provisional_diagnosis == "Confirmed")}
	# validates :igm, presence: {message: "Please enter IGM"}, if: Proc.new{|obj| !obj.ns1.present? and !obj.pcr.present? and (obj.patient.provisional_diagnosis == "Confirmed")}
	# validates :diagnosis, presence: {message: "Please enter diagnosis" }, if: Proc.new{|obj| obj.patient.provisional_diagnosis == "Confirmed" and is_hospital_user?(obj) }
	
	validates :dengue_virus_type, presence: {message: "Please enter dengue virus type"}, if: Proc.new{|obj| obj.patient.provisional_diagnosis == "Confirmed" and is_hospital_user?(obj)}
	validate :cbc_reporting_and_order_dates

	def is_hospital_user?(obj)
		(obj.patient.updated_by.present? and obj.patient.updated_by.hospital_user?)
	end

	def is_lab_user?(obj)
		(obj.patient.updated_by.present? and obj.patient.updated_by.lab_user?)
	end


	before_save :downcase_fields
	def downcase_fields
      self.ns1.try(:downcase)
      self.pcr.try(:downcase)
      self.igm.try(:downcase)
      self.igg.try(:downcase)
	end

	before_save :calculate_turnaround_time
	def calculate_turnaround_time
		if is_lab_report_and_order_date_exist? and (self.report_ordering_date_changed? || self.report_receiving_date_changed?)
			(self.lab_turnaround_time = (self.report_receiving_date - self.report_ordering_date).to_i) rescue 0
		end
		
		if is_cbc_report_and_order_date_first_exist? and (self.cbc_report_order_date_first_changed? || self.cbc_report_receiving_date_first_changed?)
			(self.cbc_turnaround_first = (self.cbc_report_receiving_date_first - self.cbc_report_order_date_first).to_i) rescue 0
		end

		if is_cbc_report_and_order_date_second_exist? and (self.cbc_report_order_date_second_changed? || self.cbc_report_receiving_date_second_changed?)
			(self.cbc_turnaround_second = (self.cbc_report_receiving_date_second - self.cbc_report_order_date_second).to_i) rescue 0
		end

		if is_cbc_report_and_order_date_third_exist? and (self.cbc_report_order_date_third_changed? || self.cbc_report_receiving_date_third_changed?)
			(self.cbc_turnaround_third = (self.cbc_report_receiving_date_third - self.cbc_report_order_date_third).to_i) rescue 0
		end
	end
	
	def time_diff(diff)
		if diff.present?
			days,  diff = diff.divmod(86400)
			hours, diff = diff.divmod(3600) 
			mins,  diff = diff.divmod(60)
			return "#{days} day(s),#{hours} hour(s), #{mins} minute(s)"
		else
			return "N/A"
		end
	end

	def cbc_reporting_and_order_dates
		
		if is_cbc_report_and_order_date_first_exist?

			if  parseDateTimeNumeric(self.cbc_report_order_date_first.to_datetime) > parseDateTimeNumeric(self.cbc_report_receiving_date_first.to_datetime)
				errors.add(:cbc_report_order_date_first, "CBC First Report Order Date Should be less than CBC First Report Receiving Date")
			end
		else
			if self.cbc_report_receiving_date_first.present? 
				errors.add(:cbc_report_order_date_first, "CBC First Report Order Date Should be present") unless self.cbc_report_order_date_first.present?
			end
		end
		
		
		
		if is_cbc_report_and_order_date_second_exist?
			if  parseDateTimeNumeric(self.cbc_report_order_date_second.to_datetime) > parseDateTimeNumeric(self.cbc_report_receiving_date_second.to_datetime)
				errors.add(:cbc_report_order_date_second, "CBC Second Report Order Date Should be less than CBC Second Report Receiving Date")
			end
		else
			if self.cbc_report_receiving_date_second.present? 
				errors.add(:cbc_report_order_date_second, "CBC Second Report Order Date Should be present") unless self.cbc_report_order_date_second.present?
			end
		end
		

		if is_cbc_report_and_order_date_third_exist?
			if  parseDateTimeNumeric(self.cbc_report_order_date_third.to_datetime) > parseDateTimeNumeric(self.cbc_report_receiving_date_third.to_datetime)
				errors.add(:cbc_report_order_date_third, "CBC Third Report Order Date Should be less than CBC Third Report Receiving Date")
			end
		else
			if self.cbc_report_receiving_date_third.present? 
				errors.add(:cbc_report_order_date_third, "CBC Third Report Order Date Should be present") unless self.cbc_report_order_date_third.present?
			end
		end

		true
	end

	def is_lab_report_and_order_date_exist?
		(self.report_ordering_date.present? and self.report_receiving_date.present?)
	end

	def is_cbc_report_and_order_date_first_exist?
		(self.cbc_report_order_date_first.present? and self.cbc_report_receiving_date_first.present?)
	end

	def is_cbc_report_and_order_date_second_exist?
		(self.cbc_report_order_date_second.present? and self.cbc_report_receiving_date_second.present?)
	end
	def is_cbc_report_and_order_date_third_exist?
		(self.cbc_report_order_date_third.present? and self.cbc_report_receiving_date_third.present?)
	end

	def parseDateTimeNumeric(datetime)
		Time.parse("#{datetime}").to_i
	end
end
