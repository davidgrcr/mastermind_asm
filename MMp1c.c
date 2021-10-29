/**
 * Implementació en C de la pràctica, per a què tingueu una
 * versió funcional en alt nivell de totes les funcions que heu 
 * d'implementar en assemblador.
 * Des d'aquest codi es fan les crides a les subrutines de assemblador. 
 * AQUEST CODI NO ES POT MODIFICAR I NO S'HA DE LLIURAR.
 **/
 
#include <stdio.h>
#include <termios.h>    //termios, TCSANOW, ECHO, ICANON
#include <unistd.h>     //STDIN_FILENO

/**
 * Constants.
 */
#define ARRAYDIM 5

/**
 * Definició de variables globals.
 */
extern int developer;	 //Variable declarada en assemblador que indica el nom del programador

char charac;   //Caràcter llegit de teclat i per a escriure a pantalla.
int  row;	   //Fila per a posicionar el cursor a la pantalla.
int  col;	   //Columna per a posicionar el cursor a la pantalla

int  aSecret[ARRAYDIM] = {-3,-3,-3,-3,-3};   //Combinació secreta.
int  aPlay[ARRAYDIM]   = {0,0,0,0,0};        //Jugada.
int  pos;      //Posició dins l'array que estem accedint i posició del cursor al tauler

short state;   //Estat del joc
               //0: Estem entrant la combinació secreta, 
               //1: Estem entrant la jugada.
               //2: La combinació secreta té espais o nombres repetits.
               //3: S'ha guanyat, jugada = combinació secreta.
               //4: S'han esgotat les jugades
               //5: S'ha premut ESC per sortir   
int   tries;   //Intents que queden
short hX;      //Encerts a lloc.


/**
 * Definició de les subrutines d'assemblador que es criden des de C.
 */
void posCurBoardP1();
void updatePosP1();
void updateArrayP1();
void checkSecretP1();
void printSecretPlayP1();
void checkPlayP1();
void printHitsP1();
void playP1();

/**
 * Definició de les funcions de C.
 */
void clearScreen_C();
void gotoxyP1_C();
void printchP1_C();
void getchP1_C();
void printMenuP1_C();
void printBoardP1_C();
void posCurBoardP1_C();
void updatePosP1_C();
void updateArrayP1_C();
void checkSecretP1_C();
void printSecretPlayP1_C();
void checkPlayP1_C();
void printHitsP1_C();
void printMessageP1_C();
void playP1_C();




/**
 * Esborrar la pantalla.
 * 
 * Variables globals utilitzades:	
 * Cap
 * 
 * Aquesta funció no es crida des d'assemblador
 * i no hi ha definida una subrutina d'assemblador equivalent.
 */
void clearScreen_C(){
	
    printf("\x1B[2J");
    
}


/**
 * Situar el cursor a una posició de la pantalla.
 * 
 * Variables globals utilitzades:	
 * (row) : Fila de la pantalla on es situa el cursor.
 * (col) : Columna de la pantalla on es situa el cursor.
 * 
 * S'ha definit un subrutina en assemblador equivalent 'gotoxyP1' 
 * per a poder cridar aquesta funció guardant l'estat dels registres 
 * del processador. Això es fa perquè les funcions de C no mantenen 
 * l'estat dels registres.
 */
void gotoxyP1_C(){
	
   printf("\x1B[%d;%dH", row, col);
   
}


/**
 * Mostrar un caràcter a la pantalla a la posició del cursor.
 * 
 * Variables globals utilitzades:	
 * (charac) : Caràcter a mostrar.
 * 
 * S'ha definit un subrutina en assemblador equivalent 'printchP1' 
 * per a cridar aquesta funció guardant l'estat dels registres del 
 * processador. Això es fa perquè les funcions de C no mantenen 
 * l'estat dels registres.
 */
void printchP1_C(){
	
   printf("%c",charac);
   
}


