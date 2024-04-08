/*-----------------------------------------------------------------------------------------------------------*/
/*--------------------------------------------------QUESTION 1-----------------------------------------------*/

/*Importons le fichier Panel95light.csv pour en faire une table SAS  */
PROC IMPORT DATAFILE='/home/u63824485/sasuser.v94/Panel95light.csv'
            OUT=PanelLight
            DBMS=csv
            REPLACE;
    GETNAMES=YES;
    DELIMITER=',';
    GUESSINGROWS=max;
RUN;

/*-----------------------------------------------------------------------------------------------------------*/
/*--------------------------------------------------QUESTION 2-----------------------------------------------*/
					
/*Donnons et commentons la distribution des variables lw (logarithme du salaire horaire), etudes, sexe, exper(experience
potentielle, en mois), mois (nombre de mois depuis le debut du panel, en janvier 95 */ 
	/*Statistiques descriptives des moyennes et frequences*/
proc means data=PanelLight n mean min max std;
    var lw exper mois;
run;
proc freq data=PanelLight;
    tables etudes sexe;
run;
	/*Representations graphiques des distributions*/
/*lw*/
title "Distribution du Salaire Horaire";
proc sgplot data=PanelLight;
    histogram lw / binwidth=0.1;
    xaxis label="Logarithme du Salaire Horaire";
    yaxis label="Frequence";
run;
/*etudes*/
proc sql;
    create table etudes_percent as
    select etudes, 
           count(*) as Frequency,
           (count(*) / (select count(*) from PanelLight))*100 as Percent
    from PanelLight
    group by etudes;
quit;
title "Nombre d'individus par niveau d'etude";
proc sgplot data=etudes_percent noautolegend;
    vbar etudes / response=Percent group=etudes datalabel;
    xaxis label="Niveau d'etudes";
    yaxis label="Nombre d'Observations";
run;
/*Diag. circulaire fréquence des sexes*/
title "Nombre et part d'individus par niveau d'etude";
proc gchart data=PanelLight;
	PIE etudes /percent= inside;
run;
/*sexe*/
proc sql;
    create table sexe_percent as
    select sexe, 
           count(*) as Frequency,
           (count(*) / (select count(*) from PanelLight))*100 as Percent
    from PanelLight
    group by sexe;
quit;
title "Frequence des sexes";
proc sgplot data=sexe_percent noautolegend;
    styleattrs datacolors=(pink blue);
    vbar sexe / response=Percent group=sexe datalabel;
    xaxis label="Sexe";
    yaxis label="Pourcentage (%)";
run;
/*Diag. circulaire fréquence des sexes*/
title "Frequence des sexes";
proc gchart data=PanelLight;
	PIE sexe /percent= inside;
run;

/*exper*/
title "Experience par niveau d'etude";
proc sgplot data=PanelLight;
    vbox exper / category=etudes;
    xaxis label="Niveau d'etudes";
    yaxis label="Experience (en mois)";
run;

title "Distribution de l'experience";
proc sgplot data=PanelLight;
    histogram exper / binwidth=0.1;
    xaxis label="Nombre de mois d'experience";
    yaxis label="Frequence";
run;
/*Mois*/
title "Distribution du nombre de mois";
proc sgplot data=PanelLight;
    histogram mois / binwidth=0.1;
    xaxis label="Nombre de Mois";
    yaxis label="Frequence";
run;
/*-----------------------------------------------------------------------------------------------------------*/
/*--------------------------------------------------QUESTION 3-----------------------------------------------*/

/*Generons une indicatrice pour chaque niveau d'etude et pour les sexes*/
data PanelLight;
    set PanelLight;
    if etudes = 'professionnel court' then professionnel_court = 1;
    else professionnel_court = 0;
    if etudes = 'professionnel long' then professionnel_long = 1;
    else professionnel_long = 0;
    if etudes = 'primaire' then primaire = 1; 
    else primaire = 0;
    if etudes = 'secondaire' then secondaire = 1; 
    else secondaire = 0;
    if etudes = 'deuxieme cycle' then deuxieme_cycle = 1; 
    else deuxieme_cycle = 0;
    if etudes = 'troisieme cycle' then troisieme_cycle = 1; 
    else troisieme_cycle = 0;
    if sexe = 'Homme' then sexeN = 1; else sexeN = 2;
    if sexe = 'Homme' then sexeHomme = 1; else sexeHomme = 0;
    if sexe = 'Femme' then sexeFemme = 1; else sexeFemme = 0;
run;

/*-----------------------------------------------------------------------------------------------------------*/
/*--------------------------------------------------QUESTION 4-----------------------------------------------*/

/* Calculer le log-salaire moyen de l'echantillon et le log-salaire par niveau d'etude */

title "Moyenne du log-salaire global et par niveau d'etude";
proc means data=PanelLight noprint;
    class etudes;
    var lw;
    output out=mean_salary(drop=_TYPE_ _FREQ_) mean(lw)=mean_lw;
run;

/*-----------------------------------------------------------------------------------------------------------*/
/*--------------------------------------------------QUESTION 5-----------------------------------------------*/
	/* 5a. Tous les niveaux d'etude, "sans precaution"*/
/*Remarque:->Colinearite*/
proc reg data=PanelLight;
    model lw = professionnel_court professionnel_long primaire secondaire deuxieme_cycle troisieme_cycle;
    output out=PanelLight_Predicted p=predicted_lw;
run;

	/* 5b. Tous les niveaux d'etude, sans constante*/
proc reg data=PanelLight;
    model lw = professionnel_court professionnel_long primaire secondaire deuxieme_cycle troisieme_cycle / noint;
    output out=PanelLight_Predicted p=predicted_lw;
run;	
	/* 5c. Tous les niveaux d'etude sauf primaire (reference 1)*/
proc reg data=PanelLight;
    model lw = professionnel_court professionnel_long secondaire deuxieme_cycle troisieme_cycle;
    output out=PanelLight_Predicted p=predicted_lw;
run;
	/* 5d. Tous les niveaux d'etude sauf cycle3 (reference 6)*/
proc reg data=PanelLight;
    model lw = professionnel_court professionnel_long primaire secondaire deuxieme_cycle;
    output out=PanelLight_Predicted p=predicted_lw;
run;
	/* 5e. Tous les niveaux d'etudes, en imposant la nullite de la moyenne des coefficients 
	des indicatrices, ponderee par les effectifs*/
