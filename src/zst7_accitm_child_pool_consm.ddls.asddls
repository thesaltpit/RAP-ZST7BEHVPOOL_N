@EndUserText.label: 'Consumption view for accounting line items'
@AccessControl.authorizationCheck: #CHECK
@Metadata.allowExtensions: true

//The below fields will be displayed once the user clicks on the individual line item
define view entity ZST7_ACCITM_CHILD_POOL_CONSM as projection on ZST7_ACCITM_CHILD_POOL
{
    key bukrs as compcd,
    key belnr as docnum,
    key gjahr as fiscyr,
    key buzei as linenum,
    @ObjectModel.text.element: ['postkeydescrp']
    bschl as postkey,
    @Semantics.text: true
    posytkeydesc as postkeydescrp,
    @ObjectModel.text.element: ['acctypedesc']
    koart as acctype,
    @Semantics.text: true 
    acctyptext as acctypedesc,
    @ObjectModel.text.element: ['dbcrdesc']
    shkzg as dbcrindc,
    @Semantics.text: true
    dbcrtext as dbcrdesc,
    @ObjectModel.text.element: ['bussareatext']
    gsber as bussarea,
    @Semantics.text: true
    bussareatxt as bussareatext,
    @ObjectModel.text.element: ['mwskztext']
    mwskz as taxcd,
    @Semantics.text: true
    taxcdesc as mwskztext,
    dmbtr as amount,
    mwsts as taxamt,
    waers as currcode,
    kostl as costcntr,
    @ObjectModel.text.element: ['vendortext']
    lifnr as vendor,
    @Semantics.text: true
    vendtext as vendortext,
    chgdttime as changdttime,
    locdttime as localchgdttm,
    
    /* Associations */
    _header:redirected to parent ZST7_ACCHDR_ROOT_POOL_CONSM
}
