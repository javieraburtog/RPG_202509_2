         ctl-opt ccsid(*ucs2:13488) ccsid(*char:*jobrun) alwnull(*usrctl);
     H* PGMINFO(*PCML *All)
     H* INFOSTMF('/home/inventario/WS_PRUE01.pcml')

      /Copy *Libl/QMODELO,INVMODELOP

     D Estado_R        S              2a
     D*---------------
     D* Define Estructura para Manipular Data
     D*---------------
     D ds_Tabla01_Insertar...
     D                 DS                  Likeds(DSTABLA01)
     D*---------------
     D* Definicion de Parametros
     D*---------------
     DWS_PRUE01        PR                  EXTPGM('WS_PRUE01')
     D Cod_Usuario                   10a
     D Tipo_Usuario                   3a
     D eMail                         15a
     D Estado                        15a
     DWS_PRUE01        PI
     D Cod_Usuario                   10a
     D Tipo_Usuario                   3a
     D eMail                         15a
     D Estado                        15a
     D*

           // Mueve Variables de interfaz usuario a estructura
           ds_Tabla01_Insertar.Cod_Usr   = Cod_USuario;
           ds_Tabla01_Insertar.Tip_Usr   = Tipo_Usuario;
           ds_Tabla01_Insertar.Cod_eMail = eMail;

          // Invocar Sub-Procedures para Manipular la Data
         Estado_R = Eje_Tabla01_Insertar_Codigo_Usuario(ds_Tabla01_Insertar
                                                         :Estado) ;

       *InLr = *On;

