-- Consultas SQL consultas

use sakila;

-- 1. Encuentra el cliente que ha realizado la mayor cantidad de alquileres en los últimos 6 meses.
SELECT 
    c.id_cliente,
    CONCAT(c.nombre, ' ', c.apellidos) AS nombre_completo,
    COUNT(a.id_alquiler) AS total_alquileres
FROM 
    cliente c
JOIN 
    alquiler a ON c.id_cliente = a.id_cliente
WHERE 
    a.fecha_alquiler >= DATE_SUB(CURDATE(), INTERVAL 6 MONTH)
GROUP BY 
    c.id_cliente, nombre_completo
ORDER BY 
    total_alquileres DESC
LIMIT 1;

-- 2. Lista las cinco películas más alquiladas durante el último año.
SELECT 
    p.id_pelicula,
    p.titulo,
    COUNT(a.id_alquiler) AS total_alquileres
FROM 
    pelicula p
JOIN 
    inventario i ON p.id_pelicula = i.id_pelicula
JOIN 
    alquiler a ON i.id_inventario = a.id_inventario
WHERE 
    a.fecha_alquiler >= DATE_SUB(CURDATE(), INTERVAL 1 YEAR)
GROUP BY 
    p.id_pelicula, p.titulo
ORDER BY 
    total_alquileres DESC
LIMIT 5;

-- 3. Obtenga el total de ingresos y la cantidad de alquileres realizados por cada categoría de película.
SELECT 
    c.nombre AS categoria,
    COUNT(a.id_alquiler) AS total_alquileres,
    SUM(pa.total) AS total_ingresos
FROM 
    categoria c
JOIN 
    pelicula_categoria pc ON c.id_categoria = pc.id_categoria
JOIN 
    pelicula p ON pc.id_pelicula = p.id_pelicula
JOIN 
    inventario i ON p.id_pelicula = i.id_pelicula
JOIN 
    alquiler a ON i.id_inventario = a.id_inventario
JOIN 
    pago pa ON a.id_alquiler = pa.id_alquiler
GROUP BY 
    c.id_categoria, c.nombre
ORDER BY 
    total_ingresos DESC;

-- 4. Calcule el número total de clientes que han realizado alquileres por cada idioma disponible en un mes específico.
-- Asumimos que el mes específico es Enero de 2023
SELECT 
    i.nombre AS idioma,
    COUNT(DISTINCT c.id_cliente) AS total_clientes
FROM 
    idioma i
JOIN 
    pelicula p ON i.id_idioma = p.id_idioma
JOIN 
    inventario inv ON p.id_pelicula = inv.id_pelicula
JOIN 
    alquiler a ON inv.id_inventario = a.id_inventario
JOIN 
    cliente c ON a.id_cliente = c.id_cliente
WHERE 
    YEAR(a.fecha_alquiler) = 2023 AND
    MONTH(a.fecha_alquiler) = 1
GROUP BY 
    i.id_idioma, i.nombre
ORDER BY 
    total_clientes DESC;

-- 5. Encuentra a los clientes que han alquilado todas las películas de una misma categoría.
-- Esta consulta utiliza el enfoque de división relacional
SELECT 
    c.id_cliente,
    CONCAT(c.nombre, ' ', c.apellidos) AS nombre_completo,
    cat.nombre AS categoria
FROM 
    cliente c
JOIN 
    alquiler a ON c.id_cliente = a.id_cliente
JOIN 
    inventario i ON a.id_inventario = i.id_inventario
JOIN 
    pelicula p ON i.id_pelicula = p.id_pelicula
JOIN 
    pelicula_categoria pc ON p.id_pelicula = pc.id_pelicula
JOIN 
    categoria cat ON pc.id_categoria = cat.id_categoria
GROUP BY 
    c.id_cliente, nombre_completo, cat.id_categoria, cat.nombre
HAVING 
    COUNT(DISTINCT p.id_pelicula) = (
        SELECT COUNT(DISTINCT p_sub.id_pelicula)
        FROM pelicula p_sub
        JOIN pelicula_categoria pc_sub ON p_sub.id_pelicula = pc_sub.id_pelicula
        WHERE pc_sub.id_categoria = cat.id_categoria
    );

-- 6. Lista las tres ciudades con más clientes activos en el último trimestre.
SELECT 
    cd.nombre AS ciudad,
    p.nombre AS pais,
    COUNT(DISTINCT c.id_cliente) AS total_clientes_activos
FROM 
    ciudad cd
JOIN 
    pais p ON cd.id_pais = p.id_pais
JOIN 
    direccion d ON cd.id_ciudad = d.id_ciudad
JOIN 
    cliente c ON d.id_direccion = c.id_direccion
JOIN 
    alquiler a ON c.id_cliente = a.id_cliente
WHERE 
    c.activo = 1 AND
    a.fecha_alquiler >= DATE_SUB(CURDATE(), INTERVAL 3 MONTH)
GROUP BY 
    cd.id_ciudad, cd.nombre, p.nombre
ORDER BY 
    total_clientes_activos DESC
LIMIT 3;

