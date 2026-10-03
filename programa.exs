defmodule Programa do
   @moduledoc """
   Cordina la ejecucion del programa del taller de confecciones.
   """

   def main() do
     confeccionistas=Datos.confeccionistas()
      lineas=Datos.lineas()
      lotes=Datos.lotes()

     resultados =
      Enum.map(lotes, fn lote ->
        resultado = Validacion.validar_lote(lote, confeccionistas, lineas)
        {lote, resultado}
      end)

    reporte_1 = Reportes.reporte_1(resultados)

    IO.inspect(reporte_1)

    end

end

