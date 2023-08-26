CREATE OR REPLACE PROCEDURE sp_obtener_menu(usuario IN VARCHAR2, cur OUT SYS_REFCURSOR) AS
BEGIN
    OPEN cur FOR
        -- Comienza la consulta SELECT
        SELECT
            a.NOMBRE_VISIBLE,
            a.NOMBRE_METODO,
            a.COD_ROL,
            CASE WHEN a.PERM_ACTUALIZAR = 'S' THEN 'TRUE' ELSE 'FALSE' END AS permiteActualiar,
            CASE WHEN a.PERM_INSERTAR = 'S' THEN 'TRUE' ELSE 'FALSE' END AS permiteInsertar,
            CASE WHEN a.PERM_CONSULTAR = 'S' THEN 'TRUE' ELSE 'FALSE' END AS permiteConsultar
        FROM
            ACC_X_FORM_ROL a
        JOIN
            USUARIOS_X_ROLES b
        ON
            a.COD_ROL = b.COD_ROL
        JOIN
            USUARIOS c
        ON
            b.COD_USUARIO = c.COD_USUARIO
        WHERE
            (
                (b.COD_ROL = 'OFNEGO' AND c.COD_USUARIO = usuario)
                OR
                (b.COD_ROL <> 'OFNEGO' AND c.COD_USUARIO = usuario AND c.EST_ACTIVO = 'S')
            )
            AND
            a.COD_SIST_FORMA = 'SF'; -- Fin de la consulta SELECT
END;
/

--////////////////////////////////////////////////////////////////////////////////////
DECLARE
  v_cursor SYS_REFCURSOR;
  v_usuario VARCHAR2(50) := 'HN123';
BEGIN
  sp_obtener_menu(v_usuario, v_cursor);
END;
/

/*
===================================================================================================
===================================================================================================
*/

CREATE OR REPLACE PROCEDURE sp_obtener_menu(usuario IN VARCHAR2) AS
    CURSOR cur_menu IS
        SELECT
            a.NOMBRE_VISIBLE,
            a.NOMBRE_METODO,
            a.COD_ROL,
            CASE WHEN a.PERM_ACTUALIZAR = 'S' THEN 'TRUE' ELSE 'FALSE' END AS permiteActualiar,
            CASE WHEN a.PERM_INSERTAR = 'S' THEN 'TRUE' ELSE 'FALSE' END AS permiteInsertar,
            CASE WHEN a.PERM_CONSULTAR = 'S' THEN 'TRUE' ELSE 'FALSE' END AS permiteConsultar
        FROM
            ACC_X_FORM_ROL a
        JOIN
            USUARIOS_X_ROLES b
        ON
            a.COD_ROL = b.COD_ROL
        JOIN
            USUARIOS c
        ON
            b.COD_USUARIO = c.COD_USUARIO
        WHERE
            (
                (b.COD_ROL = 'OFNEGO' AND c.COD_USUARIO = usuario)
                OR
                (b.COD_ROL <> 'OFNEGO' AND c.COD_USUARIO = usuario AND c.EST_ACTIVO = 'S')
            )
            AND
            a.COD_SIST_FORMA = 'SF';
BEGIN
    FOR menu IN cur_menu LOOP
        DBMS_OUTPUT.PUT_LINE('NOMBRE_VISIBLE: ' || menu.NOMBRE_VISIBLE);
        DBMS_OUTPUT.PUT_LINE('NOMBRE_METODO: ' || menu.NOMBRE_METODO);
        DBMS_OUTPUT.PUT_LINE('COD_ROL: ' || menu.COD_ROL);
        DBMS_OUTPUT.PUT_LINE('permiteActualiar: ' || menu.permiteActualiar);
        DBMS_OUTPUT.PUT_LINE('permiteInsertar: ' || menu.permiteInsertar);
        DBMS_OUTPUT.PUT_LINE('permiteConsultar: ' || menu.permiteConsultar);
        DBMS_OUTPUT.PUT_LINE('-------------------------');
    END LOOP;
END;
/



/*
=====================================================================================
=====================================================================================
*/

CREATE OR REPLACE PROCEDURE sp_obtener_menu(usuario IN VARCHAR2, json OUT CLOB) AS
    TYPE menu_rec_type IS RECORD (
        v_nombreVisible  ACC_X_FORM_ROL.NOMBRE_VISIBLE%TYPE,
        v_nombreMetodo   ACC_X_FORM_ROL.NOMBRE_METODO%TYPE,
        v_rol            ACC_X_FORM_ROL.COD_ROL%TYPE,
        permiteActualiar BOOLEAN,
        permiteInsertar BOOLEAN,
        permiteConsultar BOOLEAN
    );

    TYPE menu_list_type IS TABLE OF menu_rec_type;

    listaMenu menu_list_type := menu_list_type();

