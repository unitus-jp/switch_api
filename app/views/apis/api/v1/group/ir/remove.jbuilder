json.meta do
  json.status 200
  json.message "「#{@group.name}」から「#{@ir.name}」を削除しました。"
end
json.response do
  json.group do
    json.infrareds @group.infrareds
  end
end
