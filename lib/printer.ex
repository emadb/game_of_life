defmodule Printer do
  def print_cells(list) do
    max_x = Enum.max_by(list, fn {x, _} -> x end) |> elem(0)
    max_y = Enum.max_by(list, fn {_, y} -> y end) |> elem(1)

    matrix = for _y <- 1..max_y, _x <- 1..max_x, do: "."

    filled_matrix =
      Enum.reduce(list, matrix, fn {x, y}, acc ->
        list_replace_at(acc, (x - 1) * max_y + y - 1, "#")
      end)

    filled_matrix
    |> Enum.chunk_every(max_y)
    |> Enum.each(fn row -> IO.puts(Enum.join(row, " ")) end)
  end

  defp list_replace_at(list, index, value) do
    Enum.with_index(list)
    |> Enum.map(fn {elem, idx} -> if idx == index, do: value, else: elem end)
  end
end
