CLASS lhc_Incidents DEFINITION INHERITING FROM cl_abap_behavior_handler.

  PRIVATE SECTION.

    CONSTANTS: BEGIN OF lc_status,
                 open        TYPE zde_status_0631 VALUE 'OP',
                 in_progress TYPE zde_status_0631 VALUE 'IP',
                 pending     TYPE zde_status_0631 VALUE 'PE',
                 completed   TYPE zde_status_0631 VALUE 'CO',
                 closed      TYPE zde_status_0631 VALUE 'CL',
                 canceled    TYPE zde_status_0631 VALUE 'CN',
               END OF lc_status.

    METHODS get_instance_features FOR INSTANCE FEATURES
      IMPORTING keys REQUEST requested_features FOR Incidents RESULT result.

    METHODS get_instance_authorizations FOR INSTANCE AUTHORIZATION
      IMPORTING keys REQUEST requested_authorizations FOR Incidents RESULT result.

    METHODS get_global_authorizations FOR GLOBAL AUTHORIZATION
      IMPORTING REQUEST requested_authorizations FOR Incidents RESULT result.

    METHODS ChangeStatus FOR MODIFY
      IMPORTING keys FOR ACTION Incidents~ChangeStatus RESULT result.

    METHODS setHistory FOR MODIFY
      IMPORTING keys FOR ACTION Incidents~setHistory.

    METHODS SetIncidentNumber FOR DETERMINE ON MODIFY
      IMPORTING keys FOR Incidents~SetIncidentNumber.

    METHODS setStatusToOpen FOR DETERMINE ON SAVE
      IMPORTING keys FOR Incidents~setStatusToOpen.

    METHODS get_history_index EXPORTING ev_incuuid      TYPE sysuuid_x16
                              RETURNING VALUE(rv_index) TYPE zde_his_id_0631.


ENDCLASS.

CLASS lhc_Incidents IMPLEMENTATION.

  METHOD get_instance_features.

    DATA lv_history_index TYPE zde_his_id_0631.

    READ ENTITIES OF Z_r_DT_INCT_0631 IN LOCAL MODE
     ENTITY Incidents
       FIELDS ( Status )
       WITH CORRESPONDING #( keys )
     RESULT DATA(incidents)
     FAILED failed.

    "Para un incidente con estatus Canceled (CN), Completed (CO) o Closed (CL), ya no es posible cambiar el estatus.
    DATA(lv_create_action) = lines( incidents ).
    IF lv_create_action EQ 1.
      lv_history_index = get_history_index( IMPORTING ev_incuuid = incidents[ 1 ]-IncUUID ).
    ELSE.
      lv_history_index = 1.
    ENDIF.

    result = VALUE #( FOR incident IN incidents
                          ( %tky                   = incident-%tky
                            %action-ChangeStatus   = COND #( WHEN incident-Status = lc_status-completed OR
                                                                  incident-Status = lc_status-closed    OR
                                                                  incident-Status = lc_status-canceled  OR
                                                                  lv_history_index = 0
                                                             THEN if_abap_behv=>fc-o-disabled
                                                             ELSE if_abap_behv=>fc-o-enabled )

                            %assoc-_History       = COND #( WHEN incident-Status = lc_status-completed OR
                                                                 incident-Status = lc_status-closed    OR
                                                                 incident-Status = lc_status-canceled  OR
                                                                 lv_history_index = 0
                                                            THEN if_abap_behv=>fc-o-disabled
                                                            ELSE if_abap_behv=>fc-o-enabled ) ) ).

    "Solo el usuario asignado o un administrador pueden cambiar el estado de un incidente.

