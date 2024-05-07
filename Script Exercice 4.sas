/*-----------------------Question 1-----------------------*/
/*Chargement de la base de données depuis l'espace de stockage*/
libname maLib '/home/u63824485/sasuser.v94';

data merged_panelex3;
    set maLib.merged_panelex3;
run;

/*Modélisation Probit et Logit*/
/*Probit*/
proc logistic data=merged_panelex3;
	class sexe;
	model actifp(event='1') = lrd0 sexeFemme agea primaire secondaire 
 deuxieme_cycle professionnel_court professionnel_long / link=probit;
    title "Modèle probit expliquant l'activité principale par le revenu d'inactivité,
    l'âge et le degré de formation";
run;

/*Logit*/
proc logistic data=merged_panelex3;
	class sexe;
	model actifp(event='1') = lrd0 sexeFemme agea primaire secondaire 
 deuxieme_cycle professionnel_court professionnel_long / link=logit;
    title "Modèle logit expliquant l'activité principale par le revenu d'inactivité,
    l'âge et le degré de formation";
run;

/*------------------Question 2-----------------------*/
		/*Modéles à effets aléatoires*/
/*Modèle probit à effets aléatoires*/
proc glimmix data=merged_panelex3;
    class mident mois;
    model actifp(event='1') = lrd0 sexeFemme agea primaire secondaire 
    deuxieme_cycle professionnel_court professionnel_long / dist=binary link=probit solution;
    random int/ subject=mident;
    title "Modèle probit à effets aléatoires expliquant l'activité principale par le revenu d'inactivité,
    l'âge et le degré de formation";
run;

/*Modèle logit à effets aléatoires*/
proc glimmix data=merged_panelex3;
    class mident mois;
    model actifp(event='1') = lrd0 sexeFemme agea primaire secondaire 
    deuxieme_cycle professionnel_court professionnel_long / dist=binary link=logit solution;
    random int / subject =  mident;
    title "Modèle logit à effets aléatoires expliquant l'activité principale par le revenu d'inactivité,
    l'âge et le degré de formation";
run;

/*-----------------------Question 3-----------------------*/
		/*Modéles à effets fixes*/
/*Modèle probit à effet fixes*/
proc genmod data=merged_panelex3;
	class mident mois;
	model actifp(event='1') = lrd0 sexeFemme agea primaire secondaire 
    deuxieme_cycle professionnel_court professionnel_long
	mident / dist=binomial link=probit;
strata mident;
title "Modèle probit à effets fixes expliquant l'activité principale par le revenu d'inactivité,
    l'âge et le degré de formation";
run;

/*Modèle logit à effets fixes*/
proc genmod data=merged_panelex3;
	class mident mois;
	model actifp(event='1') = lrd0 sexeFemme agea primaire secondaire 
    deuxieme_cycle professionnel_court professionnel_long
	mident / dist=binomial link=logit;
strata mident;
title "Modèle logit à effets fixes expliquant l'activité principale par le revenu d'inactivité,
    l'âge et le degré de formation";
run;





