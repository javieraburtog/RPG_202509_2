PGM
             DCL        VAR(&USER) TYPE(*CHAR) LEN(10)
             DCL        VAR(&TRAB) TYPE(*CHAR) LEN(10)

             RTVJOBA    JOB(&TRAB) USER(&USER)
             CHGDTAARA  DTAARA(*LDA (1 10)) VALUE(&USER)
             CHGDTAARA  DTAARA(*LDA (11 10)) VALUE(&TRAB)

             CALL       PGM(INVMODELO)

ENDPGM
