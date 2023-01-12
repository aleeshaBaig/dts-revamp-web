class InsecticideStock < ApplicationRecord
  belongs_to :user
  belongs_to :district

  validates :insecticide_name, presence: { message: "Insecticide Name can't be blank" }, uniqueness: { message: "Insecticide with this name is already created for the district assigned to you.", scope: :district_id }
  validates :stock_received, presence: { message: 'Please Add Stock Received'}
  validates :stock_dispensed, presence: { message: 'Please Add Stock Dispensed'}
  validates :district_id, presence: { message: 'Please Select District'}

  validates_numericality_of :stock_dispensed, less_than_or_equal_to: :stock_received, message: "Stock Dispensed should be less than or equal to Stock Received"
end
