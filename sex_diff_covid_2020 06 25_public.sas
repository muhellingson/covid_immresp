************************************************; 
* Sex Differences in COVID Immune Response		; 
* Longitudinal Analysis							; 							
* Last Updated: 06/25/20						; 
************************************************; 

*Imported the data us Import Wizard; 

proc contents data = work.covid3; 
run;

*Data cleaning; 

data covid2; 
	set covid3; 

	*Excluding ineligible participants; 
	if Exclusion = 1 then delete; 

	*Excluding asymptomatically infected HCW; 
	if ICU = "8" then delete; 

	*Setting NA values to missing values; 
	if Npload = "NA" then Nload = ""; 
	if Sload = "NA" then Sload = ""; 

	if AntiS1IgMA450 = "NA" then AntiS1IgMA450 = "";
	if AntiS1IgGA450 = "NA" then AntiS1IgGA450 = "";

	if IFNa2 = "NA" then IFNa2 = ""; 
	if IFNy = "NA" then IFNy = ""; 
	if IFNL2orIL28A = "NA" then IFNL2orIL28A = ""; 

	if IL1b = "NA" then IL1b = ""; 
	if IL1RA = "NA" then IL1RA = ""; 
	if IL18 = "NA" then IL18 = ""; 
	if IL6 = "NA" then IL6 = ""; 
	if IL8orCXCL8 = "NA" then IL8orCXCL8 = ""; 
	if CXCL10orIP10 = "NA" then CXCL10orIP10 = ""; 
	if CCL2orMCP1 = "NA" then CCL2orMCP1 = ""; 
	if CCL5orRANTES = "NA" then CCL5orRANTES = ""; 
	if MCSF = "NA" then MCSF = ""; 
	if CCL4orMIP1b = "NA" then CCL4orMIP1b = ""; 
	if TRAIL = "NA" then CCL4orMIP1b = ""; 
	if GCSF = "NA" then GCSF = ""; 
	if scd40l = "NA" then scd40l = ""; 
	if IL15 = "NA" then IL15 = ""; 

	if DaysfromSxOnset = "NA" then DaysfromSxOnset = ""; 
	if ICU = "NA" then ICU = ""; 

	*Formatting character variables as numeric; 
	Npload_n = input(Npload, 8.);
	Sload_n = input(Sload, 8.); 
 
	AntiS1IgMA450_n = input(AntiS1IgMA450, 8.);
	AntiS1IgGA450_n = input(AntiS1IgGA450, 8.);

	IFNa2_n = input(IFNa2, 8.); 
	IFNy_n = input(IFNy, 8.); 
	IFNL2orIL28A_n = input(IFNL2orIL28A, 8.); 

	IL1b_n = input(IL1b, 8.); 
	IL1RA_n = input(IL1RA, 8.); 
	IL18_n = input(IL18, 8.); 
	IL6_n = input(IL6, 8.); 
	IL8orCXCL8_n = input(IL8orCXCL8, 8.); 
	CXCL10orIP10_n = input(CXCL10orIP10, 8.); 
	CCL2orMCP1_n = input(CCL2orMCP1, 8.); 
	CCL5orRANTES_n = input(CCL5orRANTES, 8.); 
	MCSF_n = input(MCSF, 8.); 
	CCL4orMIP1b_n = input(CCL4orMIP1b, 8.); 
	TRAIL_n = input(TRAIL, 8.); 
	GCSF_n = input(GCSF, 8.); 
	scd40l_n = input(scd40l, 8.); 
	il15_n = input(il15, 8.); 

	DaysfromSxOnset_n = input(DaysfromSxOnset, 8.); 
	ICU_n = input(ICU, 8.); 

	drop Npload Sload AntiS1IgMA450 AntiS1IgGA450 IFNa2 IFNy IFNL2orIL28A IL1b IL1RA IL18 IL6 IL8orCXCL8 CXCL10orIP10 CCL2orMCP1 CCL5orRANTES MCSF
		CCL4orMIP1b TRAIL GCSF scd40l il15 DaysfromSxOnset ICU; 
	rename AntiS1IgMA450_n = AntiS1IgMA450
		AntiS1IgGA450_n = AntiS1IgGA450
		Npload_n = Npload
		Sload_n = Sload
		IFNa2_n = IFNa2 
		IFNy_n = IFNy
		IFNL2orIL28A_n = IFNL2orIL28A
		IL1b_n = IL1b
		IL1RA_n = IL1RA
		IL18_n = IL18
		IL6_n = IL6
		IL8orCXCL8_n = IL8orCXCL8
		CXCL10orIP10_n = CXCL10orIP10
		CCL2orMCP1_n = CCL2orMCP1
		CCL5orRANTES_n = CCL5orRANTES
		MCSF_n = MCSF
		CCL4orMIP1b_n = CCL4orMIP1b
		TRAIL_n = TRAIL
		GCSF_n = GCSF
		DaysfromSxOnset_n = DaysfromSxOnset
		ICU_n = ICU
		scd40l_n = scd40l
		il15_n = il15;	 

	*Setting up indicator variable for ICU status; 
		if ICU = 2 then in_icu = 1; 
		else if ICU = 1 then in_icu = 0; 
		else in_icu = .; 

	*Indicator variable for patient vs. HCW; 
		if hcw_or_pt = "HCW" then pt = 0; 
		else pt = 1; 

	*Setting viral load values less than threshold value to 0; 
		if npload < 3.478 then npload = 0;
		if sload < 3.478 then sload = 0; 

	*Creating categorical variable for age; 
		if age >= 65 then age_cat = 1; 
		else if age < 65 then age_cat = 0; 
