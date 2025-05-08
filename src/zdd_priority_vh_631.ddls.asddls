@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Value help priority'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.dataCategory: #VALUE_HELP
@ObjectModel.representativeKey: 'PriorityCode'
@ObjectModel.usageType:{
                        serviceQuality: #X,
                        sizeCategory: #S,
                        dataClass: #CUSTOMIZING }
@VDM.viewType: #COMPOSITE
@Search.searchable: true

define view entity ZDD_PRIORITY_VH_631
  as select from zdt_priority_631
{
      @ObjectModel.text.element:['PriorityDescription']
  key priority_code        as PriorityCode,
      @Search.defaultSearchElement: true
      @Search.fuzzinessThreshold: 0.8
      @Semantics.text:true
      priority_description as PriorityDescription
}
