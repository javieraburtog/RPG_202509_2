      *------------------------------------------------------------------------*
      * Sistema....: Informacion de Casa Pellas
      * Modulo.....:
      * Archivo....: WS_CONS_02
      * Objetivo...: Consumir un web services
      * Fecha......: Viernes 17 de Septiembre del 2021
      * Programo...: Javier Aburto
      * Modificado.:
      *------------------------------------------------------------------------*
       ctl-opt option(*srcstmt:*nounref) dftactgrp(*no);
       ctl-opt BNDDIR('HTTPAPI') ;


       /copy httpapi_h

       dcl-c BASEURL 'http://192.168.1.3:10084/web/services/WS_02Service/WS_02';
       dcl-s xmlData varchar(100000);

       dcl-s param1  varchar(6);

       dcl-s UrlHost       varchar(200);
       dcl-s UrlEndPoint   varchar(200);
       dcl-s PostUrl       varchar(254);
       dcl-s PostData      varchar(32000) ;

       dcl-s Result      varchar(32000) ;
       dcl-s errorMsg char(256);

       dcl-s Resultado    char(20) ;

       // Output data
       dcl-ds xmlout qualified;
            Resultout char(20);
       END-DS;


      // xmlData = http_string( 'GET' : BASEURL );

      //xml-into Resultado %xml(xmlData:'case=convert countprefix=num_');

        PostData=set_Data_Xml(param1);

        monitor;
          Result = http_string( 'GET': BaseUrl: PostData: 'text/xml');
          Dsply 'Entro sin problema';
        on-error;
          ErrorMsg=http_error();
          Dsply 'Hay Errores - Invocando WS ';
        endmon;

      // Parse output
        monitor;
          xml-into xmlout %xml(Result: 'case=any ns=remove +
             path=Envelope/Body/parametrosResponse/return/RESULTADO');
        on-error;
          Dsply 'Hay Errores en Convert XML';
        endmon;


        Resultado = xmlout.ResultOut;

        Dsply resultado;


       *inlr = *on;


       //-------------------------------------------------------
        // Set Postdata ... SOAP Envelope
        //-------------------------------------------------------
        dcl-proc set_Data_Xml;
        dcl-pi   set_Data_Xml varchar(32000);
          param_1  varchar(6) const;
        end-pi;

        dcl-s PostData varchar(32000);

        PostData=' '
        +'<soapenv:Envelope'
        +' xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/"'
        +' xmlns:ws="http://ws_02.wsbeans.iseries/">'
        +' <soapenv:Header/>'
        +'    <soapenv:Body>'
        +'      <ws:parametros>'
        +'         <arg0>'
        +'            <PARAMETRO1>$$param_1</PARAMETRO1>'
        +'         </arg0>'
        +'      </ws:parametros>'
        +'   </soapenv:Body>'
        +'</soapenv:Envelope>';

        // Set input temperature;
        PostData = %scanrpl('$$param_1' :%trim(param_1) : PostData);

        return PostData;
       end-proc;





