data out.screenedsites (keep=study_id facilitycode redcap_data_access_group projectcode screened eligible ineligible enrolled notEnrolledRefused notEnrolledStudy notEnrolledConsentNA
	notEnrolledOther completePatient activePatient);
	merge outREDCAPData (where=redcap_event_name='baseline_arm_1' AND crf00_complete=2);
		outREDCAPData (keep=study_id fsf_study_completed fsf_study_completed fsf_study_completed fsf_study_completed);
	/*Manual override*/
	if study_id='1025' and inex_date='12Dec11'd then inex_date='12Nov12'd;
	if study_id='1007' then adjresult=1;
	if study_id='1022' then adjresult=1;
	/*Monthly/Quarterly Variables-Screen/Enrollment Summary (MT0), MT1, MT2, Enrollment Updates*/
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
	if fsf_study_completed=1 then completePatient=1; /*Monthly/Quarterly*/
	if enrolled AND fsf_study_completed not in (1,2) then activePatient=1; /*Quarterly*/
	/*Quarterly-Ineligible by reason (QT3)*/
	if ineligible=1 then do;
		if inex_inc01=0 OR v2_inex_inc01=0 then ineliAge=1;
				else ineliAge=0; /*Ineligible-Age*/
		if (inex_inc02=0 OR inex_inc02n___8=1) OR (v2_inex_inc02=0 OR v2_inex_inc02n___8=1) OR (v3_inex_inc02n___8=1) then ineliInjury=1;
				else ineliInjury=0; /*Ineligible-Injury*/
		if inex_exc04=1 then ineliGCS=1;
				else ineliGCSs=0; /*Ineligible-GCS*/
		if inex_exc05=1 OR inex_exc06=1 OR v2_inex_exc05=1 OR v2_inex_exc06=1 then ineliNonamb=1;
				else ineliNonamb=0; /*Ineligible-Nonambulatory*/
		if inex_exc07=1 OR v2_inex_exc07=1 then ineliPriorAmp=1;
				else ineliPriorAmp=0; /*Ineligible-prior amputation*/
		if inex_exc08=1 OR v2_inex_exc08=1 then ineliBurns=1;
				else ineliBurns=0; /*Ineliggible-third-degree burns*/
