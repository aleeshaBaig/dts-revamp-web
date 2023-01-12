json.set! :data do
  json.array! @pcr_machines do |pcr_machine|
    json.partial! 'pcr_machines/pcr_machine', pcr_machine: pcr_machine
    json.url  "
              #{link_to 'Show', pcr_machine }
              #{link_to 'Edit', edit_pcr_machine_path(pcr_machine)}
              #{link_to 'Destroy', pcr_machine, method: :delete, data: { confirm: 'Are you sure?' }}
              "
  end
end