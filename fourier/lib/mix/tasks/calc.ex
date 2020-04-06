defmodule Mix.Tasks.Calc do
  use Mix.Task

  def run(args \\ []) do
    Fourier.calc(Enum.slice(args, 0, 2))
  end
end