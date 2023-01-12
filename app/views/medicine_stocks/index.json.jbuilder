json.set! :data do
  json.array! @medicine_stocks do |medicine_stock|
    json.partial! 'medicine_stocks/medicine_stock', medicine_stock: medicine_stock
    json.url  "
              #{link_to 'Show', medicine_stock }
              #{link_to 'Edit', edit_medicine_stock_path(medicine_stock)}
              #{link_to 'Destroy', medicine_stock, method: :delete, data: { confirm: 'Are you sure?' }}
              "
  end
end