-- 7. Muestra las cinco categorías con menos alquileres registrados en el último año.
SELECT 
    c.nombre AS categoria,
    COUNT(a.id_alquiler) AS total_alquileres
FROM 
    categoria c
LEFT JOIN 
    pelicula_categoria pc ON c.id_categoria = pc.id_categoria
LEFT JOIN 
    pelicula p ON pc.id_pelicula = p.id_pelicula
LEFT JOIN 
    inventario i ON p.id_pelicula = i.id_pelicula
LEFT JOIN 
    alquiler a ON i.id_inventario = a.id_inventario AND
                  a.fecha_alquiler >= DATE_SUB(CURDATE(), INTERVAL 1 YEAR)
GROUP BY 
    c.id_categoria, c.nombre
ORDER BY 
    total_alquileres ASC
LIMIT 5;

-- 8. Calcula el promedio de días que un cliente tarda en devolver las películas alquiladas.
SELECT 
    AVG(DATEDIFF(a.fecha_devolucion, a.fecha_alquiler)) AS promedio_dias_devolucion
FROM 
    alquiler a
WHERE 
    a.fecha_devolucion IS NOT NULL;

-- 9. Encuentra los cinco empleados que gestionan más alquileres en la categoría de Acción.
SELECT 
    e.id_empleado,
    CONCAT(e.nombre, ' ', e.apellidos) AS nombre_empleado,
    COUNT(a.id_alquiler) AS total_alquileres_accion
FROM 
    empleado e
JOIN 
    alquiler a ON e.id_empleado = a.id_empleado
JOIN 
    inventario i ON a.id_inventario = i.id_inventario
JOIN 
    pelicula p ON i.id_pelicula = p.id_pelicula
JOIN 
    pelicula_categoria pc ON p.id_pelicula = pc.id_pelicula
JOIN 
    categoria c ON pc.id_categoria = c.id_categoria
WHERE 
    c.nombre = 'Action'
GROUP BY 
    e.id_empleado, nombre_empleado
ORDER BY 
    total_alquileres_accion DESC
LIMIT 5;

-- 10. Genera un informe de los clientes con alquileres más recurrentes.
SELECT 
    c.id_cliente,
    CONCAT(c.nombre, ' ', c.apellidos) AS nombre_completo,
    COUNT(a.id_alquiler) AS total_alquileres,
    MIN(a.fecha_alquiler) AS primera_fecha,
    MAX(a.fecha_alquiler) AS ultima_fecha,
    DATEDIFF(MAX(a.fecha_alquiler), MIN(a.fecha_alquiler)) AS dias_entre_primer_ultimo,
    ROUND(COUNT(a.id_alquiler) / 
          (CASE WHEN DATEDIFF(MAX(a.fecha_alquiler), MIN(a.fecha_alquiler)) = 0 
                THEN 1 
                ELSE DATEDIFF(MAX(a.fecha_alquiler), MIN(a.fecha_alquiler)) END) * 30, 2) AS alquileres_por_mes
FROM 
    cliente c
JOIN 
    alquiler a ON c.id_cliente = a.id_cliente
GROUP BY 
    c.id_cliente, nombre_completo
HAVING 
    COUNT(a.id_alquiler) > 1
ORDER BY 
    alquileres_por_mes DESC, total_alquileres DESC
LIMIT 10;

-- 11. Calcula el costo promedio de alquiler por idioma de las películas.
SELECT 
    i.nombre AS idioma,
    AVG(p.rental_rate) AS costo_promedio_alquiler
FROM 
    idioma i
JOIN 
    pelicula p ON i.id_idioma = p.id_idioma
GROUP BY 
    i.id_idioma, i.nombre
ORDER BY 
    costo_promedio_alquiler DESC;

-- 12. Lista las cinco películas con mayor duración alquiladas en el último año.
SELECT 
    p.id_pelicula,
    p.titulo,
    p.duracion,
    COUNT(a.id_alquiler) AS total_alquileres
FROM 
    pelicula p
JOIN 
    inventario i ON p.id_pelicula = i.id_pelicula
JOIN 
    alquiler a ON i.id_inventario = a.id_inventario
WHERE 
    a.fecha_alquiler >= DATE_SUB(CURDATE(), INTERVAL 1 YEAR)
GROUP BY 
    p.id_pelicula, p.titulo, p.duracion
ORDER BY 
    p.duracion DESC, total_alquileres DESC
LIMIT 5;

-- 13. Muestra los clientes que más alquilaron películas de Comedia.
SELECT 
    c.id_cliente,
    CONCAT(c.nombre, ' ', c.apellidos) AS nombre_completo,
    COUNT(a.id_alquiler) AS total_alquileres_comedia
FROM 
    cliente c
JOIN 
    alquiler a ON c.id_cliente = a.id_cliente
JOIN 
    inventario i ON a.id_inventario = i.id_inventario
JOIN 
    pelicula p ON i.id_pelicula = p.id_pelicula
JOIN 
    pelicula_categoria pc ON p.id_pelicula = pc.id_pelicula
JOIN 
    categoria cat ON pc.id_categoria = cat.id_categoria
WHERE 
    cat.nombre = 'Comedy'
