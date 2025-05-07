@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'root entity'
@Metadata.ignorePropagatedAnnotations: true
define root view entity Z_r_DT_INCT_0631
  as select from zdt_inct_0631
  
  composition [0..*] of ZDDT_INCT_H_0631 as _History
  
{
  key inc_uuid              as IncUuid,
      incident_id           as IncidentId,
      title                 as Title,
      description           as Description,
      status                as Status,
      priority              as Priority,
      creation_date         as CreationDate,
      changed_date          as ChangedDate,
      @Semantics.user.createdBy: true
      local_created_by      as LocalCreatedBy,
      @Semantics.systemDateTime.createdAt: true
      local_created_at      as LocalCreatedAt,
      @Semantics.user.localInstanceLastChangedBy: true
      local_last_changed_by as LocalLastChangedBy,
      @Semantics.systemDateTime.localInstanceLastChangedAt: true
      local_last_changed_at as LocalLastChangedAt,
      @Semantics.systemDateTime.lastChangedAt: true
      last_changed_at       as LastChangedAt,
      _History

     
}

