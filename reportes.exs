defmodule Reportes do

  @moduledoc """
  Genera los reportes del taller de confecciones
  """

  @doc """
  Genera el reporte R1, que contiene los lotes rechazados
   los motivos de rechazo,y la cantidad de rechazos por motivo.
  """
  
  def reporte_1(resultados) do
    Enum.reduce(resultados, %{rechazados: [], cantidades: %{}}, fn {lote, resultado}, acumulador ->
      case resultado do
        {:ok, _lote} ->
          acumulador

        {:error, motivo} ->
          rechazados = [{lote, motivo} | acumulador.rechazados]

          cantidades = Map.update(acumulador.cantidades, motivo, 1, &(&1 + 1))
           %{
            rechazados: rechazados,
            cantidades: cantidades
          }
      end
    end)
  end


end
