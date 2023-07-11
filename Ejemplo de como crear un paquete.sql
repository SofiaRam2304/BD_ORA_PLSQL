/*2 .- Ejemplo de como crear un paquete.
Escribir un paquete completo para gestionar los empleados. El paquete se llamará
gest_emple e incluirá, al menos los siguientes subprogramas:
- insertar_nuevo_emple
- borrar_emple. Cuando se borra un empleado todos los empleados que dependían de
él pasarán a depender del director del empleado borrado.
- modificar_oficio_emple
- modificar_dept_emple
- modificar_dir_emple
- modificar_salario_emple
- modificar_comision_emple
- visualizar_datos_emple. También se incluirá una versión sobrecargada del
procedimiento que recibirá el nombre del empleado.
- buscar_emple_por_nombre. Función local que recibe el nombre y devuelve el
número.
Todos los procedimientos recibirán el número del empleado seguido de los demás
datos necesarios. También se incluirán en el paquete cursores y declaraciones de tipo
registro, así como siguientes procedimientos que afectarán a todos los empleados:
- subida_salario_pct: incrementará el salario de todos los empleados el porcentaje
indicado en la llamada que no podrá ser superior al 25%.
- subida_salario_imp: sumará al salario de todos los empleados el importe indicado en
la llamada. Antes de proceder a la incrementar los salarios se comprobará que el
importe indicado no supera el 25% del salario medio.*/
/****************** Cabecera del paquete *********************/
CREATE OR REPLACE PACKAGE gest_emple AS
CURSOR c_sal RETURN EMPLE%ROWTYPE;
PROCEDURE insertar_nuevo_emple(
v_num_emp EMPLE.EMP_NO%TYPE,
v_apell EMPLE.APELLIDO%TYPE,
v_oficio EMPLE.OFICIO%TYPE,
v_dir EMPLE.DIR%TYPE,
v_fecha_al EMPLE.FECHA_ALT%TYPE,
v_sal EMPLE.SALARIO%TYPE,
v_comision EMPLE.COMISION%TYPE DEFAULT NULL,
v_num_dep EMPLE.DEPT_NO%TYPE);
PROCEDURE borrar_emple(
v_num_emple NUMBER);
30
PROCEDURE modificar_oficio_emple(
v_num_emp EMPLE.EMP_NO%TYPE,
v_oficio EMPLE.OFICIO%TYPE);
PROCEDURE modificar_dept_emple(
v_num_emp EMPLE.EMP_NO%TYPE,
v_dept EMPLE.DEPT_NO%TYPE);
PROCEDURE modificar_dir_emple(
v_num_emp EMPLE.EMP_NO%TYPE,
v_direccion EMPLE.DIR%TYPE);
PROCEDURE modificar_salario_emple(
v_num_emp EMPLE.EMP_NO%TYPE,
v_salario EMPLE.SALARIO%TYPE);
PROCEDURE modificar_comision_emple(
v_num_emp EMPLE.EMP_NO%TYPE,
v_comis EMPLE.COMISION%TYPE);
PROCEDURE visualizar_datos_emple(
v_num_emp EMPLE.EMP_NO%TYPE);
PROCEDURE visualizar_datos_emple(
v_nombre_emp EMPLE.APELLIDO%TYPE);
PROCEDURE subida_salario_pct(
v_pct_subida NUMBER);
PROCEDURE subida_salario_imp(
v_imp_subida NUMBER);
END gest_emple;
/******************** Cuerpo del paquete *********************/
CREATE OR REPLACE PACKAGE BODY gest_emple AS
CURSOR c_sal RETURN EMPLE%ROWTYPE
IS SELECT * FROM EMPLE;
FUNCTION buscar_emple_por_nombre
(n_emp VARCHAR2)
RETURN NUMBER;
/*************************************************************/
31
PROCEDURE insertar_nuevo_emple(
v_num_emp EMPLE.EMP_NO%TYPE,
v_apell EMPLE.APELLIDO%TYPE,
v_oficio EMPLE.OFICIO%TYPE,
v_dir EMPLE.DIR%TYPE,
v_fecha_al EMPLE.FECHA_ALT%TYPE,
v_sal EMPLE.SALARIO%TYPE,
v_comision EMPLE.COMISION%TYPE DEFAULT NULL,
v_num_dep EMPLE.DEPT_NO%TYPE)
IS
dir_no_existe EXCEPTION;
BEGIN
DECLARE
v_num_emple EMPLE.EMP_NO%TYPE;
BEGIN
SELECT EMP_NO INTO v_num_emple FROM EMPLE
WHERE EMP_NO=v_dir;
EXCEPTION
WHEN NO_DATA_FOUND THEN
RAISE insertar_nuevo_emple.dir_no_existe;
END;
INSERT INTO EMPLE VALUES (v_num_emp, v_apell, v_oficio,
v_dir, v_fecha_al, v_sal, v_comision, v_num_dep);
EXCEPTION
WHEN DUP_VAL_ON_INDEX THEN
DBMS_OUTPUT.PUT_LINE('Err. Número de empleado duplicado');
WHEN dir_no_existe THEN
DBMS_OUTPUT.PUT_LINE('Err. No existe el director');
END insertar_nuevo_emple;
/*************************************************************/
PROCEDURE borrar_emple(
v_num_emple NUMBER)
IS
emp_dir EMPLE.DIR%TYPE;
BEGIN
SELECT DIR INTO emp_dir FROM EMPLE
WHERE EMP_NO = v_num_emple;
DELETE FROM EMPLE WHERE EMP_NO = v_num_emple;
UPDATE EMPLE SET DIR = emp_dir WHERE DIR = v_num_emple;
END borrar_emple;
/*************************************************************/
32
PROCEDURE modificar_oficio_emple(
v_num_emp EMPLE.EMP_NO%TYPE,
v_oficio EMPLE.OFICIO%TYPE)
IS
BEGIN
UPDATE EMPLE SET OFICIO = v_oficio
WHERE EMP_NO = v_num_emp;
END modificar_oficio_emple;
/*************************************************************/
PROCEDURE modificar_dept_emple(
v_num_emp EMPLE.EMP_NO%TYPE,
v_dept EMPLE.DEPT_NO%TYPE)
IS
BEGIN
UPDATE EMPLE SET DEPT_NO = v_dept WHERE EMP_NO = v_num_emp;
END modificar_dept_emple;
/*************************************************************/
PROCEDURE modificar_dir_emple(
v_num_emp EMPLE.EMP_NO%TYPE,
v_direccion EMPLE.DIR%TYPE)
IS
BEGIN
UPDATE EMPLE SET DIR = v_direccion WHERE EMP_NO = v_num_emp;
END modificar_dir_emple;
/*************************************************************/
PROCEDURE modificar_salario_emple(
v_num_emp EMPLE.EMP_NO%TYPE,
v_salario EMPLE.SALARIO%TYPE)
IS
BEGIN
UPDATE EMPLE SET SALARIO = v_salario WHERE EMP_NO = v_num_emp;
END modificar_salario_emple;
/*************************************************************/
PROCEDURE modificar_comision_emple(
v_num_emp EMPLE.EMP_NO%TYPE,
v_comis EMPLE.COMISION%TYPE)
IS
BEGIN
UPDATE EMPLE SET COMISION = v_comis WHERE EMP_NO = v_num_emp;
END modificar_comision_emple;
/*************************************************************/
33
PROCEDURE visualizar_datos_emple(
v_num_emp EMPLE.EMP_NO%TYPE)
IS
reg_emple EMPLE%ROWTYPE;
BEGIN
SELECT * INTO reg_emple FROM EMPLE WHERE EMP_NO = v_num_emp;
DBMS_OUTPUT.PUT_LINE('NUMERO EMPLEADO: '||reg_emple.EMP_NO);
DBMS_OUTPUT.PUT_LINE('APELLIDO: '||reg_emple.APELLIDO);
DBMS_OUTPUT.PUT_LINE('OFICIO: '||reg_emple.OFICIO);
DBMS_OUTPUT.PUT_LINE('DIRECTOR: '||reg_emple.DIR);
DBMS_OUTPUT.PUT_LINE('FECHA ALTA): '||reg_emple.FECHA_ALT);
DBMS_OUTPUT.PUT_LINE('SALARIO: '||reg_emple.SALARIO);
DBMS_OUTPUT.PUT_LINE('COMISION: '||reg_emple.COMISION);
DBMS_OUTPUT.PUT_LINE('NUMERO DEPARTAMENTO: '||reg_emple.DEPT_NO);
END visualizar_datos_emple;
/*************************************************************/
PROCEDURE visualizar_datos_emple(
v_nombre_emp EMPLE.APELLIDO%TYPE)
IS
v_num_emp EMPLE.EMP_NO%TYPE;
reg_emple EMPLE%ROWTYPE;
BEGIN
v_num_emp:=buscar_emple_por_nombre(v_nombre_emp);
SELECT * INTO reg_emple FROM EMPLE WHERE EMP_NO = v_num_emp;
DBMS_OUTPUT.PUT_LINE('NUMERO EMPLEADO: '||reg_emple.EMP_NO);
DBMS_OUTPUT.PUT_LINE('APELLIDO : '||reg_emple.APELLIDO);
DBMS_OUTPUT.PUT_LINE('OFICIO : '||reg_emple.OFICIO);
DBMS_OUTPUT.PUT_LINE('DIRECTOR : '||reg_emple.DIR);
DBMS_OUTPUT.PUT_LINE('FECHA ALTA: '||reg_emple.FECHA_ALT);
DBMS_OUTPUT.PUT_LINE('SALARIO : '||reg_emple.SALARIO);
DBMS_OUTPUT.PUT_LINE('COMISION : '||reg_emple.COMISION);
DBMS_OUTPUT.PUT_LINE('NUM DEPART: '||reg_emple.DEPT_NO);
END visualizar_datos_emple;
/*************************************************************/
FUNCTION buscar_emple_por_nombre(
n_emp VARCHAR2)
RETURN NUMBER
IS
numero EMPLE.EMP_NO%TYPE;
BEGIN
SELECT EMP_NO INTO numero FROM EMPLE WHERE APELLIDO = n_emp;
RETURN numero;
END buscar_emple_por_nombre;
/*************************************************************/
34
PROCEDURE subida_salario_pct(
v_pct_subida NUMBER)
IS
subida_mayor EXCEPTION;
BEGIN
IF v_pct_subida > 25 THEN
RAISE subida_mayor;
END IF;
FOR vr_c_sal IN c_sal LOOP
UPDATE EMPLE SET SALARIO = SALARIO +
(SALARIO * v_pct_subida / 100)
WHERE EMP_NO = vr_c_sal.emp_no;
END LOOP;
EXCEPTION
WHEN subida_mayor THEN
DBMS_OUTPUT.PUT_LINE('Subida superior a la permitida');
END subida_salario_pct;
/*************************************************************/
PROCEDURE subida_salario_imp(
v_imp_subida NUMBER)
IS
subida_mayor EXCEPTION;
sueldo_medio NUMBER(10);
BEGIN
SELECT AVG(SALARIO) INTO sueldo_medio FROM EMPLE;
IF v_imp_subida>sueldo_medio THEN
RAISE subida_mayor;
END IF;
FOR vr_c_sal in c_sal LOOP
UPDATE EMPLE SET SALARIO = SALARIO + v_imp_subida
WHERE EMP_NO = vr_c_sal.emp_no;
END LOOP;
EXCEPTION
WHEN subida_mayor THEN
DBMS_OUTPUT.PUT_LINE('Subida superior a la permitida');
END subida_salario_imp;
END gest_emple;