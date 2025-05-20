CLASS lhc_Incidents DEFINITION INHERITING FROM cl_abap_behavior_handler.
  PRIVATE SECTION.

    METHODS get_instance_features FOR INSTANCE FEATURES
      IMPORTING keys REQUEST requested_features FOR Incidents RESULT result.

    METHODS get_instance_authorizations FOR INSTANCE AUTHORIZATION
      IMPORTING keys REQUEST requested_authorizations FOR Incidents RESULT result.

    METHODS get_global_authorizations FOR GLOBAL AUTHORIZATION
      IMPORTING REQUEST requested_authorizations FOR Incidents RESULT result.

    METHODS ChangeStatus FOR MODIFY
      IMPORTING keys FOR ACTION Incidents~ChangeStatus RESULT result.

    METHODS SetIncidentNumber FOR DETERMINE ON MODIFY
      IMPORTING keys FOR Incidents~SetIncidentNumber.

    METHODS setStatusToOpen FOR DETERMINE ON SAVE
      IMPORTING keys FOR Incidents~setStatusToOpen.

    METHODS validateDate FOR VALIDATE ON SAVE
      IMPORTING keys FOR Incidents~validateDate.

    METHODS validateDescription FOR VALIDATE ON SAVE
      IMPORTING keys FOR Incidents~validateDescription.

    METHODS validatePriority FOR VALIDATE ON SAVE
      IMPORTING keys FOR Incidents~validatePriority.

    METHODS validateStatus FOR VALIDATE ON SAVE
      IMPORTING keys FOR Incidents~validateStatus.

    METHODS validateTitle FOR VALIDATE ON SAVE
      IMPORTING keys FOR Incidents~validateTitle.

ENDCLASS.

CLASS lhc_Incidents IMPLEMENTATION.

  METHOD get_instance_features.
  ENDMETHOD.

  METHOD get_instance_authorizations.
  ENDMETHOD.

  METHOD get_global_authorizations.
  ENDMETHOD.

  METHOD ChangeStatus.
  ENDMETHOD.

  METHOD SetIncidentNumber.
  ENDMETHOD.

  METHOD setStatusToOpen.
  ENDMETHOD.

  METHOD validateDate.
  ENDMETHOD.

  METHOD validateDescription.
  ENDMETHOD.

  METHOD validatePriority.
  ENDMETHOD.

  METHOD validateStatus.
  ENDMETHOD.

  METHOD validateTitle.
  ENDMETHOD.

ENDCLASS.
