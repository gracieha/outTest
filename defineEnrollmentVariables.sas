data out.screenedsites;
	set outREDCAPData;
	/*Manual override*/
	if study_id='1025' and inex_date='12Dec11'd then inex_date='12Nov12'd;
	if study_id='1007' then adjresult=1;
	if study_id='1022' then adjresult=1;
	/*Monthly Variables-Screen/Enrollment Summary (MT0), MT1, MT2, Enrollment Updates*/
	if redcap_event_name='baseline_arm_1' AND crf00_complete=2 then do;
		if crf00_complete=2 then screened=1;
