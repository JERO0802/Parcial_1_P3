
defmodule Validacion do
  @moduledoc """
  Validación de lotes del taller.
  """

  @doc """
  Valida un lote siguiendo el orden exigido por el enunciado.
  """
  def validar_lote(lote, confeccionistas, lineas) do
    with {:ok, lote} <- validar_confeccionista(lote, confeccionistas),
         {:ok, lote} <- validar_linea(lote, lineas),
         {:ok, lote} <- validar_dia(lote),
         {:ok, lote} <- validar_prendas(lote),
         {:ok, lote} <- validar_defectos(lote) do
      {:ok, lote}
    end
  end

  defp validar_confeccionista(lote, confeccionistas) do
    existe =
      Enum.any?(confeccionistas, fn c ->
        c.codigo == lote.confeccionista
      end)

    if existe do
      {:ok, lote}
    else
      {:error, :confeccionista_desconocido}
    end
  end

  defp validar_linea(lote, lineas) do
    existe =
      Enum.any?(lineas, fn l ->
        l.id == lote.linea
      end)

    if existe do
      {:ok, lote}
    else
      {:error, :linea_desconocida}
    end
  end

  defp validar_dia(lote) do
    if is_integer(lote.dia) and lote.dia in 1..6 do
      {:ok, lote}
    else
      {:error, :dia_invalido}
    end
  end

  defp validar_prendas(lote) do
    if is_integer(lote.prendas) and lote.prendas >= 1 and lote.prendas <= 180 do
      {:ok, lote}
    else
      {:error, :prendas_fuera_de_rango}
    end
  end

  defp validar_defectos(lote) do
    if is_number(lote.defectos) and lote.defectos >= 0 and lote.defectos <= 100 do
      {:ok, lote}
    else
      {:error, :porcentaje_invalido}
    end
  end
end

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
