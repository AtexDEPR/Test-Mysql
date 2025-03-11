-- ----------------------------
-- Creación de tablas para la base de datos
-- ----------------------------

create database sakila;

use sakila;

-- Tabla pago
CREATE TABLE pago (
    id_pago SMALLINT UNSIGNED PRIMARY KEY,
    id_cliente SMALLINT UNSIGNED,
    id_empleado TINYINT UNSIGNED,
    id_alquiler INT,
    total DECIMAL(5,2),
    fecha_pago DATETIME,
    ultima_actualizacion TIMESTAMP
);

-- Tabla alquiler
CREATE TABLE alquiler (
    id_alquiler INT PRIMARY KEY,
    fecha_alquiler DATETIME,
    id_inventario MEDIUMINT UNSIGNED,
    id_cliente SMALLINT UNSIGNED,
    fecha_devolucion DATETIME,
    id_empleado TINYINT UNSIGNED,
    ultima_actualizacion TIMESTAMP
);

-- Tabla cliente
CREATE TABLE cliente (
    id_cliente SMALLINT UNSIGNED PRIMARY KEY,
    id_almacen TINYINT UNSIGNED,
    nombre VARCHAR(45),
    apellidos VARCHAR(45),
    email VARCHAR(50),
    id_direccion SMALLINT UNSIGNED,
    activo TINYINT(1),
    fecha_creacion DATETIME,
    ultima_actualizacion TIMESTAMP
);

-- Tabla almacen
CREATE TABLE almacen (
    id_almacen TINYINT UNSIGNED PRIMARY KEY,
    id_empleado_jefe TINYINT UNSIGNED,
    id_direccion SMALLINT UNSIGNED,
    ultima_actualizacion TIMESTAMP
);

-- Tabla empleado
CREATE TABLE empleado (
    id_empleado TINYINT UNSIGNED PRIMARY KEY,
    nombre VARCHAR(45),
    apellidos VARCHAR(45),
    id_direccion SMALLINT UNSIGNED,
    imagen BLOB,
    email VARCHAR(50),
    id_almacen TINYINT UNSIGNED,
    activo TINYINT(1),
    username VARCHAR(16),
    password VARCHAR(40),
    ultima_actualizacion TIMESTAMP
);

-- Tabla pelicula
CREATE TABLE pelicula (
    id_pelicula SMALLINT UNSIGNED PRIMARY KEY,
    titulo VARCHAR(255),
    descripcion TEXT,
    anyo_lanzamiento YEAR,
    id_idioma TINYINT UNSIGNED,
    id_idioma_original TINYINT UNSIGNED,
    duracion_alquiler TINYINT UNSIGNED,
    rental_rate DECIMAL(4,2),
    duracion SMALLINT UNSIGNED,
    replacement_cost DECIMAL(5,2),
    clasificacion ENUM('G','PG','PG-13','R','NC-17'),
    caracteristicas_especiales SET('Trailers','Commentaries','Deleted Scenes','Behind the Scenes'),
    ultima_actualizacion TIMESTAMP
);

-- Tabla film_text
CREATE TABLE film_text (
    film_id SMALLINT,
    title VARCHAR(255),
    description TEXT,
    PRIMARY KEY (film_id)
);

-- Tabla inventario
CREATE TABLE inventario (
    id_inventario MEDIUMINT UNSIGNED PRIMARY KEY,
    id_pelicula SMALLINT UNSIGNED,
    id_almacen TINYINT UNSIGNED,
    ultima_actualizacion TIMESTAMP
);

-- Tabla pelicula_categoria
CREATE TABLE pelicula_categoria (
    id_pelicula SMALLINT UNSIGNED,
    id_categoria TINYINT UNSIGNED,
    ultima_actualizacion TIMESTAMP,
    PRIMARY KEY (id_pelicula, id_categoria)
);

-- Tabla categoria
CREATE TABLE categoria (
    id_categoria TINYINT UNSIGNED PRIMARY KEY,
    nombre VARCHAR(25),
    ultima_actualizacion TIMESTAMP
);

-- Tabla pelicula_actor
CREATE TABLE pelicula_actor (
    id_actor SMALLINT UNSIGNED,
    id_pelicula SMALLINT UNSIGNED,
    ultima_actualizacion TIMESTAMP,
    PRIMARY KEY (id_actor, id_pelicula)
);

-- Tabla actor
CREATE TABLE actor (
    id_actor SMALLINT UNSIGNED PRIMARY KEY,
    nombre VARCHAR(45),
    apellidos VARCHAR(45),
    ultima_actualizacion TIMESTAMP
);

-- Tabla direccion
CREATE TABLE direccion (
    id_direccion SMALLINT UNSIGNED PRIMARY KEY,
    direccion VARCHAR(50),
    direccion2 VARCHAR(50),
    distrito VARCHAR(20),
    id_ciudad SMALLINT UNSIGNED,
    codigo_postal VARCHAR(10),
    telefono VARCHAR(20),
    ultima_actualizacion TIMESTAMP
);

