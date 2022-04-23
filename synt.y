%{
int nb_ligne=1;
char sauvType[20];
char sauvOpe[30];
int nb_colonne=1;
char idfor1[30];
char idfor2[30];
char idfor3[30];
int ex, ex1;
char ConstValeur[5000000];
char ConstValeur2[5000000];
char TypeDec[30];
char idfSV[30];
char idfSVReel[30];
char idfSV1[30];
char TypeC[30];
char SauvOP[30];
int DiVrai;
float F;
int CompaTypeSTR;
%}

%union {
int  entier;
char* str;
float Rl;
double dbl;
}

%token mc_import pvg bib_io bib_lang err mc_public 
       mc_private mc_protected mc_class <str>idf aco_ov aco_fr
	   <str>mc_entier <str>mc_reel <str>mc_chaine vrg <str>idf_tab cr_ov cr_fm
	   <entier>cstInt mc_const afect <Rl>cstFloat <str>cstStr mc_main par_ov par_fr
	   addition soustraction division multiplication mc_for increm decrem inf sup
	   inf_egal sup_egal  different
	   mc_in 
	   mc_out
	   commentaire

%%
S: LISTE_BIB HEADER_CLASS aco_ov CORPS aco_fr{printf("\nProgramme syntaxiquement correcte.\n"); 
               YYACCEPT;        }
;

HEADER_CLASS:MODIFICATEUR mc_class idf
;

MODIFICATEUR: mc_public
             |mc_private
			 |mc_protected
			 ;
			 
CORPS:LISTE_DEC mc_main par_ov par_fr aco_ov LISTE_INSTRUCTION aco_fr
;

LISTE_DEC: DEC LISTE_DEC
          |
;

DEC: DEC_VAR
     |DEC_TAB
	 |DEC_CONST
;

DEC_VAR: TYPE LISTE_IDF pvg
;

LISTE_IDF: idf vrg LISTE_IDF{ if(doubleDeclaration($1)==0)
                                    {insererTYPE($1,sauvType);
									insererTaille($1,1);}
							  else
									printf("erreur semantique: double declaration  de %s a la ligne %d et a la colonne %d.\n",$1,nb_ligne,nb_colonne);
							}
          |idf 				{ if(doubleDeclaration($1)==0)
                                    {insererTYPE($1,sauvType);
									insererTaille($1,1);}
							  else
									printf("erreur semantique: double declaration  de %s a la ligne %d et a la colonne %d.\n",$1,nb_ligne,nb_colonne);
							}
;	

DEC_TAB: TYPE LISTE_IDF_TAB pvg
;

LISTE_IDF_TAB: idf_tab cr_ov cstInt cr_fm vrg LISTE_IDF_TAB	{ 
																if(doubleDeclaration($1)==0)
																		{insererTYPE($1,sauvType);
																		if($3<0)
																		printf("erreur semantique: taille inferieur a 0 du tableau: %s a la ligne %d et a la colonne %d.\n",$1,nb_ligne,nb_colonne);
																		else{
																		 insererTaille($1,$3);}
																		 }
																else
																	printf("erreur semantique: double declaration  de %s a la ligne %d et a la colonne %d.\n",$1,nb_ligne,nb_colonne);
																
															}
              |idf_tab cr_ov cstInt cr_fm   { 
														
																if(doubleDeclaration($1)==0)
																		{insererTYPE($1,sauvType);
																		if($3<0)
																		printf("erreur semantique: taille inferieur a 0 du tableau: %s a la ligne %d et a la colonne %d.\n",$1,nb_ligne,nb_colonne);
																		else{
																		insererTaille($1,$3);}
																		}
																else
																	printf("erreur semantique: double declaration  de %s a la ligne %d et a la colonne %d.\n",$1,nb_ligne,nb_colonne);
														
											}
;	
		  
TYPE:mc_entier {strcpy(sauvType,$1);strcpy(TypeDec,"Entier");}
    |mc_reel   {strcpy(sauvType,$1);strcpy(TypeDec,"Reel");}
	|mc_chaine {strcpy(sauvType,$1);strcpy(TypeDec,"Chaine");}
;
	
DEC_CONST : mc_const TYPE LISTE_CONST pvg
;
		 
