      *------------------------------------------------------------------------*
      * Sistema....: Informacion de Casa Pellas
      * Modulo.....: Sistema de Inventarios CP
      * Archivo....: INVMODELOP
      * Objetivo...: Consumir un web services
      * Fecha......: Viernes 17 de Septiembre del 2021
      * Programo...: Javier Aburto
      * Modificado.:
      *------------------------------------------------------------------------*
     H DFTACTGRP(*NO) BNDDIR('HTTPAPI')

     D WS_CONS_02      PR
     D fahrenheit                    15p 5 const
     D WS_CONS_02      PI
     D fahrenheit                    15p 5 const

       /copy httpapi_h

     D URL             s            100a   varying
     D SOAP            s           1000A   varying
     D RESULTADO       s              4A

       dcl-s Response    varchar(32000) ;

        // Output data
       dcl-ds xmlout qualified;
             RESULTADO char(30);
        END-DS;

       http_debug(*ON);

       URL = 'http://192.168.1.3:10084/web/services/WS_02Service/WS_02';
       http_setOption('SoapAction': '""');

       SOAP = '+
        <soapenv:Envelope +
          xmlns:soapenv="http://www.w3.org/2003/05/soap-envelope" +
          xmlns:ws="http://ws_02.wsbeans.iseries/">+
          <soapenv:Header/>+
          <soapenv:Body>+
            <ws:parametros>+
             <arg0>+
               <PARAMETRO1>' + %char(%inth(fahrenheit)) + '</PARAMETRO1>+
             </arg0>+
            </ws:parametros>+
          </soapenv:Body>+
        </soapenv:Envelope>';

       response = http_string( 'POST': URL: SOAP: 'text/xml');

       xml-into xmlout %xml(response: 'case=convert ns=remove +
               path=Envelope/Body/parametrosResponse+
               /return');

        dsply   'Respuesta de WS publicado en Power i ' ;
        dsply   (xmlout.RESULTADO);


       *inlr = *on;