-- Tabla idioma
CREATE TABLE idioma (
    id_idioma TINYINT UNSIGNED PRIMARY KEY,
    nombre CHAR(20),
    ultima_actualizacion TIMESTAMP
);

-- Tabla ciudad
CREATE TABLE ciudad (
    id_ciudad SMALLINT UNSIGNED PRIMARY KEY,
    nombre VARCHAR(50),
    id_pais SMALLINT UNSIGNED,
    ultima_actualizacion TIMESTAMP
);

-- Tabla pais
CREATE TABLE pais (
    id_pais SMALLINT UNSIGNED PRIMARY KEY,
    nombre VARCHAR(50),
    ultima_actualizacion TIMESTAMP
);

-- Agregando claves foráneas

-- Claves foráneas para pago
ALTER TABLE pago
    ADD CONSTRAINT fk_pago_cliente FOREIGN KEY (id_cliente) REFERENCES cliente (id_cliente),
    ADD CONSTRAINT fk_pago_empleado FOREIGN KEY (id_empleado) REFERENCES empleado (id_empleado),
    ADD CONSTRAINT fk_pago_alquiler FOREIGN KEY (id_alquiler) REFERENCES alquiler (id_alquiler);

-- Claves foráneas para alquiler
ALTER TABLE alquiler
    ADD CONSTRAINT fk_alquiler_inventario FOREIGN KEY (id_inventario) REFERENCES inventario (id_inventario),
    ADD CONSTRAINT fk_alquiler_cliente FOREIGN KEY (id_cliente) REFERENCES cliente (id_cliente),
    ADD CONSTRAINT fk_alquiler_empleado FOREIGN KEY (id_empleado) REFERENCES empleado (id_empleado);

-- Claves foráneas para cliente
ALTER TABLE cliente
    ADD CONSTRAINT fk_cliente_almacen FOREIGN KEY (id_almacen) REFERENCES almacen (id_almacen),
    ADD CONSTRAINT fk_cliente_direccion FOREIGN KEY (id_direccion) REFERENCES direccion (id_direccion);

-- Claves foráneas para almacen
ALTER TABLE almacen
    ADD CONSTRAINT fk_almacen_empleado FOREIGN KEY (id_empleado_jefe) REFERENCES empleado (id_empleado),
    ADD CONSTRAINT fk_almacen_direccion FOREIGN KEY (id_direccion) REFERENCES direccion (id_direccion);

-- Claves foráneas para empleado
ALTER TABLE empleado
    ADD CONSTRAINT fk_empleado_direccion FOREIGN KEY (id_direccion) REFERENCES direccion (id_direccion),
    ADD CONSTRAINT fk_empleado_almacen FOREIGN KEY (id_almacen) REFERENCES almacen (id_almacen);

-- Claves foráneas para pelicula
ALTER TABLE pelicula
    ADD CONSTRAINT fk_pelicula_idioma FOREIGN KEY (id_idioma) REFERENCES idioma (id_idioma),
    ADD CONSTRAINT fk_pelicula_idioma_original FOREIGN KEY (id_idioma_original) REFERENCES idioma (id_idioma);

-- Claves foráneas para inventario
ALTER TABLE inventario
    ADD CONSTRAINT fk_inventario_pelicula FOREIGN KEY (id_pelicula) REFERENCES pelicula (id_pelicula),
    ADD CONSTRAINT fk_inventario_almacen FOREIGN KEY (id_almacen) REFERENCES almacen (id_almacen);

-- Claves foráneas para pelicula_categoria
ALTER TABLE pelicula_categoria
    ADD CONSTRAINT fk_pelicula_categoria_pelicula FOREIGN KEY (id_pelicula) REFERENCES pelicula (id_pelicula),
    ADD CONSTRAINT fk_pelicula_categoria_categoria FOREIGN KEY (id_categoria) REFERENCES categoria (id_categoria);

-- Claves foráneas para pelicula_actor
ALTER TABLE pelicula_actor
    ADD CONSTRAINT fk_pelicula_actor_actor FOREIGN KEY (id_actor) REFERENCES actor (id_actor),
    ADD CONSTRAINT fk_pelicula_actor_pelicula FOREIGN KEY (id_pelicula) REFERENCES pelicula (id_pelicula);

-- Claves foráneas para direccion
ALTER TABLE direccion
    ADD CONSTRAINT fk_direccion_ciudad FOREIGN KEY (id_ciudad) REFERENCES ciudad (id_ciudad);

-- Claves foráneas para ciudad
ALTER TABLE ciudad
    ADD CONSTRAINT fk_ciudad_pais FOREIGN KEY (id_pais) REFERENCES pais (id_pais);
