/*1-Importons panel95light*/
 		/* Définition de la librairie et appel de la base enregistrée dans l'exercice 1*/
libname maLib '/home/u63824485/sasuser.v94';

data panel95lightex1;
    set maLib.panel95lightex1;
run;

		/* Importation du fichier CSV dans SAS */
proc import datafile="/home/u63824485/sasuser.v94/PanelEuropeen95.csv"
	out = PanelEuropeen95_temp 
	dbms = csv
	replace;
	getnames=yes;
run;

		/* Filtrage des colonnes spécifiques de l'ensemble de données importé */
data PanelEuropeen95;
	set PanelEuropeen95_temp(keep=mident mois actif actifp actifs agea); 
run;

		/* Triage des ensembles de données par mident et mois */
proc sort data=PanelEuropeen95;
    by mident mois;
run;

proc sort data=panel95lightex1;
    by mident mois;
run;

		/* Fusion des ensembles de données triés */
proc sql;
    create table merged_panel as
    select a.*, b.*
    from panel95lightex1 as a
    inner join PanelEuropeen95 as b
    on a.mident=b.mident and a.mois=b.mois;
quit;
/* 2- Régression des actifs */
proc reg data=merged_panel;
    model actifs = professionnel_court professionnel_long primaire secondaire deuxieme_cycle troisieme_cycle;
run;

/*3- Ajout de p1reg et sigma1reg, et visualisation*/
proc reg data=merged_panel outest=reg_results;
    model actifs = professionnel_court professionnel_long primaire secondaire deuxieme_cycle troisieme_cycle;
    output out=predicted1 p=p1reg r=residuals;
run;

proc means data=predicted1;
    var residuals;
    output out=variance std=std_residuals;
run;
		/*Calcul de la variance des résidus*/
data variance;
    set variance;
    sigma1reg = std_residuals**2;
run;
		/*Ajout variance des résidus au df "merged_panel"*/
data merged_panel;
    if _N_ = 1 then set variance(keep=sigma1reg);
    set merged_panel;
    by mident mois;
    if _N_ = 1 then call symput('sigma1reg', sigma1reg);
run;
		/*Création d'un df "travail_final" à partir 
		du merge de merged_panel et predicted1*/
data travail_final;
    merge merged_panel(in=a) predicted1(keep=mident mois p1reg);
    by mident mois;
    if a;
run;

		/*Création d'un histogram pour représenter les valeurs prédites*/
proc sgplot data=travail_final;
    histogram p1reg / scale=count;
    density p1reg / type=kernel;
run;

/*4- Regression MCP*/
proc pls data=merged_panel method=pls;
    model actifs = professionnel_court professionnel_long primaire secondaire deuxieme_cycle troisieme_cycle;
run;

/*5- Créons les variables agea2 et agea3 en élevement respectivement la variable agea au carré et au cube*/
data merged_panel;
    set merged_panel; 
    agea2 = agea**2; 
    agea3 = agea**3; 
run;

/*6- Regressons les actifs sur agea, agea2, agea3 ainsi que les indicatrices d'éducation de sexe féminin*/
proc pls data=merged_panel method=pls;
    model actifs = agea agea2 agea3 professionnel_court professionnel_long primaire secondaire deuxieme_cycle troisieme_cycle sexeFemme;
quit;

/*------------------------------------QUESTION 7------------------------------------*/
		/*Regression avec récupération de p2reg*/
proc reg data=merged_panel outest=reg_results;
    model actifs = agea agea2 agea3 sexeFemme professionnel_court professionnel_long primaire secondaire deuxieme_cycle troisieme_cycle;
    output out=predicted2 p=p2reg r=residuals;
run;

		/* Visualisation de la distribution de p2reg */
proc sgplot data=predicted2;
    histogram p2reg / scale=count;
    density p2reg / type=kernel;
run;

/*8-*/
/*------------------------------------QUESTION 9a------------------------------------*/
	/*Indicatrice sexeHomme*/
		/*Regression avec récupération de p2reg1*/
proc pls data=merged_panel method=pls;
    model actifs = agea agea2 agea3 sexeHomme professionnel_court professionnel_long primaire secondaire deuxieme_cycle troisieme_cycle;
quit;

proc reg data=merged_panel outest=reg_results;
    model actifs = agea agea2 agea3 sexeHomme professionnel_court professionnel_long primaire secondaire deuxieme_cycle troisieme_cycle;
	output out=predicted21 p=p2reg1 r=residuals;
run;
		/*Visualisation de la distribution de p2reg1*/
proc sgplot data=predicted21;
    histogram p2reg1 / scale=count;
    density p2reg1 / type=kernel;
run;

/*------------------------------------QUESTION 9b------------------------------------*/
	/*Indicatrice sexeN*/
		/*Regression avec récupération de p2reg2*/
proc pls data=merged_panel method=pls;
    model actifs = agea agea2 agea3 sexeN professionnel_court professionnel_long primaire secondaire deuxieme_cycle troisieme_cycle;
quit;

proc reg data=merged_panel outest=reg_results;
    model actifs = agea agea2 agea3 sexeN professionnel_court professionnel_long primaire secondaire deuxieme_cycle troisieme_cycle;
	output out=predicted22 p=p2reg2 r=residuals;
run;
		/*Visualisation de la distribution de p2reg2*/
proc sgplot data=predicted22;
    histogram p2reg2 / scale=count;
    density p2reg2 / type=kernel;
run;

/*Importation de la df modifiée*/
libname maLib '/home/u63824485/sasuser.v94';

data maLib.merged_panelex2;
    set merged_panel;
run;