run;

proc contents data = covid2; 
run;	

*******************************; 
* COVID Descriptive statistics ; 
*******************************;

*Extended Data Table: Demographic and clinical charateristics of Cohort A, Cohort B and HCW comparison groups; 

	*Cohort A demographics; 

	data covidbase_cohortA;
		set covid2;

		*Limiting just to baseline observations;  
		if tp > 1 then delete; 
	
		*Limiting to just cohort A; 
		if CohortA = 0 then delete; 
	run;

	proc freq data = covidbase_cohortA; 
		table sex sex*(ethnicity bmi_cat covidrisk_1 covidrisk_2 covidrisk_3 covidrisk_4 covidrisk_5); 
	run; 

	proc means data = covidbase_cohortA mean std; 
		class sex; 
		var age daysfromsxonset statusattest; 
	run;

	*Cohort B demographics; 
	
	data covidbase_cohortB; 
		set covid2; 

		*Limiting to baseline observations; 
		if tp > 1 then delete; 

		*Limiting to patients; 
		if pt = 0 then delete; 
	run; 

	proc freq data = covidbase_cohortB; 
		tables sex sex*(ethnicity bmi_cat covidrisk_1 covidrisk_2 covidrisk_3 covidrisk_4 covidrisk_5);
	run;

	proc means data = covidbase_cohortB mean std; 
		class sex; 
		var age daysfromsxonset statusattest; 
	run;

	data covid_cohortB; 
		set covid2; 

		*Excluding HCW; 
		if pt = 0 then delete; 
	run; 

	proc freq data = covid_cohortB; 
		tables sex*tp;
	run;

	proc freq data = covid_cohortB; 
		table newid*on_tocii;
		where sex = 1; 
	run;

	proc freq data = covid_cohortB; 
		table newid*on_tocii;
		where sex = 0; 
	run;

	proc freq data = covid_cohortB; 
		table newid*on_cs;
		where sex = 1; 
	run;

	proc freq data = covid_cohortB; 
		table newid*on_cs;
		where sex = 0; 
	run;

	proc freq data = covid_cohortB; 
		table newid*in_icu;
		where sex = 1; 
	run;

	proc freq data = covid_cohortB; 
		table newid*in_icu;
		where sex = 0; 
	run;

	*HCW w/ ELISA data demographics; 

	data covidbase_HCWELISA;
		set covid2;

		*Limiting to baseline observations; 
		if tp > 1 then delete; 

		*Limiting just to HCW; 
		if pt = 1 then delete;

		*Limiting to just those with ELISA data; 
		if IFNa2 = . then delete; 

	run;


	proc freq data = covidbase_HCWELISA; 
		tables sex sex*(ethnicity bmi_cat);
	run;

	proc means data = covidbase_HCWELISA mean std; 
		class sex; 
		var age; 
	run;

	data covid_HCWELISA; 
		set covid2; 

		*Limiting to HCW; 
		if pt = 1 then delete; 

		*Limiting to HCW w/ ELISA data; 
		if IFNa2 = . then delete; 
	run; 

	proc freq data = covid_HCWELISA; 
		table sex*tp; 
	run;

	*HCW w/ FACS data demographics; 

	data covidbase_HCWFACS; 
		set covid2;  

		*Limiting to just baseline observations; 
		if tp > 1 then delete; 

		*Limiting just to HCW; 
		if pt = 1 then delete; 

		*Limiting to just HCW with FACS data; 
		if CD8TofCD3 = . then delete; 

	run;

	proc freq data = covidbase_HCWFACS; 
		tables sex sex*(ethnicity bmi_cat);
	run;

	proc means data = covidbase_HCWFACS mean std; 
		class sex; 
		var age; 
	run;

	data covid_HCWFACS; 
		set covid2; 

		*Limiting to HCW; 
		if pt = 1 then delete; 

		*Limting to those with FACS data; 
		if CD8TofCD3 = . then delete; 
	run; 

	proc freq data = covid_HCWFACS; 
		table sex*tp; 
	run;

*********************************************************************; 
* Calculating Time-Varying Propensity Scores    					 ; 
*********************************************************************; 

*Time dependent propensity scores, with age in the propensity score; 

proc logistic data= covid_cohortB descending;
model sex = age daysfromsxonset BMI on_tocii on_cs in_icu;
output out= est_prob p= ps;
run; 

*Time dependent propensity scores, without age (age as independent effect); 
proc logistic data = covid_cohortB descending; 
model sex = daysfromsxonset BMI on_tocii on_cs in_icu; 
output out = est_prob2 p = ps; 
run; 

**********************************************************; 
* Longitudinal Analysis with Time-Varying Propensity Score;
**********************************************************; 

*Marginal Linear Model, AR1 Correlation structure; 

*Extended Data Table: Adjusted least square means difference in immune response between male and female COVID-19 patients in Cohort B; 
	*(With age in the propensity score); 

*Viral Load; 

proc glimmix data=est_prob method=rspl empirical=mbn; 
	class newid tp sex (ref = "0"); 
	model Npload = sex ps/s ddfm=contain cl; 
	random tp / residual type=ar(1) subject=newid v vcorr; 
	lsmeans sex/cl; 
run;

proc glimmix data=est_prob method=rspl empirical=mbn; 
	class newid tp sex (ref = "0"); 
	model Sload = sex ps/s ddfm=contain cl; 
	random tp / residual type=ar(1) subject=newid v vcorr;
	lsmeans sex /cl; 
