# Parcial 1: Liquidación de Producción de un Taller de Confecciones

**Asignatura:** Programación III  
**Programa:** Ingeniería de Sistemas y Computación  
**Institución:** Universidad del Quindío  
**Docente:** Robinson Arias Muñoz  

---

## 👥 Integrantes del Grupo
* **Juan Camilo Agudelo Sanchez**
* **Jeronimo Delgado Estrada**
* **Jose Daniel Carmona Garcia**

---

## 📋 Descripción del Proyecto
Este proyecto implementa una solución funcional en **Elixir** para gestionar y liquidar la producción semanal de confeccionistas en un taller de uniformes escolares. El sistema procesa
los datos brutos de planillas, valida los lotes bajo un estricto orden de negocio, aplica tarifas, recargos y bonificaciones, y genera ocho reportes estadísticos consolidados (R1 a R8) 
junto con consultas individuales por consola.

---

## ⚙️ Restricciones Técnicas Cumplidas
El proyecto se diseñó y construyó respetando estrictamente el alcance permitido del curso:
* **Sin recursividad:** Todo el procesamiento y transformación de colecciones se realizó con `Enum` y comprensiones `for`.
* **Sin structs:** Se usaron mapas (`Map`), listas (`List`), tuplas (`Tuple`) y listas de palabras clave (`Keyword list`).
* **Sin módulos de archivos:** No se utilizó el módulo `File`.
* **Sin concurrencia ni proyectos Mix:** No se usaron procesos (`spawn`, `Task`, `Agent`, `GenServer`) ni gestor de dependencias `mix`.
* **Manejo de errores:** Lógica de negocio controlada mediante tuplas `{:ok, valor}` y `{:error, motivo}` encadenadas con `with`.

---
