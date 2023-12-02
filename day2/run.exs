defmodule Main do
  @colours %{"red" => 12, "green" => 13, "blue" => 14}

  def part_1() do
    File.stream!("input.txt")
    |> Stream.map(fn line ->
      parse_line(line)
    end)
    |> Stream.reject(&reject_invalid/1)
    |> Stream.map(&elem(&1, 0))
    |> Enum.sum()
    |> IO.puts()
  end

  def part_2() do
    File.stream!("input.txt")
    |> Stream.map(fn line ->
      parse_line(line)
    end)
    |> Stream.map(&minimum_cubes/1)
    |> Enum.sum()
    |> IO.puts()
  end

  defp parse_line(line) do
    [_, game_id_str, cubes_str] = Regex.run(~r/Game (\d+): (.*)/, line)

    game_id = String.to_integer(game_id_str)

    cubes = parse_cubes(cubes_str)

    {game_id, cubes}
  end

  defp reject_invalid({_game_id, cubes}) do
    Enum.any?(cubes, fn map ->
      Enum.any?(map, fn {colour, count} ->
        Map.fetch!(@colours, colour) < count
      end)
    end)
  end

  defp minimum_cubes({_game_id, cubes}) do
    Enum.reduce(cubes, %{"red" => 0, "green" => 0, "blue" => 0}, fn cube, acc ->
      Enum.reduce(cube, acc, fn {color, count}, inner_acc ->
        Map.update!(inner_acc, color, fn c -> max(count, c) end)
      end)
    end)
    |> Map.values()
    |> Enum.reduce(1, fn count, acc -> count * acc end)
  end

  defp parse_cubes(str) do
    str
    |> String.split(";")
    |> Enum.map(fn part ->
      part
      |> String.split(",")
      |> Enum.map(&String.split(&1, " ", trim: true))
      |> Enum.map(fn [number_str, colour] ->
        {colour, String.to_integer(number_str)}
      end)
      |> Enum.into(%{})
    end)
  end
end

IO.puts("Part 1:")
Main.part_1()

IO.puts("Part 2:")
Main.part_2()
