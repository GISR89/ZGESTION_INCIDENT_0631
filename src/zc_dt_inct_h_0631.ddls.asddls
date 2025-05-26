@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Proyection - History'
@Metadata.ignorePropagatedAnnotations: true
@Metadata.allowExtensions: true
define view entity ZC_DT_INCT_H_0631 
as projection on ZDDT_INCT_H_0631
{
    key HisUuid,
    key IncUuid,
    HisId,
    PreviousStatus,
    NewStatus,
    Text,
    Responsable,
    LocalCreatedBy,
    LocalCreatedAt,
    LocalLastChangedBy,
    LocalLastChangedAt,
    LastChangedAt,
    /* Associations */
    _Incidents : redirected to parent ZC_DT_INCT_0631
}
