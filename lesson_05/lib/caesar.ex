defmodule Caesar do

  use Common

  # We consider only chars in range 32 - 126 as valid ascii chars
  # http://www.asciitable.com/
  @min_ascii_char 32
  @max_ascii_char 126

  @doc """
  Function shifts forward all characters in string. String could be double-quoted or single-quoted.

  ## Examples
  iex> Caesar.encode("Hello", 10)
  "Rovvy"
  iex> Caesar.encode('Hello', 5)
  'Mjqqt'
  """
  @spec encode(charlist() | bitstring(), integer(), map()) :: charlist() | bitstring()
  def encode(str, code, opts \\ %{}) do
    case str do
      chl when is_list(chl) ->
        Logger.debug("encode charlist",
          charlist: chl,
          code: code)

        to_string(chl)
        |> encode(code, opts)
        |> String.to_charlist()

      _ when is_bitstring(str) ->
        Logger.debug("encode bitstring = #{str}",
          code: code)

        encode(str, code, "", opts)
    end
  end

  defp encode(<<>>, _, acc, _), do: acc
  defp encode(<<char_code::utf8, rest::binary>>, code, acc, opts) do
    new_char_code =
      case {char_code+code, Map.get(opts, :ascii)} do
        {new_code, true} when new_code > @max_ascii_char ->
          rem(new_code, @max_ascii_char + 1) + @min_ascii_char
        {new_code, _} -> new_code
      end
    new_acc = <<acc::binary, new_char_code::utf8>>
    Logger.debug("computing new code",
      old_char: char_code,
      new_char: new_char_code)
    encode(rest, code, new_acc, opts)
  end

  @doc """
  Function shifts backward all characters in string. String could be double-quoted or single-quoted.

  ## Examples
  iex> Caesar.decode("Rovvy", 10)
  "Hello"
  iex> Caesar.decode('Mjqqt', 5)
  'Hello'
  """
  @spec decode(charlist() | bitstring(), integer(), map()) :: charlist() | bitstring()
  def decode(str, code, opts \\ %{}) do
    case str do
      chl when is_list(chl) ->
        Logger.debug("decode charlist",
          charlist: chl,
          code: code)

        to_string(chl)
        |> decode(code, opts)
        |> String.to_charlist()

      _ when is_bitstring(str) ->
        Logger.debug("decode bitstring = #{str}",
          code: code)

        decode(str, code, "", opts)
    end
  end

  defp decode(<<>>, _, acc, _), do: acc
  defp decode(<<char_code::utf8, rest::binary>>, code, acc, opts) do
    new_char_code =
      case {char_code - code, Map.get(opts, :ascii)} do
        {new_code, true} when new_code < @min_ascii_char ->
          @max_ascii_char - (@min_ascii_char - new_code) + 1
        {new_code, _} -> new_code
      end
    new_acc = <<acc::binary, new_char_code::utf8>>
    Logger.debug("computing new code",
      old_char: char_code,
      new_char: new_char_code)
    decode(rest, code, new_acc, opts)
  end

  @doc ~S"""
  Function shifts forward all characters in string. String could be double-quoted or single-quoted.
  All characters should be in range 32-126, otherwise function raises RuntimeError with message "invalid ascii str"
  If result characters are out of valid range, than function wraps them to the beginning of the range.

  ## Examples
  iex> Caesar.encode_ascii('hello world', 15)
  'wt{{~/\'~\"{s'
  """
  @spec encode_ascii(charlist(), integer()) :: charlist()
  def encode_ascii(str, code) do
    valid_ascii_str(str)
    |> MonEx.map(fn str -> encode(str, code, %{ascii: true}) end)
    |> Result.fallback(fn _ ->
      raise "invalid ascii str"
    end)
    |> Result.unwrap()
  end

  @doc ~S"""
  Function shifts backward all characters in string. String could be double-quoted or single-quoted.
  All characters should be in range 32-126, otherwise function raises RuntimeError with message "invalid ascii str"
  If result characters are out of valid range, than function wraps them to the end of the range.

  ## Examples
  iex> Caesar.decode_ascii('wt{{~/\'~\"{s', 15)
  'hello world'
  """
  @spec decode_ascii(charlist(), integer()) :: charlist()
  def decode_ascii(str, code) do
    valid_ascii_str(str)
    |> MonEx.map(fn str -> decode(str, code, %{ascii: true}) end)
    |> Result.fallback(fn _ ->
      raise "invalid ascii str"
    end)
    |> Result.unwrap()
  end

  @spec valid_ascii_str(String.t | list(integer))
  :: Result.t(String.t | list(integer), :invalid_ascii)
  defp valid_ascii_str(str) when is_bitstring(str) do
    str
    |> String.to_charlist()
    |> valid_ascii_str()
    |> MonEx.map(fn chl -> "#{chl}" end)
  end
  defp valid_ascii_str(str) when is_list(str) do
    Enum.all?(str, fn ch ->
      @min_ascii_char <= ch && ch <= @max_ascii_char
    end)
    |> case do
      true ->
        ok(str)
      false ->
        error(:invalid_ascii)
    end
  end

end
