*eject
*--------------------------------------------------------------------*
*        COMMON DATA                                                 *
*--------------------------------------------------------------------*
*        Selektionsbedingungen f�r Listanzeigen zum Material         *
*--------------------------------------------------------------------*

DATA:    BEGIN OF COMMON PART FM06LCS3.

SELECT-OPTIONS: S_WERKS FOR EKPO-WERKS MEMORY ID WRK.

DATA:    END OF COMMON PART.
