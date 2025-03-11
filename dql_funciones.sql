-- ----------------------------
-- Script SQL con funciones 
-- ----------------------------

use sakila;

-- 1. TotalIngresosCliente(ClienteID, Año): Calcula los ingresos generados por un cliente en un año específico.
DELIMITER //
CREATE FUNCTION TotalIngresosCliente(p_cliente_id INT, p_anio INT) 
RETURNS DECIMAL(10,2)
DETERMINISTIC
READS SQL DATA
BEGIN
    DECLARE total_ingresos DECIMAL(10,2);
    
    SELECT 
        IFNULL(SUM(p.total), 0) INTO total_ingresos
    FROM 
        pago p
    JOIN 
        alquiler a ON p.id_alquiler = a.id_alquiler
    WHERE 
        p.id_cliente = p_cliente_id AND
        YEAR(a.fecha_alquiler) = p_anio;
    
    RETURN total_ingresos;
END //
DELIMITER ;

-- 2. PromedioDuraciónAlquiler(PeliculaID): Retorna la duración promedio de alquiler de una película específica.
DELIMITER //
CREATE FUNCTION PromedioDuracionAlquiler(p_pelicula_id INT) 
RETURNS DECIMAL(10,2)
DETERMINISTIC
READS SQL DATA
BEGIN
    DECLARE duracion_promedio DECIMAL(10,2);
    
    SELECT 
        AVG(DATEDIFF(a.fecha_devolucion, a.fecha_alquiler)) INTO duracion_promedio
    FROM 
        alquiler a
    JOIN 
        inventario i ON a.id_inventario = i.id_inventario
    WHERE 
        i.id_pelicula = p_pelicula_id AND
        a.fecha_devolucion IS NOT NULL;
    
    -- Si no hay resultados, retornar 0
    RETURN IFNULL(duracion_promedio, 0);
END //
DELIMITER ;

-- 3. IngresosPorCategoria(CategoriaID): Calcula los ingresos totales generados por una categoría específica de películas.
DELIMITER //
CREATE FUNCTION IngresosPorCategoria(p_categoria_id INT) 
RETURNS DECIMAL(10,2)
DETERMINISTIC
READS SQL DATA
BEGIN
    DECLARE total_ingresos DECIMAL(10,2);
    
    SELECT 
        IFNULL(SUM(p.total), 0) INTO total_ingresos
    FROM 
        pago p
    JOIN 
        alquiler a ON p.id_alquiler = a.id_alquiler
    JOIN 
        inventario i ON a.id_inventario = i.id_inventario
    JOIN 
        pelicula_categoria pc ON i.id_pelicula = pc.id_pelicula
    WHERE 
        pc.id_categoria = p_categoria_id;
    
    RETURN total_ingresos;
END //
DELIMITER ;

-- 4. DescuentoFrecuenciaCliente(ClienteID): Calcula un descuento basado en la frecuencia de alquiler del cliente.
DELIMITER //
CREATE FUNCTION DescuentoFrecuenciaCliente(p_cliente_id INT) 
RETURNS DECIMAL(5,2)
DETERMINISTIC
READS SQL DATA
BEGIN
    DECLARE num_alquileres INT;
    DECLARE descuento DECIMAL(5,2);
    
    -- Contar número de alquileres del cliente en los últimos 3 meses
    SELECT 
        COUNT(*) INTO num_alquileres
    FROM 
        alquiler
    WHERE 
        id_cliente = p_cliente_id AND
        fecha_alquiler >= DATE_SUB(CURDATE(), INTERVAL 3 MONTH);
    
    -- Calcular descuento basado en frecuencia
    IF num_alquileres > 20 THEN
        SET descuento = 20.00; -- 20% de descuento
    ELSEIF num_alquileres > 15 THEN
        SET descuento = 15.00; -- 15% de descuento
    ELSEIF num_alquileres > 10 THEN
        SET descuento = 10.00; -- 10% de descuento
    ELSEIF num_alquileres > 5 THEN
        SET descuento = 5.00;  -- 5% de descuento
    ELSE
        SET descuento = 0.00;  -- Sin descuento
    END IF;
    
    RETURN descuento;
END //
DELIMITER ;

-- 5. EsClienteVIP(ClienteID): Verifica si un cliente es "VIP" calculando en la cantidad de alquileres realizados y los ingresos generados.
DELIMITER //
CREATE FUNCTION EsClienteVIP(p_cliente_id INT) 
RETURNS BOOLEAN
DETERMINISTIC
READS SQL DATA
BEGIN
    DECLARE num_alquileres INT;
    DECLARE total_ingresos DECIMAL(10,2);
    DECLARE es_vip BOOLEAN;
    
    -- Obtener cantidad de alquileres en el último año
    SELECT 
        COUNT(*) INTO num_alquileres
    FROM 
        alquiler
    WHERE 
        id_cliente = p_cliente_id AND
        fecha_alquiler >= DATE_SUB(CURDATE(), INTERVAL 1 YEAR);
    
    -- Obtener total de ingresos generados en el último año
    SELECT 
        IFNULL(SUM(total), 0) INTO total_ingresos
    FROM 
        pago
    WHERE 
        id_cliente = p_cliente_id AND
        fecha_pago >= DATE_SUB(CURDATE(), INTERVAL 1 YEAR);
    
    -- Definir criterio de cliente VIP (más de 20 alquileres o más de $200 en gastos)
    IF num_alquileres >= 20 OR total_ingresos >= 200.00 THEN
        SET es_vip = TRUE;
    ELSE
        SET es_vip = FALSE;
    END IF;
    
    RETURN es_vip;
END //
DELIMITER ;