run;

*Antibody; 

proc glimmix data=est_prob method=rspl empirical=mbn; 
	class newid tp sex (ref = "0"); 
	model AntiS1IgGA450 = sex ps/s ddfm=contain cl; 
	random tp / residual type=ar(1) subject=newid v vcorr; 
	lsmeans sex /cl;
run;

proc glimmix data=est_prob method=rspl empirical=mbn; 
	class newid tp sex (ref = "0"); 
	model AntiS1IgMA450 = sex ps/s ddfm=contain cl; 
	random tp / residual type=ar(1) subject=newid v vcorr;
	lsmeans sex /cl; 
run;

 *Interferon Response;
 
proc glimmix data=est_prob method=rspl empirical=mbn; 
	class newid tp sex (ref = "0"); 
	model IFNa2 = sex ps/s ddfm=contain cl; 
	random tp / residual type=ar(1) subject=newid v vcorr;
	lsmeans sex/cl; 
run;

proc glimmix data=est_prob method=rspl empirical=mbn; 
	class newid tp sex (ref = "0"); 
	model IFNL2orIL28A = sex ps/s ddfm=contain cl; 
	random tp / residual type=ar(1) subject=newid v vcorr; 
	lsmeans sex/cl;
run;

proc glimmix data=est_prob method=rspl empirical=mbn; 
	class newid tp sex (ref = "0"); 
	model IFNy = sex ps/s ddfm=contain cl; 
	random tp / residual type=ar(1) subject=newid v vcorr;
run;

*Cytokines; 

proc glimmix data=est_prob method=rspl empirical=mbn; 
	class newid tp sex (ref = "0"); 
	model CCL2orMCP1 = sex ps/s ddfm=contain cl; 
	random tp / residual type=ar(1) subject=newid v vcorr; 
	lsmeans sex/cl;
run;

proc glimmix data=est_prob method=rspl empirical=mbn; 
	class newid tp sex (ref = "0"); 
	model CCL5orRANTES = sex ps/s ddfm=contain cl; 
	random tp / residual type=ar(1) subject=newid v vcorr; 
	lsmeans sex/cl; 
run;

proc glimmix data=est_prob method=rspl empirical=mbn; 
	class newid tp sex (ref = "0"); 
	model MCSF = sex ps/s ddfm=contain cl; 
	random tp / residual type=ar(1) subject=newid v vcorr;
	lsmeans sex/cl; 
run;

proc glimmix data=est_prob method=rspl empirical=mbn; 
	class newid tp sex (ref = "0"); 
	model TRAIL = sex ps/s ddfm=contain cl; 
	random tp / residual type=ar(1) subject=newid v vcorr;
	lsmeans sex/cl; 
run;

proc glimmix data=est_prob method=rspl empirical=mbn; 
	class newid tp sex (ref = "0"); 
	model IL8orCXCL8 = sex ps/s ddfm=contain cl; 
	random tp / residual type=ar(1) subject=newid v vcorr; 
run;

proc glimmix data=est_prob method=rspl empirical=mbn; 
	class newid tp sex (ref = "0"); 
	model IL18 = sex ps/s ddfm=contain cl; 
	random tp / residual type=ar(1) subject=newid v vcorr;
run;

proc glimmix data=est_prob method=rspl empirical=mbn; 
	class newid tp sex (ref = "0"); 
	model CCL4orMIP1b = sex ps/s ddfm=contain cl; 
	random tp / residual type=ar(1) subject=newid v vcorr;
run;

proc glimmix data=est_prob method=rspl empirical=mbn; 
	class newid tp sex (ref = "0"); 
	model GCSF = sex ps/s ddfm=contain cl; 
	random tp / residual type=ar(1) subject=newid v vcorr;
run;

proc glimmix data=est_prob method=rspl empirical=mbn; 
	class newid tp sex (ref = "0"); 
	model CXCL10orIP10 = sex ps/s ddfm=contain cl; 
	random tp / residual type=ar(1) subject=newid v vcorr;
run;

proc glimmix data=est_prob method=rspl empirical=mbn; 
	class newid tp sex (ref = "0"); 
	model IL6 = sex ps/s ddfm=contain cl; 
	random tp / residual type=ar(1) subject=newid v vcorr;
run;

proc glimmix data=est_prob method=rspl empirical=mbn; 
	class newid tp sex (ref = "0"); 
	model IL1Ra = sex ps/s ddfm=contain cl; 
	random tp / residual type=ar(1) subject=newid v vcorr;
run;

proc glimmix data=est_prob method=rspl empirical=mbn; 
	class newid tp sex (ref = "0"); 
	model Il1b = sex ps/s ddfm=contain cl; 
	random tp / residual type=ar(1) subject=newid v vcorr;
run;

*PBMC Composition;
*As percent of live cells;  

proc glimmix data=est_prob method=rspl empirical=mbn; 
	class newid tp sex (ref = "0"); 
	model Tnum = sex ps/s ddfm=contain cl; 
	random tp / residual type=ar(1) subject=newid v vcorr;
run;

proc glimmix data=est_prob method=rspl empirical=mbn; 
	class newid tp sex (ref = "0"); 
	model Bnum = sex ps/s ddfm=contain cl; 
	random tp / residual type=ar(1) subject=newid v vcorr;
run;