/**
 * Llegir un caràcter des del teclat sense mostrar-lo a la pantalla 
 * i emmagatzemar-lo a la variable (charac).
 * 
 * Variables globals utilitzades:	
 * (charac) : Caràcter llegit des del teclat.
 * 
 * S'ha definit un subrutina en assemblador equivalent 'getchP1' per a
 * cridar aquesta funció guardant l'estat dels registres del processador.
 * Això es fa perquè les funcions de C no mantenen l'estat dels 
 * registres.
 */
void getchP1_C(){

   static struct termios oldt, newt;

   /*tcgetattr obtenir els paràmetres del terminal
   STDIN_FILENO indica que s'escriguin els paràmetres de l'entrada estàndard (STDIN) sobre oldt*/
   tcgetattr( STDIN_FILENO, &oldt);
   /*es copien els paràmetres*/
   newt = oldt;

   /* ~ICANON per a tractar l'entrada de teclat caràcter a caràcter no com a línia sencera acabada amb /n
      ~ECHO per a què no mostri el caràcter llegit*/
   newt.c_lflag &= ~(ICANON | ECHO);          

   /*Fixar els nous paràmetres del terminal per a l'entrada estàndard (STDIN)
   TCSANOW indica a tcsetattr que canvii els paràmetres immediatament. */
   tcsetattr( STDIN_FILENO, TCSANOW, &newt);

   /*Llegir un caràcter*/
   charac=(char)getchar();                 
    
   /*restaurar els paràmetres originals*/
   tcsetattr( STDIN_FILENO, TCSANOW, &oldt);
   
}


/**
 * Mostrar a la pantalla el menú del joc i demana una opció.
 * Només accepta una de les opcions correctes del menú ('0'-'9').
 * 
 * Variables globals utilitzades:	
 * (row)       : Fila de la pantalla on es situa el cursor.
 * (col)       : Columna de la pantalla on es situa el cursor.
 * (charac)    : Caràcter llegit des del teclat.
 * (developer) :((char *)&developer): Variable definida en el codi assemblador.
 * 
 * Aquesta funció no es crida des d'assemblador
 * i no hi ha definida una subrutina d'assemblador equivalent.
 */
void printMenuP1_C(){
	
	clearScreen_C();
    row = 1;
    col = 1;
    gotoxyP1_C();
    printf("                              \n");
    printf("       Developed by:          \n");
	printf("     ( %s )   \n",(char *)&developer);
    printf(" ____________________________ \n");
    printf("|                            |\n");
    printf("|      MENU MASTERMIND       |\n");
    printf("|____________________________|\n");
    printf("|                            |\n");
    printf("|       1. PosCurBoard       |\n");
    printf("|       2. UpdatePos         |\n");
    printf("|       3. UpdateArray       |\n");
    printf("|       4. CheckSecret       |\n");
    printf("|       5. PrintSecretPlay   |\n");
    printf("|       6. PrintHits         |\n");
    printf("|       7. CheckPlay         |\n");
    printf("|       8. Play Game         |\n");
    printf("|       9. Play Game C       |\n");
    printf("|       0. Exit              |\n");
    printf("|                            |\n");
    printf("|          OPTION:           |\n");
    printf("|____________________________|\n"); 

    charac=' ';
    while (charac < '0' || charac > '9') {
      row = 20;
      col = 20;
      gotoxyP1_C();
	  getchP1_C();
	}
	
}


/**
 * Mostrar el tauler de joc a la pantalla. Les línies del tauler.
 * 
 * Variables globals utilitzades:
 * (row)   : Fila de la pantalla on es situa el cursor.
 * (col)   : Columna de la pantalla on es situa el cursor.
 * (tries) : Intents que queden.
 * 
 * Aquesta funció es crida des de C i des d'assemblador,
 * i no hi ha definida una subrutina d'assemblador equivalent.
 */
