winsor2 lev roe top1 profit board Separation cash lngdp,  cuts(1 99)
***Descriptive statistics****
sum2docx tfp_op lniudpatent lngdp_w lev_w roe_w top1_w profit_w board_w state_ownd Separation_w cash_w lngdp_w  using  Descriptive_statistics.docx,replace stats(N mean(%9.4f) sd min(%9.4f) median(%9.4f) max(%9.4f))  title("Table 1: 描述统计")
qui sum profit_w
replace profit_w=(profit_w-r(min))/(r(max)-r(min))
qui sum cash_w
replace cash_w=(cash_w-r(min))/(r(max)-r(min))
******Baseline******
reghdfe tfp_op lniudpatent, absorb( id year)
est store a1
reghdfe tfp_op lniudpatent lev_w, absorb( id year)
est store a2
reghdfe tfp_op lniudpatent lev_w profit_w roe_w, absorb( id year)
est store a3
reghdfe tfp_op lniudpatent lev_w profit_w roe_w cash_w, absorb( id year)
est store a4
reghdfe tfp_op lniudpatent lev_w profit_w roe_w cash_w top1_w  board_w state_ownd Separation_w, absorb( id year)
est store a5
reghdfe tfp_op lniudpatent lev_w profit_w roe_w cash_w top1_w board_w state_ownd Separation_w lngdp_w, absorb( id year)
est store a6
esttab a1 a2 a3 a4 a5 a6 using Baseline.rtf,replace b(%12.3f) t(%12.3f)  nogap compress s(N r2) star(* 0.1 ** 0.05 *** 0.01)

***Robustness checks***
*xtset id year
*reghdfe tfp_op L.lniudpatent L.lev_w L.roe_w L.top1_w L.profit_w L.board_w L.state_ownd L.Separation_w L.cash_w L.lngdp_w, absorb( id year)
reghdfe lp lniudpatent lev_w roe_w top1_w profit_w board_w state_ownd Separation_w cash_w lngdp_w, absorb( id year)
est store a1
reghdfe tfp_ols lniudpatent lev_w roe_w top1_w profit_w board_w state_ownd Separation_w cash_w lngdp_w, absorb( id year)
est store a2
reghdfe tfp_fe lniudpatent lev_w roe_w top1_w profit_w board_w state_ownd Separation_w cash_w lngdp_w, absorb( id year)
est store a3
reghdfe lnNum_cpatent lniudpatent lev_w roe_w top1_w profit_w board_w state_ownd Separation_w cash_w lngdp_w, absorb( id year)
est store a4
reghdfe tfp_op lniupatent lev_w roe_w top1_w profit_w board_w state_ownd Separation_w cash_w lngdp_w, absorb( id year)
est store a5
drop if province == "北京" | province == "上海" | province == "深圳" | province == "广州" | province == "杭州"
reghdfe tfp_op lniudpatent lev_w roe_w top1_w profit_w board_w state_ownd Separation_w cash_w lngdp_w, absorb( id year)
est store a6
esttab a1 a2 a3 a4 a5 a6 using Robustness_checks.rtf,replace b(%12.3f) t(%12.3f)  nogap compress s(N r2) star(* 0.1 ** 0.05 *** 0.01)
*********

*****Endophytism*****
gl Y tfp_op
gl X lev_w roe_w top1_w profit_w board_w state_ownd Separation_w cash_w lngdp_w  i.id i.year
gl D lniudpatent 
set seed 10086
ddml init partial, kfolds(5)
ddml E[D|X]: pystacked $D $X, type(reg) method(rf)
ddml E[Y|X]: pystacked $Y $X, type(reg) method(rf)
ddml crossfit
ddml estimate, robust
gen iv1=lniudpatent*MingPost
ivreghdfe tfp_op lev_w roe_w top1_w profit_w board_w state_ownd Separation_w cash_w lngdp_w (lniudpatent=iv1) , absorb(year id)  first
gen iv2=lniudpatent*Hangdistance
ivreghdfe tfp_op lev_w roe_w top1_w profit_w board_w state_ownd Separation_w cash_w lngdp_w (lniudpatent=iv2) , absorb(year id)  first
********************

