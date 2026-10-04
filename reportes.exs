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
  
  @doc """
  Genera el reporte R2 con las prendas producidas por cada línea
  y la productividad semanal en prendas por puesto.

  Las líneas sin lotes válidos aparecen con cero prendas.
  El resultado se ordena de mayor a menor productividad.
  """
  def reporte_2(lotes_validos, lineas) do
    lineas
    |> Enum.map(fn linea ->
      prendas = prendas_por_linea(lotes_validos, linea.id)

      productividad = prendas / linea.puestos

      %{
        id: linea.id,
        nombre: linea.nombre,
        prendas: prendas,
        puestos: linea.puestos,
        productividad: productividad
      }
    end)
    |> Enum.sort_by(& &1.productividad, :desc)
  end

  defp prendas_por_linea(lotes_validos, id_linea) do
    lotes_validos
    |> Enum.filter(fn lote -> lote.linea == id_linea end)
    |> Enum.map(fn lote -> lote.prendas end)
    |> Enum.sum()
  end


end
