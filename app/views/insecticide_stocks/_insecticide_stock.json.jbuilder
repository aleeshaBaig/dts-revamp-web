json.extract! insecticide_stock, :id, :insecticide_name, :stock_received, :stock_dispensed, :stock_in_hand, :district_id, :created_at, :updated_at
json.url insecticide_stock_url(insecticide_stock, format: :json)
