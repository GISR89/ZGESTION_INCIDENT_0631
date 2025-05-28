CLASS zcl_incident_messages_0631 DEFINITION
  PUBLIC
  INHERITING FROM cx_static_check
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.

    INTERFACES if_t100_dyn_msg .
    INTERFACES if_t100_message .
    INTERFACES if_abap_behv_message .

    CONSTANTS:
      gc_msgid TYPE symsgid VALUE 'ZMC_INCT_MESSAGE_631',

      BEGIN OF status_invalid,
        msgid TYPE symsgid VALUE 'ZMC_INCT_MESSAGE_631',
        msgno TYPE symsgno VALUE '001',
        attr1 TYPE scx_attrname VALUE 'MV_STATUS',
        attr2 TYPE scx_attrname VALUE '',
        attr3 TYPE scx_attrname VALUE '',
        attr4 TYPE scx_attrname VALUE '',
      END OF status_invalid,

      BEGIN OF status_invalid2,
        msgid TYPE symsgid VALUE 'ZMC_INCT_MESSAGE_631',
        msgno TYPE symsgno VALUE '002',
        attr1 TYPE scx_attrname VALUE 'MV_STATUS',
        attr2 TYPE scx_attrname VALUE '',
        attr3 TYPE scx_attrname VALUE '',
        attr4 TYPE scx_attrname VALUE '',
      END OF status_invalid2,

      BEGIN OF assign_resp,
        msgid TYPE symsgid VALUE 'ZMC_INCT_MESSAGE_631',
        msgno TYPE symsgno VALUE '003',
        attr1 TYPE scx_attrname VALUE '',
        attr2 TYPE scx_attrname VALUE '',
        attr3 TYPE scx_attrname VALUE '',
        attr4 TYPE scx_attrname VALUE '',
      END OF assign_resp,

      BEGIN OF not_allowed_change,
        msgid TYPE symsgid VALUE 'ZMC_INCT_MESSAGE_631',
        msgno TYPE symsgno VALUE '004',
        attr1 TYPE scx_attrname VALUE '',
        attr2 TYPE scx_attrname VALUE '',
        attr3 TYPE scx_attrname VALUE '',
        attr4 TYPE scx_attrname VALUE '',
      END OF not_allowed_change,

      BEGIN OF not_authorized,
        msgid TYPE symsgid VALUE 'ZMC_INCT_MESSAGE_631',
        msgno TYPE symsgno VALUE '005',
        attr1 TYPE scx_attrname VALUE '',
        attr2 TYPE scx_attrname VALUE '',
        attr3 TYPE scx_attrname VALUE '',
        attr4 TYPE scx_attrname VALUE '',
      END OF not_authorized,

      BEGIN OF change_date,
        msgid TYPE symsgid VALUE 'ZMC_INCT_MESSAGE_631',
        msgno TYPE symsgno VALUE '006',
        attr1 TYPE scx_attrname VALUE 'MV_BEGIN_DATE',
        attr2 TYPE scx_attrname VALUE '',
        attr3 TYPE scx_attrname VALUE '',
        attr4 TYPE scx_attrname VALUE '',
      END OF change_date,

      BEGIN OF validate_Fields,
        msgid TYPE symsgid VALUE 'ZMC_INCT_MESSAGE_631',
        msgno TYPE symsgno VALUE '007',
        attr1 TYPE scx_attrname VALUE '',
        attr2 TYPE scx_attrname VALUE '',
        attr3 TYPE scx_attrname VALUE '',
        attr4 TYPE scx_attrname VALUE '',
      END OF validate_Fields,

      BEGIN OF incident_responsible,
        msgid TYPE symsgid VALUE 'ZMC_INCT_MESSAGE_631',
        msgno TYPE symsgno VALUE '008',
        attr1 TYPE scx_attrname VALUE '',
        attr2 TYPE scx_attrname VALUE '',
        attr3 TYPE scx_attrname VALUE '',
        attr4 TYPE scx_attrname VALUE '',
      END OF incident_responsible.


    METHODS constructor
      IMPORTING
        textid          LIKE if_t100_message=>t100key OPTIONAL
        attr1           TYPE string OPTIONAL
        attr2           TYPE string OPTIONAL
        attr3           TYPE string OPTIONAL
        attr4           TYPE string OPTIONAL
        inc_uuid        TYPE sysuuid_x16 OPTIONAL
        incident_id     TYPE zde_incident_id_0631 OPTIONAL
        title           TYPE zde_title_0631 OPTIONAL
        description     TYPE zde_description_0631 OPTIONAL
        status          TYPE zde_status_0631 OPTIONAL
        priority        TYPE zde_priority_0631 OPTIONAL
        creation_date   TYPE zde_creation_date_0631 OPTIONAL
        changed_date    TYPE zde_changed_date_0631 OPTIONAL
        his_uuid        TYPE sysuuid_x16 OPTIONAL
        his_id          TYPE zde_his_id_0631 OPTIONAL
        previous_status TYPE zde_previous_status_0631 OPTIONAL
        new_status      TYPE zde_new_status_0631 OPTIONAL
        text            TYPE zde_text_0631 OPTIONAL
        severity        TYPE if_abap_behv_message=>t_severity OPTIONAL
        uname           TYPE syuname OPTIONAL.

    DATA :
      mv_attr1           TYPE string,
      mv_attr2           TYPE string,
      mv_attr3           TYPE string,
      mv_attr4           TYPE string,
      mv_inc_uuid        TYPE sysuuid_x16,
      mv_incident_id     TYPE zde_incident_id_0631,
      mv_title           TYPE zde_title_0631,
      mv_description     TYPE zde_description_0631,
      mv_status          TYPE zde_status_0631,
      mv_priority        TYPE zde_priority_0631,
      mv_creation_date   TYPE zde_creation_date_0631,
      mv_changed_date    TYPE zde_changed_date_0631,
      mv_his_uuid        TYPE sysuuid_x16,
      mv_his_id          TYPE zde_his_id_0631,
      mv_previous_status TYPE zde_previous_status_0631,
      mv_new_status      TYPE zde_new_status_0631,
      mv_text            TYPE zde_text_0631,
      mv_uname           TYPE syuname.

  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.

CLASS zcl_incident_messages_0631 IMPLEMENTATION.

  METHOD constructor ##ADT_SUPPRESS_GENERATION.
    super->constructor(  previous = previous ) .

    me->mv_attr1                 = attr1.
    me->mv_attr2                 = attr2.
    me->mv_attr3                 = attr3.
    me->mv_attr4                 = attr4.
    me->mv_inc_uuid              =  inc_uuid.
    me->mv_incident_id           =  incident_id.
    me->mv_title                 =  title.
    me->mv_description           =  description.
    me->mv_status                =  status.
    me->mv_priority              =  priority.
    me->mv_creation_date         =  creation_date.
    me->mv_changed_date          =  changed_date.
    me->mv_his_uuid              =  his_uuid.
    me->mv_his_id                =  his_id.
    me->mv_previous_status       =  previous_status.
    me->mv_new_status            =  new_status.
    me->mv_text                  =  text.

    if_abap_behv_message~m_severity = severity.

    CLEAR me->textid.
    IF textid IS INITIAL.
      if_t100_message~t100key = if_t100_message=>default_textid.
    ELSE.
      if_t100_message~t100key = textid.
    ENDIF.
  ENDMETHOD.


ENDCLASS.
