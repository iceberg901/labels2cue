defmodule CueUtilsTest do
  use ExUnit.Case
  doctest CueUtils
  alias CueUtils

  describe "to_mins_seconds/1" do
    test "returns correct answer for an integer" do
      assert CueUtils.to_mins_seconds_string(70) == "01:10:00"
    end

    test "returns correct answer for a float" do
      assert CueUtils.to_mins_seconds_string(70.0) == "01:10:00"
    end

    test "returns correct answer for an integer string" do
      assert CueUtils.to_mins_seconds_string("70") == "01:10:00"
    end

    test "returns correct answer for a float string" do
      assert CueUtils.to_mins_seconds_string("70.0") == "01:10:00"
    end

    test "rounds fractional seconds" do
      assert CueUtils.to_mins_seconds_string(70.4) == "01:10:00"
    end
  end

  describe "file_block/1" do
    test "returns properly formatted FILE statement for cue file" do
      assert CueUtils.file_block("name") == "FILE name.wav WAVE"
    end
  end
end