*    DATA(lv_technical_name) = cl_abap_context_info=>get_user_technical_name( ).
*    DATA(lv_administrador) = 'CB9980007185'.
*
*    READ ENTITIES OF Z_r_DT_INCT_0631 IN LOCAL MODE
*     ENTITY History
*       ALL FIELDS
*       WITH CORRESPONDING #( keys )
*     RESULT DATA(lt_responsable)
*     FAILED failed.
*
*    LOOP AT lt_responsable INTO DATA(ls_responsable).
*      IF  requested_features-%action-ChangeStatus = if_abap_behv=>mk-on AND
*                                                    ls_responsable-Responsable EQ lv_technical_name OR
*                                                    ls_responsable-Responsable EQ lv_administrador.
*        result = VALUE #( FOR incident IN incidents
*                        ( %tky                   = incident-%tky
*                          %action-ChangeStatus   = if_abap_behv=>fc-o-disabled ) ).
*      ELSE.
*        result = VALUE #( FOR incident IN incidents
*                        ( %tky                   = incident-%tky
*                          %action-ChangeStatus   = if_abap_behv=>fc-o-enabled ) ).
*
*        EXIT.
*
*      ENDIF.
*    ENDLOOP.

  ENDMETHOD.

  METHOD get_instance_authorizations.

*/
    DATA(lv_technical_name) = cl_abap_context_info=>get_user_technical_name( ).
    DATA(lv_administrador) = 'CB9980007185'.
    DATA(lv_INCuuid) = keys[ 1 ]-incuuid.

    "update  Solo el usuario asignado o un administrador pueden cambiar el estado de un incidente.

    SELECT FROM zdt_inct_h_0631
         FIELDS new_status,
                responsable,
                his_uuid,
                inc_uuid,
                his_id
         WHERE responsable IS NOT NULL
           AND inc_uuid = @lv_INCuuid
       INTO TABLE @DATA(lt_resp_validate).

    SORT lt_resp_validate BY his_id DESCENDING.

    LOOP AT lt_resp_validate ASSIGNING FIELD-SYMBOL(<lf_responsable>).

      IF <lf_responsable>-responsable EQ lv_technical_name OR
         <lf_responsable>-responsable EQ lv_administrador.

        IF requested_authorizations-%update EQ if_abap_behv=>mk-on OR
           requested_authorizations-%action-Edit EQ if_abap_behv=>mk-on.

          IF <lf_responsable>-responsable EQ lv_technical_name OR lv_technical_name EQ lv_administrador.
            APPEND INITIAL LINE TO result ASSIGNING FIELD-SYMBOL(<fs_result>).
            <fs_result>-%update = if_abap_behv=>auth-allowed.
            <fs_result>-%action-Edit = if_abap_behv=>auth-allowed.
          ELSE.
            APPEND INITIAL LINE TO result ASSIGNING <fs_result>.
            <fs_result>-%update = if_abap_behv=>auth-unauthorized.
            <fs_result>-%action-Edit = if_abap_behv=>auth-unauthorized.
          ENDIF.
        ENDIF.
      ENDIF.

      EXIT.

    ENDLOOP.


*/

*    DATA: lv_update_requested TYPE abap_bool,
*          lv_update_granted   TYPE abap_bool,
*          lv_delete_requested TYPE abap_bool,
*          lv_delete_granted   TYPE abap_bool.

*    READ ENTITIES OF Z_r_DT_INCT_0631 IN LOCAL MODE
*         ENTITY History
*         ALL FIELDS WITH CORRESPONDING #( keys )
*         RESULT DATA(lt_incidents)
*         FAILED failed.
*
*    lv_update_requested = COND #(
*                              WHEN requested_authorizations-%update = if_abap_behv=>mk-on OR
*                                   requested_authorizations-%action-Edit = if_abap_behv=>mk-on
*                              THEN abap_true
*                              ELSE abap_false ).
*    lv_delete_requested = COND #(
*                               WHEN requested_authorizations-%delete = if_abap_behv=>mk-on
*                               THEN abap_true
*                               ELSE abap_false ).
*
*    CHECK lv_update_requested EQ abap_true.
*
*    DATA(lv_technical_name) = cl_abap_context_info=>get_user_technical_name( ).
*
*    LOOP AT lt_incidents INTO DATA(ls_responsable).

