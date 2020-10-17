defmodule Main.CouchDB.Validation do
  @and_ "$and"
  @or_ "$or"
  @nor "$nor"
  @all "$all"

  @not_ "$not"
  @elem_match "$elemMatch"
  @all_match "$allMatch"
  @key_map_match "$keyMapMatch"

  #   @list_combinators [@and_, @or_, @nor, @all]
  #   @selector_combinators [@not_, @elem_match, @all_match, @key_map_match]
  #   @combinators @list_combinators ++ @selector_combinators

  @lt "$lt"
  @lte "$lte"
  @eq "$eq"
  @ne "$ne"
  @gte "$gte"
  @gt "$gt"

  @exists "$exists"
  @type_ "$type"
  @in_ "$in"
  @nin "$nin"
  @size "$size"
  @mod "$mod"
  @regex "$regex"

  @validators %{
    @lt => &__MODULE__.sub_selector?/1,
    @lte => &__MODULE__.sub_selector?/1,
    @eq => &__MODULE__.sub_selector?/1,
    @ne => &__MODULE__.sub_selector?/1,
    @gte => &__MODULE__.sub_selector?/1,
    @gt => &__MODULE__.sub_selector?/1,
    @not_ => &__MODULE__.sub_selector?/1,
    @elem_match => &__MODULE__.sub_selector?/1,
    @all_match => &__MODULE__.sub_selector?/1,
    @key_map_match => &__MODULE__.sub_selector?/1,
    @exists => &__MODULE__.boolean?/1,
    @type_ => &__MODULE__.type?/1,
    @in_ => &__MODULE__.list?/1,
    @nin => &__MODULE__.list?/1,
    @and_ => &__MODULE__.list?/1,
    @or_ => &__MODULE__.list?/1,
    @nor => &__MODULE__.list?/1,
    @all => &__MODULE__.list?/1,
    @size => &__MODULE__.integer?/1,
    @mod => &__MODULE__.modulo?/1,
    @regex => &__MODULE__.string?/1
  }

  @asc "asc"
  @desc "desc"

  def fields?(input) when is_list(input), do: Enum.all?(input, &string?/1)
  def fields?(_), do: false

  def sort?(input) when is_list(input), do: Enum.all?(input, &do_sort/1)
  def sort?(_), do: false

  def do_sort(input) when is_binary(input), do: true

  def do_sort(input) when is_map(input) and map_size(input) == 1 do
    case Enum.at(input, 0) do
      {k, v} when is_binary(k) and v in [@asc, @desc] -> true
      _ -> false
    end
  end

  def do_sort(_input), do: false

  def selector?(input) when is_map(input) do
    Enum.all?(input, &do_selector/1)
  end

  defp do_selector({k, v}) when is_binary(k) do
    func = Map.get(@validators, k, &sub_selector?/1)
    func.(v)
  end

  defp do_selector(_), do: false

  def sub_selector?(input) when is_list(input), do: list?(input)
  def sub_selector?(input) when is_map(input), do: selector?(input)
  def sub_selector?(input), do: any?(input)

  def string?(input), do: is_binary(input)
  def boolean?(input), do: is_boolean(input)
  def integer?(input), do: is_integer(input)

  def list?(input) when is_list(input) do
    Enum.all?(input, &selector?/1)
  end

  def list?(_), do: false

  def modulo?([a, b]) when is_integer(a) and is_integer(b) do
    cond do
      a >= 0 and b >= 0 -> true
      a < 0 and b < 0 -> true
      true -> false
    end
  end

  def modulo?(_), do: false

  def type?(input) when input in ["null", "boolean", "number", "string", "array", "object"],
    do: true

  def type?(_), do: false

  def any?(_), do: true
end
