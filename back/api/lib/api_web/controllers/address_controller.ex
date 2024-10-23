defmodule ApiWeb.AddressController do
  use ApiWeb, :controller

  alias CepFetcher

  def show(conn, %{"estado" => estado, "cidade" => cidade, "rua" => rua}) do
    case CepFetcher.fetch_cep_by_address(estado, cidade, rua) do
      {:ok, message} ->  # Aqui a variável `message` agora contém a string
        json(conn, %{message: message})
      {:error, reason} ->
        conn
        |> put_status(:internal_server_error)
        |> json(%{error: reason})
    end
  end

  def show(conn, _params) do
    conn
    |> put_status(:bad_request)
    |> json(%{error: "Parâmetros inválidos. Certifique-se de fornecer 'estado', 'cidade' e 'rua'."})
  end
end
