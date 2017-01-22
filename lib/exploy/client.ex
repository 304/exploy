defmodule Exploy.Client do
  require Logger

  def connect(key) when is_atom(key) do
    Logger.info "Connecting to ssh using #{key} configuration"
    settings(key) |> connect
  end

  def connect(settings) do
    connection_settings(settings) |> connection
  end

  def settings(key) when is_atom(key) do
    Application.get_env(:exploy, key)
  end

  defp connection(params) do
    :ssh.start
    case apply(:ssh, :connect, params) do
      {:ok, conn} ->
        Logger.info "Successfully connected"
        {:ok, conn}
      {:error, reason} ->
        Logger.error "Connection failed!"
        {:error, reason}
    end
  end

  defp connection_settings(settings) do
    [
      settings[:host],
      settings[:port],
      settings[:options]
    ]
  end
end