LISTE_CONST :idf afect cstInt vrg LISTE_CONST 	{ if(ex1!=1) printf("\n ERREUR SEMANTIQUE : MANQUE DE LA BIB 'ISIL.lang' pour les expression arithmetique DANS la ligne %d et a la colonne %d\n",nb_ligne,nb_colonne);
													else{
																if(doubleDeclaration($1)==0)
																		{insererTYPE($1,sauvType);
																		if (strcmp(TypeDec,"Entier")!=0 && strcmp(TypeDec,"Reel")!=0) {printf("erreur semantique: Incompatibilte de type entre '%s' et '%d'a la ligne %d et a la colonne %d.\n",$1,$3,nb_ligne,nb_colonne); }
																		else {
																		insererTaille($1,1);
																		sprintf(ConstValeur2,"%d",$3);
																		insertConst($1,ConstValeur2);}
																		}
																else
																	printf("erreur semantique: double declaration  de %s a la ligne %d et a la colonne %d.\n",$1,nb_ligne,nb_colonne);
													}
													}
			|idf afect cstFloat vrg LISTE_CONST 	{ if(ex1!=1) printf("\n ERREUR SEMANTIQUE : MANQUE DE LA BIB 'ISIL.lang' pour les expression arithmetique DANS la ligne %d et a la colonne %d\n",nb_ligne,nb_colonne);
													else{
															if(doubleDeclaration($1)==0)
																		{insererTYPE($1,sauvType);
																		if (strcmp(TypeDec,"Reel")!=0 ) {printf("erreur semantique: Incompatibilte de type entre '%s' et '%f'a la ligne %d et a la colonne %d.\n",$1,$3,nb_ligne,nb_colonne);}
																		else {
																		insererTaille($1,1);
																		sprintf(ConstValeur2,"%f",$3);
																		insertConst($1,ConstValeur2);}
																		}
																else
																	printf("erreur semantique: double declaration  de %s a la ligne %d et a la colonne %d.\n",$1,nb_ligne,nb_colonne);
													}
													}
			|idf afect cstStr vrg LISTE_CONST 	{ if(ex1!=1) printf("\n ERREUR SEMANTIQUE : MANQUE DE LA BIB 'ISIL.lang' pour les expression arithmetique DANS la ligne %d et a la colonne %d\n",nb_ligne,nb_colonne);
													else{
																if(doubleDeclaration($1)==0)
																		{insererTYPE($1,sauvType);
																		if (strcmp(TypeDec,"Chaine")!=0) {printf("erreur semantique: Incompatibilte de type entre '%s' et '%s'a la ligne %d et a la colonne %d.\n",$1,$3,nb_ligne,nb_colonne); }
																		else {
																		insererTaille($1,1);
																		insertConst($1,$3);}
																		}
																else
																	printf("erreur semantique: double declaration  de %s a la ligne %d et a la colonne %d.\n",$1,nb_ligne,nb_colonne);
												}
												}																	
			|idf vrg LISTE_CONST				{	
																if(doubleDeclaration($1)==0)
																		{
																		insererTYPE($1,sauvType);
																		insererTaille($1,1);
																		insertConst($1,"-");
																		}
																else
																	printf("erreur semantique: double declaration  de %s a la ligne %d et a la colonne %d.\n",$1,nb_ligne,nb_colonne);
													
													}
			|idf									{ if(doubleDeclaration($1)==0)
																		{
																		insererTYPE($1,sauvType);
																		insererTaille($1,1);
																		insertConst($1,"-");
																		}
																else
																	printf("erreur semantique: double declaration  de %s a la ligne %d et a la colonne %d.\n",$1,nb_ligne,nb_colonne);
													}
			|idf afect cstInt   	{if(ex1!=1) printf("\n ERREUR SEMANTIQUE : MANQUE DE LA BIB 'ISIL.lang' pour les expression arithmetique DANS la ligne %d et a la colonne %d\n",nb_ligne,nb_colonne);
													else{
																if(doubleDeclaration($1)==0)
																		{insererTYPE($1,sauvType);
																		if (strcmp(TypeDec,"Entier")!=0 && strcmp(TypeDec,"Reel")!=0) {printf("erreur semantique: Incompatibilte de type entre '%s' et '%d'a la ligne %d et a la colonne %d.\n",$1,$3,nb_ligne,nb_colonne);}
																		else {
																		insererTaille($1,1);
																		sprintf(ConstValeur2,"%d",$3);
																		insertConst($1,ConstValeur2);}
																		}
																else
																	printf("erreur semantique: double declaration  de %s a la ligne %d et a la colonne %d.\n",$1,nb_ligne,nb_colonne);
													}
													}
			|idf afect cstFloat   	{ if(ex1!=1) printf("\n ERREUR SEMANTIQUE : MANQUE DE LA BIB 'ISIL.lang' pour les expression arithmetique DANS la ligne %d et a la colonne %d\n",nb_ligne,nb_colonne);
													else{
												if(doubleDeclaration($1)==0)
																		{insererTYPE($1,sauvType);
																		if (strcmp(TypeDec,"Reel")!=0 ) {printf("erreur semantique: Incompatibilte de type entre '%s' et '%f'a la ligne %d et a la colonne %d.\n",$1,$3,nb_ligne,nb_colonne);}
																		else {
																		insererTaille($1,1);
																		sprintf(ConstValeur2,"%f",$3);
																		insertConst($1,ConstValeur2);}
																		}
																else
																	printf("erreur semantique: double declaration  de %s a la ligne %d et a la colonne %d.\n",$1,nb_ligne,nb_colonne);
													}
													}
			|idf afect cstStr   	{ if(ex1!=1) printf("\n ERREUR SEMANTIQUE : MANQUE DE LA BIB 'ISIL.lang' pour les expression arithmetique DANS la ligne %d et a la colonne %d\n",nb_ligne,nb_colonne);
													else{if(doubleDeclaration($1)==0)
																		{insererTYPE($1,sauvType);
																		if (strcmp(TypeDec,"Chaine")!=0) {printf("erreur semantique: Incompatibilte de type entre '%s' et '%s'a la ligne %d et a la colonne %d.\n",$1,$3,nb_ligne,nb_colonne); }
																		else {
																		insererTaille($1,1);
																		insertConst($1,$3);}
																		}
																else
																	printf("erreur semantique: double declaration  de %s a la ligne %d et a la colonne %d.\n",$1,nb_ligne,nb_colonne);
									}
									}		