void printBoardP1_C(){
   int i;

   clearScreen_C();
   row = 1;
   col = 1;
   gotoxyP1_C();
   printf(" _______________________________ \n");//1
   printf("|                               |\n");//2
   printf("|      _ _ _ _ _   Secret Code  |\n");//3
   printf("|_______________________________|\n");//4
   printf("|                 |             |\n");//5
   printf("|       Play      |     Hits    |\n");//6
   printf("|_________________|_____________|\n");//7
   for (i=0;i<tries;i++){                        //8-19
     printf("|   |             |             |\n");
     printf("| %d |  _ _ _ _ _  |  _ _ _ _ _  |\n",i+1);
   }
   printf("|___|_____________|_____________|\n");//20
   printf("|       |                       |\n");//21
   printf("| Tries |                       |\n");//22
   printf("|  ___  |                       |\n");//23
   printf("|_______|_______________________|\n");//24
   printf(" (ENTER) next Try       (ESC)Exit \n");//25
   printf(" (0-9) values    (j)Left (k)Right   ");//26
   
}
   

/**
 * Posiciona el cursor dins al tauler segons la posició del cursor (pos)
 * i dels intents que queden (tries). 
 * Si estem entrant la combinació secreta (state==0) ens posarem a la
 * fila 3 (row=3), si estem entrant un jugada (state!=0) la fila es 
 * calcula amb la formula: (row=9+(ARRAYDIM-tries)*2).
 * La columna es calcula amb la fórmula (col= 8+(pos*2)).
 * Per a posicionar el cursor es crida la funció gotoxyP1_C.
 * 
 * Variables globals utilitzades:	
 * (state) : Estat del joc.
 * (tries) : Intents que queden.
 * (row)   : Fila de la pantalla on es situa el cursor.
 * (col)   : Columna de la pantalla on es situa el cursor.
 * (pos)   : Posició on està el cursor.
 * 
 * Aquesta funció no es crida des d'assemblador.
 * Hi ha un subrutina en assemblador equivalent 'posCurBoardP1'.
 */
void posCurBoardP1_C(){
	
   if (state==0) {
      row = 3;
   } else {
      row = 9+(ARRAYDIM-tries)*2;
   }
   col = 8+(pos*2);
   
   gotoxyP1_C();
   
}

/**
 * Si s'ha llegit (charac=='j') esquerra o (charac=='k') dreta, 
 * actualitzar la posició del cursor (posició dins l'array de la 
 * combinació) controlant que no surti de les posicions de l'array [0..4]
 * i actualitzar l'índex de l'array (pos +/-1) segons correspongui. 
 * No es pot sortir de la zona on estem escrivint (5 posicions).
 *  
 * Variables globals utilitzades:	
 * (charac) : Caràcter llegit des del teclat.
 * (pos)    : Posició on està el cursor.
 * 
 * Aquesta funció no es crida des d'assemblador.
 * Hi ha un subrutina en assemblador equivalent 'updatePosP1'.
 */
void updatePosP1_C(){
	
   if ((charac=='j') && (pos>0)){             
      pos--;
   }
   if ((charac =='k') && (pos<ARRAYDIM-1)){
      pos++;
   }
   
}


/**
 * Guardar el valor del caràcter llegit ['0'-'9'] en un array i 
 * mostrar-lo per pantalla.
 * Obtenir el valor (val) restant 48 (ASCII de '0') a (charac).
 * Si (state==0) guardem el valor (val) a la posició (pos) de l'array 
 * (aSecret) i canviarem el caràcter llegit per un '*' (charac='*') 
 * perquè no es vegi la combinació secreta que escrivim.
 * Si (state!=0) guardem el valor (val) a la posició (pos) de l'array 
 * (aPlay). 
 * Finalment mostrem el caràcter (charac) a la pantalla a la posició on 
 * està el cursor cridant la funció printchP1_C.
 * 
 * Variables globals utilitzades:	
 * (charac)  : Caràcter a mostrar.
 * (state)   : Estat del joc.
 * (aSecret) : Array amb la combinació secreta.
 * (aPlay)   : Array amb la jugada.
 * (pos)     : Posició de l'array on guardem el valor llegit [0..4].
 * 
 * Aquesta funció no es crida des d'assemblador.
 * Hi ha un subrutina en assemblador equivalent 'updateArrayP1'.
 */
