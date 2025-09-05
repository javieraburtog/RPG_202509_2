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
      * Definir Prototipos
      *------------------------
      /Copy *Libl/QENPROCESO,INVPROTY

      *------------------------
      * Definir Variables Locales
      *------------------------
     D Stmt            S           1100A
     D X               S              3  0
     D CodIde          S              2a
     D Descri          S             25a

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
     PINV_CONFI01_ConsultarCicloKM...
     P                 B                   EXPORT
     D                 PI             2A
     D  Cod_Tabla                     2a
     D  Arr_CodIde                   10a    Dim(100)
     D  Arr_Descri                   25a    Dim(100)
     D*  Arr_KM                             LIKEDS(dsCICLOKM) DIM(100)
     D  Estado                       15a
     D*-----------

         // Inicializa Variables
          Estado ='SIN DATOS   ' ;

          x = 0 ;

          Stmt = 'Select CodIde , Descri ' +
                ' From TABMUL     '        +
                ' Where CodTAB = ''' + Cod_Tabla + '''' +
                ' Order By CodIde ' ;

         // Prepara Sentencia SQL para Cursor
          Exec Sql Prepare S_CC4  From :Stmt;

         // Declara Cursor
          Exec Sql Declare CC4 Scroll Cursor For S_CC4;

         // Abre Cursor
          Exec Sql Open CC4;

         // Lee Registro
          Exec Sql Fetch From CC4
               Into :Codide,  :Descri  ;

         // Ciclo hasta Llegar al Ultimo Registro
          DoU SQLCODE = 100 Or SQLCODE = -501;

             // Llena Arreglo
              x = x + 1 ;
              Arr_CodIde(X) = CodIde ;
              Arr_Descri(X) = Descri ;

             // Lee siguiente Registro
              Exec Sql Fetch Next From CC4
                    Into :CodIde, :Descri  ;

          EndDo;

          If X > 1 ;
             Estado ='CON DATOS   ' ;
          EndIf;

          // Cierra Cursor
          Exec SQL Close CC2;


        Return 'SI';
     P                 E
