defmodule Api.WorkingTime do
  use Ecto.Schema
  import Ecto.Changeset
@derive {
    Jason.Encoder,
    only: [:id, :start, :end, :user_id, :inserted_at, :updated_at]
  }

  schema "workingtime" do
    field :start, :utc_datetime
    field :end, :utc_datetime
    field :user_id, :id

    timestamps()
  end

  @doc false
  def changeset(working_time, attrs) do
  working_time
  |> cast(attrs, [:start, :end, :user_id])
  |> validate_required([:start, :end, :user_id])
end
end
