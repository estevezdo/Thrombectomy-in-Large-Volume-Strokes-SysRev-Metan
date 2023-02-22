*----------------------------------------------------------------*
*Name: IAT in Large Stroke Meta-analysis of RCT
*Authors: Dagoberto Estevez-Ordonez, MD and Nicholas MB Laskay, MD
*Purpose: Meta-analysis of RCT
*Date: 2/19/2023
*STATA17
*----------------------------------------------------------------*

capture log close
clear
set more off

***Start using log ****	
log using "/Thrombectomy SysRev/iatLargeStrokeMetaA.log", replace

*----------------------------------------------------------------*
*Name: IAT in Large Stroke Meta-analysis of RCT
*Authors: Dagoberto Estevez-Ordonez, MD and Nicholas MB Laskay, MD
*Purpose: Meta-analysis of RCT
*----------------------------------------------------------------*

***************************************************
***************INPUT DATA**************************
***************************************************
import excel "/Thrombectomy SysRev/iatLargeThrombectomyMetaAnalysis.xlsx", sheet("main outcomes") firstrow

gen logess= log(essOR)
gen loguci= log(uciOR)
gen loglci= log(lciOR)

save "/Thrombectomy SysRev/iatLargeThrombectomyMetaAnalysis.dta", replace

***************************************************
******************ANALYSIS*************************
***************************************************


****************
**Shift in mRs**
****************
*setup
meta set logess loglci loguci, civartolerance(1e-2) studylabel(study) studysize(number) eslabel(Odds Ratio)

*meta analysis
meta summarize, random(reml) eform(Odds Ratio)

meta forestplot, random(reml) eform(Odds Ratio) insidemarker nullrefline noohomtest xscale(range(.125 8)) xlabel(#7) nullrefline(favorsleft("Favors medical treatment", size(small)) favorsright("Favors thrombectomy", size(small)))

*publication. bias
meta funnelplot, random(reml)

meta bias, egger random(reml)

*heterogeneity plot

meta galbraith, random(reml)

************************************
**Functional Independence (mRs0-2)**
************************************

*meta analysis
meta esize iatSuccess1 iatFailure1 medicalSuccess1 medicalFailure1, esize(lnrratio) studylabel(study) eslabel(Risk ratio)

meta summarize, random(reml) eform(Risk ratio)

meta forestplot, random(reml) eform(Risk ratio) insidemarker nullrefline noohomtest xscale(range(.125 8)) xlabel(#7) nullrefline(favorsleft("Favors medical treatment", size(small)) favorsright("Favors thrombectomy", size(small)))

***********************************
**Independent Ambulation (mRs0-3)**
***********************************

*meta analysis
meta esize iatSuccess2 iatFailure2 medicalSuccess2 medicalFailure2, esize(lnrratio) studylabel(study) eslabel(Risk ratio)

meta summarize, random(reml) eform(Risk ratio)

meta forestplot, random(reml) eform(Risk ratio) insidemarker nullrefline noohomtest xscale(range(.125 8)) xlabel(#7) nullrefline(favorsleft("Favors medical treatment", size(small)) favorsright("Favors thrombectomy", size(small)))


*******************
**Safety Outcomes**
*******************

*symptomatic ICH
meta esize iatICH_sym iatNoICH_sym medicalICH_sym medicalNoICH_sypm, esize(lnrratio) studylabel(study) eslabel(Risk ratio)

meta summarize, random(reml) eform(Risk ratio)

meta forestplot, random(reml) eform(Risk ratio) insidemarker nullrefline noohomtest xscale(range(.125 8)) xlabel(#7) nullrefline(favorsleft("Favors medical treatment", size(small)) favorsright("Favors thrombectomy", size(small)))


*Any ICH
meta esize iatAnyICH iatNoAnyICH medicalAnyICH medicalNoAnyICH, esize(lnrratio) studylabel(study) eslabel(Risk ratio)

meta summarize, random(reml) eform(Risk ratio)

meta forestplot, random(reml) eform(Risk ratio) insidemarker nullrefline noohomtest xscale(range(.25 4)) xlabel(#6) nullrefline(favorsleft("Favors medical treatment", size(small)) favorsright("Favors thrombectomy", size(small)))

*Death at 90 Days
meta esize iatDeath90 iatNoDeath90 medicalDeath90 medicalNoDeath90, esize(lnrratio) studylabel(study) eslabel(Risk ratio)

meta summarize, random(reml) eform(Risk ratio)

meta forestplot, random(reml) eform(Risk ratio) insidemarker nullrefline noohomtest xscale(range(.25 4)) xlabel(#6) nullrefline(favorsleft("Favors medical treatment", size(small)) favorsright("Favors thrombectomy", size(small)))

*Decompressive Hemicraniectomy
meta esize iatDHC iatNoDHC medicalDHC medicalNoDHC, esize(lnrratio) studylabel(study) eslabel(Risk ratio)

meta summarize, random(reml) eform(Risk ratio)

meta forestplot, random(reml) eform(Risk ratio) insidemarker nullrefline noohomtest xscale(range(.25 4)) xlabel(#6) nullrefline(favorsleft("Favors medical treatment", size(small)) favorsright("Favors thrombectomy", size(small)))

*-------------------*
**Subgroup Analysis**
*-------------------*

clear

import excel "/Thrombectomy SysRev/iatLargeThrombectomyMetaAnalysis.xlsx", sheet("subgroup") firstrow

drop if subgroup==.

label define subgroup_ 1 "Time from stroke onset to randomization <6 hours" 2 "Time from stroke onset to randomization ≥6 hours" 3 "ICA" 4 "MCA" 5 "Core Volume <70 mL" 6 "Core Volume ≥70 mL" 7 "ASPECTS <3" 8 "ASPECTS ≥3"
label values subgroup subgroup_

gen logess= log(essOR)
gen loguci= log(uciOR)
gen loglci= log(lciOR)

save "/Thrombectomy SysRev/iatLargeThrombectomyMetaAnalysis_subgroup.dta", replace

*setup
meta set logess loglci loguci, civartolerance(1e-1) studylabel(study) studysize(number) eslabel(Odds Ratio)

*meta analysis 
meta summarize, random(reml) subgroup(subgroup) eform(Odds ratio)


meta forestplot, random(reml) subgroup(subgroup)  noomarker  noohetstats noohomtest noosigtest

meta forestplot, random(reml) eform(Odds ratio) subgroup(subgroup) insidemarker nullrefline xscale(range(.25 4)) meta forestplot, random(reml) eform(Odds ratio) subgroup(subgroup) insidemarker nullrefline xscale(range(.25 4)) xlabel(#5) noomarker  noohetstats noohomtest noosigtest nogwhomtests nogbhomtests nullrefline(favorsleft("Favors medical treatment", size(small)) favorsright("Favors thrombectomy", size(small)))
log close
