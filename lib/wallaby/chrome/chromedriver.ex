defmodule Wallaby.Chrome.Chromedriver do
  @moduledoc false

  alias Wallaby.Chrome
  alias Wallaby.Chrome.Chromedriver.Server

  @instance __MODULE__

  def child_spec(args \\ []) do
    chromedriver_path =
      case Chrome.chromedriver_url_from_config() do
        {:ok, nil} ->
          {:ok, chromedriver_path} = Chrome.find_chromedriver_executable()
          chromedriver_path

        {:ok, _url} ->
          ""
      end

    Server.child_spec([chromedriver_path, Keyword.merge([name: @instance], args)])
  end

  @spec wait_until_ready(timeout()) :: :ok | {:error, :timeout}
  def wait_until_ready(timeout) do
    Server.wait_until_ready(@instance, timeout)
  end

  @spec base_url :: String.t()
  def base_url do
    Server.get_base_url(@instance)
  end
end
