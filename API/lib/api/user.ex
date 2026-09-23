defmodule Api.User do
  use Ecto.Schema
  import Ecto.Changeset
  
  @derive {Jason.Encoder, only: [:id, :username, :email]}

  schema "users" do
    field :username, :string
    field :email, :string

    timestamps()
  end

  @doc false
  def changeset(user, attrs) do
    user
    |> cast(attrs, [:username, :email])
    |> validate_required([:username, :email])
    |> validate_format(:email, ~r/^[^@\s]+@[^@\s]+\.[^@\s]+$/)
  end
end
