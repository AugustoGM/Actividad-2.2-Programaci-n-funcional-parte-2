defmodule PetriTest do
  use ExUnit.Case
  #doctest Petri

  test "Devuelve las transiciones habilitadas entre P1 y P4" do
    m = [P1,P4]
    f = Petri.ex1()
    assert Petri.enablement(f, m) == [P0, B]
  end


  test "Devuelve las transiciones habilitadas entre P1 y P2" do
    m = [P1,P2]
    f = Petri.ex1()
    assert Petri.enablement(f, m) == [P0, B, D, D, C]
  end

  test "Funcion fire que realiza la ejecución de transicion teniendo cómo marcado P3 y P4, la transición E" do
    m = [P3,P4]
    f = Petri.ex1()
    t = E
    assert Petri.fire(f, t, m) == MapSet.new([P5])
  end

  test "Funcion fire que realiza la ejecución de transicion teniendo cómo marcado P1 y P2, la transición C" do
    m = [P1,P2]
    f = Petri.ex1()
    t = C
    assert Petri.fire(f, t, m) == MapSet.new([P1, P4])
  end
end