;

LISTE_CST : cstInt {sprintf(ConstValeur,"%d",$1);  strcpy(TypeC,"Entier"); F=$1;}
			| cstFloat {sprintf(ConstValeur,"%f",$1);  strcpy(TypeC,"Reel"); F=$1;}
			| cstStr {strcpy(ConstValeur,$1);  strcpy(TypeC,"Chaine");}
;

		 
LISTE_BIB: BIB LISTE_BIB
          |
;		  
BIB: mc_import NOM_BIB pvg
;
NOM_BIB:bib_io {ex=1;}
        |bib_lang {ex1=1;}
;

LISTE_INSTRUCTION :INSTRUCTIONS LISTE_INSTRUCTION
					|
;

INSTRUCTIONS:AFFECTATION
			|BOUCLE_FOR
			|LECTURE
			|ECRITURE	
;

AFFECTATION : VAL afect COMPOSITION pvg	{DiVrai=0;CompaTypeSTR=0;if(ex1!=1) printf("\n ERREUR SEMANTIQUE : MANQUE DE LA BIB 'ISIL.lang' pour les expression arithmetique DANS la ligne %d et a la colonne %d\n",nb_ligne,nb_colonne);}
;

COMPOSITION :VAL0 LISTE_OPE COMPOSITION 
			|VAL0 
;

VAL: idf							{ 
									strcpy(SauvOP,"RIEN"); 
									strcpy(idfSVReel ,$1);
								   strcpy( idfSV,$1);
								   if(doubleDeclaration($1)==0)
		                           printf("erreur semantique: %s non delcalrarer a la ligne %d et a la colonne %d.\n",$1,nb_ligne,nb_colonne);
								   if(ConstAVal($1)==-1)
								   {
								   printf("erreur semantique a la ligne %d et a la colonne %d, %s est une Const qui a deja une valeur.\n",nb_ligne,nb_colonne,$1);
								   }
								   }
	|TABSIMPLE
;
TABSIMPLE : idf_tab cr_ov cstInt cr_fm 	{
											 strcpy(idfSVReel ,$1);
											strcpy( idfSV,$1);
											if(doubleDeclaration($1)==0)
											printf("erreur semantique: %s non delcalrarer a la ligne %d et a la colonne %d\n",$1,nb_ligne,nb_colonne);
											if(Depassement($1,$3)==0)
											printf("erreur semantique: depasements de la taille du tableau: %s a la ligne %d et a la colonne %d.\n",$1,nb_ligne,nb_colonne);
											if($3<0)
											printf("erreur semantique: indice inferieur a 0 du tableau: %s a la ligne %d et a la colonne %d.\n",$1,nb_ligne,nb_colonne);
										}
;

