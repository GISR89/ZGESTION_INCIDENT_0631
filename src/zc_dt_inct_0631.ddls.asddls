@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Proyection - Incidents'
@Metadata.ignorePropagatedAnnotations: true
@Metadata.allowExtensions: true
define root view entity ZC_DT_INCT_0631
  provider contract transactional_query
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
      Responsible,
      LocalCreatedBy,
      LocalCreatedAt,
      LocalLastChangedBy,
      LocalLastChangedAt,
      LastChangedAt,
      /* Associations */
      _History : redirected to composition child ZC_DT_INCT_H_0631
}