void updateArrayP1_C(){

   int val = (int)(charac-'0');
   if (state==0) {
      aSecret[pos]=val;
      charac='*';
   } else {
	  aPlay[pos]=val;
   }
   
   printchP1_C();
}


/**
 * Verificar que la combinació secreta (aSecret) no tingui el valor -3, 
 * (valor inicial), ni números repetits.
 * Per cada element de l'array (aSecret) mirar que no hi hagi un -3
 * i que no estigui repetit a la resta de l'array (de la posició 
 * següent a l'actual fins al final). Per a indicar que la combinació
 * secreta no és correcte posarem (secretError=1).
 * Si la combinació secreta és correcta, posar (state=1) per a 
 * llegir jugades.
 * Si la combinació secreta és incorrecta, posar (state=2) per tornar-la
 * a demanar.
 * 
 * Variables globals utilitzades:
 * (aSecret) : Array amb la combinació secreta.
 * (state)   : Estat del joc.
 * 
 * Aquesta funció no es crida des d'assemblador.
 * Hi ha un subrutina en assemblador equivalent 'checkSecretP1'. 
 */
void checkSecretP1_C() {
   int i,j;
   int secretError = 0;
     
   for (i=0;i<ARRAYDIM;i++) {
     if (aSecret[i]==-3) {
       secretError=1;
     }
     for (j=i+1;j<ARRAYDIM;j++) {
       if (aSecret[i]==aSecret[j]){
		 secretError=1;
	   }
     }
   }
   
   if (secretError==1) state = 2; 
   else state = 1; 

}


/**
 * Mostrar una combinació del joc.
 * Si (state!=1) mostra la combinació secreta (aSecret) a la fila 3 (row=3),
 * sinó mostra la jugada (aPlay) a la fila  (row = 9+(ARRAYDIM-tries)*2),
 * a partir de la columna 8 (col=8).
 * Per a cada posició de l'array:
 * Posicionar el cursor cridant la funció gotoxyP1_C.
 * Si (state!=1) agafar valor de la combinació secreta (aSecret),
 * sinó agafar valor de la jugada (aPlay),
 * sumar '0' al valor agafat de l'array per convertir-lo a caràcter i
 * cridar la funció printchP1_C per a mostrar-lo.
 * Incrementar la columna de 2 en 2. 
 * 
 * Variables globals utilitzades:
 * (state)   : Estat del joc.
 * (row)     : Fila de la pantalla on es situa el cursor.
 * (col)     : Columna de la pantalla on es situa el cursor.
 * (tries)   : Intents que queden.
 * (aSecret) : Array amb la combinació secreta.
 * (aPlay)   : Array amb la jugada.
 * (charac)  : Caràcter a mostrar.
 *  
 * Aquesta funció no es crida des d'assemblador.
 * Hi ha un subrutina en assemblador equivalent 'printSecretPlayP1'.  
 */
void printSecretPlayP1_C() {
	
   int i;
   
   if (state!=1) {
      row = 3;
   } else {
      row = 9+(ARRAYDIM-tries)*2;
   }
   col = 8;
   for (i=0; i<ARRAYDIM; i++){
     gotoxyP1_C();
     if(state!=1) {
		 charac = aSecret[i]+'0';
     } else {
		 charac = aPlay[i]+'0';
     }
     printchP1_C();
     col = col + 2;     
   } 
   
}


/**
 * Compta els encerts a lloc de la jugada (aPlay) 
 * respecte de la combinació secreta (aSecret).
 * Comparar cada element de la combinació secreta (aSecret) amb
 * l'element que hi ha a la mateixa posició de la jugada (aPlay).
 * Si un element de la combinació secreta (aSecret[i]) és igual a 
 * l'element de la mateixa posició de la jugada(aPlay[i]): serà un 
 * encert a lloc 'X' i s'han d'incrementar els encerts a lloc (hX++).
 * Si totes les posicions de la combinació secreta (aSecret) i de la jugada
 * (aPlay) són iguals (hX=ARRAYDIM) hem guanyat i s'ha de modificar l'estat
 * del joc per a indicar-ho (state=3).
 * Mostrar els encerts a lloc al tauler de joc cridant 
 * a la funció printHitsP1_C.
 * 
 * Variables globals utilitzades:	
 * (aSecret) : Array amb la combinació secreta.
 * (aPlay)   : Array amb la jugada.
 * (state)   : Estat del joc.
 * (tries)   : Intents que queden.
 * 
 * 
 * Aquesta funció no es crida des d'assemblador.
 * Hi ha un subrutina en assemblador equivalent 'checkPlayP1'.
 */