***Moderating mechanism analysis***
gen lnfinreg=log(finreg)
center lnfinreg
center lniudpatent
gen cross1=c_lnfinreg*c_lniudpatent
reghdfe tfp_op lniudpatent lnfinreg cross1, absorb(year id)
est store a1
reghdfe tfp_op lniudpatent lnfinreg cross1 lev_w roe_w top1_w profit_w board_w state_ownd Separation_w cash_w lngdp_w, absorb(year id)
est store a2
gen lndig=log(dig+1)
center lndig
gen cross2=c_lndig*c_lniudpatent
reghdfe tfp_op lniudpatent lndig cross2, absorb(year id)
est store a3
reghdfe tfp_op lniudpatent lndig cross2 lev_w roe_w top1_w profit_w board_w state_ownd Separation_w cash_w lngdp_w, absorb(year id)
est store a4
esttab a1 a2 a3 a4 using Moderating_mechanism_analysis.rtf,replace b(%12.3f) t(%12.3f)  nogap compress s(N r2) star(* 0.1 ** 0.05 *** 0.01)
***************
***Heterogeneity analysis***
gen region = .
replace region = 0 if province == "北京" | province == "天津" | province == "河北" | province == "上海" | province == "江苏" | province == "浙江" | province == "福建" | province == "山东" | province == "广东" | province == "海南"
replace region =1 if province == "山西" | province == "安徽" | province == "江西" | province == "河南" | province == "湖北" | province == "湖南"
replace region = 2 if province == "内蒙古" | province == "广西" | province == "重庆" | province == "四川" | province == "贵州" | province == "云南" | province == "西藏" | province == "陕西" | province == "甘肃" |  province == "青海" | province == "宁夏" | province == "新疆"
replace region =3 if province == "辽宁" | province == "吉林" | province == "黑龙江"
egen size_median=median(marcap)
reghdfe tfp_op lniudpatent lev_w roe_w top1_w profit_w board_w state_ownd Separation_w cash_w lngdp_w if  state_ownd==1, absorb(year id)
est store a1
reghdfe tfp_op lniudpatent lev_w roe_w top1_w profit_w board_w state_ownd Separation_w cash_w lngdp_w if  state_ownd==0, absorb(year id)
est store a2
reghdfe tfp_op lniudpatent lev_w roe_w top1_w profit_w board_w state_ownd Separation_w cash_w lngdp_w if  marcap>=size_median, absorb(year id)
est store a3
reghdfe tfp_op lniudpatent lev_w roe_w top1_w profit_w board_w state_ownd Separation_w cash_w lngdp_w if  marcap<size_median, absorb(year id)
est store a4
reghdfe tfp_op lniudpatent lev_w roe_w top1_w profit_w board_w state_ownd Separation_w cash_w lngdp_w if  region==0, absorb(year id)
est store a5
reghdfe tfp_op lniudpatent lev_w roe_w top1_w profit_w board_w state_ownd Separation_w cash_w lngdp_w if  region==1, absorb(year id)
est store a6
reghdfe tfp_op lniudpatent lev_w roe_w top1_w profit_w board_w state_ownd Separation_w cash_w lngdp_w if  region==2, absorb(year id)
est store a7
reghdfe tfp_op lniudpatent lev_w roe_w top1_w profit_w board_w state_ownd Separation_w cash_w lngdp_w if  region==3, absorb(year id)
est store a8
esttab a1 a2 a3 a4 a5 a6 a7 a8 using Heterogeneity_analysis.rtf,replace b(%12.3f) t(%12.3f)  nogap compress s(N r2) star(* 0.1 ** 0.05 *** 0.01)
*****************