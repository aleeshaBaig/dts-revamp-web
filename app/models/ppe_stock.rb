class PpeStock < ApplicationRecord
  belongs_to :user
  belongs_to :hospital

  validates :ppe_name, presence: { message: "PPE Name can't be blank" }, uniqueness: { message: "PPE with this name is already created for the hospital assigned to you.", scope: :hospital_id}
  validates :stock_received, presence: { message: 'Please Add Stock Received'}
  validates :stock_dispensed, presence: { message: 'Please Add Stock Dispensed'}
  validates :hospital_id, presence: { message: 'Please Select Hospital'}

  validates_numericality_of :stock_dispensed, less_than_or_equal_to: :stock_received, message: "Stock Dispensed should be less than or equal to Stock Received"
end
