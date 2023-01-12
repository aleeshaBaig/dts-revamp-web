class SurveillanceTag < ApplicationRecord

    ## Validations
    validates :tag_type, presence: {message: 'Type should be required'}
	validates :name, presence: {message: 'Name should be required'}, uniqueness: { scope: :tag_type, message: 'Name should be unique' }
    ## Callbacks
    before_create :capitalize_name
    def capitalize_name
        self.name = self.name.capitalize
    end
end
