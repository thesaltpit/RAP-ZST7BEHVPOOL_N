@EndUserText.label: 'Consumption view for accounting header'
@AccessControl.authorizationCheck: #CHECK
@Metadata.allowExtensions: true
//This is a consumption view created as a projection view template
//Added the root keyword below
define root view entity ZST7_ACCHDR_ROOT_POOL_CONSM as projection on ZST7_ACCHDR_ROOT_POOL
//association [1..1] to ZST7_COMPCD_DESCR as _compCdDesc on $projection.compcd = _compCdDesc.compcd 
{
    key bukrs as compcd,
    key belnr as docnum,
    key gjahr as fiscyr,
    @ObjectModel.text.element: ['doctypdesc']
    blart as doctyp,
    @Semantics.user.createdBy: true   //Automatically update the created by date on creation of new entry
    bldat as docdt,
    @Semantics.user.createdBy: true   //Automatically update the created by user ID on creation of new entry
    cpudt as sysdt,
    cputm as systm,
    usnam as usernm,
    bktxt as doctxt,
    tcode as tcode,
    xblnr as refdocno,
    createddt_time as crdatetime,
    changeddt_time as chgdatetime,
    lastchngdttm as lastchgdttm,
    _compCdDesc.descr as compcddescr,
    @Semantics.text: true
    _docTypDesc.doctypdesc as doctypdesc,
    
    /* Associations */
    _items:redirected to composition child ZST7_ACCITM_CHILD_POOL_CONSM
    
}
