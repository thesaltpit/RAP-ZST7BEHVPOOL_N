@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: 'Child entity for FI line items'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
//@Metadata.allowExtensions: true
define view entity ZST7_ACCITM_CHILD_POOL
  as select from zst7accitm_tb
  association to parent ZST7_ACCHDR_ROOT_POOL as _header on  $projection.bukrs = _header.bukrs
                                                         and $projection.belnr = _header.belnr
                                                         and $projection.gjahr = _header.gjahr
//Tax code description                                                         
  association[1..1] to zst7taxcddesc_tb as _taxCdDesc on $projection.mwskz = _taxCdDesc.mwskz
//Vendor description  
  association[1..1] to lfa1 as _vendDesc on $projection.lifnr = _vendDesc.lifnr        
//Business area description
  association [1..1] to tgsbt as _bussareaDesc on $projection.gsber = _bussareaDesc.gsber
                                              and _bussareaDesc.spras = 'E'
//Posting key description                                              
  association[1..1] to tbslt  as _postKeyDesc on $projection.bschl = _postKeyDesc.bschl
                                             and _postKeyDesc.spras = 'E'                                                 
{
  key bukrs,
  key belnr,
  key gjahr,
  key buzei,
      bschl,
      _postKeyDesc.ltext as posytkeydesc,
      koart,
      shkzg,
      gsber,
      _bussareaDesc.gtext as bussareatxt,
      mwskz,
      _taxCdDesc.taxcd_desc as taxcdesc,
      dmbtr,
      mwsts,
      waers,
      kostl,
      lifnr,
      changed_dt_time as chgdttime,
      local_chg_dt_time as locdttime,
      _vendDesc.name1 as vendtext,
     
     //Debit/Credit indicator text 
      case shkzg
      when 'H' then 'Credit'
      when 'S' then 'Debit'
      end as dbcrtext,

      //Account type text
      case koart
      when 'A' then 'Assets'
      when 'D' then 'Customers'
      when 'K' then 'Vendors'
      when 'M' then 'Material'
      when 'S' then 'G/L Account'
      end as acctyptext,
        
      //Association
      _header,
      _taxCdDesc,
      _vendDesc
}
