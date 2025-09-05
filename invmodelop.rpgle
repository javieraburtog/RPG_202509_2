      *------------------------------------------------------------------------*
      * Sistema....: Informacion de Casa Pellas
      * Modulo.....: Sistema de Inventarios CP
      * Archivo....: INVMODELOP
      * Objetivo...: Definir Prototipos de Manipulacion de Datos
      * Fecha......: Lunes 25 de Abril del 2016
      * Programo...: Jossyl Zamora
      * Modificado.:
      *------------------------------------------------------------------------*
     F*--------------------------------------------------------------------*
     F*   Definicion de Nombre de Archivo
     F*--------------------------------------------------------------------*
     F*         Digitos                  Nombre        Descripcion
     F*     ----------------           ----------    -----------------
     F*  1. Del Primer al Tercer      :  INV     - Identifica al Sistema,Modulo
     F*  2. Del Cuarto al Cuarto      :  M       - Indica Modulo
     F*  3. Del Quinto al Quinto      :  D       - Indica Datos
     F*  4. Del Sexto  al Noveno      :  VENT    - Nombre del Modulo
     F*  5. Del Decimo al Decimo      :  P       - Indica Prototipo
     F*
     F*               -1234567890-
     F*       Ejemplo: INVMDVENTP
     F*
     F*       Ejemplo: SOTMDCONF       - Modulo - contiene sub-procedure
     F*       Ejemplo: SOTMDCONFP      - Prototipo
     F*
     F*------------

     F*--------------------------------------------------------------------*
     F*   Definicion de Nombre Sub-Procedure
     F*--------------------------------------------------------------------*
     F*         Digitos                  Nombre        Descripcion
     F*     ----------------           ----------    -----------------
     F*  1. Del Primer al Tercer      :  INV     - Identifica al Sistema,Modulo
     F*  2. Del Cuarto al Cuarto      :   _      - Separador
     F*  3. Del Quinto al Noveno      :  VENTA   - Nombre del Modulo
     F*  4. Del Decimo al Onceavo     :  01      - Un consecutivo
     F*  5. Del Doceavo en Adelante   :  InsertarDefinicionBonificacion - Nombre
     F*
     F*       Ejemplo: INV_VENTA01_InsertarCabeceraFactura
     F*
     F*       Ejemplo: SOT_SOTUSERS01_InsertarCodigoUsuario
     F*                SOT_SOTUSERS01_ModificarCodigoUsuario
     F*                SOT_SOTUSERS01_EliminarCodigoUsuario
     F*                SOT_SOTUSERS01_ConsultarCodigoUsuario
     F*------------
     F*
      * Estructura de datos de atributos para un articulo
     D*---------------------------------------------------------------------
     D*---------------------------------------------------------------------
     D* Nombre.....: DSTABLA01
     D* Objetivo...: Estructura para la Tabla Definicion de Bonificaciones
     D*---------------------------------------------------------------------
     DDSTABLA01        DS
     D COD_USR                       10A
     D TIP_USR                        3A
     D COD_EMAIL                     15A

      *---------------------------------------------------------------------
      * Nombre.....: EJE_TABLA01_Insertar_Codigo_Usuario
      * Objetivo...: Insertar nuevos codigos de usaurio
      * Programo...: Javier Aburto Galeano
      *
      * Parametros.:  Nombre                  Tipo          Longitud
      *              -----------            ----------    -------------
      *   Entrada--> DS_TABLA01              Caracter          _
      *
      *   Salida -->
      *      "       Estado                  Caracter         15
      *---------------------------------------------------------------------
     DEJE_Tabla01_Insertar_Codigo_Usuario...
     D                 PR             2A
     D  DS_TABLA01                         likeds(DSTABLA01)
     D  Estado                       15a

      *---------------------------------------------------------------------
      * Nombre.....: EJE_TABLA01_Eliminar_Codigo_Usuario
      * Objetivo...: Eliminar un codigo de usuario
      * Programo...: Javier Aburto Galeano
      *
      * Parametros.:  Nombre                  Tipo          Longitud
      *              -----------            ----------    -------------
      *   Entrada--> DS_TABLA01              Caracter          _
      *
      *   Salida -->
      *      "       Estado                  Caracter         15
      *---------------------------------------------------------------------
     DEJE_Tabla01_Eliminar_Codigo_Usuario...
     D                 PR             2A
     D  DS_TABLA01                         likeds(DSTABLA01)
     D  Estado                       15a
     D*------
