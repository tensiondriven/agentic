defmodule JsonSchemaGenerator do
  @moduledoc """

  Generator for json-schema which can be used to validate yaml configuration files.

  Works by introspecting Ecto embedded schemas and extracting field types and associations.

  Ecto schema function:

  __schema__(:source) - Returns the source as given to schema/2;
  __schema__(:prefix) - Returns optional prefix for source provided by @schema_prefix schema attribute;
  __schema__(:primary_key) - Returns a list of primary key fields (empty if there is none);
  __schema__(:fields) - Returns a list of all non-virtual field names;
  __schema__(:virtual_fields) - Returns a list of all virtual field names;
  __schema__(:field_source, field) - Returns the alias of the given field;
  __schema__(:type, field) - Returns the type of the given non-virtual field;
  __schema__(:virtual_type, field) - Returns the type of the given virtual field;
  __schema__(:associations) - Returns a list of all association field names;
  __schema__(:association, assoc) - Returns the association reflection of the given assoc;
  __schema__(:embeds) - Returns a list of all embedded field names;
  __schema__(:embed, embed) - Returns the embedding reflection of the given embed;
  __schema__(:read_after_writes) - Non-virtual fields that must be read back from the database after every write (insert or update);
  __schema__(:autogenerate_id) - Primary key that is auto generated on insert;
  __schema__(:autogenerate_fields) - Returns a list of fields names that are auto generated on insert, except for the primary key;
  __schema__(:redact_fields) - Returns a list of redacted field names;

   Example JSON spec:

    %{
   "type" => "object",
   "properties" => %{
     "name" => %{
       "type" => "string"
     },
     "age" => %{
       "type" => "integer"
     }
   },
   "required" => ["name", "age"]
  }
  """
  def generate(modules) when is_list(modules) do
    definitions = Enum.map(modules, &schema/1) |> Map.new()

    %{
      "$schema" => "http://json-schema.org/draft-07/schema#",
      "definitions" => definitions
    }
  end

  @doc """
  Adds specification to the top level of the map which validates that
  the top-level of the yaml is a list of somethings
  """
  def require_list_of(schema, required_module) do
    module_name = module_name(required_module)

    requirements = %{
      "type" => "array",
      "items" => %{
        "$ref": "#/definitions/#{module_name}"
      }
    }

    Map.merge(schema, requirements)
  end

  defp schema(module) do
    properties =
      module.__schema__(:fields)
      |> Enum.map(&to_json_spec(module, &1))
      |> Enum.filter(& &1)
      |> Map.new()

    fields = Map.keys(properties)

    module_name = module_name(module)

    {module_name,
     %{
       "properties" => properties,
       "type" => "object",
       "required" => fields,
       "additionalProperties" => false
     }}
  end

  defp to_json_spec(module, field) do
    ecto_type = ecto_type(module, field)
    json_type = ecto_type_to_json_type(module, field, ecto_type)

    if json_type do
      {"#{field}", json_type}
    else
      nil
    end
  end

  defp ecto_type(module, field) do
    module.__schema__(:type, field)
  end

  # scalars

  defp ecto_type_to_json_type(_module, _field, :string), do: %{"type" => "string"}
  defp ecto_type_to_json_type(_module, _field, :integer), do: %{"type" => "integer"}

  # associations

  defp ecto_type_to_json_type(module, _field, {:parameterized, Ecto.Embedded, ecto_embedded}) do
    ecto_embedded_to_json_type(module, ecto_embedded.cardinality)
  end

  defp ecto_embedded_to_json_type(module, :many) do
    %{
      "type" => "array",
      "items" => %{"$ref" => "#/definitions/#{module_name(module)}"}
    }
  end

  # helpers

  defp module_name(module) do
    module |> Atom.to_string() |> String.trim_leading("Elixir.")
  end
end
