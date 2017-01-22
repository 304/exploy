defmodule Exploy.Deploy do
  require Logger

  def run({:error, _} = error, _, _), do: handle_result(error)
  def run({:ok, ssh_conn}, release_file, settings) do
    deploy_path = settings[:deploy_path]

    Logger.info "Start deploying #{release_file} to #{settings[:host]}:#{settings[:port]}. Path: #{deploy_path} ..."

    ssh_conn
    |> remote_upload(release_file, deploy_path)
    |> remote_cd(deploy_path)
    |> remote_extract_release(release_file)
    |> handle_result
  end

  defp remote_upload({:error, _} = error, _, _), do: error
  defp remote_upload({:ok, conn}, from_path, remote_path) do
    case :ssh_scp.to(conn, from_path, remote_path) do
      :ok ->
        Logger.info "Upload successful"
        {:ok, conn}
      {:error, reason} ->
        Logger.error "Release upload failed!"
        {:error, reason}
    end
  end

  defp remote_cd({:error, _} = error, _), do: error
  defp remote_cd({:ok, conn}, target) do
    case SSHEx.run(conn, "cd #{target}" |> to_charlist) do
      {:ok, res, 0} ->
        Logger.info "Moving to folder #{target} complete!"
        {:ok, res}
      {:ok, reason, _} ->
        Logger.error "Failed to access #{target}!"
        {:error, reason}
      {:error, reason} ->
        Logger.error "Failed to access #{target}!"
        {:error, reason}
    end
  end

  defp remote_extract_release({:error, _} = error, _), do: error
  defp remote_extract_release(conn, release_file) do
    case SSHEx.run(conn, "tar -xzvf #{release_file}" |> to_charlist) do
      {:ok, res, 0} ->
        Logger.info "Release extracting complete!"
        {:ok, res}
      {:ok, reason, _} ->
        Logger.error "Release extracting failed!"
        {:error, reason}
      {:error, reason} ->
        Logger.error "Release extracting failed!"
        {:error, reason}
    end
  end


  defp handle_result({:ok, _}) do
    Logger.info("Release was successfully deployed")
    :ok
  end
  defp handle_result({:error, reason} = error) do
    Logger.error("Error occured: #{reason}")
    error
  end
end
