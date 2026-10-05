defp ejecutar_investigacion(liquidaciones, lotes_validos) do
    # C.1: Llamadas obligatorias del ranking
    IO.puts("\n========================================================")
    IO.puts("PARTE C.1: RANKING CON KEYWORD LISTS")
    IO.puts("========================================================")

    IO.puts("\nLlamada 1: Reportes.ranking(liquidaciones, [])")
    res1 = Reportes.ranking(liquidaciones, [])
    Enum.each(Enum.take(res1, 3), fn l -> IO.puts("  - #{l.codigo} (#{l.nombre}): #{Util.formato_moneda(l.neto)}") end)

    IO.puts("\nLlamada 2: Reportes.ranking(liquidaciones, campo: :prendas, limite: 3)")
    res2 = Reportes.ranking(liquidaciones, campo: :prendas, limite: 3)
    Enum.each(res2, fn l -> IO.puts("  - #{l.codigo} (#{l.nombre}): #{l.total_prendas} prendas") end)

    IO.puts("\nLlamada 3: Reportes.ranking(liquidaciones, orden: :asc, campo: :bruto)")
    res3 = Reportes.ranking(liquidaciones, orden: :asc, campo: :bruto)
    Enum.each(Enum.take(res3, 3), fn l -> IO.puts("  - #{l.codigo} (#{l.nombre}): #{Util.formato_moneda(l.valor_lotes)}") end)

    # C.2: Combinación con taller aliado
    IO.puts("\n========================================================")
    IO.puts("PARTE C.2: COMBINACIÓN DE PRODUCCIÓN CON TALLER ALIADO")
    IO.puts("========================================================")
    taller_aliado = %{1 => 550, 2 => 620, 3 => 480, 5 => 710, 7 => 200}
    r3 = Reportes.calcular_r3(lotes_validos)
    taller_propio = r3.mapa_produccion

    combinado = Reportes.combinar_produccion(taller_propio, taller_aliado)

    IO.puts("Producción Taller Propio (R3) : #{inspect(taller_propio)}")
    IO.puts("Producción Taller Aliado      : #{inspect(taller_aliado)}")
    IO.puts("Producción Combinada          : #{inspect(combinado)}")

    # C.3: Medición de tiempos de ejecución
    IO.puts("\n========================================================")
    IO.puts("PARTE C.3: MEDICIONES CON :timer.tc/1 (3 REPETICIONES)")
    IO.puts("========================================================")

    IO.puts("\n1. Búsqueda de 1.000 códigos en 100.000 registros (Lista vs. Mapa):")
    Enum.each(1..3, fn corrida ->
      res = Reportes.benchmark_busqueda()
      IO.puts("  Corrida #{corrida}: Lista = #{:erlang.float_to_binary(res.lista_ms, decimals: 2)} ms | Mapa = #{:erlang.float_to_binary(res.mapa_ms, decimals: 3)} ms")
    end)

    IO.puts("\n2. Construcción de lista de 20.000 elementos (++ vs. [elem | acc]):")
    Enum.each(1..3, fn corrida ->
      res = Reportes.benchmark_construccion_lista()
      IO.puts("  Corrida #{corrida}: Final (++) = #{:erlang.float_to_binary(res.concatenar_ms, decimals: 2)} ms | Inicio ([x|acc]) = #{:erlang.float_to_binary(res.prepend_ms, decimals: 3)} ms")
    end)
  end