proc glimmix data=est_prob method=rspl empirical=mbn; 
	class newid tp sex (ref = "0"); 
	model Tcellsoflive = sex ps/s ddfm=contain cl; 
	random tp / residual type=ar(1) subject=newid v vcorr; 
run;

proc glimmix data=est_prob method=rspl empirical=mbn; 
	class newid tp sex (ref = "0"); 
	model BcellsofLive = sex ps/s ddfm=contain cl; 
	random tp / residual type=ar(1) subject=newid v vcorr;
run;

proc glimmix data=est_prob method=rspl empirical=mbn; 
	class newid tp sex (ref = "0"); 
	model TotalMonoofLive = sex ps/s ddfm=contain cl; 
	random tp / residual type=ar(1) subject=newid v vcorr; 
run;

proc glimmix data=est_prob method=rspl empirical=mbn; 
	class newid tp sex (ref = "0"); 
	model ncMonoofLive = sex ps/s ddfm=contain cl; 
	random tp / residual type=ar(1) subject=newid v vcorr; 
run;

proc glimmix data=est_prob method=rspl empirical=mbn; 
	class newid tp sex (ref = "0"); 
	model intMonoofLive = sex ps/s ddfm=contain cl; 
	random tp / residual type=ar(1) subject=newid v vcorr;
run;

proc glimmix data=est_prob method=rspl empirical=mbn; 
	class newid tp sex (ref = "0"); 
	model cMonoofLive = sex ps/s ddfm=contain cl; 
	random tp / residual type=ar(1) subject=newid v vcorr; 
run;

*As proportion of CD3 cells; 

proc glimmix data=est_prob method=rspl empirical=mbn; 
	class newid tp sex (ref = "0"); 
	model CD8TofCD3 = sex ps/s ddfm=contain cl; 
	random tp / residual type=ar(1) subject=newid v vcorr; 
run;

proc glimmix data=est_prob method=rspl empirical=mbn; 
	class newid tp sex (ref = "0"); 
	model CD4TofCD3 = sex ps/s ddfm=contain cl; 
	random tp / residual type=ar(1) subject=newid v vcorr; 
run;

proc glimmix data=est_prob method=rspl empirical=mbn; 
	class newid tp sex (ref = "0"); 
	model CD4TCRactofCD3 = sex ps/s ddfm=contain cl; 
	random tp / residual type=ar(1) subject=newid v vcorr; 
run;

proc glimmix data=est_prob method=rspl empirical=mbn; 
	class newid tp sex (ref = "0"); 
	model CD8TCRactofCD3 = sex ps/s ddfm=contain cl; 
	random tp / residual type=ar(1) subject=newid v vcorr; 
run;

proc glimmix data=est_prob method=rspl empirical=mbn; 
	class newid tp sex (ref = "0"); 
	model CD8TexofCD3 = sex ps/s ddfm=contain cl; 
	random tp / residual type=ar(1) subject=newid v vcorr; 
run;

proc glimmix data=est_prob method=rspl empirical=mbn; 
	class newid tp sex (ref = "0"); 
	model CD4TexofCD3 = sex ps/s ddfm=contain cl; 
	random tp / residual type=ar(1) subject=newid v vcorr; 
run;

*****************************************************; 
* Patient vs. Healthcare worker analysis			 ; 
*****************************************************; 

*Extended data table: Adjust least square means difference in immune response between female and male COVID-19 patients and HCW; 

*Marginal Linear Model, CS Correlation structure; 

*Antibody response; 

proc glimmix data=covid2 method=rspl empirical=mbn; 
	class newid tp pt (ref= "0") sex (ref = "0"); 
	model AntiS1IgGA450 = sex pt age BMI sex*pt/s ddfm=contain cl; 
	random tp / residual type=cs subject=newid v vcorr;
	lsmeans sex*pt /diff = all cl adjust = tukey;  
run;

proc glimmix data=covid2 method=rspl empirical=mbn; 
	class newid tp pt (ref= "0") sex (ref = "0"); 
	model AntiS1IgMA450 = sex pt age BMI sex*pt/s ddfm=contain cl; 
	random tp / residual type=cs subject=newid v vcorr;
	lsmeans sex*pt /diff = all cl adjust = tukey;  
run;

*Type I or Type III Interferon Response;

proc glimmix data=covid2 method=rspl empirical=mbn; 
	class newid tp pt (ref= "0") sex (ref = "0"); 
	model IFNa2 = sex pt age BMI sex*pt/s ddfm=contain cl; 
	random tp / residual type=cs subject=newid v vcorr;
	lsmeans sex*pt /diff = all cl adjust = tukey;  
run;

proc glimmix data=covid2 method=rspl empirical=mbn; 
	class newid tp pt (ref= "0") sex (ref = "0"); 
	model IFNL2orIL28A = sex pt age BMI sex*pt/s ddfm=contain cl; 
	random tp / residual type=cs subject=newid v vcorr;
	lsmeans sex*pt /diff = all cl adjust = tukey;  
run;

proc glimmix data=covid2 method=rspl empirical=mbn; 
	class newid tp pt (ref= "0") sex (ref = "0"); 
	model IFNy = sex pt age BMI sex*pt/s ddfm=contain cl; 
	random tp / residual type=cs subject=newid v vcorr;
	lsmeans sex*pt /diff = all cl adjust = tukey;  
run;

*Cytokines; 

proc glimmix data=covid2 method=rspl empirical=mbn; 
	class newid tp pt (ref= "0") sex (ref = "0"); 
	model CCL2orMCP1 = sex pt age BMI sex*pt/s ddfm=contain cl; 
	random tp / residual type=cs subject=newid v vcorr;
	lsmeans sex*pt /diff = all cl adjust = tukey;  
