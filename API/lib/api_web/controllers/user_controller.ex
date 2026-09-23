defmodule ApiWeb.UserController do
  use ApiWeb, :controller

  alias Api.Repo
  alias Api.User

  import Ecto.Query

  def index(conn, params) do
    users =
      User
      |> filter_users(params)
      |> Repo.all()

    json(conn, users)
  end

  def show(conn, %{"id" => id}) do
    case Repo.get(User, id) do
      nil ->
        conn
        |> put_status(:not_found)
        |> json(%{error: "User not found"})

      user ->
        json(conn, user)
    end
  end

  def create(conn, params) do
    changeset = User.changeset(%User{}, params)

    case Repo.insert(changeset) do
      {:ok, user} ->
        conn
        |> put_status(:created)
        |> json(user)

      {:error, changeset} ->
        conn
        |> put_status(:unprocessable_entity)
        |> json(%{
          errors:
            Ecto.Changeset.traverse_errors(changeset, fn {msg, _opts} ->
              msg
            end)
        })
    end
  end

  def update(conn, %{"id" => id} = params) do
    case Repo.get(User, id) do
      nil ->
        conn
        |> put_status(:not_found)
        |> json(%{error: "User not found"})

      user ->
        changeset = User.changeset(user, params)

        case Repo.update(changeset) do
          {:ok, user} ->
            json(conn, user)

          {:error, changeset} ->
            conn
            |> put_status(:unprocessable_entity)
            |> json(%{
              errors:
                Ecto.Changeset.traverse_errors(changeset, fn {msg, _opts} ->
                  msg
                end)
            })
        end
    end
  end

  def delete(conn, %{"id" => id}) do
    case Repo.get(User, id) do
      nil ->
        conn
        |> put_status(:not_found)
        |> json(%{error: "User not found"})

      user ->
        Repo.delete!(user)
        send_resp(conn, :no_content, "")
    end
  end

  defp filter_users(query, params) do
    query
    |> filter_by_email(params["email"])
    |> filter_by_username(params["username"])
  end

  defp filter_by_email(query, nil), do: query
  defp filter_by_email(query, email), do: where(query, [u], u.email == ^email)

  defp filter_by_username(query, nil), do: query
  defp filter_by_username(query, username), do: where(query, [u], u.username == ^username)
end