VAL0: idf							{ 
									if(doubleDeclaration($1)==0)
		                          { printf("erreur semantique: %s non delcalrarer a la ligne %d et a la colonne %d.\n",$1,nb_ligne,nb_colonne); 
										if(ConstAVal(idfSV)==-1 && strcmp(SauvOP,"RIEN")!=0)
													{	
														insertConst(idfSV,"-");
													}
								  }
								   else {
								   
								   if(REComparerType2IDF(idfSV,$1)==0)
								   {
											if(ConstAVal($1)==1)
											printf("erreur semantique a la ligne %d et a la colonne %d, %s est une Const qui n'a pas de valeur.\n",nb_ligne,nb_colonne,$1);
											else{ 
												if(ConstAVal($1)==-1){
													if(ConstAValZero($1)==1 && DiVrai==1){ printf("erreur semantique: Division par '0' (La Constante %s est a 0) a la ligne %d et a la colonne %d.\n",$1,nb_ligne,nb_colonne);DiVrai=0;}
													
													if(ConstAVal(idfSV)==1)
													{
														TransfererValeur(idfSV,$1);
													}
												}
												if(ConstAVal(idfSV)==-1 && strcmp(SauvOP,"RIEN")!=0)
													{	
														insertConst(idfSV,"-");
													}
											}
								   }
								   else{
								    if(ComparerType2IDF($1,idfSV)!=0)
										{printf("erreur semantique: Incompatibilte de type entre '%s' et '%s'a la ligne %d et a la colonne %d.\n",$1,idfSV,nb_ligne,nb_colonne);CompaTypeSTR=1;}
								   else {
											if(ConstAVal($1)==1)
											printf("erreur semantique a la ligne %d et a la colonne %d, %s est une Const qui n'a pas de valeur.\n",nb_ligne,nb_colonne,$1);
											else{
												if(ConstAVal($1)==-1){
													if(ConstAValZero($1)==1 && DiVrai==1){printf("erreur semantique: Division par '0' (La Constante %s est a 0) a la ligne %d et a la colonne %d.\n",$1,nb_ligne,nb_colonne);DiVrai=0;}
													if(ConstAVal(idfSV)==1)
													{
														TransfererValeur(idfSV,$1);
													}
																								
												}
												if(ConstAVal(idfSV)==-1 && strcmp(SauvOP,"RIEN")!=0)
													{	
														insertConst(idfSV,"-");
													}
											}
										}
									  }
								   }
								   }
	|TABSIMPLE1 
	|par_ov LISTE_CST par_fr       { 
									if(REComparerType1IDF(idfSV,TypeC)!=0)
									{
									if(ComparerType1IDF(idfSV,TypeC)!=0)
									{printf("erreur semantique: Incompatibilte de type entre '%s' et '%s'a la ligne %d et a la colonne %d.\n",ConstValeur,idfSV,nb_ligne,nb_colonne);CompaTypeSTR=1;}
									else{
										if(DiVrai==1 && (strcmp(ConstValeur,"0")==0 || F==0)){printf("erreur semantique: Division par '0' a la ligne %d et a la colonne %d.\n",nb_ligne,nb_colonne);DiVrai=0;}
										if(ConstAVal(idfSV)==1)
											{
												insertConst(idfSV,ConstValeur);
											}
										if(ConstAVal(idfSV)==-1 && strcmp(SauvOP,"RIEN")!=0)
											{
												insertConst(idfSV,"-");
											}
									}
									}
									else{
									if(DiVrai==1 && (strcmp(ConstValeur,"0")==0 || F==0)){printf("erreur semantique: Division par '0' a la ligne %d et a la colonne %d.\n",nb_ligne,nb_colonne);DiVrai=0;}
									if(ConstAVal(idfSV)==1)
											{
												insertConst(idfSV,ConstValeur);
											}
										if(ConstAVal(idfSV)==-1 && strcmp(SauvOP,"RIEN")!=0)
											{
												insertConst(idfSV,"-");
											}
									}
								   }
	| LISTE_CST        				{ 
									if(REComparerType1IDF(idfSV,TypeC)!=0)
									{
									if(ComparerType1IDF(idfSV,TypeC)!=0)
									{printf("erreur semantique: Incompatibilte de type entre '%s' et '%s'a la ligne %d et a la colonne %d.\n",ConstValeur,idfSV,nb_ligne,nb_colonne);CompaTypeSTR=1;}
									else{
										if(DiVrai==1 && (strcmp(ConstValeur,"0")==0 || F==0)){printf("erreur semantique: Division par '0' a la ligne %d et a la colonne %d.\n",nb_ligne,nb_colonne);DiVrai=0;}
										if(ConstAVal(idfSV)==1)
											{
												insertConst(idfSV,ConstValeur);
											}
										if(ConstAVal(idfSV)==-1 && strcmp(SauvOP,"RIEN")!=0)
											{
												insertConst(idfSV,"-");
											}
									}
									}
									else{
									if(DiVrai==1 && (strcmp(ConstValeur,"0")==0 || F==0)){printf("erreur semantique: Division par '0' a la ligne %d et a la colonne %d.\n",nb_ligne,nb_colonne);DiVrai=0;}
									if(ConstAVal(idfSV)==1)
											{
												insertConst(idfSV,ConstValeur);
											}
										if(ConstAVal(idfSV)==-1 && strcmp(SauvOP,"RIEN")!=0)
											{
												insertConst(idfSV,"-");
											}
									}
								   }
