defmodule ExBinance.Rest.SpotClient do
  alias ExBinance.Rest.HTTPClient
  alias ExBinance.Credentials

  @type credentials :: HTTPClient.credentials()
  @type endpoint :: HTTPClient.endpoint()
  @type path :: HTTPClient.path()
  @type header :: HTTPClient.header()
  @type config_error :: HTTPClient.config_error()
  @type shared_errors :: HTTPClient.shared_errors()

  @spec get(path, map, [header] | credentials, keyword) ::
          {:ok, any} | {:error, shared_errors}
  def get(path, params, headers \\ [], opts \\ [])

  def get(path, params, headers, opts) when is_map(params) and is_list(headers) do
    HTTPClient.spot_endpoint() |> HTTPClient.get(path, params, headers, opts)
  end

  def get(path, params, %Credentials{} = credentials, opts) when is_map(params) do
    get_endpoint(credentials) |> HTTPClient.get(path, params, credentials, opts)
  end

  @spec post(path, map, credentials, keyword) :: {:ok, any} | {:error, shared_errors}
  def post(path, params, %Credentials{} = credentials, opts \\ [])
      when is_map(params) do
        get_endpoint(credentials) |> HTTPClient.post(path, params, credentials, opts)
  end

  @spec delete(path, map, credentials, keyword) :: {:ok, any} | {:error, shared_errors}
  def delete(path, params, %Credentials{} = credentials, opts \\ [])
      when is_map(params) do
        get_endpoint(credentials) |> HTTPClient.delete(path, params, credentials, opts)
  end

  @spec put(path, map, credentials, keyword) :: {:ok, any} | {:error, shared_errors}
  def put(path, params, %Credentials{} = credentials, opts \\ []) when is_map(params) do
    get_endpoint(credentials) |> HTTPClient.put(path, params, credentials, opts)
  end

  defp get_endpoint(%Credentials{endpoint: endpoint}) do
    case endpoint do
      nil -> HTTPClient.spot_endpoint()
      endpoint -> endpoint
    end
  end
end
