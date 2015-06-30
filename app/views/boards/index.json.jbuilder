json.array!(@boards) do |board|
  json.extract! board, :id, :name, :user_id
  json.url board_url(board, format: :json)
end