run;

proc glimmix data=covid2 method=rspl empirical=mbn; 
	class newid tp pt (ref= "0") sex (ref = "0"); 
	model CCL5orRANTES = sex pt age BMI sex*pt/s ddfm=contain cl; 
	random tp / residual type=cs subject=newid v vcorr;
	lsmeans sex*pt /diff = all cl adjust = tukey;  
run;

proc glimmix data=covid2 method=rspl empirical=mbn; 
	class newid tp pt (ref= "0") sex (ref = "0"); 
	model MCSF = sex pt age BMI sex*pt/s ddfm=contain cl; 
	random tp / residual type=cs subject=newid v vcorr;
	lsmeans sex*pt /diff = all cl adjust = tukey;  
run;

proc glimmix data=covid2 method=rspl empirical=mbn; 
	class newid tp pt (ref= "0") sex (ref = "0"); 
	model TRAIL = sex pt age BMI sex*pt/s ddfm=contain cl; 
	random tp / residual type=cs subject=newid v vcorr;
	lsmeans sex*pt /diff = all cl adjust = tukey;  
run;

proc glimmix data=covid2 method=rspl empirical=mbn; 
	class newid tp pt (ref= "0") sex (ref = "0"); 
	model IL8orCXCL8 = sex pt age BMI sex*pt/s ddfm=contain cl; 
	random tp / residual type=cs subject=newid v vcorr;
	lsmeans sex*pt /diff = all cl adjust = tukey;  
run;

proc glimmix data=covid2 method=rspl empirical=mbn; 
	class newid tp pt (ref= "0") sex (ref = "0"); 
	model IL18 = sex pt age BMI sex*pt/s ddfm=contain cl; 
	random tp / residual type=cs subject=newid v vcorr;
	lsmeans sex*pt /diff = all cl adjust = tukey;  
run;

proc glimmix data=covid2 method=rspl empirical=mbn; 
	class newid tp pt (ref= "0") sex (ref = "0"); 
	model CCL4orMIP1b = sex pt age BMI sex*pt/s ddfm=contain cl; 
	random tp / residual type=cs subject=newid v vcorr;
	lsmeans sex*pt /diff = all cl adjust = tukey;  
run;

proc glimmix data=covid2 method=rspl empirical=mbn; 
	class newid tp pt (ref= "0") sex (ref = "0"); 
	model IL1RA = sex pt age BMI sex*pt/s ddfm=contain cl; 
	random tp / residual type=cs subject=newid v vcorr;
	lsmeans sex*pt /diff = all cl adjust = tukey;  
run;

proc glimmix data=covid2 method=rspl empirical=mbn; 
	class newid tp pt (ref= "0") sex (ref = "0"); 
	model IL6 = sex pt age BMI sex*pt/s ddfm=contain cl; 
	random tp / residual type=cs subject=newid v vcorr;
	lsmeans sex*pt /diff = all cl adjust = tukey;  
run;

proc glimmix data=covid2 method=rspl empirical=mbn; 
	class newid tp pt (ref= "0") sex (ref = "0"); 
	model IL1b = sex pt age BMI sex*pt/s ddfm=contain cl; 
	random tp / residual type=cs subject=newid v vcorr;
	lsmeans sex*pt /diff = all cl adjust = tukey;  
run;

proc glimmix data=covid2 method=rspl empirical=mbn; 
	class newid tp pt (ref= "0") sex (ref = "0"); 
	model CXCL10orIP10 = sex pt age BMI sex*pt/s ddfm=contain cl; 
	random tp / residual type=cs subject=newid v vcorr;
	lsmeans sex*pt /diff = all cl adjust = tukey;  
run;

proc glimmix data=covid2 method=rspl empirical=mbn; 
	class newid tp pt (ref= "0") sex (ref = "0"); 
	model GCSF = sex pt age BMI sex*pt/s ddfm=contain cl; 
	random tp / residual type=cs subject=newid v vcorr;
	lsmeans sex*pt /diff = all cl adjust = tukey;  
run;


*TCell Phenotypes; 

proc glimmix data=covid2 method=rspl empirical=mbn; 
	class newid tp pt (ref= "0") sex (ref = "0"); 
	model CD8TofCD3 = sex pt age BMI sex*pt/s ddfm=contain cl; 
	random tp / residual type=cs subject=newid v vcorr;
	lsmeans sex*pt /diff = all cl adjust = tukey;  
run;

proc glimmix data=covid2 method=rspl empirical=mbn; 
	class newid tp pt (ref= "0") sex (ref = "0"); 
	model CD4TofCD3 = sex pt age BMI sex*pt/s ddfm=contain cl; 
	random tp / residual type=cs subject=newid v vcorr;
	lsmeans sex*pt /diff = all cl adjust = tukey;  
run;

proc glimmix data=covid2 method=rspl empirical=mbn; 
	class newid tp pt (ref= "0") sex (ref = "0"); 
	model CD4TCRactofCD3 = sex pt age BMI sex*pt/s ddfm=contain cl; 
	random tp / residual type=cs subject=newid v vcorr;
	lsmeans sex*pt /diff = all cl adjust = tukey;  
run;

proc glimmix data=covid2 method=rspl empirical=mbn; 
	class newid tp pt (ref= "0") sex (ref = "0"); 
	model CD8TCRactofCD3 = sex pt age BMI sex*pt/s ddfm=contain cl; 
	random tp / residual type=cs subject=newid v vcorr;
	lsmeans sex*pt /diff = all cl adjust = tukey;  
