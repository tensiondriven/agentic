defmodule Car do
  use Ecto.Schema

  @primary_key false
  embedded_schema do
    field :make, :string
    field :color, :string
  end
end

defmodule Person do
  use Ecto.Schema

  @primary_key false
  embedded_schema do
    field :name, :string
    field :age, :integer
  end
end

defmodule JsonSchemaGeneratorTest do
  use ExUnit.Case

  alias JsonSchemaGenerator

  test "generate_json_schema/1 correctly generates JSON schemas for Ecto embedded schemas" do
    expected_person_schema = %{
      "type" => "object",
      "properties" => %{
        "name" => %{"type" => "string"},
        "age" => %{"type" => "integer"}
      }
    }

    assert JsonSchemaGenerator.generate([Person]) == [expected_person_schema]
  end
end