*      IF ls_responsable-Responsable EQ lv_technical_name OR
*                                       lv_technical_name <> 'ADMINISTRADOR'.
*        lv_update_granted = abap_true.
*
*      ELSE.
*        lv_update_granted = abap_false.
*
*        APPEND VALUE #( %tky = ls_responsable-%tky
*                %msg = NEW zcl_incident_messages_0631( textid = zcl_incident_messages_0631=>not_authorized
*                                                    severity = if_abap_behv_message=>severity-error )
*                )  TO reported-incidents.
*
*      ENDIF.
*
*      APPEND VALUE #( LET upd_auth = COND #( WHEN lv_update_granted EQ abap_true
*                                             THEN if_abap_behv=>auth-allowed
*                                             ELSE if_abap_behv=>auth-unauthorized )
*                          del_auth = COND #( WHEN lv_delete_granted EQ abap_true
*                                             THEN if_abap_behv=>auth-allowed
*                                             ELSE if_abap_behv=>auth-unauthorized )
*                         IN
*                         %tky = ls_responsable-%tky
*                         %update = upd_auth
*                         %action-Edit = upd_auth
*                         %delete = del_auth ) TO result.
*  ENDLOOP.


  ENDMETHOD.

  METHOD get_global_authorizations.
**
**    DATA(lv_technical_name) = cl_abap_context_info=>get_user_technical_name( ).
**    DATA(lv_administrador) = 'CB9980007185'.
**
**
**    "update  Solo el usuario asignado o un administrador pueden cambiar el estado de un incidente.
**
**    SELECT FROM zdt_inct_h_0631
**         FIELDS new_status,
**                responsable,
**                his_uuid,
**                inc_uuid,
**                his_id
**         WHERE RESPONSABLE is not null
**       INTO TABLE @DATA(lt_resp_validate).
**
**    LOOP AT lt_resp_validate ASSIGNING FIELD-SYMBOL(<lf_responsable>).
**
**      IF <lf_responsable>-responsable eq lv_technical_name or
**         <lf_responsable>-responsable eq lv_administrador.
**
**        IF requested_authorizations-%update EQ if_abap_behv=>mk-on OR
**           requested_authorizations-%action-Edit EQ if_abap_behv=>mk-on.
**
**          IF <lf_responsable>-responsable EQ lv_technical_name OR lv_technical_name EQ lv_administrador.
**            result-%update = if_abap_behv=>auth-allowed.
**            result-%action-Edit = if_abap_behv=>auth-allowed.
**          ELSE.
**            result-%update = if_abap_behv=>auth-unauthorized.
**            result-%action-Edit = if_abap_behv=>auth-unauthorized.
**          ENDIF.
**        ENDIF.
**      ENDIF.

