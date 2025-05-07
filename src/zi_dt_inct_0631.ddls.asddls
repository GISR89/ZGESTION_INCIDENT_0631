@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Interface - Incidents'
@Metadata.ignorePropagatedAnnotations: true
define root view entity ZI_DT_INCT_0631
  provider contract transactional_interface
  as projection on Z_r_DT_INCT_0631
{
  key IncUuid,
      IncidentId,
      Title,
      Description,
      Status,
      Priority,
      CreationDate,
      ChangedDate,
      LocalCreatedBy,
      LocalCreatedAt,
      LocalLastChangedBy,
      LocalLastChangedAt,
      LastChangedAt,
      /* Associations */
      _History : redirected to composition child ZI_DT_INCT_H_0631
}
