/*

1.- Ejemplo de cómo crear un paquete.
Escribir un paquete completo para gestionar los departamentos. El paquete se llamará
gest_depart y deberá incluir, al menos, los siguientes subprogramas:
- insertar_nuevo_depart: permite insertar un departamento nuevo. El procedimiento
recibe el nombre y la localidad del nuevo departamento. Creará el nuevo departamento
comprobando que el nombre no se duplique y le asignará como número de
departamento la decena siguiente al último número de departamento utilizado.
- borrar_depart: permite borrar un departamento. El procedimiento recibirá dos
números de departamento de los cuales el primero corresponde al departamento que
queremos borrar y el segundo al departamento al que pasarán los empleados del
departamento que se va eliminar. El procedimiento se encargará de realizar los
cambios oportunos en los números de departamento de los empleados
correspondientes.
- modificar_loc_depart: modifica la localidad del departamento. El procedimiento
recibirá el número del departamento a modificar y la nueva localidad, y realizará el
cambio solicitado.
- visualizar_datos_depart: visualizará los datos de un departamento cuyo número se
pasará en la llamada. Además de los datos relativos al departamento, se visualizará el
número de empleados que pertenecen actualmente al departamento.
- visualizar_datos_depart: versión sobrecargada del procedimiento anterior que, en
lugar del número del departamento, recibirá el nombre del departamento. Realizará
una llamada a la función buscar_depart_por_nombre que se indica en el apartado
siguiente.
- buscar_depart_por_nombre: función local al paquete. Recibe el nombre de un
departamento y devuelve el número del mismo.

*/

/************* Cabecera o especificación del paquete **********/
CREATE OR REPLACE PACKAGE gest_depart AS
PROCEDURE insert_depart
(v_nom_dep VARCHAR2,
v_loc VARCHAR2);
PROCEDURE borrar_depar
(v_dep_borrar NUMBER,
v_dep_nue NUMBER);
PROCEDURE cambiar_localidad
(v_num_dep NUMBER,
v_loc VARCHAR2);
PROCEDURE visualizar_datos_depart
(v_num_dep NUMBER);
PROCEDURE visualizar_datos_depart
(v_nom_dep VARCHAR2);
END gest_depart;
/
26
/******************* Cuerpo del paquete **********************/
CREATE OR REPLACE PACKAGE BODY gest_depart AS
FUNCTION buscar_depart_por_nombre /* Función privada */
(v_nom_dep VARCHAR2)
RETURN NUMBER;
/*************************************************************/
PROCEDURE insert_depart(
v_nom_dep VARCHAR2,
v_loc VARCHAR2)
AS
ultimo_dep DEPART.DEPT_NO%TYPE;
nombre_repetido EXCEPTION;
BEGIN
/*Comprobar dpt repetido(Puede levantar NO_DATA_FOUND)*/
DECLARE
nom_dep depart.DNOMBRE%TYPE;
nombre_repetido EXCEPTION;
BEGIN
SELECT dnombre INTO nom_dep FROM depart
WHERE dnombre = v_nom_dep;
RAISE insert_depart.nombre_repetido;
EXCEPTION
WHEN NO_DATA_FOUND THEN
NULL;
WHEN TOO_MANY_ROWS THEN
RAISE insert_Depart.nombre_repetido;
END; /* Fin del bloque de comprobación
de departamento repetido */
/* Calcular el número de departamento e insertar */
SELECT MAX(DEPT_NO) INTO ultimo_dep FROM DEPART;
INSERT INTO DEPART VALUES ((TRUNC(ultimo_dep, -1) +10),
v_nom_dep,v_loc);
EXCEPTION
WHEN nombre_repetido THEN
DBMS_OUTPUT.PUT_LINE
('Err. Nombre de departamento duplicado');
WHEN NO_DATA_FOUND THEN /* Si no había ningún departamento */
INSERT INTO DEPART VALUES (10,v_nom_dep,v_loc);
END insert_depart;
/**************************************************************/
27
PROCEDURE borrar_depar
(v_dep_borrar NUMBER,
v_dep_nue NUMBER)
AS
BEGIN
UPDATE emple SET dept_no = v_dep_nue
WHERE DEPT_NO=v_dep_borrar;
DELETE FROM depart WHERE dept_no = v_dep_borrar;
END borrar_depar;
/*************************************************************/
PROCEDURE visualizar_datos_depart
(v_num_dep NUMBER)
AS
vr_dep depart%ROWTYPE;
v_num_empleados NUMBER(4);
BEGIN
SELECT * INTO vr_dep FROM depart
WHERE DEPT_NO=v_num_dep;
SELECT COUNT(*) INTO v_num_empleados FROM
EMPLE WHERE DEPT_NO=v_num_dep;
DBMS_OUTPUT.PUT_LINE
('Número de departamento: '||vr_dep.dept_no);
DBMS_OUTPUT.PUT_LINE
('Nombre del departamento: '||vr_dep.dnombre);
DBMS_OUTPUT.PUT_LINE
('Localidad : '||vr_dep.loc);
DBMS_OUTPUT.PUT_LINE
('Numero de empleados : '||v_num_empleados);
EXCEPTION
WHEN NO_DATA_FOUND THEN
DBMS_OUTPUT.PUT_LINE('Err departamento no encontrado');
END visualizar_datos_depart;
/*************************************************************/
PROCEDURE visualizar_datos_depart /* Versión sobrecargada */
(v_nom_dep VARCHAR2)
AS
v_num_dep depart.dept_no%TYPE;
vr_dep depart%ROWTYPE;
v_num_empleados NUMBER(4);
BEGIN
v_num_dep:=buscar_depart_por_nombre(v_nom_dep);
SELECT * INTO vr_dep FROM depart
WHERE dept_no=v_num_dep;
28
SELECT COUNT(*) INTO v_num_empleados FROM EMPLE
WHERE dept_no=v_num_dep;
DBMS_OUTPUT.PUT_LINE
('Número de departamento: '||vr_dep.dept_no);
DBMS_OUTPUT.PUT_LINE
('Nombre del departamento: '||vr_dep.dnombre);
DBMS_OUTPUT.PUT_LINE
('Localidad : '||vr_dep.loc);
DBMS_OUTPUT.PUT_LINE
('Numero de empleados : '||v_num_empleados);
EXCEPTION
WHEN NO_DATA_FOUND THEN
DBMS_OUTPUT.PUT_LINE('Err departamento no encontrado');
END visualizar_datos_depart;
/*************************************************************/
FUNCTION buscar_depart_por_nombre
(v_nom_dep VARCHAR2)
RETURN NUMBER
AS
v_num_dep depart.dept_no%TYPE;
BEGIN
SELECT dept_no INTO v_num_dep FROM depart
WHERE DNOMBRE = v_nom_dep;
RETURN v_num_dep;
EXCEPTION
WHEN NO_DATA_FOUND THEN
DBMS_OUTPUT.PUT_LINE('Err departamento no encontrado');
END buscar_depart_por_nombre;
/*************************************************************/
PROCEDURE cambiar_localidad(
v_num_dep NUMBER,
v_loc VARCHAR2)
AS
BEGIN
UPDATE depart
SET LOC=v_loc
WHERE dept_no=v_num_dep;
EXCEPTION
WHEN NO_DATA_FOUND THEN
DBMS_OUTPUT.PUT_LINE('Err departamento no encontrado');
END cambiar_localidad;
END gest_depart;