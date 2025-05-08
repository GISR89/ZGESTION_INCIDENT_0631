@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Value help status'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.dataCategory: #VALUE_HELP
@ObjectModel.representativeKey: 'StatusCode'
@ObjectModel.usageType:{
                        serviceQuality: #X,
                        sizeCategory: #S,
                        dataClass: #CUSTOMIZING }
@VDM.viewType: #COMPOSITE
@Search.searchable: true

define view entity ZDD_STATUS_VH_0631
  as select from zdt_status_0631
{
      @ObjectModel.text.element:['StatusDescription']
  key status_code        as StatusCode,
      @Search.defaultSearchElement: true
      @Search.fuzzinessThreshold: 0.8
      @Semantics.text:true
      status_description as StatusDescription
}