;


TABSIMPLE1 : idf_tab cr_ov cstInt cr_fm 	{ 
											if(doubleDeclaration($1)==0)
											printf("erreur semantique: %s non delcalrarer a la ligne %d et a la colonne %d\n",$1,nb_ligne,nb_colonne);
											 else{
											if(Depassement($1,$3)==0)
											printf("erreur semantique: depasements de la taille du tableau: %s a la ligne %d et a la colonne %d.\n",$1,nb_ligne,nb_colonne);
											
											if($3<0)
											printf("erreur semantique: indice inferieur a 0 du tableau: %s a la ligne %d et a la colonne %d.\n",$1,nb_ligne,nb_colonne);
											
											if(REComparerType2IDF(idfSV,$1)!=0)
											{
											 if(ComparerType2IDF($1,idfSV)!=0)
											{printf("erreur semantique: Incompatibilte de type entre '%s' et '%s'a la ligne %d et a la colonne %d.\n",$1,idfSV,nb_ligne,nb_colonne);CompaTypeSTR=1;}
											}
											}
										}
;

TABSIMPLE2 : idf_tab cr_ov cstInt cr_fm 	{ strcpy(idfSV1,$1);
											if(doubleDeclaration($1)==0)
											printf("erreur semantique: %s non delcalrarer a la ligne %d et a la colonne %d\n",$1,nb_ligne,nb_colonne);
											 else{
											if(Depassement($1,$3)==0)
											printf("erreur semantique: depasements de la taille du tableau: %s a la ligne %d et a la colonne %d.\n",$1,nb_ligne,nb_colonne);
											if($3<0)
											printf("erreur semantique: indice inferieur a 0 du tableau: %s a la ligne %d et a la colonne %d.\n",$1,nb_ligne,nb_colonne);
											}
										}
;


LISTE_OPE:addition 	{ if(ex1!=1) printf("\n ERREUR SEMANTIQUE : MANQUE DE LA BIB 'ISIL.lang' pour les expression arithmetique DANS la ligne %d et a la colonne %d\n",nb_ligne,nb_colonne); strcpy(SauvOP,"+");
					if(ComparerType1IDF(idfSV,"Chaine")==0 && strcmp(SauvOP,"+")!=0 && CompaTypeSTR==0)   { printf("erreur semantique: Operation Aretmetique '%s' entre des Chaines de caracteres a la ligne %d et a la colonne %d.\n",SauvOP,nb_ligne,nb_colonne);CompaTypeSTR=0;}
										}		
		|soustraction {if(ex1!=1) printf("\n ERREUR SEMANTIQUE : MANQUE DE LA BIB 'ISIL.lang' (expression arithmetique) DANS la ligne %d et a la colonne %d\n",nb_ligne,nb_colonne);  strcpy(SauvOP,"-");
						if(ComparerType1IDF(idfSV,"Chaine")==0 && strcmp(SauvOP,"+")!=0 && CompaTypeSTR==0)   { printf("erreur semantique: Operation Aretmetique '%s' entre des Chaines de caracteres a la ligne %d et a la colonne %d.\n",SauvOP,nb_ligne,nb_colonne); CompaTypeSTR=0;}
						}
		|division		{DiVrai=1;
						if(ex1!=1) printf("\n ERREUR SEMANTIQUE : MANQUE DE LA BIB 'ISIL.lang' (expression arithmetique) DANS la ligne %d et a la colonne %d\n",nb_ligne,nb_colonne);  strcpy(SauvOP,"/");
						if(ComparerType1IDF(idfSV,"Chaine")==0 && strcmp(SauvOP,"+")!=0 && CompaTypeSTR==0)   { printf("erreur semantique: Operation Aretmetique '%s' entre des Chaines de caracteres a la ligne %d et a la colonne %d.\n",SauvOP,nb_ligne,nb_colonne);CompaTypeSTR=0;}
						if(ComparerType1IDF(idfSVReel,"Entier")==0)   { printf("erreur semantique: Operation de division entre des Entiers vers un entier a la ligne %d et a la colonne %d.\n",nb_ligne,nb_colonne);}
						}		
		|multiplication {if(ex1!=1) printf("\n ERREUR SEMANTIQUE : MANQUE DE LA BIB 'ISIL.lang' (expression arithmetique) DANS la ligne %d et a la colonne %d\n",nb_ligne,nb_colonne);  strcpy(SauvOP,"*");
						if(ComparerType1IDF(idfSV,"Chaine")==0 && strcmp(SauvOP,"+")!=0 && CompaTypeSTR==0)   { printf("erreur semantique: Operation Aretmetique '%s' entre des Chaines de caracteres a la ligne %d et a la colonne %d.\n",SauvOP,nb_ligne,nb_colonne);CompaTypeSTR=0;}
						}	
