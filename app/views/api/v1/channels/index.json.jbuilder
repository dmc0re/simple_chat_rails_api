json.data do
  json.channels @channels do |channel|
    json.id                   channel.id
    json.name              channel.name
    json.owner_name   channel.user.name
  end
end

json.pagination do
  json.current_page   @channels.current_page 
  json.total_pages     @channels.total_pages
  json.total_count      @channels.total_count
end