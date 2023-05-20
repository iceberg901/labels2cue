[arg1|_] = System.argv()

defmodule Utils do
    defp to_mins_seconds(seconds) when is_bitstring(seconds) do
        to_mins_seconds(String.to_float(seconds))

    end

    defp to_mins_seconds(seconds) when is_float(seconds) do
        minutes = trunc(seconds / 60.0)
        {minutes, (seconds - (minutes * 60.0))}
    end

    def to_mins_seconds_string(seconds) do
        {minutes, remaining_seconds} = to_mins_seconds(seconds)
        "#{minutes}m#{Float.round(remaining_seconds, 2)}s"
    end

    defp duration(start_time, end_time) when is_bitstring(start_time) and is_bitstring(end_time) do
        duration(String.to_float(start_time), String.to_float(end_time))
    end

    defp duration(start_time, end_time) when is_float(start_time) and is_float(end_time) do
        end_time - start_time
    end

    def duration_string(start_time, end_time) do
        to_mins_seconds_string(duration(start_time, end_time))
    end
end

IO.puts(["Start", "End", "Duration", "Title"] |> Enum.intersperse("\t"))

File.stream!(arg1)
|> Stream.map(fn l -> String.split(String.trim(l), "\t") end)
|> Stream.map(fn
    [start_time, end_time|tail] ->
        ([
            Utils.to_mins_seconds_string(start_time),
            Utils.to_mins_seconds_string(end_time),
            Utils.duration_string(start_time, end_time),
          ] ++
          tail
        ) |> Enum.intersperse("\t")
end)
|> Enum.each(&IO.puts(&1))