void checkPlayP1_C(){

   int i;
   hX = 0;
   for (i=0;i<ARRAYDIM;i++) {
	 if (aSecret[i]==aPlay[i]) {
       hX++;
     } 
   }
    
   if (hX == ARRAYDIM ) {
     state = 3;
   } 
   
   printHitsP1_C();
   
}


/**
 * Mostrar els encerts a lloc.
 * Situar el cursor a la fila (row = 9+(ARRAYDIM-tries)*2) i la columna 
 * (col = 22) (part dreta del tauler) per a mostrar els encerts.
 * Es mostren tantes 'X' com encerts a lloc hi hagin (hX).
 * Per a mostrar els encerts s'ha de cridar la funció gotoxyP1_C per a 
 * posicionar el cursor i printchP1_C per a mostrar els caràcters. 
 * Cada cop que es mostra un encert s'ha d'incrimentar en 2 la columna.
 * NOTA: (hX ha de ser sempre més petit o igual que ARRAYDIM).
 * 
 * Variables globals utilitzades:	
 * (row)    : Fila de la pantalla on es situa el cursor.
 * (col)    : Columna de la pantalla on es situa el cursor.
 * (tries)  : Intents que queden.
 * (charac) : Caràcter a mostrar.
 * (hX)     : Encerts a lloc.
 * 
 * Aquesta funció no es crida des d'assemblador.
 * Hi ha un subrutina en assemblador equivalent 'printHitsP1'.
 */ 
void printHitsP1_C() {
   int i;
   row = 9 + (ARRAYDIM-tries)*2;
   col = 22;
   charac = 'X';
   for(i=hX;i>0;i--) {
     gotoxyP1_C();
     printchP1_C();
     col = col + 2;
   }
   
}



/**
 * Mostra un missatge a la part inferior dreta del tauler segons el 
 * valor de la variable (state).
 * (state) 0: Estem entrant la combinació secreta.
 *         1: Estem entrant la jugada.
 *         2: La combinació secreta té els valors inicials o valors repetits.
 *         3: S'ha guanyat, jugada = combinació secreta.
 *         4: S'han esgotat les jugades
 *         5: S'ha premut ESC per sortir
 * S'espera que es premi una tecla per continuar. 
 * Mostrar un missatge a sota al tauler per indicar-ho 
 * i al prémer una tecla l'esborra.
 * 
 * Variables globals utilitzades:	
 * (row)   : Fila de la pantalla on es situa el cursor.
 * (col)   : Columna de la pantalla on es situa el cursor.
 * (state) : Estat del joc.
 * 
 * Aquesta funció es crida des de C i des d'assemblador.
 * No hi ha definida una subrutina d'assemblador equivalent.
 */
void printMessageP1_C(){

   row = 20;
   col = 11;
   gotoxyP1_C();
   switch(state){
     break;
     case 0: 
       printf("Write the Secret Code");
     break;
     case 1:
       printf(" Write a combination ");
     break;
     case 2:
       printf("Secret Code ERROR!!! ");
     break;
     case 3:
       printf("YOU WIN: CODE BROKEN!");
     break;
     case 4:
       printf("GAME OVER: No tries! ");
     break;
     case 5:
       printf(" EXIT: (ESC) PRESSED ");
     break;
   }
   row = 21;
   col = 11;
   gotoxyP1_C(); 
   printf("    Press any key ");
   getchP1_C();	  
   row = 21;
   col = 11;
   gotoxyP1_C();  
   printf("                  ");
   
}