*
*      IF <lf_responsable>-new_status EQ lc_status-in_progress.
*        IF requested_authorizations-%update EQ if_abap_behv=>mk-on
*            OR requested_authorizations-%action-Edit EQ if_abap_behv=>mk-on.
*
*          IF <lf_responsable>-responsable EQ lv_technical_name OR lv_technical_name EQ lv_administrador.
*            result-%update = if_abap_behv=>auth-allowed.
*            result-%action-Edit = if_abap_behv=>auth-allowed.
*          ELSE.
*            result-%update = if_abap_behv=>auth-unauthorized.
*            result-%action-Edit = if_abap_behv=>auth-unauthorized.
*
*
*            APPEND VALUE #( %msg = NEW zcl_incident_messages_0631( textid = zcl_incident_messages_0631=>not_authorized
*                                                                 severity = if_abap_behv_message=>severity-error )
*                           %global = if_abap_behv=>mk-on ) TO reported-incidents.
*          ENDIF.
*
*        ENDIF.
*
*      ENDIF.
*    "delete
*    IF requested_authorizations-%delete EQ if_abap_behv=>mk-on.
*
*      IF lv_technical_name EQ lv_administrador .
*        result-%delete = if_abap_behv=>auth-allowed.
*      ELSE.
*        result-%delete = if_abap_behv=>auth-unauthorized.
*
*        APPEND VALUE #( %msg = NEW zcl_incident_messages_0631( textid = zcl_incident_messages_0631=>not_authorized
*                                                             severity = if_abap_behv_message=>severity-error )
*                       %global = if_abap_behv=>mk-on ) TO reported-incidents.
*      ENDIF.
*    ENDIF.
**
*    ENDLOOP.

  ENDMETHOD.

  METHOD get_history_index.

    "valor a his_id
    SELECT FROM zdt_inct_h_0631
      FIELDS MAX( his_id ) AS max_his_id
      WHERE inc_uuid EQ @ev_incuuid AND
            his_uuid IS NOT NULL
      INTO @rv_index.

  ENDMETHOD.

  METHOD ChangeStatus.

    DATA : lt_update_incident TYPE TABLE FOR UPDATE Z_r_DT_INCT_0631,
           lt_create_history  TYPE TABLE FOR CREATE Z_r_DT_INCT_0631\_History,
           ls_history         TYPE zdt_inct_h_0631.

    READ ENTITIES OF Z_r_DT_INCT_0631 IN LOCAL MODE
      ENTITY Incidents
      ALL FIELDS
      WITH CORRESPONDING #( keys )
      RESULT DATA(incidents).

    LOOP AT incidents ASSIGNING FIELD-SYMBOL(<lf_incidents>).

      DATA(lv_new_status) = keys[ KEY id %tky = <lf_incidents>-%tky ]-%param-status.
      DATA(lv_status) = <lf_incidents>-Status.
      DATA(lv_text)       = keys[ KEY id %tky = <lf_incidents>-%tky ]-%param-text.


      " Validaciones de estado

      IF <lf_incidents>-Status EQ 'CN' OR lv_status = 'CO' AND lv_status = 'CL'.

        APPEND VALUE #( %tky = <lf_incidents>-%tky ) TO failed-incidents.

        APPEND VALUE #(  %tky = <lf_incidents>-%tky
                         %msg = NEW zcl_incident_messages_0631( textid = zcl_incident_messages_0631=>status_invalid
                                                              severity = if_abap_behv_message=>severity-error ) ) TO reported-incidents.

      ENDIF.

      IF ( <lf_incidents>-Status EQ lc_status-pending AND lv_new_status = lc_status-closed ) OR
         ( <lf_incidents>-Status EQ lc_status-pending AND lv_new_status = lc_status-completed ) OR
         ( <lf_incidents>-Status EQ lc_status-pending AND lv_new_status = lc_status-canceled ).

        APPEND VALUE #( %tky = <lf_incidents>-%tky ) TO failed-incidents.

        DATA(lv_status_inv) = lv_new_status.

        APPEND VALUE #( %tky = <lf_incidents>-%tky
                        %msg = NEW zcl_incident_messages_0631( textid   = zcl_incident_messages_0631=>status_invalid2
                                                               status   = lv_status_inv
                                                               severity = if_abap_behv_message=>severity-error )
                                                %state_area = 'VALIDATE_COMPONENT'  ) TO reported-incidents.
        DATA(lv_error) = abap_true.
        EXIT.
      ENDIF.

      "status IN
      IF lv_new_status EQ lc_status-in_progress.
        APPEND VALUE #( %tky = <lf_incidents>-%tky
                        status = lv_new_status
                        ChangedDate = cl_abap_context_info=>get_system_date( )
                        ) TO lt_update_incident.
        DATA(lv_responsable) = cl_abap_context_info=>get_user_technical_name( ).
      ELSE.
        " Actualiza entidad
        APPEND VALUE #( %tky = <lf_incidents>-%tky
                        status = lv_new_status
                        ChangedDate = cl_abap_context_info=>get_system_date( )  ) TO lt_update_incident.

      ENDIF.


      " Asignar valor a his_id
      DATA(lv_max_his_id) = get_history_index(
                                    IMPORTING ev_incuuid = <lf_incidents>-IncUUID ).

      IF lv_max_his_id IS INITIAL.
        ls_history-his_id = 1.
      ELSE.
        ls_history-his_id = lv_max_his_id + 1.
      ENDIF.

      ls_history-previous_status = <lf_incidents>-Status.
      ls_history-new_status = lv_new_status.
      ls_history-text = lv_text.

      TRY.
          ls_history-his_uuid = cl_system_uuid=>create_uuid_x16_static( ).
          ls_history-inc_uuid = <lf_incidents>-IncUuid.
        CATCH cx_uuid_error INTO DATA(lo_error).
          DATA(lv_exception) = lo_error->get_text(  ).
      ENDTRY.

      " Insertar datos historial
      IF ls_history-his_id IS NOT INITIAL.

        APPEND VALUE #( %tky    = <lf_incidents>-%tky
                        %target = VALUE #( (  HisUUID         = ls_history-his_uuid
                                              incUuid         = ls_history-inc_uuid
                                              hisid           = ls_history-his_id
                                              previousstatus  = ls_history-previous_status
                                              newstatus       = ls_history-new_status
                                              text            = ls_history-text
                                              responsable = lv_responsable
                                              ) ) ) TO lt_create_history .
      ENDIF.
    ENDLOOP.

    UNASSIGN <lf_incidents>.

    CHECK lv_error IS INITIAL.

    MODIFY ENTITIES OF Z_r_DT_INCT_0631 IN LOCAL MODE
    ENTITY Incidents
    UPDATE  FIELDS ( ChangedDate
                     Status )
    WITH lt_update_incident.

    FREE incidents.

    MODIFY ENTITIES OF Z_r_DT_INCT_0631 IN LOCAL MODE
     ENTITY Incidents
     CREATE BY \_History FIELDS ( HisUUID
                                  IncUUID
                                  HisID
                                  PreviousStatus
                                  NewStatus
                                  Text
                                  Responsable
                                  )
        AUTO FILL CID
        WITH lt_create_history
     MAPPED mapped
     FAILED failed
     REPORTED reported.

    READ ENTITIES OF Z_r_DT_INCT_0631 IN LOCAL MODE
    ENTITY Incidents
    ALL FIELDS WITH CORRESPONDING #( keys )
    RESULT incidents
    FAILED failed
    REPORTED reported.


    result = VALUE #( FOR incident IN incidents ( %tky = incident-%tky
                                                  %param = incident ) ).

  ENDMETHOD.

  METHOD sethistory.