run;

proc glimmix data=covid2 method=rspl empirical=mbn; 
	class newid tp pt (ref= "0") sex (ref = "0"); 
	model CD8TexofCD3 = sex pt age BMI sex*pt/s ddfm=contain cl; 
	random tp / residual type=cs subject=newid v vcorr;
	lsmeans sex*pt /diff = all cl adjust = tukey;  
run;

proc glimmix data=covid2 method=rspl empirical=mbn; 
	class newid tp pt (ref= "0") sex (ref = "0"); 
	model CD4TexofCD3 = sex pt age BMI sex*pt/s ddfm=contain cl; 
	random tp / residual type=cs subject=newid v vcorr;
	lsmeans sex*pt /diff = all cl adjust = tukey;  
run;

*PBMC Composition; 

proc glimmix data=covid2 method=rspl empirical=mbn; 
	class newid tp pt (ref= "0") sex (ref = "0"); 
	model Tnum = sex pt age BMI sex*pt/s ddfm=contain cl; 
	random tp / residual type=cs subject=newid v vcorr;
	lsmeans sex*pt /diff = all cl adjust = tukey;  
run;

proc glimmix data=covid2 method=rspl empirical=mbn; 
	class newid tp pt (ref= "0") sex (ref = "0"); 
	model Bnum = sex pt age BMI sex*pt/s ddfm=contain cl; 
	random tp / residual type=cs subject=newid v vcorr;
	lsmeans sex*pt /diff = all cl adjust = tukey;  
run;

proc glimmix data=covid2 method=rspl empirical=mbn; 
	class newid tp pt (ref= "0") sex (ref = "0"); 
	model Tcellsoflive = sex pt age BMI sex*pt/s ddfm=contain cl; 
	random tp / residual type=cs subject=newid v vcorr;
	lsmeans sex*pt /diff = all cl adjust = tukey;  
run;

proc glimmix data=covid2 method=rspl empirical=mbn; 
	class newid tp pt (ref= "0") sex (ref = "0"); 
	model Bcellsoflive = sex pt age BMI sex*pt/s ddfm=contain cl; 
	random tp / residual type=cs subject=newid v vcorr;
	lsmeans sex*pt /diff = all cl adjust = tukey;  
run;

proc glimmix data=covid2 method=rspl empirical=mbn; 
	class newid tp pt (ref= "0") sex (ref = "0"); 
	model ncMonoofLive = sex pt age BMI sex*pt/s ddfm=contain cl; 
	random tp / residual type=cs subject=newid v vcorr;
	lsmeans sex*pt /diff = all cl adjust = tukey;  
run;

proc glimmix data=covid2 method=rspl empirical=mbn; 
	class newid tp pt (ref= "0") sex (ref = "0"); 
	model cMonoofLive = sex pt age BMI sex*pt/s ddfm=contain cl; 
	random tp / residual type=cs subject=newid v vcorr;
	lsmeans sex*pt /diff = all cl adjust = tukey;  
run;

proc glimmix data=covid2 method=rspl empirical=mbn; 
	class newid tp pt (ref= "0") sex (ref = "0"); 
	model intMonoofLive = sex pt age BMI sex*pt/s ddfm=contain cl; 
	random tp / residual type=cs subject=newid v vcorr;
	lsmeans sex*pt /diff = all cl adjust = tukey;  
run;

proc glimmix data=covid2 method=rspl empirical=mbn; 
	class newid tp pt (ref= "0") sex (ref = "0"); 
	model TotalMonoofLive = sex pt age BMI sex*pt/s ddfm=contain cl; 
	random tp / residual type=cs subject=newid v vcorr;
	lsmeans sex*pt /diff = all cl adjust = tukey;  
run;


*Extended Data Table - Adjusted least square means difference between Cohort A female and male COVID-19 patients 
and HCW controls at baseline;

*Linear regression, Tukey correction for multiple comparisons; 

data covid5; 
	set covid4; 

	*Just baseline; 
	if tp > 1 then delete; 
run; 


*Antibody response; 

proc glimmix data=covid5; 
	class newid pt (ref= "0") sex (ref = "0"); 
	model AntiS1IgGA450 = sex pt age BMI sex*pt/cl; 
	lsmeans sex*pt /diff = all cl adjust = tukey;  
run;

proc glimmix data=covid5; 
	class newid pt (ref= "0") sex (ref = "0"); 
	model AntiS1IgMA450 = sex pt age BMI sex*pt/cl; 
	lsmeans sex*pt /diff = all cl adjust = tukey;  
run;

*Type I or Type III Interferon Response;

proc glimmix data=covid5; 
	class newid pt (ref= "0") sex (ref = "0"); 
	model IFNa2 = sex pt age BMI sex*pt/cl; 
	lsmeans sex*pt /diff = all cl adjust = tukey;  
run;

proc glimmix data=covid5; 
	class newid pt (ref= "0") sex (ref = "0"); 
	model IFNy = sex pt age BMI sex*pt/cl; 
	lsmeans sex*pt /diff = all cl adjust = tukey;  
run;

proc glimmix data=covid5; 
	class newid pt (ref= "0") sex (ref = "0"); 
	model IFNL2orIL28A = sex pt age BMI sex*pt/cl; 
	lsmeans sex*pt /diff = all cl adjust = tukey;  
run;

