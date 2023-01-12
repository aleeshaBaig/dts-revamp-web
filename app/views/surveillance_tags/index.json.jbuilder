json.set! :data do
  json.array! @surveillance_tags do |surveillance_tag|
    json.partial! 'surveillance_tags/surveillance_tag', surveillance_tag: surveillance_tag
    json.url  "
              #{link_to 'Show', surveillance_tag }
              #{link_to 'Edit', edit_surveillance_tag_path(surveillance_tag)}
              #{link_to 'Destroy', surveillance_tag, method: :delete, data: { confirm: 'Are you sure?' }}
              "
  end
end