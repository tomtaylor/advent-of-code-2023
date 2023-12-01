defmodule Main do
  @file "input.txt"
  @digits ~w(0 1 2 3 4 5 6 7 8 9)
  @words ~w(zero one two three four five six seven eight nine)

  def run() do
    file = File.stream!("input.txt")

    sum =
      file
      |> Stream.map(fn line ->
        first = scan(line, @digits, @words)

        last =
          scan(
            String.reverse(line),
            @digits,
            Enum.map(@words, &String.reverse/1)
          )

        String.to_integer("#{first}#{last}")
      end)
      |> Enum.sum()

    IO.puts(sum)
  end

  defp scan(line, digits, words) do
    regex = (digits ++ words) |> Enum.join("|") |> Regex.compile!()
    digits_lookup = digits |> Enum.with_index() |> Enum.into(%{})
    words_lookup = words |> Enum.with_index() |> Enum.into(%{})
    lookup = Map.merge(digits_lookup, words_lookup)

    case Regex.run(regex, line) do
      nil -> nil
      [match] -> Map.fetch!(lookup, match)
    end
  end
end

Main.run()
