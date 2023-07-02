-- Crear la tabla Proveedor
CREATE TABLE Proveedor (
    id NUMBER PRIMARY KEY,
    marca VARCHAR2(50),
    ciudad VARCHAR2(50),
    nombre VARCHAR2(50),
    email VARCHAR2(50),
    telefono VARCHAR2(15)
);


-- Crear la tabla Encargado_Bodega
CREATE TABLE Encargado_Bodega (
    id NUMBER PRIMARY KEY,
    nombre VARCHAR2(50),
    telefono VARCHAR2(15),
    direccion VARCHAR2(100),
    email VARCHAR2(50)
);

-- Crear la tabla Productos
CREATE TABLE Productos (
    id NUMBER PRIMARY KEY,
    nombre VARCHAR2(50),
    descripcion VARCHAR2(100),
    precio_venta NUMBER(10, 2),
    cantidad NUMBER,
    categoria VARCHAR2(50),
    precio_compra NUMBER(10, 2)
);

-- Crear la tabla Factura
CREATE TABLE Factura (
    id NUMBER PRIMARY KEY,
    fecha DATE,
    id_cliente NUMBER,
    cantidad NUMBER,
    total NUMBER(10, 2),
    metodo_pago VARCHAR2(50),
    CONSTRAINT fk_cliente FOREIGN KEY (id_cliente) REFERENCES Cliente(id)
);

-- Crear la tabla Cliente
CREATE TABLE Cliente (
    id NUMBER PRIMARY KEY,
    nombre VARCHAR2(50),
    telefono VARCHAR2(15),
    metodo_pago VARCHAR2(50),
    direccion VARCHAR2(100),
    email VARCHAR2(50)
);

-- Crear la tabla Vendedor
CREATE TABLE Vendedor (
    id NUMBER PRIMARY KEY,
    nombre VARCHAR2(50),
    telefono VARCHAR2(15),
    direccion VARCHAR2(100),
    email VARCHAR2(50)
);


-------CRUD TABLA PROVEEDOR----------
INSERT INTO Proveedor (id, marca, ciudad, nombre, email, telefono)
VALUES (2, 'Marca1', 'Ciudad1', 'Proveedor1', 'proveedor1@email.com', '123456789');

UPDATE Proveedor
SET marca = 'NuevaMarca'
WHERE id = 1;

DELETE FROM Proveedor
WHERE id = 1;

SELECT * FROM Proveedor;

-------CRUD TABLA ENCARGADO_BODEGA----------
INSERT INTO Encargado_Bodega (id, nombre, telefono, direccion, email)
VALUES (1, 'Encargado1', '987654321', 'Dirección1', 'encargado1@email.com');

UPDATE Encargado_Bodega
SET nombre = 'NuevoNombre'
WHERE id = 1;

DELETE FROM Encargado_Bodega
WHERE id = 1;

SELECT * FROM Encargado_Bodega;

-------CRUD TABLA PRODUCTOS----------
INSERT INTO Productos (id, nombre, descripcion, precio_venta, cantidad, categoria, precio_compra)
VALUES (1, 'Producto1', 'Descripción1', 9.99, 100, 'Categoría1', 5.99);

UPDATE Productos
SET nombre = 'NuevoNombre'
WHERE id = 1;

DELETE FROM Productos
WHERE id = 1;

SELECT * FROM Productos;

-------CRUD TABLA FACTURA----------
INSERT INTO Factura (id, fecha, id_cliente, cantidad, total, metodo_pago)
VALUES (1, SYSDATE, 1, 5, 49.95, 'Efectivo');

UPDATE Factura
SET cantidad = 10
WHERE id = 1;

DELETE FROM Factura
WHERE id = 1;

SELECT * FROM Factura;

                     ---PROCEDIMIENTO_ALMACENADO_PROVEEDOR---------
---INSERT---
CREATE OR REPLACE PROCEDURE InsertarProveedor(
  p_id IN NUMBER,
  p_marca IN VARCHAR2,
  p_ciudad IN VARCHAR2,
  p_nombre IN VARCHAR2,
  p_email IN VARCHAR2,
  p_telefono IN VARCHAR2
)
AS
BEGIN
  INSERT INTO Proveedor (id, marca, ciudad, nombre, email, telefono)
  VALUES (p_id, p_marca, p_ciudad, p_nombre, p_email, p_telefono);
END;
/

BEGIN
  InsertarProveedor(1, 'Marca1', 'Ciudad1', 'Proveedor1', 'proveedor1@email.com', '123456789');
END;

---UPDATE---
CREATE OR REPLACE FUNCTION ActualizarProveedor(
  p_id IN NUMBER,
  p_marca IN VARCHAR2
)
RETURN NUMBER
AS
BEGIN
  UPDATE Proveedor
  SET marca = p_marca
  WHERE id = p_id;
  
  RETURN SQL%ROWCOUNT;