/**
 * Funció principal del joc
 * Llegeix la combinació secreta i verifica que sigui correcte.
 * A continuació es llegeix una jugada, compara la jugada amb la
 * combinació secreta per a determinar els encerts a lloc.
 * Repetir el procés mentre no s'encerta la combinació secreta i mentre 
 * queden intents. Si es prem la tecla 'ESC' durant la lectura de la 
 * combinació secreta o d'una jugada sortir.
 * 
 * Pseudo codi:
 * El jugador disposa de 5 intents per encertar la combinació secreta,
 * l'estat inicial del joc és 0 i el cursor es posa a la posició 0.
 * Mostrar el tauler de joc cridant la funció printBoardP1_C.
 * Mostrar un missatge indicant que s'ha d'entrar la combinació secreta
 * cridant la funció printMessageP1_C.
 * Mentre (state==0) llegir combinació secreta o (state==2) llegir 
 * la combinació secreta perquè no era correcte:
 * - Posar l'estat inicial del joc a 0 (state=0).
 *   Mentre no es premi (ESC) o (ENTER):
 *   - Posicionar el cursor al tauler cridant la funció posCurBoardP1_C.
 *   - Llegir una tecla cridant la funció getchP1_C.
 *   - Si s'ha llegit una 'j'(esquerra) o una 'k' (dreta) moure el 
 *     cursor per les 5 posicions de la combinació, actualitzant 
 *     l'índex de l'array (pos +/-1) cridant la funció updatePosP1_C.
 *     (no es pot sortir de la zona on estem escrivint (5 posicions))
 *   - Si s'ha llegit un caràcter vàlid ['0'-'9'] el guardem a l'array
 *     (aSecret), si (status==0) canviarem el caràcter llegit per un 
 *     '*' per a què no es vegi la combinació secreta que escrivim i
 *     mostrem el caràcter per pantalla a la posició on està el cursor
 *     cridant la funció updateArrayP1_C.
 *   - Si s'ha llegit un ESC(27) posar (state=5) per a sortir.
 * 
 *   Si no s'ha premut la tecla (ESC) (state!=5) cridar la funció 
 *   checkSecretP1_C per verificar si la combinació secreta te un -3 o
 *   números repetits i mostrar un missatge cridant la funció 
 *   printMessageP1_C indicant que ja es poden entrar jugades (state=1) 
 *   si la combinació secreta és correcte o que la combinació secreta 
 *   no és correcte (state=2).
 * 
 *  Mentre (state==1) estem introduint jugades:
 *  - Inicialitzar la posició del cursor a 0 (pos=0).
 *  - Mostrar els intents que queden (tries) per a encertar la combinació 
 *    secreta, situar el cursor a la fila 21, columna 5 cridant la funció
 *    gotoxyP1_C i mostra el caràcter associat al valor de la variable
 *    (tries) sumant '0' i cridant a la funció printchP1_C.
 *  - Mostrar la jugada que tenim a l'array (aPlay), inicialment serà 
 *    ("00000") i es podrà modificar.
 *    Mentre no es premi (ESC) o (ENTER):
 *     - Posicionar el cursor al tauler cridant la funció posCurBoardP1_C.
 *     - Llegir una tecla cridant la funció getchP1_C.
 *     - Si s'ha llegit una 'j'(esquerra) o una 'k' (dreta) actualitzar
 *       la posició del cursor, índex de l'array, (pos +/-1) cridant la 
 *       funció updatePosP1_C.
 *       (no es pot sortir de la zona on estem escrivint (5 posicions)).
 *     - Si s'ha llegit un caràcter vàlid ['0'-'9'] el guardem a l'array
 *       (aPlay) i mostrem el caràcter per pantalla a la posició on està 
 *       el cursor cridant la funció updateArrayP1_C.
 *     - Si s'ha llegit un ESC(27) posar (state=5) per a sortir.
 * 
 *    Si no s'ha premut (ESC)(state!=5) cridar la funció chekPlaysP1_C 
 *    per compta els encerts a lloc de la jugada (aPlay)
 *    respecte de la combinació secreta (aSecret), si la jugada és igual,
 *    posició a posició, a la combinació secreta, hem guanyat (state=3).
 *    Decrementem els intents (tries), i si no queden intents (tries==0) i
 *    no hem encertat la combinació secreta (state==1), hem perdut (state=4).
 * 
 * Per a acabar, mostrar la combinació secreta cridant la funció 
 * printSecretPlayP1_C. Mostrar els intents que queden (tries) per a 
 * encertar la combinació secreta, situar el cursor a la fila 21, 
 * columna 5 cridant la funció gotoxyP1_C i mostra el caràcter associat 
 * al valor de la variable (tries) sumant '0' i cridant a la funció 
 * printchP1_C, finalment mostrar el missatge indicant quin ha estat 
 * el motiu cridant la funció printMessageP1_C.
 * S'acaba el joc.
 * 
 * Variables globals utilitzades:	
 * (state)  : Estat del joc.
 * (tries)  : Intents que queden.
 * (pos)    : Posició on està el cursor.
 * (charac) : Caràcter llegit des del teclat i a mostrar.
 * (row)    : Fila de la pantalla on es situa el cursor.
 * (col)    : Columna de la pantalla on es situa el cursor.
 * 
 * Aquesta funció no es crida des d'assemblador.
 * Hi ha un subrutina en assemblador equivalent 'playP1'. 
 */
