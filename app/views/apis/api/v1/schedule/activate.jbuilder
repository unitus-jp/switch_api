json.meta do
  json.status 201
  json.message "「#{@schedule.name}」を稼働しました。"
end
json.response do
  json.schedule @schedule
end
