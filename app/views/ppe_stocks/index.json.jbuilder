json.set! :data do
  json.array! @ppe_stocks do |ppe_stock|
    json.partial! 'ppe_stocks/ppe_stock', ppe_stock: ppe_stock
    json.url  "
              #{link_to 'Show', ppe_stock }
              #{link_to 'Edit', edit_ppe_stock_path(ppe_stock)}
              #{link_to 'Destroy', ppe_stock, method: :delete, data: { confirm: 'Are you sure?' }}
              "
  end
end