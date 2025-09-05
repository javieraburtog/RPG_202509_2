         ctl-opt option(*srcstmt:*nodebugio:*nounref) dftactgrp(*no);
         ctl-opt ccsid(*ucs2:13488) ccsid(*char:*jobrun) alwnull(*usrctl);
     H* PGMINFO(*PCML *All)
     H* INFOSTMF('/home/javier/WS01.pcml')
     D*---------------
     D* Definicion de Parametros
     D*---------------
     DParametros       PR                  EXTPGM('WS_01  ')
     D Parametro1                     7  0
     D Resultado                      4a
     D*
     DParametros       PI
     D No_Documento                   7  0
     D Resultado                      4a
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

         Resultado ='101';


       EndSR;


