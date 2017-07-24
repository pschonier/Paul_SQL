delete from PM10300	 where BACHNUMB = 'MICR_REJECT'
delete from SY00500	 where BACHNUMB = 'MICR_REJECT'
delete from ME240465 where bachnumb = 'MICR_REJECT'
delete from ME240472 where bachnumb = 'MICR_REJECT' and DEX_ROW_ID = 3 --there may be more than 1 in here so use dex_id

