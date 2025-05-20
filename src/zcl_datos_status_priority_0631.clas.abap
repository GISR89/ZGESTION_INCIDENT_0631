CLASS zcl_datos_status_priority_0631 DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.

   INTERFACES if_oo_adt_classrun.

  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.

CLASS zcl_datos_status_priority_0631 IMPLEMENTATION.
  METHOD if_oo_adt_classrun~main.

    DELETE FROM zdt_status_0631.
    DELETE FROM zdt_priority_631.

* data status
    INSERT zdt_status_0631 FROM TABLE @( VALUE #( ( status_code = 'OP'
                                                    status_description = 'Open' )
                                                  ( status_code = 'IP'
                                                    status_description = 'In Progress' )
                                                  ( status_code = 'PE'
                                                    status_description = 'Pending' )
                                                  ( status_code = 'CO'
                                                    status_description = 'Completed' )
                                                  ( status_code = 'CL'
                                                    status_description = 'Closed' )
                                                  ( status_code = 'CN'
                                                    status_description = 'Canceled' ) ) ).
    IF sy-subrc EQ 0.
      out->write( |{ sy-dbcnt } Estados| ).
    ENDIF.

* data priority
    INSERT zdt_priority_631 FROM TABLE @( VALUE #( ( priority_code = 'H'
                                                     priority_description = 'High' )
                                                   ( priority_code = 'M'
                                                     priority_description = 'Medium' )
                                                   ( priority_code = 'L'
                                                     priority_description = 'Low' ) ) ).
    IF sy-subrc EQ 0.
      out->write( |{ sy-dbcnt } Prioridades| ).
    ENDIF.


  ENDMETHOD.

ENDCLASS.