;

BOUCLE_FOR: mc_for par_ov INITIALISATION pvg CONDITION pvg INCREMENTATION par_fr aco_ov LISTE_INSTRUCTION aco_fr
;

INITIALISATION : idf afect cstInt 	{if(ex1!=1) printf("\n ERREUR SEMANTIQUE : MANQUE DE LA BIB 'ISIL.lang' pour les expression arithmetique DANS la ligne %d et a la colonne %d\n",nb_ligne,nb_colonne);
									else{
									if(doubleDeclaration($1)==0)
									printf("erreur semantique %s non delcalrarer a la ligne %d et a la colonne %d.\n",$1,nb_ligne,nb_colonne);
									else{
									 if(ComparerType1IDF($1,"Entier")!=0)
										printf("erreur semantique: '%s' doit etre un entier 'FOR' a la ligne %d et a la colonne %d.\n",$1,nb_ligne,nb_colonne);
										else{
												if(ConstAVal($1)==1)
														{
															printf("erreur semantique a la ligne %d et a la colonne %d, %s est une Const donc ne pas etre utiliser comme argument.\n",nb_ligne,nb_colonne,$1);
														}
										}
									}
											strcpy(idfor1,$1);											
									}		
									}
			   | idf afect TABSIMPLE2 { if(ex1!=1) printf("\n ERREUR SEMANTIQUE : MANQUE DE LA BIB 'ISIL.lang' pour les expression arithmetique DANS la ligne %d et a la colonne %d\n",nb_ligne,nb_colonne);
										else{
										if(doubleDeclaration($1)==0)
											printf("erreur semantique %s non delcalrarer a la ligne %d et a la colonne %d.\n",$1,nb_ligne,nb_colonne);
										else{
										if(ConstAVal($1)==1)
										{
											printf("erreur semantique a la ligne %d et a la colonne %d, %s est une Const donc ne pas etre utiliser comme argument.\n",nb_ligne,nb_colonne,$1);
										}
										else{
											if(ComparerType1IDF($1,"Entier")!=0)
											printf("erreur semantique: '%s' doit etre entier a la ligne %d et a la colonne %d.\n",$1,nb_ligne,nb_colonne);}
										if(doubleDeclaration(idfSV1)==0)
											printf("erreur semantique %s non delcalrarer a la ligne %d et a la colonne %d.\n",idfSV1,nb_ligne,nb_colonne);
										else{
											if(ComparerType2IDF($1,idfSV1)!=0)
											printf("erreur semantique: Incompatibilte de type entre '%s' et '%s'a la ligne %d et a la colonne %d.\n",$1,idfSV1,nb_ligne,nb_colonne);	
											}											
										
										}	strcpy(idfor1,$1);	
									 }
									}
			   | idf afect idf 		{ if(ex1!=1) printf("\n ERREUR SEMANTIQUE : MANQUE DE LA BIB 'ISIL.lang' pour les expression arithmetique DANS la ligne %d et a la colonne %d\n",nb_ligne,nb_colonne);
									else{
									if(doubleDeclaration($1)==0)
										printf("erreur semantique %s non delcalrarer a la ligne %d et a la colonne %d.\n",$1,nb_ligne,nb_colonne);
									
											strcpy(idfor1,$1);
										
									  if(doubleDeclaration($3)==0)
											printf("erreur semantique %s non delcalrarer a la ligne %d et a la colonne %d.\n",$3,nb_ligne,nb_colonne);
										
										if(ConstAVal($1)==1)
										{
										printf("erreur semantique a la ligne %d et a la colonne %d, %s est une Const donc ne pas etre utiliser comme argument.\n",nb_ligne,nb_colonne,$1);
										}	
										else{
									  if(doubleDeclaration($1)==0 )
									  {
									  printf("erreur semantique %s non delcalrarer a la ligne %d et a la colonne %d.\n",$1,nb_ligne,nb_colonne);
									  }
									  else { if (doubleDeclaration($3)==0) printf("erreur semantique %s non delcalrarer a la ligne %d et a la colonne %d.\n",$3,nb_ligne,nb_colonne);
												else {if(ComparerType1IDF($1,"Entier")!=0)
														printf("erreur semantique: '%s' doit etre entier a la ligne %d et a la colonne %d.\n",$1,nb_ligne,nb_colonne);
															else {
																if(ComparerType2IDF($1,$3)!=0)
																printf("erreur semantique: Incompatibilte de type entre '%s' et '%s'a la ligne %d et a la colonne %d.\n",$1,$3,nb_ligne,nb_colonne);}
																}
									  }
									  }
									}
 
								   }
