json.data do
  json.messages @messages do |message|
    json.id                message.id
    json.user_name  message.user.name
    json.text             message.text
    json.created_at   message.created_at
  end
end

json.pagination do
  json.current_page   @messages.current_page 
  json.total_pages     @messages.total_pages
  json.total_count      @messages.total_count
end