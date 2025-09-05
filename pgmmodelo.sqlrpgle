     F*--------------------------------------------------------------------*
     F* Sistema...: Informacion de Casa Pellas                             *
     F* Modulo....: Sistema de Inventarios CP                              *
     F* Programa..: PGMMODELO                                              *
     F* Objetivo..: Modelar la estructura basica de un programa            *
     F* Fecha.....: Lunes 25 de Abril del 2016                             *
     F* Programo..: Javier Aburto                                          *
     F* Modificado:                                                        *
     F*--------------------------------------------------------------------*
     F*--------------------------------------------------------------------*
     F*   Definicion de Nombre de Programas, Archivos Prototipos
     F*--------------------------------------------------------------------*
     F*------------
     F*  Nombre de Programas, Primera Version
     F*------------
     F* 1. Prefijo   : INV           - Identifica el Prefijo del Sistema, Modulo
     F* 2. SubFijo   : 600           - Consecutivo Numerico del Programa
     F*
     F*        Ejemplo :  INV600
     F*
     F*------------
     F*  Nombre de Programas, Segunda, Tercera,..., Version
     F*------------
     F* 1. Prefijo   : INV           - Identifica el Prefijo del Sistema, Modulo
     F* 2. SubFijo 1 : 600           - Consecutivo Numerico del Programa
     F* 3. SubFijo 2 : 1             - Consecutivo de Version
     F*
     F*        Ejemplo :  INV6001
     F*
     F*--------------------------------------------------------------------*
     F*   Definicion de Archivos,Tablas, Archivos UI, Archivo Reportes
     F*--------------------------------------------------------------------*
     F*------------
     F*  Nombre de Archivos, Tablas , Archivos UI, Archivos Reportes
     F*------------
     F*   Prefijo  : INV           - Identifica el Prefijo del Sistema, Modulo
     F*   SubFijo  : Nombre del contenido
     F*
     F*------------
     F*  Nombre de Archivos UI
     F*------------
     F* 1. Prefijo   : INV           - Identifica el Prefijo del Sistema, Modulo
     F* 2. SubFijo 1 : 600           - Consecutivo Numerico del Programas
     F* 3. SubFijo 2 : FM            - Indica que es UI
     F*
     F*        Ejemplo :  INV600FM
     F*------------
     F*  Nombre de Archivos de Reportes
     F*------------
     F* 1. Prefijo   : INV           - Identifica el Prefijo del Sistema, Modulo
     F* 2. SubFijo 1 : 600           - Consecutivo Numerico del Programas
     F* 3. SubFijo 2 : R             - Indica que es Reporte
     F*
     F*        Ejemplo :  INV600FM
     F*
     F*--------------------------------------------------------------------*
     F*   Definicion de Nombre Variables
     F*--------------------------------------------------------------------*
     F*------------
     F*  Variables de Intefaz de Usuario (UI)
     F*------------
     F*   Prefijo  : sc
     F*   SubFijo  : Nombre del contenido
     F*
     F*------------
     F*  Variables tipo Caracter Temporal
     F*------------
     F*   Prefijo  : ch
     F*   SubFijo  : Nombre del contenido
     F*
     F*------------
     F*  Variables tipo Numerica Temporal
     F*------------
     F*   Prefijo  : nu
     F*   SubFijo  : Nombre del contenido
     F*
     F*------------
     F*  Variables tipo Fechas Temporal
     F*------------
     F*   Prefijo  : dt
     F*   SubFijo  : Nombre del contenido
     F*
     F*------------
     F*  Arreglos
     F*------------
     F*   Prefijo  : arr
     F*   SubFijo  : Nombre del contenido
     F*
     F*------------
     F*  Estructura de Datos
     F*------------
     F*   Prefijo  : ds
     F*   SubFijo  : Nombre del contenido
     F*
     F*
     F*
     H* DftActGrp(*No) ActGrp(*Caller)
     FPgmModelFMCf   E             WorkStn InfDs(DspFbk)
     F                                     SFILE(SUBDET:SEC5)
     F                                     IndDs(Indicadores)
     FTabMul    If   E           k Disk
     F*--------------------------------------------------------------------*
     D*
     D*---------------
     D* Para Convertir Fechas
     D*---------------
      /Copy *Libl/QCPYSRC,INVTECLAS
      /Copy *Libl/QENPROCESO,INVPROTY

     D*---------------
     D*  Variables Locales
     D*---------------
     D ySuc            S              1a
     D ySuc3           S              1a
     D yBod            S              1a
     D*
     D X               S              3  0
     D Resultado       S              2a
     D Cod_Tabla       S              2a
     D Arr_CodIde      S             10a   Dim(100)
     D Arr_Descri      S             25a   Dim(100)
     D Estado          S             15a
     D*
     D Sec5            S              4  0
     D ySec5           S              4  0
     D Indice          S              2  0
     D*
     D xCodigoTabla    s              2a
     DxCodigoElemento  s             10a
     D xEstado1        s              1  0
     D xTipoTabla      s              1a
     D*
     D chNumeroRuc     s             20a
     D chCodigoMoneda  s              3a
     D nuImpuestoIVA   s              3  0
     D*---------------
     D*  Variables Boolean
     D*---------------
     D  HayError       S              1n
     D  FinSubFile     S              1n
     D
     D*---------------
     D*  Arreglos
     D*---------------
     D  Arr1           S              2  0 DIM(10)
     D*---------------
     D* Parametros Llamada Programa INV2283
     D*---------------
     D NoDePantalla    S              2  0
     D FinDePrograma   S              1  0
     D Proceso         S              2  0
     D ConfPorOmision  s              2  0
     D CodCia          S              2a
     D CodSuc          S              2a
     D CodBod          S              8a
     D NomCia          S             23a
     D NomSuc          S             15a
     D NomBod          S             15a
     D NomProg         S             10a   inz('PGMMODELO ')
     D
     D*---------------
     D* Para Convertir Fechas
     D*---------------
     D yFecIso         S               D   DATFMT(*ISO)
     D yFecJul         S               D   DATFMT(*JUL)
     D yTim            S               T   TIMFMT(*HMS)
     D yFecJulN        S              6  0
     D yFecIsoN        S              8  0
     D yHora           S              6  0
     D*
     D*---------------
     D* Indicadores de Pantalla
     D*---------------
     DIndicadores      DS
     D LimpiarSubfile                  N   Overlay(indicadores : 30)
     D errorScCantid                   N   Overlay(indicadores : 62)
     D errorScParte                    N   Overlay(indicadores : 63)
     D*---------------
     D* Definicion de Parametros Seguridad
     D*---------------
     DINV229           PR                  EXTPGM('INV229')
     D  FindePrograma                 1  0
     D  NomProg                      10a
     D*
     D*---------------
     D* Prototipo de Parametros Cia+Suc+Bod
     D*---------------
     DINV2283          PR                  EXTPGM('INV2283')
     D  NoDePantalla                  2  0
     D  FinDePrograma                 1  0
     D  Proceso                       2  0
     D ConfPorOmision                 2  0
     D  CodCia                        2a
     D  CodSuc                        2a
     D  CodBod                        8a
     D  NomCia                       23a
     D  NomSuc                       15a
     D  NomBod                       15a
     D*---------------
     D* Definicion de Parametros de Tablas
     D*---------------
     DINV110           PR                  EXTPGM('INV110')
     D  CodigoTabla                   2a
     D CodigoElemento                10a
     D  Estado1                       1  0
     D  TipoTabla                     1a
     D*
     D*---------------
     D* Recupera Posicion del Cursor
     D*---------------
     DDSPFBK           DS
     D  TeclaFuncion                  1A   Overlay(DSPFBK:369)
     D SCREEN                370    371B 0
     D WINDOW                382    383B 0
     D*
     D*---------------
     D* Datos Nombre Trabajo y Numero
     D*---------------
     DMyPSDS          SDS
     D PARMS             *PARMS
     D NombrePrograma          1     10
     D CodigoUsuario         254    263
     D NombreTrabajo         244    253
     D NumeroTrabajo         264    269a
     D*
     D*---------------
     D* Recupera Usuario y Pantalla
     D*---------------
     DLOCALDATA       UDS                  DTAARA(*LDA)
     D  user                   1     10
     D  panta                 11     20
     D*--------------------------------------------------------------------*
      /Free
       //--------------------------------------------------------------------*
       //  Instrucciones Principales del Programa                            *
       //--------------------------------------------------------------------*

       ExSr Inicio;
       ExSr Seguridad;

       DoW Not *InLR;
         Select;
         When Proceso = 1;
           ExSr Seleccion_Estructura_Organizacional;
         When Proceso = 2;
           ExSr Encabezado;
         When Proceso = 3;
          ExSr Detalle;
         When Proceso = 4;
          ExSr Confirma;
         When Proceso = 5;
          ExSr Graba_Actualiza;
         EndSl;
       EndDo;

       //--------------------------------------------------------------------*
       //  SubRutina de Compa¦ia,Sucursal y Bodega                           *
       //--------------------------------------------------------------------*

       BegSr Seleccion_Estructura_Organizacional;

         FinDePrograma=0;
         NoDePantalla=2;
         ConfPorOmision=ConfPorOmision+1;

         CallP INV2283(NoDePantalla:FinDePrograma:Proceso:ConfPorOmision
                         :CodCia:CodSuc:CodBod:NomCia:
                          NomSuc:NomBod);

         If FinDePrograma=1;
            eval *InLr=*On;
            Return;
         EndIf;

       EndSr;

       //--------------------------------------------------------------------*
       //  SubRutina de Encabezado de Pedidos de Rutas                       *
       //--------------------------------------------------------------------*

       BegSr ENCABEZADO;

        //-------------
        // Compañia:
        //-------------
         chNumeroRuc =' ';
         chCodigoMoneda=' ';
         nuImpuestoIVA=0;
         CodIde=CodCia;
         Chain ('01':CodIde) reg001;
         If %Found();
           chNumeroRuC=%Trim(tDescri1) ;
           nuImpuestoIVA=%dec(Orden:2:0);
           chCodigoMoneda=Otros1 ;
         EndIf;

        //-------------
        // Sucursal: CPD '00=Casa Matriz'
        //    ySuc = ' ', Existencia está en INVD01
        //  *** Existencias está en 10 Bodegas : Campos,  ***
        //  *** IEXT01,IEXT02,IEXT03,IEXT04,IEXT05,IEXT06 ***
        //  *** IEXT07,IEXT08,IEXT09,IEXT10               ***
        //-------------

        //-------------
        // Sucursal: Existencia INVD02
        //    ySuc = 'S', Existencia está en INVD02
        //  *** Existencia de Una Bodega '01=LA PRINCIPAL'***
        //
        //    ySuc3= 'S', Aplica a DICAP '47=Distribuidora'
        //-------------
         ySuc =' ';
         ySuc3=' ';
         CodIde=CodSuc;
         Chain ('02':CodIde) reg001;
         If %Found();
           ySuc=p2;
           ySuc3=p6;
         EndIf;

        //-------------
        // Bodega  : Existencia INVD03
        //    yBod = 'S', Existencia está en INVD03
        //    yBod = ' ', Existencia está en INVD01 ó INVD02
        //-------------
         yBod=' ';
         CodIde=CodBod;
         Chain ('03':CodIde) reg001;
         If %Found();
           yBod=p2;
         EndIf;


        //----------------
        // Presenta Datos
        //----------------
         Write Parame;

         ExFmt Encabe;

         HayError=*Off;
         *In35=*Off;

        //----------------
        // Evaluacion de Teclas de Funcion
        //----------------
         Select;
         When TeclaFuncion=F3;
            *InLr=*On;
            Return;

         When TeclaFuncion=F4;
            ExSr Ayudas;

         When TeclaFuncion=F12;
            Proceso = 1;

         Other;

            ExSr Validar_Encabezado;

          //----------------
          // Avanza Pantalla
          //---------------
          If HayError=*Off;
            HayError=*Off;

            Proceso = 3;

            Write Encabe;
          EndIf;

         EndSl;


       EndSr;

       //------------------------------------------------------------------*
       // Sub-Rutina de Detalle
       //------------------------------------------------------------------*
       BegSr DETALLE;


        //----------------
        // Inicializa SubFile
        //----------------
        If *In97 = *Off;

           LimpiarSubFile = *On;
           Write SubDe1;

           HayError = *Off;
           LimpiarSubFile = *Off;
           *In31 = *Off;
           *In11 = *On;
           Sec5  = 0;

        //----------------
        // Llenar Desde una Tabla
        //----------------
       //Setll ('XX') reg001;
       //Reade ('XX') reg001;
       //DoW Not %Eof() ;

       //  scParte=CodIde;

       //  Sec5=Sec5+1;
       //  Write SubDet;
       //  If %Eof();
       //     FinSubfile=*On;
       //  EndIf;


       //  Reade ('XX') reg001;

       //EndDo;

           Cod_Tabla = '02' ;

           Resultado = INV_CONFI01_ConsultarCicloKM(Cod_Tabla
                                                 :Arr_CodIde
                                                 :Arr_Descri
                                                 :Estado ) ;
          Dsply Resultado ;
          Dsply Estado ;
          Dsply Arr_CodIde(1) ;
          Dsply Arr_Descri(1) ;
          Dsply '2' ;
          Dsply Arr_CodIde(2) ;
          Dsply Arr_Descri(2) ;
          Dsply '3';
          Dsply Arr_CodIde(3) ;
          Dsply Arr_Descri(3) ;

         X = 1 ;
         DoW  X <= 100;


           scParte = Arr_Descri(x);

           Sec5=Sec5+1;
           Write SubDet;
           x = x + 1 ;

           If %Eof();
              FinSubfile=*On;
           EndIf;


         EndDo;


        //----------------
        // Llenar Blancos SubFile :
        //----------------
         DoW FinSubFile = *Off;

           scParte=' ';

           Sec5 = Sec5 + 1;
           Write SubDet;
           If %Eof();
              FinSubfile=*On;
           EndIf;

         EndDo;

         Sec5 = 1;

        EndIf;

       //----------------
       // Presenta Datos de SubFile
       //----------------
        HayError = *On;
        DoU HayError = *Off;

          If Sec5 > 0;
            ExFmt SubDe1;
          EndIf;

         // Evaluacion de Teclas de Funcion
         Select;
         When TeclaFuncion=F3;
            *InLr=*On;
            Return;

         When TeclaFuncion=F4;

         When TeclaFuncion=F12;
            Proceso = 2 ;
            FinSubFile=*Off;
            LeaveSr;
         Other;


           //----------------
           // Lee SubFile - Valida
           //----------------
           HayError=*Off;
           *In97=*Off;
           eval Sec5=1;
           Chain Sec5 SubDet;
           DoW %Found(PgmModelFm);

             *In97 = *On;

             ExSr Validar_Detalle;


             Update SubDet;

             If HayError = *On;
               ySec5 = Sec5;
               Leave;
             EndIf;

             eval Sec5=Sec5+1;
             Chain Sec5 SUbDet;
           EndDo;

           If HayError = *On;
              Sec5 = ySec5;
           Else;
              Sec5 = 1;
           EndIf;



           //----------------
           // Avanza Pantalla
           //----------------
           If HayError = *Off;
             Write SubDe1;
             Proceso = 4 ;
           EndIf;


         EndSl;

        EndDo;

       ENDSR;

       //------------------------------------------------------------------*
       // Sub-Rutina de Confirmacion
       //------------------------------------------------------------------*
       BegSr CONFIRMA;

        ExFmt Pregunta1;

        // Evaluacion de Teclas de Funcion
        Select;
        When TeclaFuncion=F3;
           *InLr=*On;
           Return;
        When TeclaFuncion=F4;

        When TeclaFuncion=F12;
           Proceso = 2 ;
           LeaveSr;
        Other;

          //----------------
          // Avanza Pantalla
          //----------------
          If xR1='N';
            Proceso = 3;
          EndIf;

          If HayError=*Off And xR1='S';
            Proceso = 5;
          EndIf;

        EndSl;


       ENDSR;


       //------------------------------------------------------------------*
       // SubRutina de Actualizacion de Archivos                           *
       //------------------------------------------------------------------*
       BegSr Graba_ACTUALIZA;

        //----------------
        // Actualiza
        //----------------

        //----------------
        // Avanza Pantalla
        //----------------
        If HayError=*Off;
          Proceso = 2;
        EndIf;

       EndSr;

       //------------------------------------------------------------------*
       // SubRutina de Validacion de Encabezado                            *
       //------------------------------------------------------------------*
       BegSr Validar_Encabezado;

           ExSr ManejoError;

       EndSr;

       //------------------------------------------------------------------*
       // SubRutina de Manejo de Errores                                   *
       //------------------------------------------------------------------*
       BegSr ManejoError;

         Monitor;

           indice=1;
           DoW Indice<=11;
              Arr1(indice)=1;

              indice=indice+1;
           EndDo;

           On-Error 00121 ;
           dsply 'AAAA';

         EndMon;


       EndSr;

       //------------------------------------------------------------------*
       // SubRutina de Validacion de Detaller                              *
       //------------------------------------------------------------------*
       BegSr Validar_Detalle;

             errorScCantid=*Off;

             If scCantida = 0  And scParte <> ' ';
                errorScCantid=*On;
                HayError=*On;
                LeaveSr;
             Endif;


       EndSr;

       //--------------------------------------------------------------------*
       //  SubRutina de Mensaje                                              *
       //--------------------------------------------------------------------*

       BegSr Mensaje;

        // ExFmt Mensaj;

       EndSr;

       //--------------------------------------------------------------------*
       //  SubRutina de Inicio de Programa                                   *
       //--------------------------------------------------------------------*

       BegSr Inicio;

         Fec    =%dec(%date());
         yFecIso=%date();
         ytim=%time();
         yFecIsoN=%Dec(yFecIso);
         yHora=%Dec(yTim);

         Proceso = 1;

         Write Marco;

       EndSr;

       //--------------------------------------------------------------------*
       //  SubRutina de Seguridad                                            *
       //--------------------------------------------------------------------*
       BegSr Seguridad;

         Eval FindePrograma=0;

         CallP INV229(FinDePrograma:NomProg);

         If FinDePrograma=1;
            eval *InLr=*On;
            Return;
         EndIf;

       EndSr;


      //--------------------------------------------------------------------*
      //  Sub-Rutina de Ayudas                                              *
      //--------------------------------------------------------------------*
       BegSr AYUDAS;

         //----------
         //  Posicion de Cursor
         //----------
          ExSr Cursor;

         //----------
         //  Ayuda de Tablas
         //----------
          If Linea=7;
            xCodigoTabla='80';
            CallP INV110(xCodigoTabla:xCodigoElemento:xEstado1:xTipoTabla);

            xCodigo=xCodigoElemento;

            If FinDePrograma=1;
              eval *InLr=*On;
              Return;
            EndIf;


          EndIf;

         //
         Write Marco;
         Write Parame;
         Write Encabe;
         //-------
       ENDSR;
      /END-FREE
     C*--------------------------------------------------------------------*
     C*  SubRutina de Identificacion de Posicion del Cursor                *
     C*--------------------------------------------------------------------*
     C     CURSOR        BEGSR
     C     SCREEN        IFNE      *ZEROS
     C     SCREEN        DIV       256           LINEA             3 0
     C                   MVR                     COLUM             3 0
     C                   ELSE
     C                   ENDIF
     C                   MOVE      LINEA         FILA
     C                   MOVE      COLUM         COLU
     C                   ENDSR
     C*--------------------------------------------------------------------*
