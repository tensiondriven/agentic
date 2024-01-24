defmodule JsonSchemaGenerator do
  def generate(modules) when is_list(modules) do
    Enum.map(modules, &schema/1)
  end

  # __schema__(:source) - Returns the source as given to schema/2;
  # __schema__(:prefix) - Returns optional prefix for source provided by @schema_prefix schema attribute;
  # __schema__(:primary_key) - Returns a list of primary key fields (empty if there is none);
  # __schema__(:fields) - Returns a list of all non-virtual field names;
  # __schema__(:virtual_fields) - Returns a list of all virtual field names;
  # __schema__(:field_source, field) - Returns the alias of the given field;
  # __schema__(:type, field) - Returns the type of the given non-virtual field;
  # __schema__(:virtual_type, field) - Returns the type of the given virtual field;
  # __schema__(:associations) - Returns a list of all association field names;
  # __schema__(:association, assoc) - Returns the association reflection of the given assoc;
  # __schema__(:embeds) - Returns a list of all embedded field names;
  # __schema__(:embed, embed) - Returns the embedding reflection of the given embed;
  # __schema__(:read_after_writes) - Non-virtual fields that must be read back from the database after every write (insert or update);
  # __schema__(:autogenerate_id) - Primary key that is auto generated on insert;
  # __schema__(:autogenerate_fields) - Returns a list of fields names that are auto generated on insert, except for the primary key;
  # __schema__(:redact_fields) - Returns a list of redacted field names;

  defp schema(module) do
    properties = module.__schema__(:fields) |> Enum.map(&to_json_spec(module, &1)) |> Map.new()
    %{"properties" => properties, "type" => "object"}
  end

  defp to_json_spec(module, field) do
    ecto_type = ecto_type(module, field)
    json_type = ecto_type_to_json_type(ecto_type)
    {"#{field}", %{"type" => "#{json_type}"}}
  end

  defp ecto_type(module, field) do
    module.__schema__(:type, field)
  end

  defp ecto_type_to_json_type(:string), do: :string
  defp ecto_type_to_json_type(:integer), do: :integer

  defp ecto_type_to_json_type(unhandled),
    do: raise("Unknown ecto-to-json-schema field mapping: #{unhandled}")
end
