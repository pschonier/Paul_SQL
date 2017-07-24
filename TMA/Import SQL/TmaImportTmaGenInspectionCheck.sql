insert into f_genInspectionCheck
select GIC_GIF_FK, gici.GIC_DESCRIPTION, case gici.GIC_PASS WHEN 'True' THEN 1 ELSE 0 END, gici.GIC_READING, gici.GIC_COMMENTS, GIC_UPDATEMETER, pri.pri_pk, rc_pk, wc_pk, fo_pk, ftr_pk, GIC_CLNT_FK, GIC_CREATOR_FK, GIC_CreatedDate, GIC_MODIFIER_FK, GIC_ModifiedDate 
from IT..tmageninspectioncheckimport gici
left outer join f_priority pri on gici.GIC_DEFAULT_PRI_FK_CODE = pri.pri_code
left outer join f_repaircenter rc on gici.GIC_DEFAULT_RC_FK_CODE = rc.rc_code
left outer join f_workordertype wc on gici.GIC_DEFAULT_WC_FK_Description = wc.wc_description
left outer join f_joblibrary fo on gici.GIC_DEFAULT_FO_FK_Code = fo.fo_code
left outer join f_trade ftr on gici.GIC_DEFAULT_FTR_FK_Code = ftr.ftr_code
inner join[dbo].[f_genInspectionCheck] on 1000 = GIC_PK
