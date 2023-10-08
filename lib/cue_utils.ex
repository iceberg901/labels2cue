defmodule CueUtils do
  def to_mins_seconds_string(seconds) do
    [minutes, remaining_seconds] =
      to_mins_seconds(seconds)
      |> Enum.map(fn s ->
        Integer.to_string(s)
        |> String.pad_leading(2, "0")
      end)

    "#{minutes}:#{remaining_seconds}:00"
  end

  defp to_mins_seconds(seconds) when is_float(seconds) do
    minutes = trunc(seconds / 60.0)
    [minutes, round(seconds - minutes * 60.0)]
  end

  defp to_mins_seconds(seconds) when is_bitstring(seconds) do
    {parsed, _} = Float.parse(seconds)
    to_mins_seconds(parsed)
  end

  defp to_mins_seconds(seconds) when is_integer(seconds) do
    seconds
    |> to_string()
    |> to_mins_seconds
  end

  def file_block(file_name), do: "FILE #{file_name}.wav WAVE"

  def track_block({[start_time, _, last], index}) do
    [
      "  TRACK #{index} AUDIO\n"
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
    |> Enum.concat(["    INDEX 01 #{to_mins_seconds_string(start_time)}\n"])
  end
end
