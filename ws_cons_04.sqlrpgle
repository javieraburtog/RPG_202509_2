      *------------------------------------------------------------------------*
      * Sistema....: Informacion de Casa Pellas
      * Modulo.....:
      * Archivo....: WS_CONS_04
      * Objetivo...: Consumir un web services
      * Fecha......: Miercoles 6 de Octubre del 2021
      * Programo...: Javier Aburto
      * Modificado.:
      *------------------------------------------------------------------------*
       ctl-opt option(*srcstmt:*nounref) dftactgrp(*no);
       ctl-opt BNDDIR('HTTPAPI') ;

       // Entry plist
        dcl-pi WS_CONS_04;
           TempinAlfa char(15);
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
        dcl-s tempin packed(7:2);

        // Output data
        dcl-ds xmlout qualified;
             Tempout packed(7:2);
        END-DS;


        // Legge input
        monitor;
           tempin=%dec(tempinAlfa:7:2);
        on-error;
           tempin=40;
        ENDMON;
        dsply ('Introduzca grados temperatura') ' '  tempin ;

        UrlHost       ='http://192.168.1.3:10084/';
        UrlEndPoint='/web/services/ConvertTempService/ConvertTemp';

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
             path=Envelope/Body/converttempResponse/return');
        on-error;
        endmon;


        string='Tempin:'+%editc(tempin:'K');
        dsply string;
        string='Tempout:'+%editc(xmlout.tempout:'K');
        dsply string ;
        Dsply ( 'Press <Enter> to end program' ) ' ' reply;

        *inlr = *on ;


       //-------------------------------------------------------
        // Set Postdata ... SOAP Envelope
        //-------------------------------------------------------
        dcl-proc set_PostDataConvertTemp;
        dcl-pi   set_PostDataConvertTemp varchar(32000);
          TempF   packed(7:2) const;
        end-pi;
        dcl-s PostData varchar(32000);

        PostData=' '
        +'<soapenv:Envelope'
        +' xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/"'
        +' xmlns:con="http://converttemp.wsbeans.iseries/">'
        +' <soapenv:Header/>'
        +'    <soapenv:Body>'
        +'      <con:converttemp>'
        +'         <arg0>'
        +'            <TEMPIN>$$TEMPF</TEMPIN>'
        +'         </arg0>'
        +'      </con:converttemp>'
        +'   </soapenv:Body>'
        +'</soapenv:Envelope>';

        // Set input temperature;
        PostData=%scanrpl('$$TEMPF':%editc(Tempf:'K'):PostData);

        return PostData;
       end-proc;



