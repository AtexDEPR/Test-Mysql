-- ----------------------------
-- Script sql eventos 
-- ----------------------------

use sakila;

-- Evento 1: InformeAlquileresMensual
-- Genera un informe mensual de los alquileres realizados y lo almacena en una tabla de informes.
CREATE EVENT InformeAlquileresMensual
ON SCHEDULE EVERY 1 MONTH
STARTS '2025-04-01 00:00:00'
DO
BEGIN
    INSERT INTO informe_alquileres_mensual (mes, total_alquileres, total_ingresos)
    SELECT 
        DATE_FORMAT(fecha_alquiler, '%Y-%m') AS mes,
        COUNT(*) AS total_alquileres,
        SUM(total) AS total_ingresos
    FROM alquiler
    JOIN pago ON alquiler.id_alquiler = pago.id_alquiler
    GROUP BY mes;
END;

-- Evento 2: ActualizarSaldoPendienteCliente
-- Actualiza los saldos pendientes de los clientes al final de cada mes.
CREATE EVENT ActualizarSaldoPendienteCliente
ON SCHEDULE EVERY 1 MONTH
STARTS '2025-04-01 00:00:00'
DO
BEGIN
    UPDATE cliente
    SET saldo_pendiente = saldo_pendiente - (
        SELECT SUM(total)
        FROM pago
        WHERE pago.id_cliente = cliente.id_cliente
        AND DATE_FORMAT(fecha_pago, '%Y-%m') = DATE_FORMAT(NOW() - INTERVAL 1 MONTH, '%Y-%m')
    );
END;

-- Evento 3: AlertaPeliculasNoAlquiladas
-- Envía una alerta cuando una película no ha sido alquilada en el último año.
CREATE EVENT AlertaPeliculasNoAlquiladas
ON SCHEDULE EVERY 1 YEAR
STARTS '2025-01-01 00:00:00'
DO
BEGIN
    DECLARE pelicula_id INT;
    DECLARE done INT DEFAULT FALSE;
    DECLARE cur CURSOR FOR
        SELECT id_pelicula
        FROM pelicula
        WHERE id_pelicula NOT IN (
            SELECT DISTINCT id_pelicula
            FROM alquiler
            JOIN inventario ON alquiler.id_inventario = inventario.id_inventario
            WHERE fecha_alquiler >= NOW() - INTERVAL 1 YEAR
        );
    DECLARE CONTINUE HANDLER FOR NOT FOUND SET done = TRUE;

    OPEN cur;
    read_loop: LOOP
        FETCH cur INTO pelicula_id;
        IF done THEN
            LEAVE read_loop;
        END IF;
        -- Aquí se podría enviar una notificación o registrar en una tabla de alertas
        INSERT INTO alertas_peliculas_no_alquiladas (id_pelicula, fecha_alerta)
        VALUES (pelicula_id, NOW());
    END LOOP;
    CLOSE cur;
END;

-- Evento 4: LimpiarAuditoriaCada6Meses
-- Borra los registros antiguos de auditoría cada seis meses.
CREATE EVENT LimpiarAuditoriaCada6Meses
ON SCHEDULE EVERY 6 MONTH
STARTS '2025-06-01 00:00:00'
DO
BEGIN
    DELETE FROM auditoria_cliente
    WHERE fecha_cambio < NOW() - INTERVAL 6 MONTH;
END;

-- Evento 5: ActualizarCategoriasPopulares
-- Actualiza la lista de categorías más alquiladas al final de cada mes.
CREATE EVENT ActualizarCategoriasPopulares
ON SCHEDULE EVERY 1 MONTH
STARTS '2025-04-01 00:00:00'
DO
BEGIN
    INSERT INTO categorias_populares (mes, id_categoria, total_alquileres)
    SELECT 
        DATE_FORMAT(fecha_alquiler, '%Y-%m') AS mes,
        id_categoria,
        COUNT(*) AS total_alquileres
    FROM alquiler
    JOIN inventario ON alquiler.id_inventario = inventario.id_inventario
    JOIN pelicula_categoria ON inventario.id_pelicula = pelicula_categoria.id_pelicula
    GROUP BY mes, id_categoria
    ORDER BY total_alquileres DESC
    LIMIT 5;
END;
