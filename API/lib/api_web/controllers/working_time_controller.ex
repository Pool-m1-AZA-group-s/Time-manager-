defmodule ApiWeb.WorkingTimeController do
  use ApiWeb, :controller

  alias Api.WorkingTime
  alias Api.Repo

  import Ecto.Query

  def index(conn, %{"userID" => user_id}) do
    query =
      from w in WorkingTime,
        where: w.user_id == ^String.to_integer(user_id)

    working_times = Repo.all(query)

    json(conn, working_times)
  end

  # GET /api/workingtimes/:userID/:id
  def show(conn, %{"userID" => user_id, "id" => id}) do
    working_time =
      Repo.get_by!(
        WorkingTime,
        id: String.to_integer(id),
        user_id: String.to_integer(user_id)
      )

    json(conn, working_time)
  end

  # PUT /api/workingtimes/:id
  def update(conn, %{
        "id" => id,
        "start" => start_time,
        "end" => end_time
      }) do

    working_time = Repo.get!(WorkingTime, String.to_integer(id))

    changeset =
      WorkingTime.changeset(working_time, %{
        "start" => start_time,
        "end" => end_time
      })

    case Repo.update(changeset) do
      {:ok, working_time} ->
        json(conn, working_time)

      {:error, changeset} ->
        conn
        |> put_status(:unprocessable_entity)
        |> json(%{errors: changeset.errors})
    end
  end

  # DELETE /api/workingtimes/:id
  def delete(conn, %{"id" => id}) do
    working_time = Repo.get!(WorkingTime, String.to_integer(id))

    case Repo.delete(working_time) do
      {:ok, _working_time} ->
        send_resp(conn, :no_content, "")

      {:error, changeset} ->
        conn
        |> put_status(:unprocessable_entity)
        |> json(%{errors: changeset.errors})
    end
  end


  def create(conn, %{
      "userID" => user_id,
      "start" => start_time,
      "end" => end_time
    }) do

  changeset =
    WorkingTime.changeset(%WorkingTime{}, %{
      "start" => start_time,
      "end" => end_time,
      "user_id" => String.to_integer(user_id)
    })

  case Repo.insert(changeset) do
    {:ok, working_time} ->
      conn
      |> put_status(:created)
      |> json(working_time)

    {:error, changeset} ->
      conn
      |> put_status(:unprocessable_entity)
      |> json(%{errors: changeset.errors})
  end
end
end
