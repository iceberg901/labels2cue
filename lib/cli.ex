defmodule CLI do
  def exec(argv) do
    {input_stream, file_name} =
      with [path | _] <- argv do
        {File.stream!(path), Path.basename(path) |> Path.rootname()}
      else
        _ -> {IO.stream(:stdio, :line), "stdin"}
      end

    IO.puts(CueUtils.file_block(file_name))

    input_stream
    |> Stream.map(fn l -> String.split(String.trim(l), "\t") end)
    |> Stream.with_index(1)
    |> Stream.map(&CueUtils.track_block(&1))
    |> Enum.each(&IO.write(&1))
  end
end
