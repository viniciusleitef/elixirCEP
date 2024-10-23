defmodule ApiWeb.Router do
  use ApiWeb, :router

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/api", ApiWeb do
    pipe_through :api

    get "/cep/:cep", CepController, :show
    get "/address", AddressController, :show
  end
end
