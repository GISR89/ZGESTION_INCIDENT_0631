@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Interface - History'
@Metadata.ignorePropagatedAnnotations: true
define view entity ZI_DT_INCT_H_0631 
as projection on ZDDT_INCT_H_0631
{
    key HisUuid,
    key IncUuid,
    HisId,
    PreviousStatus,
    NewStatus,
    Text,
    LocalCreatedBy,
    LocalCreatedAt,
    LocalLastChangedBy,
    LocalLastChangedAt,
    LastChangedAt,
    /* Associations */
    _Incidents : redirected to parent ZI_DT_INCT_0631
}
