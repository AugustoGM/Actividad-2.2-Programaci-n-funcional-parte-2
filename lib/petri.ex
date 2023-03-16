defmodule Petri do
  def ex1 do
    [
      [P0, A],
      [A, P1], [A, P2],
      [P1, B], [P1, D],
      [B, P3],
      [D, P3], [D, P4],
      [P2, D], [P2, C],
      [C, P4],
      [P3, E],
      [P4, E],
      [E, P5],
    ]
  end

  def enablement(f, m) do #procesa la red de Petri y el marcado actual, y devuelve una lista que contiene sólo las transiciones que pueden habilitarse en el marcado actual
    f
    |> Enum.filter(fn [t, _] -> isEnable?(f, t, m) end) #selecciona sólo aquellas transiciones que están habilitadas, es decir, aquellas transiciones cuyas plazas de entrada están todas marcadas en m.
    |> Enum.map(fn [t, _] -> t end) #utiliza Enum.map para devolver una lista que contiene sólo las transiciones habilitadas.
  end

  def preset(f, n) do
    f
    |> Enum.filter(fn [_a, b] -> b == n end)
    |> Enum.map(fn e -> hd(e) end)
    #|> Enum.map(fn [a,_b] -> a end)
  end

  def postset(f, n) do
    f
    |> Enum.filter(fn [a, _b] -> a == n end)
    #|> Enum.map(fn e -> tl(e) end)
    |> Enum.map(fn [_a,b] -> b end)
  end

  def isEnable?(f, t, m) do # determina si la transición t está habilitada en el marcado m.
    preset(f, t)
    |>MapSet.new()
    |>MapSet.subset?(m |> MapSet.new())
  end

  def fire(f, t, m) do
    if isEnable?(f, t, m) do
      m
      |> MapSet.new()
      |> MapSet.difference(preset(f,t) |> MapSet.new)
      |> MapSet.union(postset(f,t) |> MapSet.new)
    else
      m
    end
  end

end



defmodule Petri2 do
  import MapSet
  @plazas [:P0, :P1, :P2, :P3, :P4, :P5]
  @transiciones [:A, :B, :C, :D, :E]

  def ex2 do
    [
      [0, 1, 0, 0, 0],
      [1, 0, 1, 1, 0],
      [1, 0, 1, 0, 1],
      [0, 1, 0, 0, 1],
      [0, 1, 0, 1, 0],
      [0, 0, 0, 0, 1]
    ]
  end

  def enablement(f, m) do
    f
    |> Enum.filter(fn t -> isEnable?(f, t, m) end)
    |> Enum.map(fn t -> {preset(f, t), t |> elem(1)} end)
  end

  def preset(f, n) do
    f
    |> Enum.with_index()
    |> Enum.filter(fn {_, i} -> Enum.at(n, i) == 1 end)
    |> Enum.map(fn {e, _} -> e end)
  end

  def postset(f, n) do
    f
    |> Enum.filter(fn row -> row[n] == 1 end)
    |> Enum.map(fn row ->
      Enum.with_index(row)
      |> Enum.filter(fn {_, i} -> i != n end)
      |> Enum.map(fn {v, _} -> v end)
    end)
  end

  def isEnable?(f, t, m) do
    preset(f, t)
    |> Enum.all?(fn p -> Map.get(m, p, 0) > 0 end)
  end

  def fire(f, t, m) do
    if isEnable?(f, t, m) do
      m
      |> MapSet.new()
      |> MapSet.difference(preset(f, t) |> MapSet.new())
      |> MapSet.union(postset(f, t) |> MapSet.new())
    else
      if MapSet.member?(preset(f, t) |> MapSet.new(), m |> MapSet.new()) do
        raise "La transición #{t} no está habilitada"
      else
        raise "La transición #{t} no existe"
      end
    end
  end

end