GROUP BY 
    c.id_cliente, nombre_completo
ORDER BY 
    total_alquileres_comedia DESC
LIMIT 10;

-- 14. Encuentra la cantidad total de días alquilados por cada cliente en el último mes.
SELECT 
    c.id_cliente,
    CONCAT(c.nombre, ' ', c.apellidos) AS nombre_completo,
    SUM(DATEDIFF(IFNULL(a.fecha_devolucion, CURDATE()), a.fecha_alquiler)) AS total_dias_alquilados
FROM 
    cliente c
JOIN 
    alquiler a ON c.id_cliente = a.id_cliente
WHERE 
    a.fecha_alquiler >= DATE_SUB(CURDATE(), INTERVAL 1 MONTH)
GROUP BY 
    c.id_cliente, nombre_completo
ORDER BY 
    total_dias_alquilados DESC;

-- 15. Muestra el número de alquileres diarios en cada almacén durante el último trimestre.
SELECT 
    al.id_almacen,
    DATE(a.fecha_alquiler) AS fecha,
    COUNT(a.id_alquiler) AS total_alquileres
FROM 
    almacen al
JOIN 
    inventario i ON al.id_almacen = i.id_almacen
JOIN 
    alquiler a ON i.id_inventario = a.id_inventario
WHERE 
    a.fecha_alquiler >= DATE_SUB(CURDATE(), INTERVAL 3 MONTH)
GROUP BY 
    al.id_almacen, fecha
ORDER BY 
    al.id_almacen, fecha;

-- 16. Calcule los ingresos totales generados por cada almacén en el último semestre.
SELECT 
    al.id_almacen,
    SUM(p.total) AS ingresos_totales
FROM 
    almacen al
JOIN 
    inventario i ON al.id_almacen = i.id_almacen
JOIN 
    alquiler a ON i.id_inventario = a.id_inventario
JOIN 
    pago p ON a.id_alquiler = p.id_alquiler
WHERE 
    a.fecha_alquiler >= DATE_SUB(CURDATE(), INTERVAL 6 MONTH)
GROUP BY 
    al.id_almacen
ORDER BY 
    ingresos_totales DESC;

-- 17. Encuentra el cliente que ha realizado el alquiler más caro en el último año.
SELECT 
    c.id_cliente,
    CONCAT(c.nombre, ' ', c.apellidos) AS nombre_completo,
    p.total AS monto_alquiler,
    p.id_alquiler,
    pel.titulo
FROM 
    cliente c
JOIN 
    alquiler a ON c.id_cliente = a.id_cliente
JOIN 
    pago p ON a.id_alquiler = p.id_alquiler
JOIN 
    inventario i ON a.id_inventario = i.id_inventario
JOIN 
    pelicula pel ON i.id_pelicula = pel.id_pelicula
WHERE 
    a.fecha_alquiler >= DATE_SUB(CURDATE(), INTERVAL 1 YEAR)
ORDER BY 
    p.total DESC
LIMIT 1;

-- 18. Lista las cinco categorías con más ingresos generados durante los últimos tres meses.
SELECT 
    c.nombre AS categoria,
    SUM(p.total) AS ingresos_totales
FROM 
    categoria c
JOIN 
    pelicula_categoria pc ON c.id_categoria = pc.id_categoria
JOIN 
    pelicula pel ON pc.id_pelicula = pel.id_pelicula
JOIN 
    inventario i ON pel.id_pelicula = i.id_pelicula
JOIN 
    alquiler a ON i.id_inventario = a.id_inventario
JOIN 
    pago p ON a.id_alquiler = p.id_alquiler
WHERE 
    a.fecha_alquiler >= DATE_SUB(CURDATE(), INTERVAL 3 MONTH)
GROUP BY 
    c.id_categoria, c.nombre
ORDER BY 
    ingresos_totales DESC
LIMIT 5;

-- 19. Obtenga la cantidad de películas alquiladas por cada idioma en el último mes.
SELECT 
    i.nombre AS idioma,
    COUNT(a.id_alquiler) AS total_peliculas_alquiladas
FROM 
    idioma i
JOIN 
    pelicula p ON i.id_idioma = p.id_idioma
JOIN 
    inventario inv ON p.id_pelicula = inv.id_pelicula
JOIN 
    alquiler a ON inv.id_inventario = a.id_inventario
WHERE 
    a.fecha_alquiler >= DATE_SUB(CURDATE(), INTERVAL 1 MONTH)
GROUP BY 
    i.id_idioma, i.nombre
ORDER BY 
    total_peliculas_alquiladas DESC;

-- 20. Lista los clientes que no han realizado ningún alquiler en el último año.
SELECT 
    c.id_cliente,
    CONCAT(c.nombre, ' ', c.apellidos) AS nombre_completo,
    c.email
FROM 
    cliente c
LEFT JOIN 
    alquiler a ON c.id_cliente = a.id_cliente AND
                   a.fecha_alquiler >= DATE_SUB(CURDATE(), INTERVAL 1 YEAR)
WHERE 
    a.id_alquiler IS NULL
ORDER BY 
    nombre_completo;