;

CONDITION: idf OPE_COMP cstInt 		{ if(doubleDeclaration($1)==0)
									printf("erreur semantique %s non delcalrarer a la ligne %d et a la colonne %d.\n",$1,nb_ligne,nb_colonne);
									else{
									 if(ComparerType1IDF($1,"Entier")!=0)
										printf("erreur semantique: '%s' doit etre un entier 'FOR' a la ligne %d et a la colonne %d.\n",$1,nb_ligne,nb_colonne);
										else{  
												if(ConstAVal($1)!=0)
														{
															printf("erreur semantique a la ligne %d et a la colonne %d, %s est une Const donc ne pas etre utiliser comme argument.\n",nb_ligne,nb_colonne,$1);
														}
										}
									}	
											strcpy(idfor2,$1);
											
								    }
			|idf OPE_COMP TABSIMPLE2 { if(doubleDeclaration($1)==0)
											printf("erreur semantique %s non delcalrarer a la ligne %d et a la colonne %d.\n",$1,nb_ligne,nb_colonne);
										else{
										if(ConstAVal($1)!=0)
										{
											printf("erreur semantique a la ligne %d et a la colonne %d, %s est une Const donc ne pas etre utiliser comme argument.\n",nb_ligne,nb_colonne,$1);
										}
										else{
											if(ComparerType1IDF($1,"Entier")!=0)
											printf("erreur semantique: '%s' doit etre entier a la ligne %d et a la colonne %d.\n",$1,nb_ligne,nb_colonne);}
										if(doubleDeclaration(idfSV1)==0)
											printf("erreur semantique %s non delcalrarer a la ligne %d et a la colonne %d.\n",idfSV1,nb_ligne,nb_colonne);
										else{
											if(ComparerType2IDF($1,idfSV1)!=0)
											printf("erreur semantique: Incompatibilte de type entre '%s' et '%s'a la ligne %d et a la colonne %d.\n",$1,idfSV1,nb_ligne,nb_colonne);	
											}											
										
										}
											strcpy(idfor2,$1);
											
								   }
			|idf OPE_COMP idf 		{ if(doubleDeclaration($1)==0)
										printf("erreur semantique %s non delcalrarer a la ligne %d et a la colonne %d.\n",$1,nb_ligne,nb_colonne);
									
											strcpy(idfor1,$1);
										
									  if(doubleDeclaration($3)==0)
											printf("erreur semantique %s non delcalrarer a la ligne %d et a la colonne %d.\n",$3,nb_ligne,nb_colonne);
										
										if(ConstAVal($1)!=0)
										{
										printf("erreur semantique a la ligne %d et a la colonne %d, %s est une Const donc ne pas etre utiliser comme argument.\n",nb_ligne,nb_colonne,$1);
										}	
										else{
									  if(doubleDeclaration($1)==0 )
									  {
									  printf("erreur semantique %s non delcalrarer a la ligne %d et a la colonne %d.\n",$1,nb_ligne,nb_colonne);
									  }
									  else { if (doubleDeclaration($3)==0) printf("erreur semantique %s non delcalrarer a la ligne %d et a la colonne %d.\n",$3,nb_ligne,nb_colonne);
												else {if(ComparerType1IDF($1,"Entier")!=0)
														printf("erreur semantique: '%s' doit etre entier a la ligne %d et a la colonne %d.\n",$1,nb_ligne,nb_colonne);
															else {
																if(ComparerType2IDF($1,$3)!=0)
																printf("erreur semantique: Incompatibilte de type entre '%s' et '%s'a la ligne %d et a la colonne %d.\n",$1,$3,nb_ligne,nb_colonne);}
																}
									  }
									  }
 
								   }
;
 
