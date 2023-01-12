json.extract! medicine_stock, :id, :medicine_name, :stock_received, :stock_dispensed, :stock_in_hand, :hospital_id, :created_at, :updated_at
json.url medicine_stock_url(medicine_stock, format: :json)