*    DATA : lt_update_incident TYPE TABLE FOR UPDATE Z_r_DT_INCT_0631,
*           lt_create_history  TYPE TABLE FOR CREATE Z_r_DT_INCT_0631\_History,
*           ls_history         TYPE zdt_inct_h_0631.
*
*    READ ENTITIES OF Z_r_DT_INCT_0631 IN LOCAL MODE
*    ENTITY Incidents
*    ALL FIELDS
*    WITH CORRESPONDING #( keys )
*    RESULT DATA(incidents).
*
*    LOOP AT incidents ASSIGNING FIELD-SYMBOL(<lf_incidents>).
*
*      DATA(lv_max_his_id) = get_history_index( IMPORTING ev_incuuid = <lf_incidents>-IncUUID ).
*
*      IF lv_max_his_id IS INITIAL.
*        ls_history-his_id = 1.
*      ELSE.
*        ls_history-his_id = lv_max_his_id + 1.
*      ENDIF.
*
*      TRY.
*          ls_history-inc_uuid = cl_system_uuid=>create_uuid_x16_static( ).
*        CATCH cx_uuid_error INTO DATA(lo_error).
*          DATA(lv_exception) = lo_error->get_text(  ).
*      ENDTRY.
*
*      IF ls_history-his_id IS NOT INITIAL.
*
*        APPEND VALUE #( %tky    = <lf_incidents>-%tky
*                        %target = VALUE #( (  HisUUID         = ls_history-his_uuid
*                                              IncUUID         = ls_history-inc_uuid
*                                              hisid           = ls_history-his_id
*                                              previousstatus  = ls_history-previous_status
*                                              newstatus       = ls_history-new_status
*                                              text            = 'First Incident' ) ) ) TO lt_create_history .
*      ENDIF.
*    ENDLOOP.
*
*    UNASSIGN <lf_incidents>.
*    FREE incidents.
*
*    MODIFY ENTITIES OF Z_r_DT_INCT_0631 IN LOCAL MODE
*    ENTITY Incidents
*    CREATE BY \_History FIELDS ( HisUUID
*                                 IncUUID
*                                 HisID
*                                 PreviousStatus
*                                 NewStatus
*                                 Text )
*       AUTO FILL CID
*       WITH lt_create_history
*    MAPPED mapped
*    FAILED failed
*    REPORTED reported.

  ENDMETHOD.

  METHOD SetIncidentNumber.

    "lectura de la entidad
    READ ENTITIES OF Z_r_DT_INCT_0631 IN LOCAL MODE
    ENTITY Incidents
    FIELDS ( status
             CreationDate )
    WITH CORRESPONDING #( keys )
    RESULT DATA(lt_incidents).

    DELETE lt_incidents WHERE CreationDate IS NOT INITIAL.
    CHECK lt_incidents IS NOT INITIAL.

    "  valor para incident_id
    SELECT FROM zdt_inct_0631
       FIELDS MAX( incident_id ) AS max_inct_id
       WHERE incident_id IS NOT NULL
    INTO @DATA(lv_max_inc_id).

    IF lv_max_inc_id IS INITIAL.
      lv_max_inc_id = 1.
    ELSE.
      lv_max_inc_id += 1.
    ENDIF.

    "modificacion de status, incidentId, creationDate
    MODIFY ENTITIES OF Z_r_DT_INCT_0631 IN LOCAL MODE
    ENTITY Incidents
    UPDATE
    FIELDS ( IncidentId
             Status
             CreationDate )
    WITH VALUE #( FOR ls_incidents IN lt_incidents ( %tky         = ls_incidents-%tky
                                                     IncidentId   = lv_max_inc_id
                                                     Status       = lc_status-open
                                                     CreationDate = cl_abap_context_info=>get_system_date( ) ) ).


  ENDMETHOD.

  METHOD setStatusToOpen.

    DATA : lt_update_incident TYPE TABLE FOR CREATE Z_r_DT_INCT_0631,
           lt_create_history  TYPE TABLE FOR CREATE Z_r_DT_INCT_0631\_History,
           ls_history         TYPE zdt_inct_h_0631.

    "lectura de la entidad
    READ ENTITIES OF Z_r_DT_INCT_0631 IN LOCAL MODE
    ENTITY incidents
    ALL FIELDS
    WITH CORRESPONDING #( keys )
    RESULT DATA(lt_incidents).

    CHECK lt_incidents IS NOT INITIAL.

    LOOP AT lt_incidents ASSIGNING FIELD-SYMBOL(<lf_incidents>).

      DATA(lv_max_his_id) = get_history_index( IMPORTING ev_incuuid = <lf_incidents>-IncUUID ).

      IF lv_max_his_id IS INITIAL.
        ls_history-his_id = 1.
      ELSE.
        ls_history-his_id = lv_max_his_id + 1.
      ENDIF.

      TRY.
          ls_history-his_uuid = cl_system_uuid=>create_uuid_x16_static( ).
          ls_history-inc_uuid = <lf_incidents>-IncUuid.
        CATCH cx_uuid_error INTO DATA(lo_error).
          DATA(lv_exception) = lo_error->get_text(  ).
      ENDTRY.

      IF ls_history-his_id IS NOT INITIAL.

        APPEND VALUE #( %tky    = <lf_incidents>-%tky
                        %target = VALUE #( (  HisUUID         = ls_history-his_uuid
                                              IncUUID         = ls_history-inc_uuid
                                              hisid           = ls_history-his_id
                                              previousstatus  = ls_history-previous_status
                                              newstatus       = lc_status-open
                                              text            = 'First Incident'
                                               ) ) ) TO lt_create_history .
      ENDIF.
    ENDLOOP.

    UNASSIGN <lf_incidents>.
    FREE lt_incidents.

    MODIFY ENTITIES OF Z_r_DT_INCT_0631 IN LOCAL MODE
    ENTITY incidents
    CREATE BY \_History FIELDS ( HisUUID
                                 IncUUID
                                 HisID
                                 PreviousStatus
                                 NewStatus
                                 Text  )
       AUTO FILL CID
       WITH lt_create_history
    MAPPED DATA(lt_mapped)
    FAILED DATA(lt_failed)
    REPORTED DATA(lt_reported).

  ENDMETHOD.


ENDCLASS.
