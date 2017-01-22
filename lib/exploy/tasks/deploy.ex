defmodule Mix.Tasks.Exploy.Deploy do
  use Mix.Task

  alias Exploy.{Client, Deploy}

  def run(_args) do
    settings = Client.settings(:localhost)
    release_file = "test"

    Client.connect(settings)
    |> Deploy.run(release_file, settings)
  end
end
