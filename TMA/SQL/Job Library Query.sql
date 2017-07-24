select * from f_joblibrary jl 

select * from f_jobLibraryMasterCheckLink mcl
join f_mastercheck mc on mc.chk_pk = mcl.fochk_chk_fk
join f_joblibrary jl on jl.fo_pk = mcl.fochk_fo_fk
join f_jobType jt on jt.fj_pk = jl.fo_fj_fk

select * from f_masterCheck


select * from f_jobType