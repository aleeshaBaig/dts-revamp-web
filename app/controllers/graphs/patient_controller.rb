class Graphs::PatientController < Graphs::ApplicationController
	include GraphsHelper
	def confirmed_patient_month_wise
		@data = Patient.select("DATE_TRUNC('month', patients.created_at)::DATE").where("patients.deleted_at IS NULL AND (PROVISIONAL_DIAGNOSIS = 3)").group("DATE_TRUNC('month', patients.created_at)::DATE").order("DATE_TRUNC('month', patients.created_at)::DATE asc").count
    end
end
