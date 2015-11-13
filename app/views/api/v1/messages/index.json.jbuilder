json.data do
  json.channels @messages do |message|
    json.id 		message.id
    json.user_email	message.user.email
    json.text 		message.text
    json.created_time 	message.created_at
  end
end

json.pagination do
  json.current_page 	@messages.current_page 
  json.total_pages 	@messages.total_pages
  json.total_count 	@messages.total_count
end