
@doc """
Calcula el valor económico de un lote válido.
"""
def valor_lote(lote) do
  valor_base = lote.prendas * @tarifa_base

  cond do
    lote.defectos <= 2 ->
      valor_base * 1.07

    lote.defectos <= 5 ->
      valor_base

    lote.defectos <= 10 ->
      valor_base * 0.88

    true ->
      valor_base * 0.75
  end
end

@doc """
Calcula la bonificación de un día.
"""
def bonificacion_productividad(prendas_dia) do
  if prendas_dia >= 120 do
    @bonificacion_diaria
  else
    0
  end
end

@doc """
Calcula el descuento por alquiler.
"""
def alquiler_maquinas(alquiler, dias_trabajados) do
  if alquiler do
    dias_trabajados * @alquiler_maquina
  else
    0
  end
end

@doc """
Suma las bonificaciones obtenidas en la semana.
"""
def total_bonificaciones(lotes_validos, codigo) do
  lotes_validos
  |> Enum.filter(fn lote ->
    lote.confeccionista == codigo
  end)
  |> Enum.group_by(& &1.dia)
  |> Enum.map(fn {_dia, lotes} ->
    prendas =
      Enum.sum(
        Enum.map(lotes, fn lote ->
          lote.prendas
        end)
      )

    bonificacion_productividad(prendas)
  end)
  |> Enum.sum()
end

@doc """
Cuenta los días en los que registró al menos un lote válido.
"""
def dias_trabajados(lotes_validos, codigo) do
  lotes_validos
  |> Enum.filter(fn lote ->
    lote.confeccionista == codigo
  end)
  |> Enum.map(fn lote ->
    lote.dia
  end)
  |> Enum.uniq()
  |> Enum.count()
end

@doc """
Genera la liquidación de un confeccionista.
"""
def liquidacion_confeccionista(
      confeccionista,
      lotes_validos
    ) do

  lotes_confeccionista =
    Enum.filter(lotes_validos, fn lote ->
      lote.confeccionista == confeccionista.codigo
    end)

  prendas =
    Enum.sum(
      Enum.map(lotes_confeccionista, fn lote ->
        lote.prendas
      end)
    )

  valor_lotes =
    Enum.sum(
      Enum.map(lotes_confeccionista, fn lote ->
        valor_lote(lote)
      end)
    )

  bonificaciones =
    total_bonificaciones(
      lotes_validos,
      confeccionista.codigo
    )

  dias =
    dias_trabajados(
      lotes_validos,
      confeccionista.codigo
    )

  alquiler =
    alquiler_maquinas(
      confeccionista.alquiler,
      dias
    )

  neto =
    valor_lotes +
    bonificaciones -
    alquiler

  %{
    codigo: confeccionista.codigo,
    nombre: confeccionista.nombre,
    prendas: prendas,
    valor_lotes: valor_lotes,
    bonificaciones: bonificaciones,
    alquiler: alquiler,
    neto: neto
  }
end

@doc """
Genera la liquidación completa.
"""
def liquidar_todos(
      confeccionistas,
      lotes_validos
    ) do

  Enum.map(
    confeccionistas,
    fn confeccionista ->
      liquidacion_confeccionista(
        confeccionista,
        lotes_validos
      )
    end
  )
end
