-- Trigger 1: ActualizarTotalAlquileresEmpleado
-- Actualiza el total de alquileres gestionados por un empleado cada vez que se registra un nuevo alquiler.
DELIMITER //

CREATE TRIGGER ActualizarTotalAlquileresEmpleado
AFTER INSERT ON alquiler
FOR EACH ROW
BEGIN
    UPDATE empleado
    SET total_alquileres_gestionados = total_alquileres_gestionados + 1
    WHERE id_empleado = NEW.id_empleado;
END//

DELIMITER ;

-- Trigger 2: AuditarActualizacionCliente
-- Registra los cambios en la tabla de auditoría cada vez que se modifica un cliente.
DELIMITER //

CREATE TRIGGER AuditarActualizacionCliente
AFTER UPDATE ON cliente
FOR EACH ROW
BEGIN
    INSERT INTO auditoria_cliente (id_cliente, accion, fecha_cambio, datos_anteriores, datos_nuevos)
    VALUES (
        OLD.id_cliente,
        'UPDATE',
        NOW(),
        CONCAT('Nombre: ', OLD.nombre, ' ', OLD.apellidos, ', Email: ', OLD.email, ', Activo: ', OLD.activo),
        CONCAT('Nombre: ', NEW.nombre, ' ', NEW.apellidos, ', Email: ', NEW.email, ', Activo: ', NEW.activo)
    );
END//

DELIMITER ;

-- Trigger 3: RegistrarHistorialDeCosto
-- Guarda el historial de cambios en los costos de alquiler de las películas.
DELIMITER //

CREATE TRIGGER RegistrarHistorialDeCosto
AFTER UPDATE ON pelicula
FOR EACH ROW
BEGIN
    IF OLD.rental_rate <> NEW.rental_rate THEN
        INSERT INTO historial_costo_pelicula (id_pelicula, costo_anterior, costo_nuevo, fecha_cambio)
        VALUES (
            OLD.id_pelicula,
            OLD.rental_rate,
            NEW.rental_rate,
            NOW()
        );
    END IF;
END//

DELIMITER ;

-- Trigger 4: NotificarEliminacionAlquiler
-- Registra una notificación cuando se elimina un registro de alquiler.


-- Trigger 5: RestringirAlquilerConSaldoPendiente
-- Evita que un cliente con saldo pendiente pueda realizar nuevos alquileres.
