json.extract! ppe_stock, :id, :ppe_name, :stock_received, :stock_dispensed, :stock_in_hand, :hospital_id, :created_at, :updated_at
json.url ppe_stock_url(ppe_stock, format: :json)
