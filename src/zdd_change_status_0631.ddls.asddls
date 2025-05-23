@EndUserText.label: 'Abstract change status'
define abstract entity ZDD_CHANGE_STATUS_0631

{
  @EndUserText.label: 'Change Status'
  @Consumption.valueHelpDefinition: [ { entity.name: 'zdd_status_vh_0631',
                                        entity.element: 'StatusCode',
                                        useForValidation: true  } ]
   key status : zde_status_0631;
  @EndUserText.label: 'Observation'
  text   : zde_text_0631;

}
