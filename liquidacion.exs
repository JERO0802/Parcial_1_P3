
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
