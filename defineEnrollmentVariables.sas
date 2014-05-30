data out.screenedsites (keep=study_id facilitycode redcap_data_access_group projectcode screened eligible ineligible enrolled notEnrolledRefused notEnrolledStudy notEnrolledConsentNA
	notEnrolledOther completePatient);
	merge outREDCAPData (where=redcap_event_name='baseline_arm_1' AND crf00_complete=2);
		outREDCAPData (keep=study_id fsf_study_completed fsf_study_completed fsf_study_completed fsf_study_completed);
	/*Manual override*/
	if study_id='1025' and inex_date='12Dec11'd then inex_date='12Nov12'd;
	if study_id='1007' then adjresult=1;
	if study_id='1022' then adjresult=1;
	/*Monthly Variables-Screen/Enrollment Summary (MT0), MT1, MT2, Enrollment Updates*/
	if crf00_complete=2 then screened=1;
	if /*inex_con12=1 OR*/ inex_con12spy=1 OR v2_inex_con12spy=1 OR v3_inex_con12spy=1 then eligible=1;
	if (inex_con12spn=1 OR v2_inex_con12spn=1 OR v3_inex_con12spn=1) OR (.<inex_inc_calc<3 OR .<v2_inex_inc_calc<3)
		then ineligible=1;

	if eligible=1 then do;
		if treat_assign=1 then enrolled=1;
		if inex_con15=0 /*and inex_con16 ne .*/ then notEnrolledRefused=1;
		if inex_elac_this_study in (2,3) then notEnrolledStudy=1;
		if inex_con15=2 then notEnrolledConsentNA=1;
		if (enrolled ne 1 AND notEnrolledRefused ne 1) OR (inex_elac_this_study in (2,3,4) OR notEnrolledConsentNA=1 OR notEnrolledStudy=1) then notEnrolledother=1;
	end;
	if fsf_study_completed=1 then completePatient=1;
