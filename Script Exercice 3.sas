/*----------------------------------------Question 1*/
 		/* Définition de la librairie et appel de la base "merged_panelex2" enregistrée dans l'exercice 2*/
libname maLib '/home/u63824485/sasuser.v94';

data merged_panelex2;
    set maLib.merged_panelEX2_2;
run;

/*L'exercice 1 ayant été traité, la base contient la variable 'sexeN' pour laquelle elle est prend 
comme valeur 1 si l'individu observé est un homme et 2 si l'individu observé est une femme.*/

/*----------------------------------------Question 2*/
	/*Régression actifp et actifs expliqué par sexeN */
proc reg data=merged_panelex2;
	model actifp = sexeN lrd0;
    title "Régression de actifp sur sexeN et lrd0";
run;
quit;

proc reg data=merged_panelex2;
	model actifs = sexeN lrd0;
    title "Régression de actifs sur sexeN et lrd0";
run;
quit;

	/*Régression actifp et actifs expliqué par sexeHomme */
proc reg data=merged_panelex2;
	model actifp = sexeHomme lrd0;
    title "Régression de actifp sur sexeHomme et lrd0";
run;
quit;

proc reg data=merged_panelex2;
	model actifs = sexeHomme lrd0;
    title "Régression de actifs sur sexeHomme et lrd0";
run;
quit;
	
	/*Régression actifp et actifs expliqué par sexeFemme */
proc reg data=merged_panelex2;
	model actifp = sexeFemme lrd0;
    title "Régression de actifp sur sexeFemme et lrd0";
run;
quit;

proc reg data=merged_panelex2;
	model actifs = sexeFemme lrd0;
    title "Régression de actifs sur sexeFemmeet lrd0";
run;
quit;
/*----------------------------------------Question 3*/
/*------------------------LOGIT------------------------*/
	/*Régression actifp et actifs expliqué par sexeN */

proc logistic data=merged_panelex2;
	class sexe;
	model actifp(event='1') = sexeN lrd0 / link=logit;
    title "Modèle logit de actifp sur sexeN et lrd0";
run;
quit;

proc logistic data=merged_panelex2;
	class sexe;
	model actifs(event='1') = sexeN lrd0 / link=logit;
    title "Modèle logit de actifs sur sexeN et lrd0";
run;
quit;

	/*Régression actifp et actifs expliqué par sexeHomme */
proc logistic data=merged_panelex2;
	class sexe;
	model actifp(event='1') = sexeHomme lrd0 / link=logit;
    title "Modèle logit de actifp sur sexeHomme et lrd0";
run;
quit;

proc logistic data=merged_panelex2;
	class sexe;
	model actifs(event='1') = sexeHomme lrd0 / link=logit;
    title "Modèle logit de actifs sur sexeHomme et lrd0";
run;
quit;
	
	/*Régression actifp et actifs expliqué par sexeFemme */
proc logistic data=merged_panelex2;
	class sexe;
	model actifp(event='1') = sexeFemme lrd0 / link=logit;
    title "Modèle logit de actifp sur sexeFemme et lrd0";
run;
quit;

proc logistic data=merged_panelex2;
	class sexe;
	model actifs(event='1') = sexeFemme lrd0 / link=logit;
    title "Modèle logit de actifs sur sexeFemme et lrd0";
run;
quit;


/*------------------------PROBIT------------------------*/
	/*Régression actifp et actifs expliqué par sexeN */
proc logistic data=merged_panelex2;
	class sexe;
	model actifp = sexeN lrd0 / link=probit;
    title "Modèle probit de actifp sur sexeN et lrd0";
run;
quit;

proc logistic data=merged_panelex2;
	class sexe;
	model actifs(event='1') = sexeN lrd0 / link=probit;
    title "Modèle probit de actifs sur sexeN et lrd0";
run;
quit;

	/*Régression actifp et actifs expliqué par sexeHomme */
proc logistic data=merged_panelex2;
	class sexe;
	model actifp(event='1') = sexeHomme lrd0 / link=probit;
    title "Régression de actifp sur sexeHomme et lrd0";
run;
quit;

proc logistic data=merged_panelex2;
	class sexe;
	model actifs(event='1') = sexeHomme lrd0 / link=probit;
    title "Modèle probit de actifs sur sexeHomme et lrd0";
run;
quit;
	
	/*Régression actifp et actifs expliqué par sexeFemme */
proc logistic data=merged_panelex2;
	model actifp(event='1') = sexeFemme lrd0 / link=probit;
    title "Modèle probit de actifp sur sexeFemme et lrd0";
run;
quit;

proc logistic data=merged_panelex2;
	class sexe;
	model actifs(event='1') = sexeFemme lrd0 / link=probit;
    title "Modèle probit de actifs sur sexeFemme et lrd0";
run;
quit;

/*----------------------------------------Question 4*/


/*----------------------------------------Question 5*/
		/*------LOGIT------*/
proc logistic data=merged_panelex2;
	model actifp(event='1') = lrd0 sexeFemme / link=logit;
	output out=output_actifp1 predicted=pred_actifp1;
run;

proc sgplot data=output_actifp1;
	series x=lrd0 y=pred_actifp1 / markers group=sexeFemme;
	yaxis label="Probabilité de réalisation de l'activité principale";
	xaxis label="Logarithme du revenu d'inactivité";
	keylegend / title="Sexe";
run;

proc logistic data=merged_panelex2;
	model actifs(event='1') = lrd0 sexeFemme / link=logit;
	output out=output_actifs1 predicted=pred_actifs1;
run;

proc sgplot data=output_actifs1;
	series x=lrd0 y=pred_actifs1 / markers group=sexeFemme;
	yaxis label="Probabilité de réalisation de l'activité secondaire";
	xaxis label="Logarithme du revenu d'inactivité";
	keylegend / title="Sexe";
run;

		/*------PROBIT------*/
proc logistic data=merged_panelex2;
	model actifp(event='1') = lrd0 sexeFemme / link=probit;
	output out=output_actifp2 predicted=pred_actifp2;
run;

proc sgplot data=output_actifp2;
	series x=lrd0 y=pred_actifp2 / markers group=sexeFemme;
	yaxis label="Probabilité de réalisation de l'activité principale";
	xaxis label="Logarithme du revenu d'inactivité";
	keylegend / title="Sexe";
run;

proc logistic data=merged_panelex2;
	model actifs(event='1') = lrd0 sexeFemme/ link=probit;
	output out=output_actifs2 predicted=pred_actifs2;
run;

proc sgplot data=output_actifs2;
	series x=lrd0 y=pred_actifs2 / markers group=sexeFemme;
	yaxis label="Probabilité de réalisation de l'activité secondaire";
	xaxis label="Logarithme du revenu d'inactivité";
	keylegend / title="Sexe";
run;

/*----------------------------------------Question 6*/
