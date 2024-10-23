defmodule CepFetcher do
  use HTTPoison.Base

  @base_url "https://viacep.com.br/ws"

  def fetch_cep(cep) when is_binary(cep) do
    url = "#{@base_url}/#{cep}/json/"

    case HTTPoison.get(url) do
      {:ok, %HTTPoison.Response{status_code: 200, body: body}} ->
        case Jason.decode(body, keys: :atoms) do
          {:ok, data} ->
            format_address(data)

          {:error, reason} ->
            {:error, "Failed to decode JSON: #{reason}"}
        end

      {:ok, %HTTPoison.Response{status_code: status_code}} ->
        {:error, "Failed with status code #{status_code}"}

      {:error, %HTTPoison.Error{reason: reason}} ->
        {:error, "Request failed: #{reason}"}
    end
  end

  def fetch_cep_by_address(estado, cidade, rua) when is_binary(estado) and is_binary(cidade) and is_binary(rua) do
    estado_encoded = URI.encode(estado)
    cidade_encoded = URI.encode(cidade)
    rua_encoded = URI.encode(rua)

    url = "#{@base_url}/#{estado_encoded}/#{cidade_encoded}/#{rua_encoded}/json/"

    case HTTPoison.get(url) do
      {:ok, %HTTPoison.Response{status_code: 200, body: body}} ->
        case Jason.decode(body) do
          {:ok, data} when is_list(data) ->
            # Aqui retornamos a string diretamente
            format_multiple_results(data)

          {:error, reason} ->
            {:error, "Failed to decode JSON: #{reason}"}
        end

      {:ok, %HTTPoison.Response{status_code: status_code}} ->
        {:error, "Failed with status code #{status_code}"}

      {:error, %HTTPoison.Error{reason: reason}} ->
        {:error, "Request failed: #{reason}"}
    end
  end

  defp format_address(%{erro: "true"}) do
    {:error, "CEP não encontrado ou inválido."}
  end

  defp format_address(%{logradouro: logradouro, bairro: bairro, localidade: localidade, uf: uf}) do
    {:ok, "#{logradouro}, no bairro #{bairro}, na cidade de #{localidade} - #{uf}."}
  end

  defp format_multiple_results([]) do
    {:error, "Nenhum resultado encontrado para o endereço fornecido."}
  end

  defp format_multiple_results(results) do
    count = length(results)

    formatted_results =
      Enum.with_index(results, 1)
      |> Enum.map(fn {result, index} ->
        cep = Map.get(result, "cep", "CEP não disponível")
        "Resultado #{index}: Cep: #{cep}"
      end)
      |> Enum.join(" | ")

    {:ok, "Sua pesquisa gerou #{count} resultados: #{formatted_results}"}
  end
end
