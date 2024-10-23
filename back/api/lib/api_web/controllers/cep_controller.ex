defmodule ApiWeb.CepController do
  use ApiWeb, :controller
  alias CepFetcher

  def show(conn, %{"cep" => cep}) do
    case CepFetcher.fetch_cep(cep) do
      {:ok, address} ->
        json(conn, %{message: address})  # Aqui você utiliza json/3

      {:error, error_message} ->
        json(conn, %{error: error_message})  # E aqui também
    end
  end
end
