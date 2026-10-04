defmodule Programa do
   @moduledoc """
   Cordina la ejecucion del programa del taller de confecciones.
   """
   #Este fue hecho de manera temporal para poder probar el reporte 1, se puede eliminar cuando se haga la integracion con el resto del programa.
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
