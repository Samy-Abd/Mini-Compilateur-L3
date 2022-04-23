

// je vais commencer a programmer ma table de symbole
 //1-decalration
 #include <stdlib.h>
		typedef struct
		{
		char NomEntite[20];
		char CodeEntite[20];
		char TypeEntite[20];
		int  TailleEntite;
		char ConsON[20];
		char Valeur[5000000] ;
		} TypeTS;
		
		typedef struct Elmnt Elmnt;
		struct Elmnt
		{
			TypeTS TS;
			Elmnt *suivant;
		};
		
		typedef struct
		{
		char Signe[20];
		char Type[20];
		char Idf[20];
		} TabFormat;
		
		typedef struct
		{
		char idf[20];
		char Type[20];
		} IdfFormat;
		
		TabFormat TF[100];
		IdfFormat idfFormat[100];
		int cpm1=0;
		int cpm2=0;
		
		
		
		Elmnt *tete=NULL;
		Elmnt *act=NULL;
		//initiation d'la liste
		  
		

		 	
	
  //2- definir une fonction recherche
	Elmnt *recherche(char entite[])
		{

		Elmnt *actuel = tete;
	
		while (actuel != NULL)
		{	
			
			if(strcmp(actuel->TS.NomEntite,entite)==0)
			{
				return actuel;
			}
			actuel = actuel->suivant;
		}
		
		return NULL;
		
		}
		
  //3-définir la fonction inserer
  void inserer(char entite[], char code[])
	{
		
		
		if(tete==NULL){
		tete = malloc(sizeof(*tete));
		
		if (tete == NULL)
		{
         printf("tete a NULL(init)");
		}
		strcpy((*tete).TS.NomEntite,entite);
		strcpy((*tete).TS.CodeEntite,code);
		strcpy(tete->TS.TypeEntite,"");
		strcpy(tete->TS.Valeur,"-");
		strcpy(tete->TS.ConsON,"Non");
		tete->TS.TailleEntite=1;
		tete->suivant = NULL;
		act=tete;
		}
		else{
			if ( recherche(entite)==NULL)
			{	
				Elmnt *nouveau = malloc(sizeof(*nouveau));
				if ( nouveau == NULL)
				{
				printf(" nouveau a  NULL(inserer)");
				}
				strcpy(nouveau->TS.NomEntite,entite);
				strcpy(nouveau->TS.CodeEntite,code);
				strcpy(nouveau->TS.TypeEntite,"");
				strcpy(nouveau->TS.Valeur,"-");
				strcpy(nouveau->TS.ConsON,"Non");
				nouveau->TS.TailleEntite=1;
				
				nouveau->suivant = NULL;
				act->suivant= nouveau;
				act =act->suivant;
			}
		}
	
	}
  //4-définir la fonction afficher
	  void afficher ()
	{
		
		Elmnt *actuel = tete;
	printf("\n/***********************************Table des symboles **********************************/\n");
	printf("____________________________________________________________________________________________\n");
	printf("\t| NomEntite |  CodeEntite | TyepEntite   |  TailleEntite  |  constO/N   |Valeur      |\n");
	printf("____________________________________________________________________________________________\n");
	int i=0;
	  while(actuel != NULL)
	  {
		printf("\t|%10s |%12s | %12s | %12d  |%12s |%12s|\n",actuel->TS.NomEntite,actuel->TS.CodeEntite,actuel->TS.TypeEntite,actuel->TS.TailleEntite,actuel->TS.ConsON,actuel->TS.Valeur);
		 actuel = actuel->suivant;
	   }
	}
	
	void afficher2(){
		int i =0;
		printf("cpm1 = %d et cpm2= %d\n",cpm1,cpm2);
		for (i=0;i<cpm1;i++){
		printf("////truc liste format %s \n",TF[i].Type);
		}
		i= cpm2-1;
		while(i>=0){
		printf("****le truc des idf %s\n",idfFormat[i].idf);
		i--;
		}
		
	}
	
	//5-définir une focntion pour inserer le type
	
	 void insererTYPE(char entite[], char type[])
	{
		 
       Elmnt *pos=malloc(sizeof(*pos));
	   pos=recherche(entite);
	   
	if(pos!=NULL)
	   strcpy(pos->TS.TypeEntite,type); 

	}
	
    //6- definir une focntion qui detecte la double declaration
	int doubleDeclaration(char entite[])
	{
	 Elmnt *pos=malloc(sizeof(*pos));
	 pos=recherche(entite);
	if(strcmp(pos->TS.TypeEntite,"")==0) {return 0;}
	  else return -1; 
	}
	
	//7- Inserer Val Constante
	void insertConst(char entite[] , char valeur[])
	{
		Elmnt *pos=NULL;
		pos=recherche(entite);
		if(pos!=NULL){
		strcpy(pos->TS.ConsON,"Oui");
		strcpy( pos->TS.Valeur,valeur);}

	}
	
	void TransfererValeur(char entite1[],char entite2[])
	{	
		Elmnt *pos1=NULL;
		pos1=recherche(entite1);
		Elmnt *pos2=NULL;
		pos2=recherche(entite2);
		if(pos1 !=NULL && pos2!=NULL)
		{
			strcpy( pos1->TS.Valeur,pos2->TS.Valeur);
		}

	}
	
	//8- verifier la constante :
	int ConstAVal(char entite[]){

	Elmnt *pos=NULL;
	pos=recherche(entite);
       if (strcmp(pos->TS.ConsON,"Non")==0) return 0 ;
       else
		{
		if   (strcmp(pos->TS.Valeur,"-")==0) return 1 ;
			else return -1;
		}  
	}
	
	int ConstAValZero(char entite[]){
	Elmnt *pos=NULL;
	pos=recherche(entite);
	if(pos!=NULL)
		{
		
       if (strcmp(pos->TS.ConsON,"Oui")==0 && (strcmp(pos->TS.Valeur,"0")==0 || strcmp(pos->TS.Valeur,"0.000000")==0) ) return 1;
		else return -1;
		}	
	}