END;
/

DECLARE
  v_rowcount NUMBER;
BEGIN
  v_rowcount := ActualizarProveedor(1, 'NuevaMarca');
  DBMS_OUTPUT.PUT_LINE('Filas actualizadas: ' || v_rowcount);
END;

---DELETE---
CREATE OR REPLACE PROCEDURE EliminarProveedor(
  p_id IN NUMBER
)
AS
BEGIN
  DELETE FROM Proveedor
  WHERE id = p_id;
END;
/

BEGIN
  EliminarProveedor(1);
END;

---OBTENER PROVEEDORES---
CREATE OR REPLACE FUNCTION ObtenerProveedores
RETURN SYS_REFCURSOR
AS
  l_cursor SYS_REFCURSOR;
BEGIN
  OPEN l_cursor FOR
    SELECT * FROM Proveedor;
    
  RETURN l_cursor;
END;
/

DECLARE
  v_cursor SYS_REFCURSOR;
  v_id Proveedor.id%TYPE;
  v_marca Proveedor.marca%TYPE;
  -- Definir otras variables para el resto de las columnas
BEGIN
  v_cursor := ObtenerProveedores;
  LOOP
    FETCH v_cursor INTO v_id, v_marca;
    EXIT WHEN v_cursor%NOTFOUND;
    -- Imprimir o procesar los datos
    DBMS_OUTPUT.PUT_LINE('ID: ' || v_id || ', Marca: ' || v_marca);
  END LOOP;
  CLOSE v_cursor;
END;

            ---PROCEDIMIENTO_ALMACENADO ENCARGADO_BODEGA---------
---INSERT---
CREATE OR REPLACE PROCEDURE InsertarEncargadoBodega(
  p_id IN NUMBER,
  p_nombre IN VARCHAR2,
  p_telefono IN VARCHAR2,
  p_direccion IN VARCHAR2,
  p_email IN VARCHAR2
)
AS
BEGIN
  INSERT INTO Encargado_Bodega (id, nombre, telefono, direccion, email)
  VALUES (p_id, p_nombre, p_telefono, p_direccion, p_email);
END;
/

---UPDATE---
CREATE OR REPLACE FUNCTION ActualizarEncargadoBodega(
  p_id IN NUMBER,
  p_nombre IN VARCHAR2
)
RETURN NUMBER
AS
BEGIN
  UPDATE Encargado_Bodega
  SET nombre = p_nombre
  WHERE id = p_id;
  
  RETURN SQL%ROWCOUNT;
END;
/

---DELETE---
CREATE OR REPLACE PROCEDURE EliminarEncargadoBodega(
  p_id IN NUMBER
)
AS
BEGIN
  DELETE FROM Encargado_Bodega
  WHERE id = p_id;
END;
/

---OBTENER---
CREATE OR REPLACE FUNCTION ObtenerEncargadosBodega
RETURN SYS_REFCURSOR
AS
  l_cursor SYS_REFCURSOR;
BEGIN
  OPEN l_cursor FOR
    SELECT * FROM Encargado_Bodega;
    
  RETURN l_cursor;
END;
/

               ---PROCEDIMIENTO_ALMACENADO TABLA PRODUCTO---------
---INSERT---
CREATE OR REPLACE PROCEDURE InsertarProducto(
  p_id IN NUMBER,
  p_nombre IN VARCHAR2,
  p_descripcion IN VARCHAR2,
  p_precio_venta IN NUMBER,
  p_cantidad IN NUMBER,
  p_categoria IN VARCHAR2,
  p_precio_compra IN NUMBER
)
AS
BEGIN
  INSERT INTO Productos (id, nombre, descripcion, precio_venta, cantidad, categoria, precio_compra)
  VALUES (p_id, p_nombre, p_descripcion, p_precio_venta, p_cantidad, p_categoria, p_precio_compra);
END;
/
---UPDATE---
CREATE OR REPLACE FUNCTION ActualizarProducto(
  p_id IN NUMBER,
  p_nombre IN VARCHAR2
)
RETURN NUMBER
AS
BEGIN
  UPDATE Productos
  SET nombre = p_nombre
  WHERE id = p_id;
  
  RETURN SQL%ROWCOUNT;
END;
/

---DELETE--
CREATE OR REPLACE PROCEDURE EliminarProducto(
  p_id IN NUMBER
)
AS
BEGIN
  DELETE FROM Productos
  WHERE id = p_id;
END;
/

---OBTENER---
CREATE OR REPLACE FUNCTION ObtenerProductos
RETURN SYS_REFCURSOR
AS
  l_cursor SYS_REFCURSOR;
