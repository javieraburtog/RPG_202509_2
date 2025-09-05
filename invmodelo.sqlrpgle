     F*--------------------------------------------------------------------*
     F* Sistema...: Informacion de Casa Pellas                             *
     F* Modulo....: Sistema de Inventarios CP                              *
     F* Programa..: INVMODELO                                              *
     F* Objetivos.: -Modelar la estructura basica de un programa           *
     F*           : -Separar las capas, UI, Controller y Data (MVC)        *
     F* Fecha.....: Lunes 25 de Abril del 2016                             *
     F* Programo..: Javier Aburto                                          *
     F* Modificado: Javier Aburto                    23/02/2024            *
     F*--------------------------------------------------------------------*

       dcl-f InvModelFM workstn infDs(DspFbk) sfile(SubDet:NoRelativo)
                                indds(Indicadores) ;
       dcl-f Tabla01 usage(*input) keyed ;

       dcl-f InvPrg usage(*input) keyed ;

       dcl-f TabMul usage(*input) keyed ;


       // Importar Prototipos
       /Copy *Libl/QCPYSRC,INVTECLAS
       /Copy *Libl/QMODELO,INVMODELOP

       // Variables Locales

        // Variables para centrado de texto
       Dcl-S Texto_a_Centrar char(78);
       Dcl-S Texto_Centrado char(78);
       Dcl-S Longitud packed(2:0);

       // Variables para Conteos
       Dcl-S Idx1 packed(2:0);
       Dcl-S Idx2 packed(2:0);
       Dcl-S Indice packed(2:0);

       //---
       // Variables para SubFile
       Dcl-S NoRelativo packed(4:0);
       Dcl-S NoRelativo_ packed(4:0);

       // Posicion de Cursor
       Dcl-S Fila_ packed(3:0);
       Dcl-S Columna_ packed(3:0);

       // Parametros de Tabla de Catalogos
       Dcl-S xCodigoTabla char(2);
       Dcl-S xCodigoElemento char(10);
       Dcl-S xEstado1 packed(1:0);
       Dcl-S xTipoTabla char(1);

       Dcl-S Estado_ char(2);
       Dcl-S Estado_1 char(15);

       // Variables Numericas, prueba manejo de excepciones
       Dcl-S Valor_A packed(11:2) inz(15.00);
       Dcl-S Valor_B packed(11:2) inz(0.00);
       Dcl-S Resultado packed(11:2);

       // Codigo de Mensajes de aplicacion
       Dcl-S Id_Mensaje char(10);

       // UI, Manejo Teclas de funcion por formulario
       Dcl-S Id_Sistema char(10) Inz('INV');
       Dcl-S Tipo_Formato char(2) Inz('UI');
       Dcl-S Cod_Formato char(10);
       Dcl-S Valores char(78);

       // Variables, tipo boolean
       Dcl-S HayError Ind;
       Dcl-S FinSubFile Ind;

       // Definicion de Arreglo
       Dcl-s Arr_Numero packed(2:0) dim(100) ;

       // Definicion de variables temporales
       Dcl-S NoDePantalla packed(2:0);
       Dcl-S FinDePrograma packed(1:0);
       Dcl-S Proceso packed(2:0);
       Dcl-S ConfPorOmision packed(2:0);
       Dcl-S CodCia char(2);
       Dcl-S CodSuc char(2);
       Dcl-S CodBod char(8);
       Dcl-S NomCia char(23);
       Dcl-S NomSuc char(15);
       Dcl-S NomBod char(15);
       Dcl-S NomProg char(10) inz('INVMODELO');

       // Definicion de variables de Fechas y Hora
       dcl-s Fecha_ISO date(*iso) ;
       dcl-s Fecha_Juliana date(*jul) ;
       dcl-s Hora_Time time(*hms) ;

       Dcl-S Fecha_Iso_N packed(8:0);
       Dcl-S Hora_N packed(6:0);

       // Indicadores de UI o Pantalla
       dcl-ds Indicadores ;
         dcl-subf LimpiarSubFile ind pos(30) ;
         dcl-subf errorScCantid  ind pos(62) ;
         dcl-subf errorScCodUsr  ind pos(63) ;
         dcl-subf errorScCodEmail ind pos(64) ;
         dcl-subf errorScParte ind pos(35) ;
         dcl-subf errorScCodigo ind pos(36) ;
         dcl-subf errorScMsg01 ind pos(99) ;
       end-ds ;

       dcl-ds Indicador ;
         dcl-subf LimpiarSubfile1 ind pos(30) ;
         dcl-subf errorScCantid1  ind pos(62) ;
         dcl-subf errorScCodUsr1  ind pos(63) ;
         dcl-subf errorScCodEmail1 ind pos(64) ;
       end-ds ;

       // Definicion Prototipo, Seguridad interna
       Dcl-PR INV229 EXTPGM;
          FinDePrograma packed(1:0);
          NomProg char(10);
       End-PR;

       // Definicion Prototipo, Estructura Organizacional
       Dcl-PR INV2283 EXTPGM;
          NoDePantalla packed(2:0);
          FinDePrograma packed(1:0);
          Proceso packed(2:0);
          ConfPorOmision packed(2:0);
          CodCia char(2);
          CodSuc char(2);
          CodBod char(8);
          NomCia char(23);
          NomSuc char(15);
          NomBod char(15);
       End-PR;

       // Definicion Prototipo, Catalogos
       Dcl-PR INV110 EXTPGM;
          CodigoTabla char(2);
          CodigoElemento char(10);
          Estado1 packed(1:0);
          TipoTabla char(1);
       End-PR;

       // Estructura para Posicion del Cursor
       Dcl-ds DspFBK;
         TeclaFuncion char(1) pos(369);
         Screen bindec(4:0) pos(370) ;
         Window bindec(4:0) pos(382);
       End-ds ;

       // Estructura Program Status
       Dcl-ds MyPSDS psds ;
         NombrePrograma char(10) pos(1) ;
         CodigoUsuario char(10) pos(254) ;
         NombreTrabajo char(10) pos(244) ;
         NumeroTrabajo char(6) pos(264) ;
       End-ds ;

       // Prototype for sub-procedure
       Dcl-PR Manejo_de_Mensajes char(10);
          Param1 char(10);
       End-PR;

       // Prototype for sub-procedure
       Dcl-PR Centrado_de_Texto ;
       End-PR;


     D*---------------
     D* Recupera Usuario y Pantalla
     D*---------------
     DLOCALDATA       UDS                  DTAARA(*LDA)
     D  user                   1     10
     D  panta                 11     20
     D*---------------
     D* Define Estructura para Manipular Data
     D*---------------
     D ds_Tabla01_Insertar...
     D                 DS                  Likeds(DSTABLA01)
     D*--------------------------------------------------------------------*

       //--------------------------------------------------------------------*
       //  Instrucciones Principales del Programa  d                         *
       //--------------------------------------------------------------------*

       ExSr Inicio;

       ExSr Seguridad_Interna;

       DoW Not *InLR;
         Select;
         When Proceso = 1;
           ExSr Seleccion_Estructura_Organizacional;
         When Proceso = 2;
           ExSr Encabezado;
         When Proceso = 3;
           ExSr Detalle;
         When Proceso = 4;
           ExSr Confirma_Data_Digitada;
         When Proceso = 5;
           ExSr Graba_Actualiza;
         EndSl;

       EndDo;

       //--------------------------------------------------------------------*
       //  SubRutina de Compa¦ia,Sucursal y Bodega                           *
       //--------------------------------------------------------------------*
       BegSr Seleccion_Estructura_Organizacional;

          FinDePrograma  = 0;
          NoDePantalla   = 2;
          ConfPorOmision = ConfPorOmision + 1;

          CallP INV2283(NoDePantalla:FinDePrograma:Proceso:ConfPorOmision
                         :CodCia:CodSuc:CodBod:NomCia:
                          NomSuc:NomBod);

          If FinDePrograma = 1;
             *InLr = *On;
             Return;
          EndIf;

       EndSr;

       //--------------------------------------------------------------------*
       //  SubRutina de Encabezado de Pedidos de Rutas                       *
       //--------------------------------------------------------------------*
       BegSr ENCABEZADO;

         // Presenta Datos
         Cod_Formato = 'ENCABE' ;
         ExSr Recupera_Teclas_de_Funcion_x_UI;

         // Presenta Datos
         ExFmt Encabe;

         // Inicializar Indicadores y Variables
         HayError     = *Off;
         errorscParte = *Off;
         errorscCodigo= *Off;
         errorscMsg01 = *Off;

         // Evaluacion de Teclas de Funcion
         Select;
         When TeclaFuncion = F3;
            *InLr=*On;
            Return;

         When TeclaFuncion = F4;
            ExSr Ayuda_en_Campos;

         When TeclaFuncion = F12;
            Proceso = 1;

         Other;

            // Validacion de data digitada
            ExSr Validar_Encabezado;

           // Avanza Pantalla
           If HayError = *Off;
              Proceso = 3;
              Write Encabe;
           Else;
              errorscMsg01 = *On;
           EndIf;
         EndSl;

       EndSr;

       //------------------------------------------------------------------*
       // Sub-Rutina de Detalle
       //------------------------------------------------------------------*
       BegSr DETALLE;

        // Inicializa SubFile
        If *In97 = *Off;

          LimpiarSubFile = *On;
          Write SubDe1;

          HayError = *Off;
          LimpiarSubFile = *Off;
          *In31 = *Off;
          *In11 = *On;
          NoRelativo = 0;

          // Llenar Desde una Tabla
          Read  fTabla01;
          DoW Not %Eof() ;

            scCodUsr  = Cod_Usr;
            scCodeMail= Cod_Email;

            // Graba registro en Subfile
            NoRelativo = NoRelativo + 1;
            Write SubDet;
            If %Eof();
              FinSubfile=*On;
            EndIf;

            Read  fTabla01;

          EndDo;

          // Llenar Blancos SubFile :
          DoW FinSubFile = *Off;

             scCodUsr  = ' ';
             scCodeMail= ' ';

            // Graba registro en Subfile
            NoRelativo = NoRelativo + 1;
            Write SubDet;
            If %Eof();
              FinSubfile=*On;
            EndIf;

          EndDo;

          NoRelativo = 1;

        EndIf;

        // Presenta Datos de SubFile
        HayError = *On;
        DoU HayError = *Off;

           // Presenta Interfaz de Usuario
           If NoRelativo > 0;
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

             // Procesa data digitada
             ExSr Procesa_SubArchivo_SubDet;

             // Avanza Pantalla
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
       BegSr Confirma_Data_Digitada;

         // Presenta Interfaz de Usaurio
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

           // Avanza Pantalla
           If xR1 = 'N';
             Proceso = 3;
           EndIf;

           If HayError = *Off And xR1 = 'S';
             Proceso = 5;
           EndIf;
         EndSl;

       ENDSR;

       //------------------------------------------------------------------*
       // SubRutina de Actualizacion de Archivos                           *
       //------------------------------------------------------------------*
       BegSr Graba_ACTUALIZA;

         // Lee SubFile - Valida
         eval NoRelativo = 1;
         Chain NoRelativo SubDet;
         DoW %Found(InvModelFm);

           // Evaluar Codigo de Usuario
           If scCodUsr <> ' ';

             // Mueve Variables de interfaz usuario a estructura
             ds_Tabla01_Insertar.Cod_Usr   = scCodUsr;
             ds_Tabla01_Insertar.Tip_Usr   = scTipUsr;
             ds_Tabla01_Insertar.Cod_eMail = scCodEmail;

             // Invocar Sub-Procedures para Manipular la Data
             If Opc = ' ';
               Estado_ = Eje_Tabla01_Insertar_Codigo_Usuario(ds_Tabla01_Insertar
                                                     :Estado_1) ;
             EndIf;
             If Opc = 'B';
               Estado_ = Eje_Tabla01_Eliminar_Codigo_Usuario(ds_Tabla01_Insertar
                                                     :Estado_1) ;
             EndIf;

             dsply Estado_;
             dsply Estado_1;

             // Estado_
             Select;
             When Estado_ = 'SI' And Estado_1 = 'ENCONTRADO';
               // Actualizar

             When Estado_ = 'SI' And Estado_1 = 'NO ENCONTRADO';
               // Insertar

             EndSl;

           EndIf;

           // Actualiza SubFile
           Update SubDet;

           NoRelativo = NoRelativo + 1;
           Chain NoRelativo SUbDet;
         EndDo;

         // Avanza Pantalla
         If HayError = *Off;
            Proceso = 2;
         EndIf;

       EndSr;

       //------------------------------------------------------------------*
       // SubRutina de Validacion de Encabezado                            *
       //------------------------------------------------------------------*
       BegSr Validar_Encabezado;

           ExSr Manejo_Error_por_Excepciones;

           scMsg01    = ' ';

           // Valida dato, campo Parte
           If scParte = ' ' ;
               errorscParte = *On;
               HayError = *On;

               ID_Mensaje = 'MSG00001';
               Manejo_de_Mensajes(Id_Mensaje);
               scMsg01    = Texto_Centrado;

               LeaveSr;
           Endif;

           // Valida dato, campo Codigo
           If scCodigo = ' ' ;
               errorscCodigo = *On;
               HayError = *On;

               ID_Mensaje = 'MSG00002';
               Manejo_de_Mensajes(Id_Mensaje);
               scMsg01    = Texto_Centrado;

               LeaveSr;
           Endif;

       EndSr;

       //------------------------------------------------------------------*
       // SubRutina de Manejo de Excepciones                               *
       //------------------------------------------------------------------*
       BegSr Manejo_Error_Por_Excepciones;

         // Indice de un Arreglo fuera de Rango
          Monitor;
            indice=1;
            DoW Indice <= 11;
              Arr_Numero(indice) = 1;

              indice = indice + 1;
            EndDo;

            On-Error 00121 ;
            dsply 'Indice no existe en el Arreglo';

          EndMon;

         // División entre cero
          Monitor;
           Resultado = Valor_A / Valor_B ;
          On-Error 0102 ;
            dsply 'El divisor tiene un valor cero';

          EndMon;

       EndSr;

       //------------------------------------------------------------------*
       // SubRutina de Procesamiento de SubArchivo                         *
       //------------------------------------------------------------------*
       BegSr Procesa_SubArchivo_SubDet;

          // Lee SubFile - Valida
          HayError=*Off;
          *In97=*Off;
          eval NoRelativo=1;
          Chain NoRelativo SubDet;
          DoW %Found(InvModelFm);

             *In97 = *On;

             ExSr Validar_Detalle;

            // Actualiza SubFile
             Update SubDet;

            // Si hay Error, guarda No. Relativo
             If HayError = *On;
               NoRelativo_ = NoRelativo;
               Leave;
             EndIf;

             NoRelativo = NoRelativo + 1;
             Chain NoRelativo SUbDet;
          EndDo;

          // Si hay Error, actualiza No. Relativo
          If HayError = *On;
             NoRelativo = NoRelativo_;
          Else;
             NoRelativo = 1;
          EndIf;

       EndSr;

       //------------------------------------------------------------------*
       // SubRutina de Validacion de Detalle                               *
       //------------------------------------------------------------------*
       BegSr Validar_Detalle;

          errorscCodEmail = *Off;

          // Valida datos digitado campo Cantidad
          If scCodEmail = ' '  And scCodUSr <> ' ';
             errorscCodEmail = *On;
             HayError = *On;

             ID_Mensaje = 'MSG00001';
             Manejo_de_Mensajes(Id_Mensaje);

             LeaveSr;
          Endif;

       EndSr;

       //------------------------------------------------------------------*
       // SubRutina para Recuperar Teclas de Funcion por Formato           *
       //------------------------------------------------------------------*
       BegSr Recupera_Teclas_de_Funcion_x_UI;

          Exec Sql
            Select Valores_Valido
            Into  : Valores
            From  INVPRG
            Where  Cod_Sistema =: Id_Sistema And
                   Cod_Programa=: NombrePrograma And
                   Tipo        =: Tipo_Formato   And
                   Cod_Formato =: Cod_Formato ;

          // Centrar Texto
          Longitud = 77;
          Texto_a_Centrar = Valores;
          Centrado_de_Texto();

          scTeclas = Valores ;

          Write Marco;
          Write Parame;

       EndSr;

       //--------------------------------------------------------------------*
       //  SubRutina de Consulta del Registro del Programa                   *
       //--------------------------------------------------------------------*
       BegSr Consulta_Registro_del_Programa;

          Exec Sql
            Select DESCRIPCION_C
            Into  : Valores
            From  INV_PROGRAMAS1
            Where  Cod_Sistema =: Id_Sistema And
                   Cod_Programa=: NombrePrograma ;

          Select;
           When SQLCOD = 0 ;                   // Encontrado
             scId_Prog  = NombrePrograma;

             // Centrar Texto
             Longitud = 40;
             Texto_a_Centrar = Valores;
             Centrado_de_Texto();

             scNom_Prog = Texto_Centrado;
           When SQLCOD <> 0;                   // No Encontrado

          EndSl;

       EndSr;

       //--------------------------------------------------------------------*
       //  SubRutina de Inicio de Programa                                   *
       //--------------------------------------------------------------------*
       BegSr Inicio;

          Proceso = 1;

          Fec         = %dec(%date() : *EUR);
          Fecha_Iso   = %date();
          Hora_Time   = %time();
          Fecha_ISO_N = %Dec(Fecha_Iso);
          Hora_N      = %Dec(Hora_Time);

          // Consulta Registro de Programa
          ExSr Consulta_Registro_del_Programa;

          Write Marco;

       EndSr;

       //--------------------------------------------------------------------*
       //  SubRutina de Seguridad                                            *
       //--------------------------------------------------------------------*
       BegSr Seguridad_Interna;

          Eval FindePrograma=0;

          CallP INV229(FinDePrograma:NomProg);

          If FinDePrograma=1;
             *InLr = *On;
            Return;
          EndIf;

       EndSr;

      //--------------------------------------------------------------------*
      //  Sub-Rutina de Ayudas                                              *
      //--------------------------------------------------------------------*
       BegSr Ayuda_en_Campos;

          //  Posicion de Cursor
          ExSr Manejo_Posicion_de_Cursor;

          //  Ayuda de Tablas
          If Fila = 7;
             xCodigoTabla = '1N';
             CallP INV110(xCodigoTabla:xCodigoElemento:xEstado1:xTipoTabla);

             scCodigo = xCodigoElemento;

             If FinDePrograma=1;
               *InLr = *On;
               Return;
             EndIf;
          EndIf;

          Write Marco;
          Write Parame;
          Write Encabe;

       ENDSR;

      //-------------------------------------------------------------------*
      // SubRutina de Identificacion de Posicion del Cursor                *
      //-------------------------------------------------------------------*
       BegSr Manejo_Posicion_de_Cursor;

          If SCREEN <> 0 ;
            Fila_     = %Div(Screen:256) ;
            Columna_  = %Rem(Screen:256) ;
          Else;
          EndIf;

          Fila  = Fila_ ;
          Colu  = Columna_ ;

       EndSr;


      // Sub-Procedure de Manejo de Id de Mensajes de Aplicacion           *
      //-------------------------------------------------------------------*
       // Defined a sub-procedure
       Dcl-Proc Manejo_de_Mensajes;

          // Defined sub-procedure Inteface
          Dcl-PI *n char(10);
             Id_Mensaje char(10);
          End-PI;

          Dcl-S result char(10);

          Exec Sql
            Select DESCRIPCION_L
            Into  : Valores
            From  INV_PROGRAMAS2
            Where  Cod_Sistema =: Id_Sistema And
                   Cod_Mensaje =: Id_Mensaje ;

          Select;
           When SQLCOD = 0 ;                   // Encontrado
             // Centrar Texto
             Longitud = 77;
             Texto_a_Centrar = Valores;
             Centrado_de_Texto();

             Result ='Encontrado ' ;
           When SQLCOD <> 0;                   // No Encontrado

             Result ='NO Encontrado ' ;
          EndSl;

          Return result;

       End-Proc;

       //--------------------------------------------------------------------*
       //  Sub-Procedure de Centrado de Texto                                *
       //--------------------------------------------------------------------*
       Dcl-Proc Centrado_de_Texto;

         Clear Texto_Centrado;

         If Texto_A_Centrar <> ' ';
            idx1 = %CheckR(' ' :Texto_a_Centrar);
            idx2 = ((Longitud - idx1) / 2) + 1;
            If idx2 > 0 And idx1 > 0;
              %Subst(Texto_Centrado :idx2 :idx1) =
                                          %Subst(Texto_a_Centrar :1 :idx1);
            Else;
              Texto_Centrado = Texto_a_Centrar;
            EndIf;
         EndIf;
       End-Proc;

