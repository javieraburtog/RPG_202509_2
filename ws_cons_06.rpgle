      *------------------------------------------------------------------------*
      *
      *
      *
      *
      *
      *
      *
      *
      *
      *
      *
      *
      *
      *
      *
      * Sistema....: Informacion de Casa Pellas
      * Modulo.....:
      * Archivo....: WS_CONS_06
      * Objetivo...: Consumir un web services publicado en INTERNET
      * Fecha......: Jueves 07 Octubre del 2021
      * Programo...: Javier Aburto
      * Modificado.:
      *------------------------------------------------------------------------*
     H DFTACTGRP(*NO) BNDDIR('HTTPAPI')

     D WS_CONS_06      PR
     D fahrenheit                    15p 5 const
     D WS_CONS_06      PI
     D fahrenheit                    15p 5 const

       /copy httpapi_h

     D URL             s            100a   varying
     D SOAP            s           1000A   varying
     D RESULTADO       s              4A

       dcl-s codigo1 packed(8:0) inz(13641);

       dcl-s Response    varchar(32000) ;

        // Output data
       dcl-ds xmlout qualified;

             resultado varchar(20);

        end-ds;

       http_debug(*ON);

       Url =
        'http://192.168.35.150:9080/ejemplo_ws_soap1/PersonServiceImplService';

       http_setOption('SoapAction': '""');

       SOAP = '+
        <soapenv:Envelope +
          xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" +
          xmlns:pac="http://package1/"> +
          <soapenv:Header/>+
            <soapenv:Body>+
             <pac:getNames>+
                <arg0>' + %char(codigo1) + '</arg0>+
             </pac:getNames>+
          </soapenv:Body>+
        </soapenv:Envelope>';

       response = http_string( 'POST': URL: SOAP: 'text/xml');


       xml-into xmlout %xml(response: 'case=convert ns=remove +
               path=Envelope/Body/getNamesResponse');

       dsply   'WS Publicado en Server WAS Local' ;
       dsply   (xmlout.resultado);


       *inlr = *on;








