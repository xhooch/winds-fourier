defmodule Fourier do
  require Logger
  @file_in  "in.csv"
  @file_out  "out.csv"
  @threads  "100"

  def calc([]), do: calc([@file_in, @file_out, @threads])
  def calc([file_in]), do: calc([file_in, @file_out, @threads])
  def calc([file_in, file_out]), do: calc([file_in, file_out, @threads])
  def calc([file_in, file_out, threads]) do
    threads = case Integer.parse(threads) do
      {d, _} -> d
      _ -> @threads
    end
    work(file_in, file_out, threads)
  end

  defp work(file_in, file_out, threads) do
    # обрабатываем входные данные
    Logger.debug "Start load data from #{file_in}"
    {data, n} = File.open!(file_in)
                |> IO.stream(:line)
                |> Enum.reduce(
                     {%{}, 0},
                     fn x, {acc, i} ->
                       case Float.parse(x) do
                         {d, _} -> {Map.put(acc, i, d), i + 1}
                         _ -> {acc, i}
                       end
                     end
                   )
    # считаем
    Logger.debug "Received #{n} lines"
    Logger.debug "Start to calculate in #{threads} threads"
    Counter.start_link(0)

    z = data
        |> Flow.from_enumerable(max_demand: threads)
        |> Flow.map(
             fn {k, _} ->
               Counter.increment()
               ProgressBar.render(Counter.value, n)
               %{k => one(data, k, n)}
             end
           )
        |> Enum.map(fn m -> Map.values(m) end)
        |> List.flatten()
        |> Enum.join("\n")

    Logger.debug "All data processed"
    File.write(file_out, z)
    Logger.debug "Result was saved to #{file_out}"
  end

  defp one(data, k, n) do
    {a, b} = Enum.reduce(
      data,
      {0, 0},
      fn {i, v}, {sa, sb} ->
        arg = 2 * :math.pi * k * i / n
        a = v * :math.cos(arg)
        b = v * :math.sin(arg)
        {sa + a, sb + b}
      end
    )
    :math.sqrt(a * a + b * b)
  end
end