void playP1_C() {
   
   state = 0;
   tries = 5;
   pos=0;
   
   printBoardP1_C();
   printMessageP1_C();

   while (state == 0 || state == 2) {
	  state=0;
      do {
         posCurBoardP1_C();
	     getchP1_C();
         if ((charac=='j') || (charac=='k')){             
            updatePosP1_C();
         }
         if (charac>='0' && charac<='9'){   
            updateArrayP1_C();
         }
         if (charac == 27) {
           state = 5;    
         }
      } while ((charac!=10) && (charac!=27)); 
      if (state!=5) {
	     checkSecretP1_C();
         printMessageP1_C();
      }
   }
   
   while (state==1) {
	 pos = 0;
	 row=21;
	 col=5;
	 gotoxyP1_C();
	 charac=tries + '0';
     printchP1_C();
	 printSecretPlayP1_C();
	 do {
         posCurBoardP1_C();
	     getchP1_C();
         if ((charac=='j') || (charac=='k')){             
            updatePosP1_C();
         }
         if (charac>='0' && charac<='9'){   
            updateArrayP1_C();
         }
         if (charac == 27) {
           state = 5;    
         }
      } while ((charac!=10) && (charac!=27)); 
      if (state!=5) {
	     checkPlayP1_C();
	     tries--;
	     if (tries == 0 && state == 1) {
            state = 4;   
         }
      }
   }
   row=21;
   col=5;
   gotoxyP1_C();
   charac=tries + '0';
   printchP1_C();
   printSecretPlayP1_C();
   printMessageP1_C();
   
}


/**
 * Programa Principal
 * 
 * ATENCIÓ: A cada opció es crida a una subrutina d'assemblador.
 * A sota hi ha comentada la funció en C equivalent que us donem feta 
 * per si voleu veure com funciona.
 *  */
