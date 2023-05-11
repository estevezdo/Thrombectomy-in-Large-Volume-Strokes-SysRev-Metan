*----------------------------------------------------------------*
*Name: IAT in Large Stroke Meta-analysis of RCT
*Authors: Dagoberto Estevez-Ordonez, MD and Nicholas MB Laskay, MD
*Purpose: Meta-analysis of RCT
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

*bonferroni correction (1 primary outcome + 2 secondary outcomes + 4 safety outcomes)
display r(p)
display r(p)*7

meta forestplot, random(reml) eform(Odds Ratio) insidemarker nullrefline noohomtest xscale(range(.125 8)) xlabel(#7) nullrefline(favorsleft("Favors medical treatment", size(small)) favorsright("Favors thrombectomy", size(small)))


*publication. bias

meta funnelplot, random(reml)

meta summarize, random(reml) eform(Odds Ratio)
display r(theta)
scalar theta = r(theta)
meta summarize, random(reml) eform(Odds Ratio) nostudies
display r(theta)

twoway function theta-1.96*x, horizontal range(0 0.258) || function theta+1.96*x, horizontal range(0 0.258)
local opts horizontal range(0 0.258) lpattern(dash) lcolor("red") legend(order(1 2 3 4 5 6) label(6 "95% pseudo CI"))
meta funnel, random(reml) contours(1 5 10) addplot(function theta-1.96*x, `opts' || function theta+1.96*x, `opts')


meta bias, egger random(reml)

*heterogeneity plot

meta galbraith, random(reml)

*--------------------*
*Sensitivity Analysis*
*--------------------*
preserve 
clear
frame reset

use iatLargeThrombectomyMetaAnalysis.dta

meta set logess loglci loguci, civartolerance(1e-2) studylabel(study) studysize(number) eslabel(Odds Ratio)
meta summarize, random(reml) eform(Odds Ratio)

display exp(r(theta))

display r(tau2)
*tau2 is 0.01485416 or 1.48e-2

local variances 1e-5 1e-4 1.5e-3 1.5e-2 1e-1 2e-1 5e-1 8e-1
 
frame create sens tau2 or p

frames dir
 
 foreach t2 of local variances{
 	meta summarize, tau2(`t2')
	local or = exp(r(theta))
	frame post sens (`r(tau2)') (`or') (`r(p)')
	}
	
frame sens: scatter or tau2, name(or, replace)
frame sens: scatter p tau2, name(p, replace)

restore 

************************************
**Functional Independence (mRs0-2)**
************************************

*meta analysis
meta esize iatSuccess1 iatFailure1 medicalSuccess1 medicalFailure1, esize(lnrratio) studylabel(study) eslabel(Risk ratio)

meta summarize, random(reml) eform(Risk ratio)

*bonferroni correction (1 primary outcome + 2 secondary outcomes + 4 safety outcomes)
display r(p)
display r(p)*7

meta forestplot, random(reml) eform(Risk ratio) insidemarker nullrefline noohomtest xscale(range(.125 8)) xlabel(#7) nullrefline(favorsleft("Favors medical treatment", size(small)) favorsright("Favors thrombectomy", size(small)))

*Calculating NNT, bcii a b c d (a - iat successes, b - medical therapy successes, c- iat failures, d- medical therapy failures)
bcii 119 46 388 452

*--------------------*
*Sensitivity Analysis*
*--------------------*

preserve 
clear
frame reset

use iatLargeThrombectomyMetaAnalysis.dta
meta esize iatSuccess1 iatFailure1 medicalSuccess1 medicalFailure1, esize(lnrratio) studylabel(study) eslabel(Risk ratio)
meta summarize, random(reml) eform(Risk ratio)

display exp(r(theta))

display r(tau2)
*tau2 is 2.852e-08

local variances 2.852e-08 1.5e-7 1e-5 1e-4 2e-4 5e-4 7e-4 1e-3 1.5e-3
 
frame create sens tau2 rr p

frames dir
 
 foreach t2 of local variances{
 	meta summarize, tau2(`t2')
	local rr = exp(r(theta))
	frame post sens (`r(tau2)') (`rr') (`r(p)')
	}
	
frame sens: scatter rr tau2, name(rr, replace)
frame sens: scatter p tau2, name(p, replace)

restore

***********************************
**Independent Ambulation (mRs0-3)**
***********************************

*meta analysis
meta esize iatSuccess2 iatFailure2 medicalSuccess2 medicalFailure2, esize(lnrratio) studylabel(study) eslabel(Risk ratio)

meta summarize, random(reml) eform(Risk ratio)

*bonferroni correction (1 primary outcome + 2 secondary outcomes + 4 safety outcomes)
display r(p)
display r(p)*7

meta forestplot, random(reml) eform(Risk ratio) insidemarker nullrefline noohomtest xscale(range(.125 8)) xlabel(#7) nullrefline(favorsleft("Favors medical treatment", size(small)) favorsright("Favors thrombectomy", size(small)))

*Calculating NNT, bcii a b c d (a - iat successes, b - medical therapy successes, c- iat failures, d- medical therapy failures)
bcii 206 120 301 378

*--------------------*
*Sensitivity Analysis*
*--------------------*

preserve 
clear
frame reset

use iatLargeThrombectomyMetaAnalysis.dta

meta esize iatSuccess2 iatFailure2 medicalSuccess2 medicalFailure2, esize(lnrratio) studylabel(study) eslabel(Risk ratio)
meta summarize, random(reml) eform(Risk ratio)

display exp(r(theta))

display r(tau2)
*tau2 is 0.0459

local variances 1e-5 1e-4 1.5e-3 4.6e-2 1e-1 2e-1 5e-1 8e-1
 
frame create sens tau2 rr p

frames dir
 
 foreach t2 of local variances{
 	meta summarize, tau2(`t2')
	local rr = exp(r(theta))
	frame post sens (`r(tau2)') (`rr') (`r(p)')
	}
	
frame sens: scatter rr tau2, name(rr, replace)
frame sens: scatter p tau2, name(p, replace)

restore


*******************
**Safety Outcomes**
*******************

*symptomatic ICH
meta esize iatICH_sym iatNoICH_sym medicalICH_sym medicalNoICH_sypm, esize(lnrratio) studylabel(study) eslabel(Risk ratio)

meta summarize, random(reml) eform(Risk ratio)

*bonferroni correction (1 primary outcome + 2 secondary outcomes + 4 safety outcomes)
display r(p)
display r(p)*7

meta forestplot, random(reml) eform(Risk ratio) insidemarker nullrefline noohomtest xscale(range(.125 8)) xlabel(#7) nullrefline(favorsleft("Favors medical treatment", size(small)) favorsright("Favors thrombectomy", size(small)))

*Any ICH
meta esize iatAnyICH iatNoAnyICH medicalAnyICH medicalNoAnyICH, esize(lnrratio) studylabel(study) eslabel(Risk ratio)

meta summarize, random(reml) eform(Risk ratio)

*bonferroni correction (1 primary outcome + 2 secondary outcomes + 4 safety outcomes)
display r(p)
display r(p)*7

meta forestplot, random(reml) eform(Risk ratio) insidemarker nullrefline noohomtest xscale(range(.25 4)) xlabel(#6) nullrefline(favorsleft("Favors medical treatment", size(small)) favorsright("Favors thrombectomy", size(small)))

*Death at 90 Days
meta esize iatDeath90 iatNoDeath90 medicalDeath90 medicalNoDeath90, esize(lnrratio) studylabel(study) eslabel(Risk ratio)

meta summarize, random(reml) eform(Risk ratio)

*bonferroni correction (1 primary outcome + 2 secondary outcomes + 4 safety outcomes)
display r(p)
display r(p)*7

meta forestplot, random(reml) eform(Risk ratio) insidemarker nullrefline noohomtest xscale(range(.25 4)) xlabel(#6) nullrefline(favorsleft("Favors medical treatment", size(small)) favorsright("Favors thrombectomy", size(small)))

*Decompressive Hemicraniectomy
meta esize iatDHC iatNoDHC medicalDHC medicalNoDHC, esize(lnrratio) studylabel(study) eslabel(Risk ratio)

meta summarize, random(reml) eform(Risk ratio)

*bonferroni correction (1 primary outcome + 2 secondary outcomes + 4 safety outcomes)
display r(p)
display r(p)*7

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

meta forestplot, random(reml) eform(Odds ratio) subgroup(subgroup) insidemarker nullrefline xscale(range(.25 4)) xlabel(#5) noomarker  noohetstats noohomtest noosigtest nogwhomtests nogbhomtests nullrefline(favorsleft("Favors medical treatment", size(small)) favorsright("Favors thrombectomy", size(small)))

log close
