defmodule Person do
  use Ecto.Schema

  @primary_key false
  embedded_schema do
    field :name, :string
    field :age, :integer
  end
end

defmodule Car do
  use Ecto.Schema

  @primary_key false
  embedded_schema do
    field :make, :string
    field :color, :string
    embeds_many :riders, Person
  end
end

defmodule JsonSchemaGeneratorTest do
  use ExUnit.Case

  alias JsonSchemaGenerator

  test "JsonSchemaGenerator.generate/1 generates an expected schema for scalars" do
    json_schema = %{
      "$schema" => "http://json-schema.org/draft-07/schema#",
      "definitions" => %{
        "Person" => %{
          "additionalProperties" => false,
          "properties" => %{"age" => %{"type" => "integer"}, "name" => %{"type" => "string"}},
          "required" => ["age", "name"],
          "type" => "object"
        }
      }
    }

    assert JsonSchemaGenerator.generate([Person]) == json_schema
  end

  test "JsonSchemaGenerator.generate/1 generates an expected schema for embeds_many" do
    json_schema = %{
      "$schema" => "http://json-schema.org/draft-07/schema#",
      "definitions" => %{
        "Person" => %{
          "additionalProperties" => false,
          "properties" => %{"age" => %{"type" => "integer"}, "name" => %{"type" => "string"}},
          "required" => ["age", "name"],
          "type" => "object"
        }
      }
    }

    result = JsonSchemaGenerator.generate([Car])

    refute result == json_schema
  end

  test "JsonSchemaGenerator.require_list_of/2 allows enforcing the root as a list of a given type" do
    json_schema = %{
      "$schema" => "http://json-schema.org/draft-07/schema#",
      "definitions" => %{
        "Car" => %{
          "additionalProperties" => false,
          "properties" => %{
            "color" => %{"type" => "string"},
            "make" => %{"type" => "string"},
            "riders" => %{
              "items" => %{"$ref" => "#/definitions/Car"},
              "type" => "array"
            }
          },
          "required" => ["color", "make", "riders"],
          "type" => "object"
        }
      },
      "items" => %{"$ref": "#/definitions/Car"},
      "type" => "array"
    }

    result =
      [Car]
      |> JsonSchemaGenerator.generate()
      |> JsonSchemaGenerator.require_list_of(Car)

    assert result == json_schema
  end
end