//9- Comparer Type entre 2 idf :
	int ComparerType2IDF(char entite1[],char entite2[]) 
	{   
		Elmnt *pos1=NULL;
		pos1=recherche(entite1);
		Elmnt *pos2=NULL;
		pos2=recherche(entite2);
		if(pos1 !=NULL && pos2!=NULL)
		{
			if (strcmp(pos1->TS.TypeEntite,pos2->TS.TypeEntite)==0) return 0; 
		}
		return -1;	
	}
	
	int REComparerType2IDF(char entite1[],char entite2[]) 
	{   
		Elmnt *pos1=NULL;
		pos1=recherche(entite1);
		Elmnt *pos2=NULL;
		pos2=recherche(entite2);
		if(pos1 !=NULL && pos2!=NULL)
		{
			if (strcmp(pos1->TS.TypeEntite,"Reel")==0 && strcmp(pos2->TS.TypeEntite,"Entier")==0) return 0; 
		}
		return -1;	
	}
	
	
	
//10- Comparer Type entre idf et entier:
	int ComparerType1IDF(char entite1[],char Type[]) 
	{   
		Elmnt *pos=NULL;
		pos=recherche(entite1);
		if(pos !=NULL)
		{
			if (strcmp(pos->TS.TypeEntite,Type)==0) return 0; 
		}
		return -1;	
	}	
	
	int REComparerType1IDF(char entite1[],char Type[]) 
	{   
		Elmnt *pos=NULL;
		pos=recherche(entite1);
		if(pos !=NULL)
		{
			if (strcmp(pos->TS.TypeEntite,"Reel")==0 && strcmp(Type,"Entier")==0) return 0; 
		}
		return -1;	
	}	
	
	
	
	//11- Verifier taille tableau:
	int Depassement(char entite[], int taille)
{
		Elmnt *pos=NULL;
		pos=recherche(entite);
		if(pos!=NULL){
			if(pos->TS.TailleEntite<taille) return 0;
		}
	return -1;
}
//12- inserer taille:
	void insererTaille(char entite[], int taille)
{
       Elmnt *pos=malloc(sizeof(*pos));
	   pos=recherche(entite);
	if(pos!=NULL)
	  pos->TS.TailleEntite=taille; 	
}
//13- Verifier idf de For:
int VerificationFor(char val1[],char val2[],char val3[])
{
	 if(strcmp(val1,val2)==0 && strcmp(val1,val3)==0 )  return 0;
	 return -1;
}

void ListeFormat (char* chaine){
		int taille = strlen(chaine);
		int i=0;
		for (i=0;i<taille;i++){
			if((chaine[i]=='%')&&(chaine[i+1]=='d')){strcpy(TF[cpm1].Signe,"%d");strcpy(TF[cpm1].Type,"Entier");cpm1++;}
			if((chaine[i]=='%')&&(chaine[i+1]=='f')){strcpy(TF[cpm1].Signe,"%f");strcpy(TF[cpm1].Type,"Reel");cpm1++;} 
			if((chaine[i]=='%')&&(chaine[i+1]=='s')){strcpy(TF[cpm1].Signe,"%s");strcpy(TF[cpm1].Type,"Chaine");cpm1++;}

		}
	
}

void ListeIDF(char nom[]){
	strcpy(idfFormat[cpm2].idf,nom);

	cpm2++;
	
}
void Reinitialiser()
{
	int i=0;
	for (i=0;i<cpm2;i++){
		free(idfFormat+i);
	}
	for (i=0;i<cpm1;i++){
		free(TF+i);
	}
	cpm1=0;
	cpm2=0;
}


int VerificationFormatIDF(){
	if (cpm1!=cpm2){
		return 1;
	}
	int i=0;
	int j=cpm2-1;
	char c1 [20];
	char c2 [20];
	Elmnt *e = NULL;
		while(i<cpm1 && j>=0){
			e = recherche(idfFormat[j].idf);
				if (e!=NULL){
					strcpy (c1,e->TS.TypeEntite);
					strcpy (c2,TF[i].Type);
					if (strcmp(c1,c2)==0){
						j--;
						i++;
				}else{
					return 2;
				}
			}
		}
	return 0;
}
