defmodule Mix.Tasks.Exploy.Build do
  use Mix.Task

  def run(args) do
    {options, _, _} = OptionParser.parse(args)

    strategy = Keyword.get(options, :strategy, :docker)

    Exploy.Build.run(strategy, options)
  end
end
