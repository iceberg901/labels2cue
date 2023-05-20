defmodule Utils do
    defp to_mins_seconds(seconds) when is_bitstring(seconds) do
        to_mins_seconds(String.to_float(seconds))

    end

    defp to_mins_seconds(seconds) when is_float(seconds) do
        minutes = trunc(seconds / 60.0)
        {minutes, round(seconds - (minutes * 60.0))}
    end

    def to_mins_seconds_string(seconds) do
        {minutes, remaining_seconds} = to_mins_seconds(seconds)
        "#{minutes}:#{remaining_seconds}:00"
    end

    def track_block({[start_time, _, last], index}) do
        [
            "  TRACK #{index} AUDIO\n",
        ]
        |> Enum.concat(
            with [title, performer] <- String.split(last, ~r/\s+by\s+/) do
                [
                    "    TITLE #{title}\n",
                    "    PERFORMER #{performer}\n"
                ]
            else
                _ -> ["    TITLE #{last}\n"]
            end
        )
        |> Enum.concat(["    INDEX 01 #{Utils.to_mins_seconds_string(start_time)}\n"])
    end
end

{input_stream, file_name} =
    with [path |_] <- System.argv do
        {File.stream!(path), Path.basename(path) |> Path.rootname}
    else
        _ -> {IO.stream(:stdio, :line), "stdin"}
    end

IO.puts("FILE #{file_name}.wav WAVE")

input_stream
|> Stream.map(fn l -> String.split(String.trim(l), "\t") end)
|> Stream.with_index(1)
|> Stream.map(&Utils.track_block(&1))
|> Enum.each(&IO.write(&1))