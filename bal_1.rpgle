     D Cod_Compania    s              2a
     D Cod_Sucursal    s              2a
     D Cod_Bodega      s              8a
     D Cod_Tipo_Documento...
     D                 s              2a
     D No_Documento    s              7  0
     D Estado          s              2a
     D*---------------
     D* Definicion de Parametros , sssssssssss
     D*---------------
     DINV721           PR                  EXTPGM('INV721')
     D Cod_Compania                   2a
     D Cod_Sucursal                   2a
     D Cod_Bodega                     8a
     D Cod_Tipo_Documento...
     D                                2a
     D No_Documento                   7  0
     D Estado                         2a
     D*

      //declare variable for prices and costs using free format

      dcl-s Price         packed(7:2);
      dcl-s Cost          packed(7:2);


       Dsply ('Cod_Compania') ' ' Cod_Compania;
       Dsply ('Cod_Sucursal') ' ' Cod_Sucursal;
       Dsply ('Cod_BODEGA ')  ' ' Cod_Bodega;
       Dsply ('Cod_Tipo_Movimiento')  ' ' Cod_Tipo_Documento;
       Dsply ('No_Documento')  ' ' No_Documento;
       Dsply ('Estado      ')    ' ' Estado;


       CallP INV721(Cod_Compania:Cod_Sucursal:Cod_Bodega
                   :Cod_Tipo_Documento
                   :No_Documento   :  ESTADO        )   ;


       *InLr = *On;