BEGIN
  OPEN l_cursor FOR
    SELECT * FROM Productos;
    
  RETURN l_cursor;
END;
/

 ---PROCEDIMIENTO_ALMACENADO FACTURA---------
 ---INSERT---
 CREATE OR REPLACE PROCEDURE InsertarFactura(
  p_id IN NUMBER,
  p_fecha IN DATE,
  p_id_cliente IN NUMBER,
  p_cantidad IN NUMBER,
  p_total IN NUMBER,
  p_metodo_pago IN VARCHAR2
)
AS
BEGIN
  INSERT INTO Factura (id, fecha, id_cliente, cantidad, total, metodo_pago)
  VALUES (p_id, p_fecha, p_id_cliente, p_cantidad, p_total, p_metodo_pago);
END;
/

---UPDATE---
CREATE OR REPLACE FUNCTION ActualizarFactura(
  p_id IN NUMBER,
  p_cantidad IN NUMBER
)
RETURN NUMBER
AS
BEGIN
  UPDATE Factura
  SET cantidad = p_cantidad
  WHERE id = p_id;
  
  RETURN SQL%ROWCOUNT;
END;
/
---DELETE---
CREATE OR REPLACE PROCEDURE EliminarFactura(
  p_id IN NUMBER
)
AS
BEGIN
  DELETE FROM Factura
  WHERE id = p_id;
END;
/

---OBTENER---
CREATE OR REPLACE FUNCTION ObtenerFacturas
RETURN SYS_REFCURSOR
AS
  l_cursor SYS_REFCURSOR;
BEGIN
  OPEN l_cursor FOR
    SELECT * FROM Factura;
    
  RETURN l_cursor;
END;
/

 ---PROCEDIMIENTO_ALMACENADO CLIENTE---------
---INSERT--
CREATE OR REPLACE PROCEDURE InsertarCliente(
  p_id IN NUMBER,
  p_nombre IN VARCHAR2,
  p_telefono IN VARCHAR2,
  p_metodo_pago IN VARCHAR2,
  p_direccion IN VARCHAR2,
  p_email IN VARCHAR2
)
AS
BEGIN
  INSERT INTO Cliente (id, nombre, telefono, metodo_pago, direccion, email)
  VALUES (p_id, p_nombre, p_telefono, p_metodo_pago, p_direccion, p_email);
END;
/
---UPDATE---
CREATE OR REPLACE FUNCTION ActualizarCliente(
  p_id IN NUMBER,
  p_nombre IN VARCHAR2
)
RETURN NUMBER
AS
BEGIN
  UPDATE Cliente
  SET nombre = p_nombre
  WHERE id = p_id;
  
  RETURN SQL%ROWCOUNT;
END;
/

---DELETE---
CREATE OR REPLACE PROCEDURE EliminarCliente(
  p_id IN NUMBER
)
AS
BEGIN
  DELETE FROM Cliente
  WHERE id = p_id;
END;
/

---OBTENER---
CREATE OR REPLACE FUNCTION ObtenerClientes
RETURN SYS_REFCURSOR
AS
  l_cursor SYS_REFCURSOR;
BEGIN
  OPEN l_cursor FOR
    SELECT * FROM Cliente;
    
  RETURN l_cursor;
END;
/

 ---PROCEDIMIENTO_ALMACENADO VENDEDOR---------
---INSERT---
CREATE OR REPLACE PROCEDURE InsertarVendedor(
  p_id IN NUMBER,
  p_nombre IN VARCHAR2,
  p_telefono IN VARCHAR2,
  p_direccion IN VARCHAR2,
  p_email IN VARCHAR2
)
AS
BEGIN
  INSERT INTO Vendedor (id, nombre, telefono, direccion, email)
  VALUES (p_id, p_nombre, p_telefono, p_direccion, p_email);
END;
/

---UPDATE---
CREATE OR REPLACE FUNCTION ActualizarVendedor(
  p_id IN NUMBER,
  p_nombre IN VARCHAR2
)
RETURN NUMBER
AS
BEGIN
  UPDATE Vendedor
  SET nombre = p_nombre
  WHERE id = p_id;
  
  RETURN SQL%ROWCOUNT;
END;
/

---DELETE---
CREATE OR REPLACE PROCEDURE EliminarVendedor(
  p_id IN NUMBER
)
AS
BEGIN
  DELETE FROM Vendedor
  WHERE id = p_id;
END;
/
---OBTENER---
CREATE OR REPLACE FUNCTION ObtenerVendedores
RETURN SYS_REFCURSOR
AS
  l_cursor SYS_REFCURSOR;
BEGIN
  OPEN l_cursor FOR
    SELECT * FROM Vendedor;
    
  RETURN l_cursor;
END;
/
