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

  @doc """
  Genera el reporte R3 con las prendas producidas por el taller
  en cada uno de los seis días.

  Para cada día indica la cantidad de prendas producidas y si se
  alcanzó la meta de 600 prendas.

  Los días sin lotes válidos aparecen con cero prendas.
  También indica si la meta se alcanzó todos los días y si se
  alcanzó al menos un día.
  """
 def reporte_3(lotes_validos) do
    produccion_diaria =
      Enum.map(1..6, fn dia ->
        prendas = prendas_por_dia(lotes_validos, dia)

        %{
          dia: dia,
          prendas: prendas,
          meta_alcanzada: prendas >= 600
        }
      end)

    %{
      produccion_diaria: produccion_diaria,
      resumen: %{
        todos_los_dias: Enum.all?(produccion_diaria, & &1.meta_alcanzada),
        al_menos_un_dia: Enum.any?(produccion_diaria, & &1.meta_alcanzada)
      }
    }
  end


  defp prendas_por_dia(lotes_validos, dia) do
    lotes_validos
    |> Enum.filter(fn lote -> lote.dia == dia end)
    |> Enum.map(fn lote -> lote.prendas end)
    |> Enum.sum()
  end

   @doc """
  Genera el reporte R6 con el confeccionista que tiene el menor
  porcentaje de defectos ponderado por prendas.

  Solo participan los confeccionistas que tengan al menos
  tres lotes válidos.
  """
  def reporte_6(lotes_validos, confeccionistas) do
    candidatos =
      Enum.map(confeccionistas, fn confeccionista ->
        lotes_confeccionista =
          Enum.filter(lotes_validos, fn lote ->
            lote.confeccionista == confeccionista.codigo
          end)

        cantidad_lotes = Enum.count(lotes_confeccionista)

        if cantidad_lotes >= 3 do
          prendas_totales =
            lotes_confeccionista
            |> Enum.map(fn lote -> lote.prendas end)
            |> Enum.sum()

          defectos_ponderados =
            lotes_confeccionista
            |> Enum.map(fn lote -> lote.defectos * lote.prendas end)
            |> Enum.sum()

          porcentaje_ponderado = defectos_ponderados / prendas_totales

          %{
            codigo: confeccionista.codigo,
            nombre: confeccionista.nombre,
            lotes_validos: cantidad_lotes,
            prendas: prendas_totales,
            porcentaje_ponderado: porcentaje_ponderado
          }
        else
          nil
        end
      end)
      |> Enum.filter(fn candidato -> candidato != nil end)

    case candidatos do
      [] ->
        nil

      _ ->
        Enum.min_by(candidatos, fn candidato ->
          candidato.porcentaje_ponderado
        end)
    end
  end

end
