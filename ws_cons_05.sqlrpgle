      *------------------------------------------------------------------------*
      * Sistema....: Informacion de Casa Pellas
      * Modulo.....:
      * Archivo....: WS_CONS_05
      * Objetivo...: Consumir un web services publica en server Power i
      * Fecha......: Miercoles 6 de Octubre del 2021
      * Programo...: Javier Aburto
      * Modificado.:
      *------------------------------------------------------------------------*
       ctl-opt option(*srcstmt:*nounref) dftactgrp(*no);
       ctl-opt BNDDIR('HTTPAPI') ;

       // Entry plist
        dcl-pi WS_CONS_05;
           TempinAlfa char(6);
        END-PI;

       /copy httpapi_h

        dcl-s UrlHost       varchar(200);
        dcl-s UrlEndPoint   varchar(200);
        dcl-s PostUrl       varchar(254);
        dcl-s PostData      varchar(32000) ;
        dcl-s PostResult    varchar(32000) ;
        dcl-s string char(30);
        dcl-s reply  char(10);
        dcl-s errorMsg char(256);

        // Input data
        dcl-s tempin char(6);

        // Output data
        dcl-ds xmlout qualified;
             RESULTADO char(30);
        END-DS;


        // Legge input
        monitor;
           tempin = tempinAlfa;
        on-error;
           tempin='PAR1';
           dsply ('Introduzca  Parametro') ' '  tempin ;
        ENDMON;

        UrlHost       ='http://192.168.1.3:10084/';
        UrlEndPoint='/web/services/WS_02Service/WS_02';

        PostUrl=%trim(UrlHost)+%trim(UrlEndPoint);
        PostData=set_PostdataConvertTemp(Tempin);
        //PostHeader=get_PostHeader(%len(%trim(PostData)):'text/xml');

        // Call the SOAP web service
        // http_setOption('SoapAction': '"GetConversionRate"');
        clear errorMsg;
        clear xmlout;

        monitor;
          PostResult = http_string( 'POST': PostURL: PostData: 'text/xml');
        on-error;
          ErrorMsg=http_error();
          PostResult='<Result>Error</Result>';
        endmon;


       // Parse output
        monitor;
          xml-into xmlout %xml(postResult: 'case=any ns=remove +
             path=Envelope/Body/parametrosResponse/return');
        on-error;
        endmon;


        string = 'Tempin:' + tempin;
        dsply string;
        string = 'Tempout:' + (xmlout.RESULTADO);
        dsply string ;
        Dsply ( 'Press <Enter> to end program' ) ' ' reply;

        *inlr = *on ;


       //-------------------------------------------------------
        // Set Postdata ... SOAP Envelope
        //-------------------------------------------------------
        dcl-proc set_PostDataConvertTemp;
        dcl-pi   set_PostDataConvertTemp varchar(32000);
          TempF   char(6) const;
        end-pi;
        dcl-s PostData varchar(32000);

        PostData=' '
        +'<soapenv:Envelope'
        +' xmlns:soapenv="http://www.w3.org/2003/05/soap-envelope"'
        +' xmlns:ws="http://ws_02.wsbeans.iseries/">'
        +' <soapenv:Header/>'
        +'    <soapenv:Body>'
        +'      <ws:parametros>'
        +'         <arg0>'
        +'            <PARAMETRO1>$$TEMPF</PARAMETRO1>'
        +'         </arg0>'
        +'      </ws:parametros>'
        +'   </soapenv:Body>'
        +'</soapenv:Envelope>';

        // Set input temperature;
        PostData = %scanrpl('$$TEMPF' : Tempf : PostData);

        return PostData;
       end-proc;



