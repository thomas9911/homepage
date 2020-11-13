admin_name = "admin"

{:ok, [%{"id" => admin_id} = _admin_user]} = Main.get_user_by_name(admin_name)

Enum.map(
  [
    %{
      "title" => "Title1",
      "content" => "Just some text, nice!"
    },
    %{
      "_id" => "aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa",
      "title" => "Title2",
      "content" => "Just some other, nice!"
    },
    %{
      "title" => "Title3",
      "content" => "Just some more text, neat!"
    }
  ],
  &Main.new_post(admin_id, &1)
)
