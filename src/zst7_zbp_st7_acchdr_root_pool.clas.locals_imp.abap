*"* use this source file for the definition and implementation of
*"* local helper classes, interface definitions and type
*"* declarations
CLASS lc_accounting_doc DEFINITION INHERITING FROM cl_abap_behavior_handler.

  PRIVATE SECTION.

    METHODS copyaccdochdr FOR MODIFY
      IMPORTING keys FOR ACTION accountingheader~copyaccdochdr RESULT result.

    METHODS validatedoctype FOR VALIDATE ON SAVE
      IMPORTING keys FOR accountingheader~validatedoctype.

ENDCLASS.


CLASS lc_accounting_doc IMPLEMENTATION.

  METHOD copyaccdochdr.

* Reading the values in the current instance using EML (entity manipulation language) syntax
    READ ENTITIES OF zst7_acchdr_root_pool IN LOCAL MODE
    ENTITY accountingheader
    ALL FIELDS WITH CORRESPONDING #( keys )
    RESULT DATA(lt_acchdr).

** Selecting the line items
*    SELECT * FROM zst7accitm_tb
*    INTO TABLE @DATA(lt_accitm)
*    FOR ALL ENTRIES IN @lt_acchdr
*    WHERE bukrs = @lt_acchdr-bukrs
*      AND belnr = @lt_acchdr-belnr
*      AND gjahr = @lt_acchdr-gjahr.

* First select the next document number in sequence
    READ TABLE lt_acchdr INTO DATA(ls_acchdr) INDEX 1.
    IF sy-subrc = 0.

      SELECT SINGLE * FROM zst7acchdr_tb
          INTO @DATA(ls_acchdr_tb)
          WHERE bukrs = @ls_acchdr-bukrs
            AND belnr = @ls_acchdr-belnr
            AND gjahr = @ls_acchdr-gjahr.

      IF sy-subrc = 0.
*        SORT lt_acchdr_tb DESCENDING BY bukrs belnr gjahr.
*        READ TABLE lt_acchdr_tb INTO DATA(ls_acchdr_t) INDEX 1.
        IF ls_acchdr-gjahr EQ sy-datum+0(4).
          ls_acchdr-belnr = ls_acchdr-belnr + 1.
          ls_acchdr-gjahr = sy-datum+0(4).
          CONCATENATE sy-datum+6(2) '-' sy-datum+4(2) '-' sy-datum+0(4) INTO ls_acchdr-bldat.
          ls_acchdr-usnam = sy-uname.
          ls_acchdr-cpudt = sy-datum.
          ls_acchdr-cputm = sy-uzeit.
        ELSE.
          ls_acchdr-gjahr = sy-datum+0(4).
          CONCATENATE sy-datum+0(4) sy-datum+4(2) sy-datum+6(2) INTO ls_acchdr-bldat.
          ls_acchdr-usnam = sy-uname.
          ls_acchdr-cpudt = sy-datum.
          ls_acchdr-cputm = sy-uzeit.
        ENDIF.

*       Updating the header details in the internal table that is to be displayed
        MODIFY TABLE lt_acchdr FROM ls_acchdr.
      ENDIF.

    ENDIF.

* Modify and create the new entry
    MODIFY ENTITIES OF zst7_acchdr_root_pool
    IN LOCAL MODE
    ENTITY accountingheader
    CREATE FIELDS ( bukrs belnr gjahr blart bldat cpudt cputm usnam bktxt tcode xblnr )
    WITH CORRESPONDING #( lt_acchdr )
    MAPPED DATA(copied_data).


* Send back the updated result to the results page
* INDEX INTO works as a loop count. So lv_idx will read each line item
*    result = VALUE #( FOR ls_create IN lt_acchdr INDEX INTO lv_idx
*                      ( %cid_ref = keys[ lv_idx ]-%cid_ref
*                        %key-bukrs = ls_acchdr-bukrs "keys[ lv_idx ]-bukrs
*                        %key-belnr = ls_acchdr-belnr "keys[ lv_idx ]-belnr
*                        %key-gjahr = ls_acchdr-gjahr  "keys[ lv_idx ]-gjahr
*                        %param = CORRESPONDING #( ls_create )
*                      )
*                    ).


    DATA: acchdr     TYPE TABLE FOR CREATE zst7_acchdr_root_pool,
          accitem    TYPE TABLE FOR CREATE zst7_acchdr_root_pool\_items,
          accitem_wa LIKE LINE OF accitem,
          lt_accitem LIKE accitem_wa-%target,
          ls_accitem LIKE LINE OF lt_accitem.

    MOVE-CORRESPONDING lt_acchdr TO acchdr.

