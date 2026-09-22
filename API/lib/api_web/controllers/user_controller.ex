defmodule ApiWeb.UserController do
  use ApiWeb, :controller

  alias Api.Repo
  alias Api.User

  def index(conn, _params) do
    users = Repo.all(User)
    json(conn, users)
  end
end
