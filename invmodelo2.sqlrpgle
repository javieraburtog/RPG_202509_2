     F*--------------------------------------------------------------------*
     F* Sistema...: Informacion de Casa Pellas                             *
     F* Modulo....: Sistema de Inventarios CP                              *
     F* Programa..: INVMODELO2                                             *
     F* Objetivo..: Modulo de Manipulacion de Datos: Archivos/Tablas       *
     F* Fecha.....: Sabado 30 de Abril del 2016                            *
     F* Programo..: Javier Aburto                                          *
     F* Modifacado:                                                        *
     F*--------------------------------------------------------------------*
     F*--------------------------------------------------------------------*
     F*   Definicion de Nombre Modulo
     F*--------------------------------------------------------------------*
     F*         Digitos                  Nombre        Descripcion
     F*     ----------------           ----------    -----------------
     F*  1. Del Primer al Tercer      :  INV     - Identifica al Sistema,Modulo
     F*  2. Del Cuarto al Cuarto      :  M       - Indica Modulo
     F*  3. Del Quinto al Quinto      :  D       - Indica Datos
     F*  4. Del Sexto  al Decimo      :  VENTA   - Nombre del Modulo
     F*
     F*               -1234567890-
     F*       Ejemplo: INVMDVENTA
     F*------------

     F*--------------------------------------------------------------------*
     F*   Definicion de Nombre Procedimientos
     F*--------------------------------------------------------------------*
     F*         Digitos                  Nombre        Descripcion
     F*     ----------------           ----------    -----------------
     F*  1. Del Primer al Tercer      :  INV     - Identifica al Sistema,Modulo
     F*  2. Del Cuarto al Cuarto      :   _      - Separador
     F*  3. Del Quinto al Noveno      :  BONIF   - Nombre del Modulo
     F*  4. Del Decimo al Onceavo     :  01      - Un consecutivo
     F*  5. Del Doceavo en Adelante   :  InsertarDefinicionBonificacion - Nombre
     F*
     F*       Ejemplo: INV_VENTA01_InsertarCabeceraFactura
     F*------------
     F*
     H NOMAIN

      *------------------------
      * Importacion de los Prototipos
      *------------------------
      /Copy *Libl/QMODELO,INVMODELOP

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
     P EJE_Tabla01_Insertar_Codigo_Usuario...
     P                 B                   EXPORT
     D                 PI             2A
     D  DS_TABLA01                         likeds(DSTABLA01)
     D  Estado                       15a
     D*-----------

        Exec Sql
                Select *
                Into  :DS_TABLA01
                From  TABLA_DE_USUARIOS
                Where  Cod_USR              = :DS_TABLA01.COD_USR;

         Select;
         When SQLCOD = 0 ;

           Estado = 'ENCONTRADO';
           Return 'SI';

         When SQLCOD <> 0;

           Exec Sql
               Insert Into TABLA_DE_USUARIOS
              	(COD_USR, TIP_USR, COD_EMAIL)
               Values(:DS_TABLA01);

               Estado = 'INSERTADO';
               Return 'SI';

         EndSl;
     P                 E

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
     P EJE_Tabla01_Eliminar_Codigo_Usuario...
     P                 B                   EXPORT
     D                 PI             2A
     D  DS_TABLA01                         likeds(DSTABLA01)
     D  Estado                       15a
     D*-----------

        Exec Sql
                Select *
                Into  :DS_TABLA01
                From  TABLA_DE_USUARIOS
                Where  Cod_USR              = :DS_TABLA01.COD_USR;

         Select;
         When SQLCOD = 0 ;

            Exec Sql
                Delete
                From  TABLA_DE_USUARIOS
                Where  Cod_USR              = :DS_TABLA01.COD_USR;

           Estado = 'Eliminado';
           Return 'SI';

         When SQLCOD <> 0;

               Estado = 'NO ENCONTRADO';
               Return 'SI';

         EndSl;

     P                 E
