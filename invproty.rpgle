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
     F*       Ejemplo: INVMDCONFI
     F*------------

     F*--------------------------------------------------------------------*
     F*   Definicion de Nombre Prototipos
     F*--------------------------------------------------------------------*
     F*         Digitos                  Nombre        Descripcion
     F*     ----------------           ----------    -----------------
     F*  1. Del Primer al Tercer      :  INV     - Identifica al Sistema,Modulo
     F*  2. Del Cuarto al Cuarto      :   _      - Separador
     F*  3. Del Quinto al Noveno      :  VENTA   - Nombre del Modulo
     F*  4. Del Decimo al Onceavo     :  01      - Un consecutivo
     F*  5. Del Doceavo en Adelante   :  InsertarDefinicionBonificacion - Nombre
     F*
     F*       Ejemplo: INV_CONFI01_InsertarCabeceraFactura
     F*------------
      *---------------------------------------------------------------------
      * Nombre.....: INV_CONFI01_ConsultarCicloKM
      * Objetivo...: Insertar un Registro a la Tabla o Archivo
      * Parametros.:
      *     Entrada: DS_INV_DEFINICION_BONIFACION
      *     Salida.: Estado
      *---------------------------------------------------------------------
      * Estructura de datos de atributos para un articulo
     D*---------------------------------------------------------------------
     D* Nombre.....: DSCicloKM
     D* Objetivo...: Estructura para la Tabla Definicion de Bonificaciones
     D*---------------------------------------------------------------------
     DDSCICLOKM        DS                  DIM(100) QUALIFIED
     D CODIDE_                       10A
     D DESCRI_                       25A
     D*
      *---------------------------------------------------------------------
      * Nombre.....: INV_CONFI01_ConsultarCicloKM
      * Objetivo...: Consultar Registro a la Tabla o Archivo
      * Parametros.:  Nombre                 Tipo          Longitud
      *              -----------           ----------    -------------
      *   Entrada--> Codigo_Tabla           Caracter         2
      *
      *   Salida --> Arreglo_Codigo         Caracter        10
      *      "       Arreglo_Descripcion    Caracter        25
      *      "       Arreglo_Descripcion    Caracter        25
      *      "       Estado                 Caracter        15a
      *---------------------------------------------------------------------
     DINV_CONFI01_ConsultarCicloKM...
     D                 PR             2A
     D  Cod_Tabla                     2a
     D  Arr_CodIde                   10a   Dim(100)
     D  Arr_Descri                   25a   Dim(100)
     D* Arr_KM                             LIKEDS(dsCICLOKM) DIM(100)
     D  Estado                       15a