BEGIN
    SELECT
        a.NOMBRE_VISIBLE,
        a.NOMBRE_METODO,
        a.COD_ROL,
        CASE WHEN a.PERM_ACTUALIZAR = 'S' THEN TRUE ELSE FALSE END,
        CASE WHEN a.PERM_INSERTAR = 'S' THEN TRUE ELSE FALSE END,
        CASE WHEN a.PERM_CONSULTAR = 'S' THEN TRUE ELSE FALSE END
    BULK COLLECT INTO
        listaMenu
    FROM
        ACC_X_FORM_ROL a
    JOIN
        USUARIOS_X_ROLES b
    ON
        a.COD_ROL = b.COD_ROL
    JOIN
        USUARIOS c
    ON
        b.COD_USUARIO = c.COD_USUARIO
    WHERE
        (
            (b.COD_ROL = 'OFNEGO' AND c.COD_USUARIO = usuario)
            OR
            (b.COD_ROL <> 'OFNEGO' AND c.COD_USUARIO = usuario AND c.EST_ACTIVO = 'S')
        )
        AND
        a.COD_SIST_FORMA = 'SF';

    -- Construir el objeto JSON manualmente
    json := '[';
    FOR i IN 1..listaMenu.COUNT LOOP
        json := json || '{"nombreVisible":"' || listaMenu(i).nombreVisible || '",'
                     || '"nombreMetodo":"' || listaMenu(i).nombreMetodo || '",'
                     || '"rol":"' || listaMenu(i).rol || '",'
                     || '"permiteActualiar":' || listaMenu(i).permiteActualiar || ','
                     || '"permiteInsertar":' || listaMenu(i).permiteInsertar || ','
                     || '"permiteConsultar":' || listaMenu(i).permiteConsultar || '}';
        IF i < listaMenu.COUNT THEN
            json := json || ',';
        END IF;
    END LOOP;
    json := json || ']';

END;
/

--////////////////////////////
DECLARE
  v_json CLOB;
  v_usuario VARCHAR2(50) := 'HN123';
BEGIN
  sp_obtener_menu(v_usuario, v_json);
  DBMS_OUTPUT.PUT_LINE('Resultado del procedimiento:');
  DBMS_OUTPUT.PUT_LINE(v_json);
END;
/








--//////////////////////////////////

CREATE OR REPLACE PROCEDURE sp_obtener_menu(usuario IN VARCHAR2, json OUT CLOB) AS
    TYPE menu_rec_type IS RECORD (
        v_nombreVisible  ACC_X_FORM_ROL.NOMBRE_VISIBLE%TYPE,
        v_nombreMetodo   ACC_X_FORM_ROL.NOMBRE_METODO%TYPE,
        v_rol            ACC_X_FORM_ROL.COD_ROL%TYPE,
        permiteActualizar BOOLEAN,
        permiteInsertar BOOLEAN,
        permiteConsultar BOOLEAN
    );

    TYPE menu_list_type IS TABLE OF menu_rec_type;

    listaMenu menu_list_type := menu_list_type();
BEGIN
    -- Paso 1: Consulta SQL para recuperar datos del menú
    SELECT
        a.NOMBRE_VISIBLE,
        a.NOMBRE_METODO,
        a.COD_ROL,
        CASE WHEN a.PERM_ACTUALIZAR = 'S' THEN TRUE ELSE FALSE END,
        CASE WHEN a.PERM_INSERTAR = 'S' THEN TRUE ELSE FALSE END,
        CASE WHEN a.PERM_CONSULTAR = 'S' THEN TRUE ELSE FALSE END
    BULK COLLECT INTO
        listaMenu
    FROM
        ACC_X_FORM_ROL a
    JOIN
        USUARIOS_X_ROLES b
    ON
        a.COD_ROL = b.COD_ROL
    JOIN
        USUARIOS c
    ON
        b.COD_USUARIO = c.COD_USUARIO
    WHERE
        (
            (b.COD_ROL = 'OFNEGO' AND c.COD_USUARIO = usuario)
            OR
            (b.COD_ROL <> 'OFNEGO' AND c.COD_USUARIO = usuario AND c.EST_ACTIVO = 'S')
        )
        AND
        a.COD_SIST_FORMA = 'SF';

    -- Paso 2: Construir el objeto JSON manualmente
    json := '[';
    FOR i IN 1..listaMenu.COUNT LOOP
        json := json || '{"nombreVisible":"' || listaMenu(i).v_nombreVisible || '",'
                     || '"nombreMetodo":"' || listaMenu(i).v_nombreMetodo || '",'
                     || '"rol":"' || listaMenu(i).v_rol || '",'
                     || '"permiteActualizar":' || listaMenu(i).permiteActualizar || ','
                     || '"permiteInsertar":' || listaMenu(i).permiteInsertar || ','
                     || '"permiteConsultar":' || listaMenu(i).permiteConsultar || '}';
        IF i < listaMenu.COUNT THEN
            json := json || ',';
        END IF;
    END LOOP;
    json := json || ']';

    -- Paso 3: Fin del procedimiento
END;
/

