         ctl-opt option(*srcstmt:*nodebugio:*nounref) dftactgrp(*no);
         ctl-opt ccsid(*ucs2:13488) ccsid(*char:*jobrun) alwnull(*usrctl);
     H* PGMINFO(*PCML *All)
     H* INFOSTMF('/home/javier/WS_02.pcml')
     D*---------------
     D* Definicion de Parametros
     D*---------------
     DParametros       PR                  EXTPGM('WS_02  ')
     D Parametro1                     6a
     D Resultado                     30a
     D*
     DParametros       PI
     D Parametro1                     6a
     D Resultado                     30a
     D
       //------------------------------------------------------------------*
       //    Instrucciones Principales del Programa                        *
       //------------------------------------------------------------------*

        ExSr Inicio ;

        Return ;

       //------------------------------------------------------------------*
       //  Sub Rutina de Inicio del Programa                               *
       //------------------------------------------------------------------*
       BegSr Inicio;

         Resultado ='Repuesta, conectado al WS en server IWS';


       EndSR;


