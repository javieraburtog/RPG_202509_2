     D Cod_Usuario     s             10a
     D Tipo_Usuario    s              3a
     D eMail           s             15a
     D Estado          s             15a
     D*---------------
     D* Definicion de Parametros
     D*---------------
     DWS_PRUE01        PR                  EXTPGM('WS_PRUE01')
     D Cod_Usuario                   10a
     D Tipo_Usuario                   3a
     D eMail                         15a
     D Estado                        15a
     D*

       //Dsply ('Cod_Usuario') ' ' Cod_Usuario;
       //Dsply ('Tipo_Usuario') ' ' Tipo_Usuario;
       //Dsply ('eMail ')  ' ' eMail;
       //Dsply ('Estado      ')    ' ' Estado;


       CallP WS_PRUE01(Cod_Usuario:Tipo_Usuario:eMail
                   :Estado  ) ;

       *InLr = *On;

