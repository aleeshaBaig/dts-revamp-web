class AddColumnDivisionNameToDistricts < ActiveRecord::Migration[6.0]
  def change
    add_column :districts, :division_name, :string
		District.all.each{|district| district.update(district_name: district.district_name.try(:titleize))}
		Province.all.each{|province| province.update(province_name: province.province_name.try(:titleize))}
		Division.all.each{|division| division.update(division_name: division.division_name.try(:titleize))}
		Hospital.all.each{|hospital| hospital.update(hospital_name: hospital.hospital_name.try(:titleize))}
  end
end
