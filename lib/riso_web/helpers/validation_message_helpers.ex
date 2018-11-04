alias Kronky.ValidationMessage

defmodule RisoWeb.Helpers.ValidationMessageHelpers do
  def generic_message(message) when is_binary(message) do
    %ValidationMessage{
      code: :unknown,
      field: "base",
      template: message,
      message: message,
      options: []
    }
  end

  def message(field, message) when is_binary(message) do
    %ValidationMessage{
      code: :unknown,
      field: field,
      template: message,
      message: message,
      options: []
    }
  end
end
