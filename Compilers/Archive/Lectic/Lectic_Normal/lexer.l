%{
#include<math.h>
#include<string.h>
%}

  int other=0,k=0,z=0,chok=0,countlines=1; // prwto meros, dhlwseis
  int esc = -1;
  int est = -1;
HX [0-9]|[a-f]
digit		[0-9]
letter		[A-Za-z]
ID	({letter}+)({letter}|{digit}|_)*
%x C_COMMENT
%x L_COMMENT
%x S_STRING
%x CHARACTER 
%x E_CHARACTER
%% 

"/*"            { printf("Multi-Line Comment %s",yytext); BEGIN(C_COMMENT); }
<C_COMMENT>\n	{ printf("%s",yytext); countlines++;} 
<C_COMMENT><<EOF>>	{ printf("Warning: Reached End of File without close Comments \n"); countlines++; BEGIN(INITIAL);} // + periptwsh poy briskoume to EOF mesa sta comments
<C_COMMENT>"*/" { printf("%s\n",yytext); BEGIN(INITIAL); }
<C_COMMENT>.    {printf("%s",yytext); }

"//"            { printf("Line Comment %s",yytext); BEGIN(L_COMMENT); }
<L_COMMENT>\n	{ printf("%s",yytext); countlines++; BEGIN(INITIAL); }   // de mphke \n epeidh typwnetai ayto tou sxolioy kai mas phgainei mia grammh pio katw
<L_COMMENT>.    {printf("%s",yytext); }  // me eisagwgika h xwris to enter ??? fainetai na douleyei kai me ta duo 

"\""            { printf("String %s",yytext); BEGIN(S_STRING); }
<S_STRING>\" { printf("%s\n",yytext); BEGIN(INITIAL); }
<S_STRING>\n { printf(" <- ERROR: Missing quotes. Strings cannot be extended in more than one line.%s\n",yytext); BEGIN(INITIAL); }
<S_STRING>.    {printf("%s",yytext); }

"\'"	 { k=0; printf("Character %s",yytext); BEGIN(CHARACTER); }
<CHARACTER>\'	{ printf("%s\n",yytext); BEGIN(INITIAL); } 
<CHARACTER>\n { printf(" <- ERROR: Missing quotes. Characters cannot be extended in more than one line.%s",yytext); BEGIN(INITIAL); }
<CHARACTER>\\	{ if (k==0) {printf("%s",yytext); k++; z=0; chok=0; BEGIN(E_CHARACTER);} else { printf(" <- ERROR: Strings need double quotes \n"); BEGIN(INITIAL); } }
<CHARACTER>.	{ if (k==0) { printf("%s",yytext); k++; } else { printf(" <- ERROR: Strings need double quotes \n"); BEGIN(INITIAL); } }

<E_CHARACTER>\' { if(chok==0) {	chok++; printf("%s",yytext);	} else {	printf("%s\n",yytext); BEGIN(INITIAL);} } 
<E_CHARACTER>r|t|n|0|\"|\\ {
		if (z==0) { 
			printf("%s",yytext); 
			z++;
			chok++;
		} else { 
			printf(" <- ERROR: Strings need double quotes \n");
			BEGIN(INITIAL); 
		}
}
<E_CHARACTER>x{HX}{HX} {
		if (z==0) { 
			printf("%s",yytext);
			z++;
			chok++;
		} else {
			printf(" <- ERROR: Strings need double quotes \n"); BEGIN(INITIAL); }}
<E_CHARACTER>.	{ printf(" <- ERROR: Not a Character \n"); BEGIN(INITIAL); }

<INITIAL>{

[0-9]+ printf("integer %s\n",yytext);  // anagnwsei tous akeraious

[0-9]+"."[0-9]+(e(("+"|"-"){digit}+|{digit}+))* printf("Double %lf\n",atof(yytext));  // anagnwsei tous pragmatikous

if|else|for|byref|void|bool|break|char|continue|delete|double|false|int|new|NULL|return|true	{
	printf("Keyword %s\n",yytext);   //keyword
	}

{ID}	printf("Identifier %s\n",yytext); //identifiers

"("|")"|";"|"["|"]"|"{"|"}"	printf("Separator %s\n",yytext);   //diaxwristikoi xarakthres

"+"|"-"|"*"|"/"|"%"|"&"|"!"|"&&"|"||"|"?"|":"|","|"++"|"--"|"+="|"-="|"*="|"/="|"%="|"="|"=="|"!="|">"|"<"|">="|"<="	{
	printf("operator %s\n",yytext); // operators
	}

\n	countlines++; //printf("%d",countlines); 
[ \t\r]	{}  // agnooume spaces, tabs, line feed, carriage return

.  {other++; printf("SOSOSOSOS\n"); }  // tha agnohsei otidipote allo kai metraei posa agnoei
}



%%
int main(int argc, char *argv[]){
 yylex(); // menei akoma synarthsh gia lathi poy tha typwnei  to onoma toy arxeioy, tha xrhsimopoiei diaforetika xrwmata kai tha emfanizei kai arithmo grammhs
 printf("Found %d other characters\n",other);
}
/*
char escape(char * tex){
	if(tex[0] == '\' ){
		printf("is escape!")		
		if(tex[
	}

}*/