* Copying the line items now
* Reading the values in the current instance using EML (entity manipulation language) syntax
    READ ENTITIES OF zst7_acchdr_root_pool IN LOCAL MODE
    ENTITY accountingheader BY \_items
    ALL FIELDS WITH CORRESPONDING #( keys )
    RESULT DATA(lt_accitm).

    LOOP AT lt_accitm INTO DATA(ls_accitm).
      ls_accitem-gjahr = sy-datum+0(4).

      IF ls_accitm-gjahr EQ sy-datum+0(4).
        ls_accitem = VALUE #( %cid = ''
                              bukrs = ls_accitm-bukrs
                              belnr = ls_accitm-belnr + 1
                              gjahr = sy-datum+0(4)
                              buzei = ls_accitm-buzei
                              bschl = ls_accitm-bschl
                              koart = ls_accitm-koart
                              shkzg = ls_accitm-shkzg
                              gsber = ls_accitm-gsber
                              mwskz = ls_accitm-mwskz
                              dmbtr = ls_accitm-dmbtr
                              mwsts = ls_accitm-mwsts
                              waers = ls_accitm-waers
                              kostl = ls_accitm-kostl
                              lifnr = ls_accitm-lifnr
                              chgdttime = ls_accitm-chgdttime
                              locdttime = ls_accitm-locdttime
                            ).
        APPEND ls_accitem TO lt_accitem.
      ELSE.
        ls_accitem = VALUE #( %cid = ''
                      bukrs = ls_accitm-bukrs
                      belnr = ls_accitm-belnr
                      gjahr = sy-datum+0(4)
                      buzei = ls_accitm-buzei
                      bschl = ls_accitm-bschl
                      koart = ls_accitm-koart
                      shkzg = ls_accitm-shkzg
                      gsber = ls_accitm-gsber
                      mwskz = ls_accitm-mwskz
                      dmbtr = ls_accitm-dmbtr
                      mwsts = ls_accitm-mwsts
                      waers = ls_accitm-waers
                      kostl = ls_accitm-kostl
                      lifnr = ls_accitm-lifnr
                      chgdttime = ls_accitm-chgdttime
                      locdttime = ls_accitm-locdttime
                    ).
        APPEND ls_accitem TO lt_accitem.
      ENDIF.

    ENDLOOP.

    accitem_wa = VALUE #( %cid_ref = ''
                          bukrs = ls_accitem-bukrs
                          belnr = ls_accitem-belnr
                          gjahr = ls_accitem-gjahr
                          %target = lt_accitem
                        ).
    APPEND accitem_wa TO accitem.

*call FUNCTION 'NUMBER_GET_NEXT'
*EXPORTING


* This statement will create the copied header & line items
    MODIFY ENTITIES OF zst7_acchdr_root_pool IN LOCAL MODE
    ENTITY accountingheader
*//    CREATE FROM acchdr
* The header details under the AccountingHeader from acchdr will be copied
    CREATE FIELDS ( bukrs belnr gjahr blart bldat cpudt cputm usnam bktxt tcode xblnr createddt_time changeddt_time lastchngdttm )
    WITH acchdr
* The \items points to the items under the AccountingHeader will be copied
*//    CREATE BY \_items FROM accitem
    CREATE BY \_items FIELDS ( bukrs belnr gjahr buzei bschl koart shkzg gsber mwskz dmbtr mwsts waers kostl lifnr chgdttime locdttime )
    WITH accitem
* IF copied_line_items, failed_data & reported_data are all blank, then the record was
* successfully created else you will see some error message in there
    MAPPED DATA(copied_line_items)
    FAILED DATA(failed_data)
    REPORTED DATA(reported_data).


  ENDMETHOD.


  METHOD validatedoctype.

* Reading the values in the current instance using EML (entity manipulation language) syntax
    READ ENTITIES OF zst7_acchdr_root_pool IN LOCAL MODE
    ENTITY accountingheader
    ALL FIELDS WITH CORRESPONDING #( keys )
    RESULT DATA(lt_acchdr).

    READ TABLE lt_acchdr INTO DATA(ls_acchdr) INDEX 1.
    IF sy-subrc EQ 0.
* Custom message
* Statement to collect the error
      ls_acchdr-%tky-bukrs = '1710'.
      APPEND VALUE #( %tky = ls_acchdr-%tky ) TO failed-accountingheader.

* if_abap_behv_message is a message constant that can be used
* Preparing the message object which contains the message details ( text & type of message )
* If document type is not filled
      IF ls_acchdr-blart IS INITIAL.
        APPEND VALUE #( %tky-bukrs = keys[ 1 ]-bukrs "ls_acchdr-blart
                        %tky-belnr = keys[ 1 ]-belnr
                        %tky-gjahr = keys[ 1 ]-gjahr
                        %msg = new_message(
                               id = 'ZST7_MESSAGES'
                               number = '001'
                               severity = if_abap_behv_message=>severity-error
                               v1 = ls_acchdr-blart
                            )
                        )
                      TO reported-accountingheader.


      ELSEIF ls_acchdr-bldat IS INITIAL.
        APPEND VALUE #( %tky-bukrs = keys[ 1 ]-bukrs
                        %tky-belnr = keys[ 1 ]-belnr
                        %tky-gjahr = keys[ 1 ]-gjahr
                        %msg = new_message(
                               id = 'ZST7_MESSAGES'
                               number = '002'
                               severity = if_abap_behv_message=>severity-error
                               v1 = ls_acchdr-bldat
                            )

                      ) TO reported-accountingheader.

      ELSEIF ls_acchdr-tcode IS INITIAL.
        APPEND VALUE #( %tky-bukrs = keys[ 1 ]-bukrs
                        %tky-belnr = keys[ 1 ]-belnr
                        %tky-gjahr = keys[ 1 ]-gjahr
                        %msg = new_message(
                               id = 'ZST7_MESSAGES'
                               number = '004'
                               severity = if_abap_behv_message=>severity-error
                               v1 = ls_acchdr-tcode
                            )

                        ) TO reported-accountingheader.

      ELSEIF ls_acchdr-xblnr IS INITIAL.
        APPEND VALUE #( %tky-bukrs = keys[ 1 ]-bukrs
                        %tky-belnr = keys[ 1 ]-belnr
                        %tky-gjahr = keys[ 1 ]-gjahr
                        %msg = new_message(
                               id = 'ZST7_MESSAGES'
                               number = '005'
                               severity = if_abap_behv_message=>severity-error
                               v1 = ls_acchdr-xblnr
                           )
                       ) TO reported-accountingheader.

      ENDIF.


    ENDIF.

  ENDMETHOD.


ENDCLASS.