*Cytokines; 

proc glimmix data=covid5; 
	class newid pt (ref= "0") sex (ref = "0"); 
	model CCL2orMCP1 = sex pt age BMI sex*pt/cl; 
	lsmeans sex*pt /diff = all cl adjust = tukey;  
run;

proc glimmix data=covid5; 
	class newid pt (ref= "0") sex (ref = "0"); 
	model CCL5orRANTES = sex pt age BMI sex*pt/cl; 
	lsmeans sex*pt /diff = all cl adjust = tukey;  
run;

proc glimmix data=covid5; 
	class newid pt (ref= "0") sex (ref = "0"); 
	model MCSF = sex pt age BMI sex*pt/cl; 
	lsmeans sex*pt /diff = all cl adjust = tukey;  
run;

proc glimmix data=covid5; 
	class newid pt (ref= "0") sex (ref = "0"); 
	model TRAIL = sex pt age BMI sex*pt/cl; 
	lsmeans sex*pt /diff = all cl adjust = tukey;  
run;

proc glimmix data=covid5; 
	class newid pt (ref= "0") sex (ref = "0"); 
	model IL8orCXCL8 = sex pt age BMI sex*pt/cl; 
	lsmeans sex*pt /diff = all cl adjust = tukey;  
run;


proc glimmix data=covid5; 
	class newid pt (ref= "0") sex (ref = "0"); 
	model IL18 = sex pt age BMI sex*pt/cl; 
	lsmeans sex*pt /diff = all cl adjust = tukey;  
run;

proc glimmix data=covid5; 
	class newid pt (ref= "0") sex (ref = "0"); 
	model CCL4orMIP1b = sex pt age BMI sex*pt/cl; 
	lsmeans sex*pt /diff = all cl adjust = tukey;  
run;


proc glimmix data=covid5; 
	class newid pt (ref= "0") sex (ref = "0"); 
	model IL1RA = sex pt age BMI sex*pt/cl; 
	lsmeans sex*pt /diff = all cl adjust = tukey;  
run;

proc glimmix data=covid5; 
	class newid pt (ref= "0") sex (ref = "0"); 
	model IL6 = sex pt age BMI sex*pt/cl; 
	lsmeans sex*pt /diff = all cl adjust = tukey;  
run;

proc glimmix data=covid5; 
	class newid pt (ref= "0") sex (ref = "0"); 
	model IL1b = sex pt age BMI sex*pt/cl; 
	lsmeans sex*pt /diff = all cl adjust = tukey;  
run;

proc glimmix data=covid5; 
	class newid pt (ref= "0") sex (ref = "0"); 
	model CXCL10orIP10 = sex pt age BMI sex*pt/cl; 
	lsmeans sex*pt /diff = all cl adjust = tukey;  
run;

proc glimmix data=covid5; 
	class newid pt (ref= "0") sex (ref = "0"); 
	model GCSF = sex pt age BMI sex*pt/cl; 
	lsmeans sex*pt /diff = all cl adjust = tukey;  
run;

*TCell Phenotypes; 

proc glimmix data=covid5; 
	class newid pt (ref= "0") sex (ref = "0"); 
	model CD8TofCD3 = sex pt age BMI sex*pt/cl; 
	lsmeans sex*pt /diff = all cl adjust = tukey;  
run;

proc glimmix data=covid5; 
	class newid pt (ref= "0") sex (ref = "0"); 
	model CD4TofCD3 = sex pt age BMI sex*pt/cl; 
	lsmeans sex*pt /diff = all cl adjust = tukey;  
run;

proc glimmix data=covid5; 
	class newid pt (ref= "0") sex (ref = "0"); 
	model CD4TCRactofCD3 = sex pt age BMI sex*pt/cl; 
	lsmeans sex*pt /diff = all cl adjust = tukey;  
run;

proc glimmix data=covid5; 
	class newid pt (ref= "0") sex (ref = "0"); 
	model CD8TCRactofCD3 = sex pt age BMI sex*pt/cl; 
	lsmeans sex*pt /diff = all cl adjust = tukey;  
run;

proc glimmix data=covid5; 
	class newid pt (ref= "0") sex (ref = "0"); 
	model CD8TexofCD3 = sex pt age BMI sex*pt/cl; 
	lsmeans sex*pt /diff = all cl adjust = tukey;  
run;

proc glimmix data=covid5; 
	class newid pt (ref= "0") sex (ref = "0"); 
	model CD4TexofCD3 = sex pt age BMI sex*pt/cl; 
	lsmeans sex*pt /diff = all cl adjust = tukey;  
run;

*PBMC Composition; 

proc glimmix data=covid5; 
	class newid pt (ref= "0") sex (ref = "0"); 
	model Tnum = sex pt age BMI sex*pt/cl; 
	lsmeans sex*pt /diff = all cl adjust = tukey;  
run;

proc glimmix data=covid5; 
	class newid pt (ref= "0") sex (ref = "0"); 
	model Bnum = sex pt age BMI sex*pt/cl; 
	lsmeans sex*pt /diff = all cl adjust = tukey;  
run;

proc glimmix data=covid5; 
	class newid pt (ref= "0") sex (ref = "0"); 
	model Tcellsoflive = sex pt age BMI sex*pt/cl; 
	lsmeans sex*pt /diff = all cl adjust = tukey;  
run;

proc glimmix data=covid5; 
	class newid pt (ref= "0") sex (ref = "0"); 
	model Bcellsoflive = sex pt age BMI sex*pt/cl; 
	lsmeans sex*pt /diff = all cl adjust = tukey;  
