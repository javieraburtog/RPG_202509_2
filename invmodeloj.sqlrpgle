     F*--------------------------------------------------------------------*
     F* Sistema...: Informacion de Casa Pellas                             *
     F* Modulo....: Sistema de Inventarios CP                              *
     F* Programa..: INVMODELO                                              *
     F* Objetivo..: Modelar la estructura basica de un programa            *
     F* Fecha.....: Lunes 25 de Abril del 2016                             *
     F* Programo..: Javier Aburto                                          *
     F* Modificado:                                                        *
     F*--------------------------------------------------------------------*
     FInvModelFMCf   E             WorkStn InfDs(DspFbk)
     F                                     INDDS(indicadores)
     F                                     SFILE(SUBDET:SEC5)
     FTabMul    If   E           k Disk
      *--------------------------------------------------------------------*
      * TRAER LOS PROTOTIPOS
      *--------------------------------------------------------------------*

      /Copy *Libl/QCPYSRC,INVTECLAS

     D*---------------
     D*  Variables Locales
     D*---------------
     D ySuc            S              1a
     D ySuc3           S              1a
     D yBod            S              1a
     D*
     D Linea           S              3  0
     D Colum           S              3  0
     D Indice          S              2  0
     D*
     D Sec5            S              4  0
     D ySec5           S              4  0
     D*
     DxCodigoTabla     s              2a
     DxCodigoElemento  s             10a
     DxEstado1         s              1  0
     DxTipoTabla       s              1a
     D*---------------
     D*  Variables Boolean
     D*---------------
     D HayError        S              1n
     D  FinSubfiles    S               N
     D****************
     D* Indicadores de Pantalla
     D****************
     Dindicadores      DS
     D masCampos                       N   Overlay(indicadores : 11)
     D LimpiarSubfile                  N   Overlay(indicadores : 30)
     D errorCampo1                     N   Overlay(indicadores : 62)
     D errorCampo2                     N   Overlay(indicadores : 63)
     D*---------------
     D*  Arreglos
     D*---------------
     D Arr1            S              2  0 DIM(10)
     D*---------------
     D* Parametros Llamada Programa INV2283
     D*---------------
     D FinProg         S              1  0
     D np              S              2  0
     D CodCia          S              2a
     D CodSuc          S              2a
     D CodBod          S              8a
     D NomCia          S             23a
     D NomSuc          S             15a
     D NomBod          S             15a
     D NomProg         S             10a   inz('INVMODELO ')
     D p               S              2  0
     D xv              s              2  0
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
     D* Definicion de Parametros Seguridad
     D*---------------
     DINV229           PR                  EXTPGM('INV229')
     D  FinProg                       1  0
     D  NomProg                      10a
     D*
     D*---------------
     D* Prototipo de Parametros Cia+Suc+Bod
     D*---------------
     DINV2283          PR                  EXTPGM('INV2283')
     D  Np                            2  0
     D  FinProg                       1  0
     D  P                             2  0
     D  Xv                            2  0
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
     D CodigoTabla                    2a
     D CodigoElemento                10a
     D Estado1                        1  0
     D TipoTabla                      1a
     D*
     D*---------------
     D* Recupera Posicion del Cursor
     D*---------------
     DDSPFBK           DS
     D TeclaFuncion                   1A   Overlay(DSPFBK:369)
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
         When p=1;
           ExSr ComSucBod;
         When p=2;
           ExSr Encabezado;
         When p=3;
          ExSr Detalle;
         When p=4;
          ExSr Confirma;
         When p=5;
          ExSr Graba_Actualiza;
         EndSl;
       EndDo;

       //--------------------------------------------------------------------*
       //  SubRutina de Compa¦ia,Sucursal y Bodega                           *
       //--------------------------------------------------------------------*

       BegSr ComSucBod;

         FinProg=0;
         Np=2;
         xv=xv+1;

         CallP INV2283(Np:FinProg:P:Xv:CodCia:CodSuc:CodBod:NomCia:
                     NomSuc:NomBod);

         If FinProg=1;
            eval *InLr=*On;
            Return;
         EndIf;

       EndSr;

       //--------------------------------------------------------------------*
       //  SubRutina de Encabezado de Pedidos de Rutas                       *
       //--------------------------------------------------------------------*

       BegSr ENCABEZADO;

        //-------------
        // Sucursal: Existencia INVD02
        //-------------
         ySuc=' ';
         ySuc3=' ';
         CodIde=CodSuc;
         Chain ('02':CodIde) reg001;
         If %Found();
           ySuc=p2;
           ySuc3=p6;
         EndIf;

         Write Parame;

        //----------------
        // Presenta Datos
        //----------------
         ExFmt Encabe;

         HayError=*Off;
         *In35=*Off;

        //----------------
        // Evaluacion de Teclas de Funcion
        //----------------
         Select;
         When TeclaFuncion = F3;
            *InLr=*On;
            Return;

         When TeclaFuncion = F4;
            ExSr Ayudas;

         When TeclaFuncion = F12;
            P=1;

         Other;

            ExSr Validar_Encabezado;

            //----------------
            // Avanza Pantalla
            //----------------
            If HayError=*Off;
               P=3;
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
        If *In97=*Off;

            LimpiarSubfile = *On;
            Write SubDe1;
            HayError = *Off;
            LimpiarSubfile = *Off;
            masCampos = *Off;
            *In31=*Off;
            Sec5=0;

            //----------------
            // Llena SubFile desde una tabla
            //----------------
            Setll ('20') reg001;
            ReadE ('20') reg001;
            DoW Not %Eof();

                SCPARTE = CodIde;

                Sec5=Sec5+1;
                Write SubDet;

                If %Eof();
                  FinSubfiles = *On;
                EndIf;

                ReadE ('20') reg001;

            EndDo;

            //----------------
            // Llenar Blancos SubFile :
            //----------------
            Dow FinSubfiles = *Off;

               SCPARTE = '';
               Sec5=Sec5+1;
               Write SubDet;
               If %Eof();
                  FinSubfiles=*On;
               EndIf;

            EndDo;

            Sec5=1;

        EndIf;

       //----------------
       // Presenta Datos de SubFile
       //----------------
        HayError=*On;

        DoU HayError = *Off;

         If Sec5>0;
           ExFmt SubDe1;
           errorCampo1 = *Off;
           errorCampo2 = *Off;
         EndIf;

         // Evaluacion de Teclas de Funcion
         Select;
         When TeclaFuncion = F3;
            *InLr=*On;
            Return;

         When TeclaFuncion = F4;

         When TeclaFuncion = F12;
            P=2;
            FinSubfiles = *Off;
            LeaveSr;
         Other;

            //----------------
            // Lee SubFile - Valida
            //----------------
            HayError = *Off;
            *In97=*Off;
            eval Sec5=1;
            Chain Sec5 SubDet;
            DoW %Found(InvModelFm);

              *in97 = *On;

              ExSr Validar_Detalle;

              Update SubDet;

              If HayError=*On;
                 ySec5=Sec5;
                 Leave;
              EndIf;

              eval Sec5=Sec5+1;
              Chain Sec5 SUbDet;
            EndDo;

            If HayError=*On;
               Sec5=ySec5;
            Else;
               Sec5=1;
            EndIf;

            //----------------
            // Avanza Pantalla
            //----------------
            If HayError = *Off;
               Write SubDe1;
               P=4;
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
        When TeclaFuncion = F3;
           *InLr=*On;
           Return;
        When TeclaFuncion = F4;

        When TeclaFuncion = F12;
           P=3;
           LeaveSr;
        EndSl;

        //----------------
        // Avanza Pantalla
        //----------------
        If xR1='N';
          P=3;
        EndIf;

        If HayError = *Off And xR1='S';
          P=5;
        EndIf;

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
        If HayError = *Off;
          P=2;
        EndIf;

       EndSr;

       //------------------------------------------------------------------*
       // SubRutina de Validacion de Encabezado                            *
       //------------------------------------------------------------------*
       BegSr Validar_Encabezado;

         ExSr ManejoError;

       EndSr;

       //------------------------------------------------------------------*
       // SubRutina de Validacion de Detaller                              *
       //------------------------------------------------------------------*
       BegSr Validar_Detalle;

         If SCCANTIDA = 0 and scparte <> '';
            HayError    = *On;
            errorCampo1 = *On;
            LeaveSr;
         ENDIF;


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

         P=1;
         Write Marco;

       EndSr;

       //--------------------------------------------------------------------*
       //  SubRutina de Seguridad                                            *
       //--------------------------------------------------------------------*
       BegSr Seguridad;

         Eval FinProg=0;

         CallP INV229(FinProg:NomProg);

         If FinProg=1;
            eval *InLr=*On;
            Return;
         EndIf;

       EndSr;

       //----------------------------------------------------------------------*
       // SubRutina de Identificacion de Posicion del Cursor
       //----------------------------------------------------------------------*
       BegSr Cursor;

         If Screen <> *ZEROS;
            Linea = Screen/256;
            Colum = %rem(Screen:256);
         ENDIF;

         Fila = Linea;
         Colu = Colum;

       ENDSR;

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
         If Fila = 7;
            xCodigoTabla='80';
            CallP INV110(xCodigoTabla:xCodigoElemento:xEstado1:xTipoTabla);

            xCodigo=xCodigoElemento;

            If FinProg=1;
              eval *InLr=*On;
              Return;
            EndIf;


         EndIf;

         Write Marco;
         Write Parame;
         Write Encabe;

       ENDSR;


       /End-Free
