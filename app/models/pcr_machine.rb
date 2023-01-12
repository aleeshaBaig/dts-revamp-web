class PcrMachine < ApplicationRecord
  belongs_to :user
  belongs_to :hospital

  validates :hospital_id, presence: { message: "Hospital ID can't be blank" }, uniqueness: { message: "PCR Machine data has been already created for the hospital assigned to you."}
  validates :pcr_functional, presence: { message: 'Please Add Functioanl Machines'}
  validates :pcr_non_functional, presence: { message: 'Please Add Non-Functioanl Machines'}
end
