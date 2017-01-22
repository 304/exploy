defmodule Exploy.Build do
  require Logger

  @spec run(String.t, :atom) :: :ok | {:error, String.t}
  def run(:docker, opts) do
    build_docker_image(Path.join([__DIR__, "../../src/Dockerfile"]))
    |> build_release_in_docker(opts)
  end

  def run(strategy, _) do
    reason = "Unsupported strategy: #{strategy}"
    Logger.error reason
    {:error, reason}
  end

  defp build_docker_image(dockerfile) do
    case System.cmd "docker", ["build", "-t", "exploy-build", "-f", dockerfile, "."], [into: IO.stream(:stdio, :line)] do
      {_, 0} ->
        Logger.info "Docker image was built!"
        :ok
      {stream, _} ->
        Logger.error "Failed to build a docker image!"
        {:error, stream}
    end
  end

  defp build_release_in_docker({:error, _} = error, _), do: error
  defp build_release_in_docker(:ok, opts) do
    case System.cmd "docker", ["run", "-v", "#{System.cwd}:/app", "exploy-build", "mix", "release"] ++ OptionParser.to_argv(opts), [into: IO.stream(:stdio, :line)] do
      {_, 0} ->
        Logger.info "Project compilation was successful!"
        :ok
      {stream, _} ->
        Logger.error "Project compilation failed!"
        {:error, stream}
    end
  end
end