void main(void){   
   int i;
   int op=' ';      

   while (op!='0') {
     printMenuP1_C();	  //Mostrar menú i retornar opció.
     op = charac;
     switch(op){
       case '0':
         row=23;
         col=1;
         gotoxyP1_C(); 
         break;
       case '1':	          //Posiciona Cursor al Tauler.
         state=1;
         tries=5;
         pos = 0;		
         printBoardP1_C();
         row=21;
         col=11;
         gotoxyP1_C();
         printf("   Press any key  ");   
         //=======================================================
         posCurBoardP1();
         ///posCurBoardP1_C();
         //=======================================================
         getchP1_C();
         break;
       case '2':	          //Actualitzar posició del cursor.
         state=1;
         tries=5;
	     pos = 2;
         printBoardP1_C();
         row=21;
         col=11;  
         gotoxyP1_C();
         printf(" Press 'j' or 'k' ");
         posCurBoardP1_C();
         getchP1_C();
         if (charac=='j' || charac=='k') {
         //=======================================================
         updatePosP1();
         ///updatePosP1_C();	    
         //=======================================================
         }
         row=21;
         col=11;
         gotoxyP1_C();
         printf("   Press any key  ");
         posCurBoardP1_C();
         getchP1_C();
         break;
       case '3': 	     //Actualitzar array i mostrar-ho per pantalla.
         state=1;
         tries=5;
         pos=0;		  
         printBoardP1_C();
         printSecretPlayP1_C();
         row=21;
         col=11;
         gotoxyP1_C();
         printf(" Press (0-9) value ");
         posCurBoardP1_C();
         getchP1_C();
         if (charac>='0' && charac<='9'){       
         //=======================================================
         updateArrayP1();
         ///updateArrayP1_C();
         //=======================================================
         }
         row=21;
         col=11;
         gotoxyP1_C();
         printf("   Press any key  ");
         getchP1_C();
         break;
       case '4': 	     //Verifica la combinació secreta.
         state=0;
         tries=5;
         pos=0;	
         printBoardP1_C();
         int secret1[ARRAYDIM] = {1,2,-3,4,1}; //Combinació secreta
         for (i=0;i<ARRAYDIM;i++) {
           aSecret[i]=secret1[i];
         }  
         //=======================================================
         checkSecretP1();
         ///checkSecretP1_C();
         //=======================================================
         printSecretPlayP1_C();		
         printMessageP1_C();
         break;
       case '5': 	     //Mostrar una combinació del joc.
         state=1;
         tries=5;
         pos=0;
         printBoardP1_C();
         //=======================================================
         printSecretPlayP1();
         ///printSecretPlayP1_C();		
         //=======================================================
         row=21;
         col=11;
         gotoxyP1_C();
         printf("   Press any key  ");
         getchP1_C();
         break;
       case '6': 	     //Mostrar encerts.
         state=1;
         tries=5;
         pos=0;
         printBoardP1_C();
         hX = 4;
         //=======================================================
         printHitsP1();
         ///printHitsP1_C();
         //=======================================================
         row=21;
         col=11;
         gotoxyP1_C();
         printf("   Press any key  ");
         getchP1_C();
         break;
       case '7': 	     //Compta els encerts a lloc.
         state=0;
         tries=5;
         pos=0;
         printBoardP1_C();
         int secret2[ARRAYDIM] = {1,2,3,4,0}; //Combinació secreta
         int play2[ARRAYDIM] = {1,4,3,0,5};   //Jugada
         for (i=0;i<ARRAYDIM;i++) {
           aSecret[i]=secret2[i];
           aPlay[i]=play2[i];
         } 
         printSecretPlayP1_C();
         state=1;
         printSecretPlayP1_C();	
         //=======================================================
         checkPlayP1();
         ///checkPlayP1_C();
         //=======================================================
         printMessageP1_C();
         break;
       case '8': 	     //Joc complet en assemblador.
         i=0;
         int secret0[ARRAYDIM] = {-3,-3,-3,-3,-3}; //Combinació secreta
         int play0[ARRAYDIM] = {0,0,0,0,0};        //Jugada
         for (i=0;i<ARRAYDIM;i++) {
           aSecret[i]=secret0[i];
           aPlay[i]=play0[i];
         } 
         //=======================================================
         playP1();
         //=======================================================
         break;
       case '9': 	     //Joc complet en C
         i=0;
         int secret[ARRAYDIM] = {-3,-3,-3,-3,-3}; //Combinació secreta
         int play[ARRAYDIM] = {0,0,0,0,0};        //Jugada
         for (i=0;i<ARRAYDIM;i++) {
           aSecret[i]=secret[i];
           aPlay[i]=play[i];
         } 
         //=======================================================
         playP1_C();
         //=======================================================
         break;
     }
   }

}
