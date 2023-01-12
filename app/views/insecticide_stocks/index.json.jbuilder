json.set! :data do
  json.array! @insecticide_stocks do |insecticide_stock|
    json.partial! 'insecticide_stocks/insecticide_stock', insecticide_stock: insecticide_stock
    json.url  "
              #{link_to 'Show', insecticide_stock }
              #{link_to 'Edit', edit_insecticide_stock_path(insecticide_stock)}
              #{link_to 'Destroy', insecticide_stock, method: :delete, data: { confirm: 'Are you sure?' }}
              "
  end
end