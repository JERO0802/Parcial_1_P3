@doc """
  C.1: Ranking de confeccionistas según opciones pasadas en Keyword list.
  Opciones:
  - campo: :neto (default) | :prendas | :bruto
  - orden: :desc (default) | :asc
  - limite: entero positivo | nil (default: todos)
  """
  def ranking(liquidaciones, opciones \\ []) do
    campo = Keyword.get(opciones, :campo, :neto)
    orden = Keyword.get(opciones, :orden, :desc)
    limite = Keyword.get(opciones, :limite, nil)

    clave_selector =
      case campo do
        :neto -> & &1.neto
        :prendas -> & &1.total_prendas
        :bruto -> & &1.valor_lotes
        _ -> & &1.neto
      end

    ordenado =
      case orden do
        :asc -> Enum.sort_by(liquidaciones, clave_selector, :asc)
        _ -> Enum.sort_by(liquidaciones, clave_selector, :desc)
      end

    if is_integer(limite) and limite > 0 do
      Enum.take(ordenado, limite)
    else
      ordenado
    end
  end

@doc """
  C.2: Combina la producción de dos talleres sumando las prendas de los días comunes con Map.merge/3.
  """
  def combinar_produccion(taller1, taller2) do
    Map.merge(taller1, taller2, fn _dia, prendas1, prendas2 ->
      prendas1 + prendas2
    end)
  end

@doc """
  C.3 (Benchmark 1): Búsqueda de 1.000 códigos en lista con Enum.find/2 vs. mapa indexado con Map.get/2.
  """
  def benchmark_busqueda do
    total_elementos = 100_000
    total_muestras = 1_000

    lista =
      Enum.map(1..total_elementos, fn i ->
        %{codigo: "C_#{i}", nombre: "Confeccionista #{i}"}
      end)

    mapa = Map.new(lista, fn c -> {c.codigo, c} end)

    codigos =
      Enum.map(1..total_muestras, fn _ ->
        "C_#{:rand.uniform(total_elementos)}"
      end)

    {t_lista, _} =
      :timer.tc(fn ->
        Enum.each(codigos, fn cod ->
          Enum.find(lista, fn c -> c.codigo == cod end)
        end)
      end)

    {t_mapa, _} =
      :timer.tc(fn ->
        Enum.each(codigos, fn cod ->
          Map.get(mapa, cod)
        end)
      end)

    %{lista_ms: t_lista / 1000.0, mapa_ms: t_mapa / 1000.0}
  end

 @doc """
  C.3 (Benchmark 2): Construcción de lista de 20.000 elementos con ++ vs. [elem | acc].
  """
  def benchmark_construccion_lista do
    n = 20_000

    {t_concatenar, _} =
      :timer.tc(fn ->
        Enum.reduce(1..n, [], fn x, acc -> acc ++ [x] end)
      end)

    {t_prepend, _} =
      :timer.tc(fn ->
        1..n
        |> Enum.reduce([], fn x, acc -> [x | acc] end)
        |> Enum.reverse()
      end)

    %{concatenar_ms: t_concatenar / 1000.0, prepend_ms: t_prepend / 1000.0}
  end