run;

proc glimmix data=covid5; 
	class newid pt (ref= "0") sex (ref = "0"); 
	model ncMonoofLive = sex pt age BMI sex*pt/cl; 
	lsmeans sex*pt /diff = all cl adjust = tukey;  
run;

proc glimmix data=covid5; 
	class newid pt (ref= "0") sex (ref = "0"); 
	model cMonoofLive = sex pt age BMI sex*pt/cl; 
	lsmeans sex*pt /diff = all cl adjust = tukey;  
run;

proc glimmix data=covid5; 
	class newid pt (ref= "0") sex (ref = "0"); 
	model intMonoofLive = sex pt age BMI sex*pt/cl; 
	lsmeans sex*pt /diff = all cl adjust = tukey;  
run;

proc glimmix data=covid5; 
	class newid pt (ref= "0") sex (ref = "0"); 
	model TotalMonoofLive = sex pt age BMI sex*pt/cl; 
	lsmeans sex*pt /diff = all cl adjust = tukey;  
run;

*********************************************; 
* Patient Trajectory Analysis				 ; 
*********************************************; 

*Imported data using Import Wizard;
*See data management code for details on dataset used. All data will be publicly available and details on how patient
trajectory was determined is included in the manuscript;  

proc contents data = covid_traj; 
run;

*Extend data table: Adjusted least square means difference between female and male patients based on disease trajectory; 
*Adjusted for age and days from symptom onset, limited to cohort A; 

proc glimmix data=covid_traj; 
	class sex (ref = "0") status_traj (ref = "0"); 
	model CD8IFNyofCD3 = sex status_traj sex*status_traj age daysfromsxonset/cl; 
	lsmeans sex*status_traj / diff = all cl adjust = tukey;  
run;

proc glimmix data=covid_traj; 
	class sex (ref = "0") status_traj (ref = "0"); 
	model CD8TCRactofCD3 = sex status_traj sex*status_traj age daysfromsxonset/cl; 
	lsmeans sex*status_traj / diff = all cl adjust = tukey;  
run;

proc glimmix data=covid_traj; 
	class sex (ref = "0") status_traj (ref = "0"); 
	model CD4TCRactofCD3 = sex status_traj sex*status_traj age daysfromsxonset/cl; 
	lsmeans sex*status_traj / diff = all cl adjust = tukey;  
run;

proc glimmix data=covid_traj; 
	class sex (ref = "0") status_traj (ref = "0"); 
	model CD4TexofCD3 = sex status_traj sex*status_traj age daysfromsxonset/cl; 
	lsmeans sex*status_traj / diff = all cl adjust = tukey;  
run;

proc glimmix data=covid_traj; 
	class sex (ref = "0") status_traj (ref = "0"); 
	model CD8TexofCD3 = sex status_traj sex*status_traj age daysfromsxonset/cl; 
	lsmeans sex*status_traj / diff = all cl adjust = tukey;  
run;

proc glimmix data=covid_traj; 
	class sex (ref = "0") status_traj (ref = "0"); 
	model ncMonooflive = sex status_traj sex*status_traj age daysfromsxonset/cl; 
	lsmeans sex*status_traj / diff = all cl adjust = tukey;  
run;

proc glimmix data=covid_traj; 
	class sex (ref = "0") status_traj (ref = "0"); 
	model CXCL10orIP10 = sex status_traj sex*status_traj age daysfromsxonset/cl; 
	lsmeans sex*status_traj / diff = all cl adjust = tukey;  
run;

proc glimmix data=covid_traj; 
	class sex (ref = "0") status_traj (ref = "0"); 
	model MCSF = sex status_traj sex*status_traj age daysfromsxonset/cl; 
	lsmeans sex*status_traj / diff = all cl adjust = tukey;  
run;

proc glimmix data=covid_traj; 
	class sex (ref = "0") status_traj (ref = "0"); 
	model TRAIL = sex status_traj sex*status_traj age daysfromsxonset/cl; 
	lsmeans sex*status_traj / diff = all cl adjust = tukey;  
run;

proc glimmix data=covid_traj; 
	class sex (ref = "0") status_traj (ref = "0"); 
	model IL8orCXCL8 = sex status_traj sex*status_traj age daysfromsxonset/cl; 
	lsmeans sex*status_traj / diff = all cl adjust = tukey;  
run;

proc glimmix data=covid_traj; 
	class sex (ref = "0") status_traj (ref = "0"); 
	model IL18 = sex status_traj sex*status_traj age daysfromsxonset/cl; 
	lsmeans sex*status_traj / diff = all cl adjust = tukey;  
run;

proc glimmix data=covid_traj; 
	class sex (ref = "0") status_traj (ref = "0"); 
	model sCD40L = sex status_traj sex*status_traj age daysfromsxonset/cl; 
	lsmeans sex*status_traj / diff = all cl adjust = tukey;  
run;

proc glimmix data=covid_traj; 
	class sex (ref = "0") status_traj (ref = "0"); 
	model ccl5orRANTES = sex status_traj sex*status_traj age daysfromsxonset/cl; 
	lsmeans sex*status_traj / diff = all cl adjust = tukey;  
run;

proc glimmix data=covid_traj; 
	class sex (ref = "0") status_traj (ref = "0"); 
	model il15 = sex status_traj sex*status_traj age daysfromsxonset/cl; 
	lsmeans sex*status_traj / diff = all cl adjust = tukey;  
run;
