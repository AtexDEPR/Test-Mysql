# SAKILA CAMPUS
---

### Descripcion
---
El proyecto se basa en un tienda que renta peliculas llamada SAKILA CAMPUS
la base de datos esta dividadia en 16 tablas las cuales se relacionan
de manera que no quedan estando de muchos a muchos sino que deciende en
tablas conectoras como podira ser pelicula_categoria,
en este poryecto tambien tratamos de optimicizar tareas como Genera un informe mensual
de alquileres y lo almacena automáticamente usando eventos y eventos que nos ayudan a optimizar
tareas como Calcula un descuento basado en la frecuencia de alquiler del cliente para mejorar
la experiencia del cliente, este proyecto tambien incluye consultas avanzada las cuales sun muy utiles
para la eficiencia al momenteo de buscar informacion importante en la base de datos.

Consultas SQL:

  1.  Encuentra el cliente que ha realizado la mayor cantidad de alquileres en los últimos 6 meses.
  2.  Lista las cinco películas más alquiladas durante el último año.
  3.  Obtén el total de ingresos y la cantidad de alquileres realizados por cada categoría de película.
  4.  Calcula el número total de clientes que han realizado alquileres por cada idioma disponible en un mes específico.
  5.  Encuentra a los clientes que han alquilado todas las películas de una misma categoría.
  6.  Lista las tres ciudades con más clientes activos en el último trimestre.
  7.  Muestra las cinco categorías con menos alquileres registrados en el último año.
  8.  Calcula el promedio de días que un cliente tarda en devolver las películas alquiladas.
  9.  Encuentra los cinco empleados que gestionaron más alquileres en la categoría de Acción.
  10.  Genera un informe de los clientes con alquileres más recurrentes.
  11.  Calcula el costo promedio de alquiler por idioma de las películas.
  12.  Lista las cinco películas con mayor duración alquiladas en el último año.
  13.  Muestra los clientes que más alquilaron películas de Comedia.
  14.  Encuentra la cantidad total de días alquilados por cada cliente en el último mes.
  15.  Muestra el número de alquileres diarios en cada almacén durante el último trimestre.
  16.  Calcula los ingresos totales generados por cada almacén en el último semestre.
  17.  Encuentra el cliente que ha realizado el alquiler más caro en el último año.
  18.  Lista las cinco categorías con más ingresos generados durante los últimos tres meses.
  19.  Obtén la cantidad de películas alquiladas por cada idioma en el último mes.
  20.  Lista los clientes que no han realizado ningún alquiler en el último año.

Funciones SQL:

Desarrolla las siguientes funciones:

  1.  TotalIngresosCliente(ClienteID, Año): Calcula los ingresos generados por un cliente en un año específico.
  2.  PromedioDuracionAlquiler(PeliculaID): Retorna la duración promedio de alquiler de una película específica.
  3.  IngresosPorCategoria(CategoriaID): Calcula los ingresos totales generados por una categoría específica de películas.
  4.  DescuentoFrecuenciaCliente(ClienteID): Calcula un descuento basado en la frecuencia de alquiler del cliente.
  5.  EsClienteVIP(ClienteID): Verifica si un cliente es "VIP" basándose en la cantidad de alquileres realizados y los ingresos generados.

Triggers:

Implementa los siguientes triggers:

   1. ActualizarTotalAlquileresEmpleado: Al registrar un alquiler, actualiza el total de alquileres gestionados por el empleado correspondiente.
   2. AuditarActualizacionCliente: Cada vez que se modifica un cliente, registra el cambio en una tabla de auditoría.
   3. RegistrarHistorialDeCosto: Guarda el historial de cambios en los costos de alquiler de las películas.
   4. NotificarEliminacionAlquiler: Registra una notificación cuando se elimina un registro de alquiler.
   5. RestringirAlquilerConSaldoPendiente: Evita que un cliente con saldo pendiente pueda realizar nuevos alquileres.

Eventos SQL:

Crea los siguientes eventos:

   1. InformeAlquileresMensual: Genera un informe mensual de alquileres y lo almacena automáticamente.
   2. ActualizarSaldoPendienteCliente: Actualiza los saldos pendientes de los clientes al final de cada mes.
   3. AlertaPeliculasNoAlquiladas: Envía una alerta cuando una película no ha sido alquilada en el último año.
   4. LimpiarAuditoriaCada6Meses: Borra los registros antiguos de auditoría cada seis meses.
   5. ActualizarCategoriasPopulares: Actualiza la lista de categorías más alquiladas al final de cada mes.

###Resultado esperado
---

Se deberá entregar el examen a través de un repositorio privado en GitHub (Compartido con las cuentas que el Trainer indique). El repositorio deberá estar bien estructurado, contener toda la documentación necesaria y los archivos SQL correspondientes.


1. Repositorio en GitHub:


    Crear un repositorio privado en GitHub. Asegúrate de invitar al profesor como colaborador para que pueda revisar el trabajo.
    El repositorio debe seguir una estructura clara y organizada. Los archivos SQL deben estar divididos en carpetas según su propósito.
    El README.md debe incluir una descripción detallada del examen, instrucciones para configurar la base de datos, cómo ejecutar las consultas, funciones, triggers y eventos, así como cualquier otra consideración importante.


2. Estructura del Repositorio:


El repositorio debe estar organizado de la siguiente manera:

    ddl.sql (Creación de base de datos con tablas y relaciones)
    dml.sql (inserciones de datos)
    dql_select.sql (Consultas)
    dql_funciones.sql (funciones)
    dql_triggers.sql (triggers)
    dql_eventos.sql (eventos)
    Readme.md
    Diagrama.jpg (Modelo de datos)


3. Contenido del README.md:


El archivo README.md debe estar bien estructurado y contener los siguientes apartados:


Descripción del Proyecto:

    Explicación clara y concisa del Examen (el nombre que le hayan dado a su examen). Incluye el propósito de la base de datos y una descripción general de las funcionalidades que se han implementado.


Requisitos del Sistema:

    Detalla el software necesario para ejecutar los scripts (e.g., MySQL versión X.X, cliente MySQL Workbench, etc.).


Instalación y Configuración:

    Instrucciones paso a paso para configurar el entorno, cargar la base de datos y ejecutar los scripts SQL. Asegúrate de incluir:
    Cómo ejecutar el archivo ddl.sql para generar la estructura de la base de datos.
    Cómo cargar los datos iniciales con el archivo dml.sql.
    Instrucciones para ejecutar las consultas, funciones, eventos y triggers.


Archivos SQL:

    Todos los scripts SQL necesarios deben estar incluidos en las carpetas adecuadas. Los nombres de los archivos deben ser claros y descriptivos.
    Los scripts deben estar bien documentados con comentarios que expliquen el propósito de cada sección, cómo funcionan las consultas o procedimientos, y cualquier otro detalle que facilite su comprensión.


### Estructura del Repositorio
---
    ddl.sql (Creación de base de datos con tablas y relaciones)
    dml.sql (inserciones de datos)
    dql_select.sql (Consultas)
    dql_funciones.sql (funciones)
    dql_triggers.sql (triggers)
    dql_eventos.sql (eventos)
    Readme.md
    Diagrama.jpg (Modelo de datos)