INCREMENTATION: idf increm { if(doubleDeclaration($1)==0)
									printf("erreur semantique %s non delcalrarer a la ligne %d et a la colonne %d.\n",$1,nb_ligne,nb_colonne);
							
								strcpy(idfor3,$1);
								if(ConstAVal($1)!=0)
										{
										printf("erreur semantique a la ligne %d et a la colonne %d, %s est une Const donc ne pas etre utiliser comme argument.\n",nb_ligne,nb_colonne,$1);
										}
								
								if(VerificationFor(idfor1,idfor2,idfor3)!=0)
									printf("erreur semantique Boucle For parties:(INITIALISATION:%s,CONDITION:%s,INCREMENTATION:%s)=>Differents,a la ligne %d et a la colonne %d.\n",idfor1,idfor2,idfor3,nb_ligne,nb_colonne);
									
							 
							}
				|idf decrem { if(doubleDeclaration($1)==0)
									printf("erreur semantique %s non delcalrarer a la ligne %d et a la colonne %d.\n",$1,nb_ligne,nb_colonne);
							 
								strcpy(idfor3,$1);
								
								if(ConstAVal($1)!=0)
										{
										printf("erreur semantique a la ligne %d et a la colonne %d, %s est une Const donc ne pas etre utiliser comme argument.\n",nb_ligne,nb_colonne,$1);
										}
								
								if(VerificationFor(idfor1,idfor2,idfor3)!=0)
									printf("erreur semantique Boucle For parties:(INITIALISATION:%s,CONDITION:%s,INCREMENTATION:%s)=>Differents,a la ligne %d et a la colonne %d.\n",idfor1,idfor2,idfor3,nb_ligne,nb_colonne);
							
							}
;

OPE_COMP :inf
		  |sup
		  |inf_egal
		  |sup_egal
		  |different
;

LECTURE :mc_in par_ov  cstStr  vrg SUITE_IDF  par_fr pvg {
															ListeFormat ($3);
															if (VerificationFormatIDF()==1){printf("le nombre d'idf et de signes formatage non egale 'In',a la ligne %d et a la colonne %d.\n",nb_ligne,nb_colonne);}	
															else {if (VerificationFormatIDF()==2){printf("les idf et les signes de formatages ne se correspondent pas 'In', a la ligne %d et a la colonne %d.\n",nb_ligne,nb_colonne);}}
															Reinitialiser();
															if(ex!=1) printf("ERREUR SEMANTIQUE :MANQUE DE LA BIB 'ISIL.io' (Entree et Sortie) DANS la ligne %d et a la colonne %d.\n",nb_ligne,nb_colonne);}
;



SUITE_IDF :TABSIMPLE vrg SUITE_IDF
		  |idf vrg SUITE_IDF 		{ListeIDF($1); 								
									if(doubleDeclaration($1)==0)
										printf("erreur semantique %s non delcalrarer a la ligne %d et a la colonne %d.\n",$1,nb_ligne,nb_colonne);
								    }
		  |TABSIMPLE3
		  |idf 						{ListeIDF($1); 
									if(doubleDeclaration($1)==0)
										printf("erreur semantique %s non delcalrarer a la ligne %d et a la colonne %d.\n",$1,nb_ligne,nb_colonne);
								   }
;
TABSIMPLE3 : idf_tab cr_ov cstInt cr_fm 	{ ListeIDF($1);
											if(doubleDeclaration($1)==0)
											printf("erreur semantique: %s non delcalrarer a la ligne %d et a la colonne %d\n",$1,nb_ligne,nb_colonne);
											if(Depassement($1,$3)==0)
											printf("erreur semantique: depasements de la taille du tableau: %s a la ligne %d et a la colonne %d.\n",$1,nb_ligne,nb_colonne);
											if($3<0)
											printf("erreur semantique: indice inferieur a 0 du tableau: %s a la ligne %d et a la colonne %d.\n",$1,nb_ligne,nb_colonne);
										}
;

ECRITURE : mc_out par_ov  cstStr  vrg SUITE_IDF  par_fr pvg {
															ListeFormat ($3);
															if (VerificationFormatIDF()==1){printf("le nombre d'idf et de signes formatage non egale 'Out',a la ligne %d et a la colonne %d.\n",nb_ligne,nb_colonne);}	
															else {if (VerificationFormatIDF()==2){printf("les idf et les signes de formatages ne se correspondent pas 'Out', a la ligne %d et a la colonne %d.\n",nb_ligne,nb_colonne);}}
															Reinitialiser();
															if(ex!=1) printf("ERREUR SEMANTIQUE :MANQUE DE LA BIB 'ISIL.io' (Entree et Sortie) DANS la ligne %d et a la colonne %d\n",nb_ligne,nb_colonne);}
|mc_out par_ov cstStr par_fr pvg {if(ex!=1) printf("ERREUR SEMANTIQUE :MANQUE DE LA BIB 'ISIL.io' (Entree et Sortie) DANS la ligne %d et a la colonne %d\n",nb_ligne,nb_colonne);};
;

	
%%
main()
{yyparse();
afficher();
}
yywrap() {}

yyerror(char*msg)
{

printf("\nErreur syntaxique a la ligne %d\n",nb_ligne);
}
