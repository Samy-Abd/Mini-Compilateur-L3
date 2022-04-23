%{
#include "synt.tab.h"
extern nb_ligne;
extern YYSTYPE yylval;
#include "fonctions.h"
extern int nb_colonne;
%}
lettres [a-zA-Z]
chiffres [0-9]
INT ([+-]?{chiffres})*
FLOAT  ([+-]?{chiffres})*"."{chiffres}*
STRING  \"[^"]*\"
idf "$"{lettres}({lettres}|{chiffres}|_{lettres}|_{chiffres})*
idf_tab "@"{lettres}({lettres}|{chiffres}|_)*
COMMENTAIRE "##"[^#]*"##"


%%
import return mc_import;
ISIL.io return bib_io;
ISIL.lang return bib_lang;
{COMMENTAIRE}
public return mc_public;
private return mc_private;
protected return mc_protected;
class return mc_class;

Entier  { nb_colonne+=yyleng; yylval.str=strdup("Entier"); 
		  return mc_entier;
		}
		
Reel { nb_colonne+=yyleng; yylval.str=strdup("Reel"); 
		  return mc_reel;
	 }
	 
Chaine { nb_colonne+=yyleng; yylval.str=strdup("Chaine"); 
		  return mc_chaine;
	   }
	   
main {nb_colonne+=yyleng;return mc_main;}
CONST {nb_colonne+=yyleng; return mc_const;}
For {nb_colonne+=yyleng; return mc_for;}
In {nb_colonne+=yyleng;return mc_in;}
Out {nb_colonne+=yyleng;return mc_out;}
":=" {nb_colonne+=yyleng;return afect;}
"+" {nb_colonne+=yyleng;return addition;}
"-" {nb_colonne+=yyleng;return soustraction;}
"/"  {nb_colonne+=yyleng;return division;}
"*" {nb_colonne+=yyleng;return multiplication;}
"<" {nb_colonne+=yyleng;return inf;}
">" {nb_colonne+=yyleng;return sup;}
"<=" {nb_colonne+=yyleng;return inf_egal;}
">=" {nb_colonne+=yyleng;return sup_egal;}
"!=" {nb_colonne+=yyleng;return different;}
"++" {nb_colonne+=yyleng;return increm;}
"--" {nb_colonne+=yyleng;return decrem;}

{idf} {if(yyleng<=25) { nb_colonne+=yyleng; inserer(yytext, "idf");
                        yylval.str=strdup(yytext);
                        return idf;
					  }
            else
			printf("erreur lexical a la ligne %d,:%s idf trop long\n",nb_ligne,yytext);
		}
		
{idf_tab} { nb_colonne+=yyleng;inserer(yytext, "idf_tab");
			yylval.str=strdup(yytext);
            return idf_tab;
		  }
		  
{INT} { nb_colonne+=yyleng;yylval.entier=atoi(yytext);
             return cstInt;
	  }	  
{FLOAT} { nb_colonne+=yyleng;yylval.Rl=atof(yytext);
             return cstFloat;
	  }	 
{STRING} {nb_colonne+=yyleng; yylval.str=strdup(yytext);
             return cstStr;
	  }	
"(" {nb_colonne+=yyleng;return par_ov;}
")" {nb_colonne+=yyleng;return par_fr;}
"[" {nb_colonne+=yyleng;return cr_ov;}
"]" {nb_colonne+=yyleng;return cr_fm;}
"," {nb_colonne+=yyleng;return vrg;}
"{" {nb_colonne+=yyleng;return aco_ov;}
"}" {nb_colonne+=yyleng;return aco_fr;}
; {nb_colonne+=yyleng;return pvg;}
[ \t] 
[\n] {nb_ligne++;nb_colonne=1;}
. {printf("erreur lexicale a ligne %d sur l'entite %s\n",nb_ligne,yytext);
   return err;  }

