section .data               
;Canviar Nom i Cognom per les vostres dades.
developer db "_David_ _Gras_",0

;Constant que també està definida en C.
ARRAYDIM equ 5		

section .text            
;Variables definides en Assemblador.
global developer                        

;Variables definides en C.
extern charac, row, col
extern aSecret, aPlay, pos, state, tries, hX

;Subrutines d'assemblador que es criden des de C.
global posCurBoardP1, updatePosP1, updateArrayP1, checkSecretP1
global checkPlayP1, printHitsP1, printSecretPlayP1, playP1

;Funcions de C que es criden des de assemblador.
extern clearScreen_C,  gotoxyP1_C, printchP1_C, getchP1_C
extern printBoardP1_C, printMessageP1_C


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; ATENCIÓ: Recordeu que en assemblador les variables i els paràmetres 
;;   de tipus 'char' s'han d'assignar a registres de tipus  
;;   BYTE (1 byte): al, ah, bl, bh, cl, ch, dl, dh, sil, dil, ..., r15b
;;   les de tipus 'short' s'han d'assignar a registres de tipus 
;;   WORD (2 bytes): ax, bx, cx, dx, si, di, ...., r15w
;;   les de tipus 'int' s'han d'assignar a registres de tipus 
;;   DWORD (4 bytes): eax, ebx, ecx, edx, esi, edi, ...., r15d
;;   les de tipus 'long' s'han d'assignar a registres de tipus 
;;   QWORD (8 bytes): rax, rbx, rcx, rdx, rsi, rdi, ...., r15
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;
;; Les subrutines en assemblador que heu d'implementar són:
;;   posCurBoardP1, updatePosP1, updateArrayP1, 
;;   checkSecretP1, printSecretPlayP1, checkPlayP1, printHitsP1.  
;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Aquesta subrutina es dóna feta. NO LA PODEU MODIFICAR.
; Situar el cursor a una posició de la pantalla
; cridant a la funció gotoxyP1_C.
; 
; Variables globals utilitzades:	
; (row) : Fila de la pantalla on es situa el cursor.
; (col) : Columna de la pantalla on on es situa el cursor.
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
gotoxyP1:
   push rbp
   mov  rbp, rsp
   ;guardem l'estat dels registres del processador perquè
   ;les funcions de C no mantenen l'estat dels registres.
   push rax
   push rbx
   push rcx
   push rdx
   push rsi
   push rdi
   push r8
   push r9
   push r10
   push r11
   push r12
   push r13
   push r14
   push r15

   call gotoxyP1_C
 
   pop r15
   pop r14
   pop r13
   pop r12
   pop r11
   pop r10
   pop r9
   pop r8
   pop rdi
   pop rsi
   pop rdx
   pop rcx
   pop rbx
   pop rax

   mov rsp, rbp
   pop rbp
   ret


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Aquesta subrutina es dóna feta. NO LA PODEU MODIFICAR.
; Mostrar un caràcter a la pantalla a la posició del cursor
; cridant la funció printchP1_C
; 
; Variables globals utilitzades:	
; (charac) : Caràcter a mostrar.
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
printchP1:
   push rbp
   mov  rbp, rsp
   ;guardem l'estat dels registres del processador perquè
   ;les funcions de C no mantenen l'estat dels registres.
   push rax
   push rbx
   push rcx
   push rdx
   push rsi
   push rdi
   push r8
   push r9
   push r10
   push r11
   push r12
   push r13
   push r14
   push r15

   call printchP1_C
 
   pop r15
   pop r14
   pop r13
   pop r12
   pop r11
   pop r10
   pop r9
   pop r8
   pop rdi
   pop rsi
   pop rdx
   pop rcx
   pop rbx
   pop rax

   mov rsp, rbp
   pop rbp
   ret
   

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Aquesta subrutina es dóna feta. NO LA PODEU MODIFICAR.
; Llegir un caràcter des del teclat sense mostrar-lo a la pantalla 
; i emmagatzemar-lo a la variable (charac) cridant la funció getchP1_C.
; 
; Variables globals utilitzades:	
; (charac) : Caràcter llegit des del teclat.
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
getchP1:
   push rbp
   mov  rbp, rsp
   ;guardem l'estat dels registres del processador perquè
   ;les funcions de C no mantenen l'estat dels registres.
   push rax
   push rbx
   push rcx
   push rdx
   push rsi
   push rdi
   push r8
   push r9
   push r10
   push r11
   push r12
   push r13
   push r14
   push r15
   push rbp
 
   call getchP1_C

   pop rbp
   pop r15
   pop r14
   pop r13
   pop r12
   pop r11
   pop r10
   pop r9
   pop r8
   pop rdi
   pop rsi
   pop rdx
   pop rcx
   pop rbx
   pop rax
   
   mov rsp, rbp
   pop rbp
   ret 

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Posiciona el cursor dins al tauler segons la posició del cursor (pos)
; dels intents que queden (tries). 
; Si estem entrant la combinació secreta (state=0) ens posarem a la
; fila 3 (row=3), si estem entrant un jugada (state!=0) la fila es 
; calcula amb la formula: (row=9+(ARRAYDIM-tries)*2).
; La columna es calcula amb la formula (col= 8+(pos*2)).
; Per a posicionar el cursor es crida la subrutina gotoxyP1.
; 
; Variables globals utilitzades:	
; (state) : Estat del joc.
; (tries) : Intents que queden.
; (row)   : Fila de la pantalla on es situa el cursor.
; (col)   : Columna de la pantalla on on es situa el cursor.
; (pos)   : Posició on està el cursor.
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
posCurBoardP1:
   push rbp
   mov  rbp, rsp
   
   push rax
   push rsi
   
   pcb_if:						;if (status == 0) {
   cmp DWORD[state], 0
   jne pcb_if_else				;salta a l'etiqueta si diferent
	 mov DWORD[row], 3     		;row = 3
	 jmp pcb_if_end
   pcb_if_else:
     mov eax, ARRAYDIM         	;row = 9+(DimVector-tries)*2;
     sub eax, DWORD[tries]
     shl eax, 1
     add eax, 9
     mov DWORD[row], eax
   pcb_if_end:  
   mov esi,DWORD[pos]			;col = 8+(pos*2);
   shl esi, 1					;pos*2
   add esi, 8					;8+(pos*2)
   mov DWORD[col],esi     
   call gotoxyP1				;gotoxyP1_C();
   
   pcb_end:
   pop rsi
   pop rax
   

   mov rsp, rbp
   pop rbp
   ret


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Si s'ha llegit una 'j'(esquerra) o una 'k' (dreta) actualitzar la 
; posició del cursor (posició dins l'array de la combinació) controlant
; que no surti de les posicions de l'array [0..4] i actualitzar l'índex
; de l'array (pos +/-1) segons correspongui. No es pot sortir de la 
; zona on estem escrivint (5 posicions).
; Retornar el valor actualitzat de (pos).
;  
; Variables globals utilitzades:	
; (charac) : Caràcter llegit des del teclat.
; (pos)    : Posició on està el cursor.
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
updatePosP1:
   push rbp
   mov  rbp, rsp
   
   push rax
   push rsi
   
   
   udp_if2:								;if (charac=='j')
   cmp BYTE[charac], 'j'
   jne udp_if2_end						;salta a l'etiqueta si diferent,
      udp_if21:							;if (i>0)
      cmp DWORD[pos],0
      jle udp_if21_end					;salta si és més petit o igual.
        dec DWORD[pos]					;pos--
      udp_if21_end:
    udp_if2_end:
    
   udp_if3:								;if (charac=='k')
   cmp BYTE[charac], 'k'
   jne udp_if3_end						;salta a l'etiqueta si diferent,
	  udp_if31:							;if (i<ARRAYDIM-1)
	  cmp DWORD[pos], (ARRAYDIM-1)
	  jge udp_if31_end					;salta si és més petit o igual.
		inc DWORD[pos]					;pos++
      udp_if31_end:
    udp_if3_end:
         
   udp_end:
    
   mov rsp, rbp
   pop rbp
   ret


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Guardar el valor del caràcter llegit ['0'-'9'] en un array i 
; mostrar-lo per pantalla.
; Obtenir el valor (val) restant 48 (ASCII de '0') a (charac).
; Si (state==0) guardem el valor (val) a la posició (pos) de l'array 
; (aSecret) i canviarem el caràcter llegit per un '*' (charac='*') 
; perquè no es vegi la combinació secreta que escrivim.
; Si (state!=0) guardem el valor (val) a la posició (pos) de l'array 
; (aPlay).
; Finalment mostrem el caràcter (charac) a la pantalla a la posició on 
; està el cursor cridant la funció printchP1_C.
; 
; Variables globals utilitzades:	
; (charac)  : Caràcter a mostrar.
; (state)   : Estat del joc.
; (aSecret) : Array amb la combinació secreta.
; (aPlay)   : Array amb la jugada.
; (pos)     : Posició de l'array on guardem el valor llegit [0..4].
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
updateArrayP1:
   push rbp
   mov  rbp, rsp
   
   push rax
   push rsi
   push rdi
   
   
    mov esi,DWORD[pos]	    			;pos = pos*4;
    mov edi, esi
	shl edi, 2

	 mov al, BYTE[charac]				
	 sub al, '0'						;(int)(charac-'0');
	  ua_if:	
	  cmp DWORD[state], 0             	;if (state==0) {
	  jne ua_if_else					;salta a l'etiqueta si diferent,
		mov DWORD[aSecret+edi],eax 		;aSecret[pos]=charac;
		mov BYTE[charac],'*'			;charac='*';
		jmp ua_if_end
	  ua_if_else:
		mov DWORD[aPlay+edi],eax		;aPlay[pos]=val;
	  ua_if_end:
	  
	  call printchP1					;printchP1_C();
   
   ua_end:
   pop rdi
   pop rsi
   pop rax

   mov rsp, rbp
   pop rbp
   ret


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Verificar que la combinació secreta (vSecret) no tingui el valor -3, 
; valor incial, ni números repetits.
; Per cada element de l'array (aSecret) mirar que no hi hagi un -3
; i que no estigui repetit a la resta de l'array (de la posició 
; següent a l'actual fins al final). Per a indicar que la combinació
; secreta no és correcte posarem (secretError=1).
; Si la combinació secreta és correcta, posar (state=1) i anem 
; a llegir jugades.
; Si la combinació secreta és incorrecta, posar (state=2) per tornar-la
; a demanar.
; 
; Variables globals utilitzades:
; (aSecret) : Array amb la combinació secreta.
; (state)   : Estat del joc.	
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;  
checkSecretP1:
   push rbp
   mov  rbp, rsp
   
   push rax
   push rbx
   push rcx
   push rsi
   push rdi
   push rbp
   
   mov eax,0   					   		;int secretError = 0;
   mov esi,0							;int i=0;
   mov edi,0							;int j=0
   
   cs_fori:
    cmp esi, ARRAYDIM  					;for (i=0;i<ARRAYDIM;i++) {
    jge cs_fori_end						;salta si és més gran o igual.
	 cs_if1:							;if (aSecret[i]==-3) {
	 mov ebx, esi
	 shl ebx, 2
	 cmp DWORD[aSecret+ebx], -3
	 jne cs_if1_end						;salta a l'etiqueta si diferent,
      mov eax,1							;secretError=1;
	 cs_if1_end:
	
	 mov edi,esi
	 add edi,1 							;j=i+1
	 cs_forj:	
     cmp edi, ARRAYDIM  				;for (j=i+1;j<ARRAYDIM;j++) {
     jge cs_forj_end
     cs_if2:					 		;if (aSecret[i]==aSecret[j]){
     mov ecx, DWORD[aSecret+ebx]
     mov ebp, edi
	 shl ebp, 2
     cmp ecx, DWORD[aSecret+ebp]
     jne cs_if2_end						;salta a l'etiqueta si diferent,
     mov eax,1							;secretError=1;
    
     cs_if2_end: 
     inc edi    						;j++
     jmp cs_forj     
	 cs_forj_end:
	 
	 inc esi							;i++
   	 jmp cs_fori
   cs_fori_end:
     
   cs_if3: 								;if (secretError==1) 
	cmp eax, 1
    jne cs_if3_else						;salta a l'etiqueta si diferent,
	 mov DWORD[state], 2				;state = 2
	 jmp cs_if3_end
	cs_if3_else:
	 mov DWORD[state], 1  				;else state = 1; 
    cs_if3_end:
	    
   cs_end:
   pop rbp
   pop rdi
   pop rsi
   pop rcx
   pop rbx
   pop rax
   

   mov rsp, rbp
   pop rbp
   ret


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Mostrar una combinació del joc.
; Si (state!=1) mostra la combinació secreta (aSecret) a la fila 3 (row=3),
; sinó mostra la jugada (aPlay) a la fila  (row = 9+(ARRAYDIM-tries)*2),
; a partir de la columna 8 (col=8).
; Per a cada posició de l'array:
; Posicionar el cursor cridant la subrutina gotoxyP1.
; Si (state!=1) agafar valor de la combinació secreta (aSecret),
; sinó agafar valor de la jugada (aPlay),
; sumar '0' al valor agafat de l'array per convertir-lo a caràcter i
; cridar la subrutina printchP1 per a mostrar-lo.
; Incrementar la columna de 2 en 2. 
; 
; Variables globals utilitzades:
; (state)   : Estat del joc.
; (row)     : Fila de la pantalla on es situa el cursor.
; (col)     : Columna de la pantalla on on es situa el cursor.
; (tries)   : Intents que queden.
; (aSecret) : Array amb la combinació secreta.
; (aPlay)   : Array amb la jugada.
; (charac)  : Caràcter a mostrar.
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;  
printSecretPlayP1:
   push rbp
   mov  rbp, rsp
	
   push rax
   push rsi
   push rdi
   
   gsp_if:							;if (status == 1) {
   cmp DWORD[state], 1
   jne gsp_if_else					;salta a l'etiqueta si diferent,
     mov eax, ARRAYDIM         		;row = 9+(DimVector-tries)*2;
     sub eax, DWORD[tries]
     shl eax, 1
     add eax, 9
     mov DWORD[row], eax	 
	 jmp gsp_if_end
   gsp_if_else:
	 mov DWORD[row], 3     			;row = 3
   gsp_if_end:  
   
   mov DWORD[col],8
   
   mov esi, 0						;int i=0
   ps_fori:							;for (i=0; i<ARRAYDIM; i++){
   cmp esi, ARRAYDIM
   jge ps_fori_end					;salta si és més gran o igual.
     call gotoxyP1					;gotoxyP1_C();
     mov edi, esi
	 shl edi, 2
	gsp_if2:						;if (state == 1) {
	cmp DWORD[state], 1
	jne gsp_if2_else				;salta a l'etiqueta si diferent,	
     mov al, BYTE[aPlay+edi] 	 	;charac = aPlay[i]+'0';
     add al, '0'
   	 mov BYTE[charac], al
	 jmp gsp_if2_end
	 
	 gsp_if2_else:
	 mov ah, BYTE[aSecret+edi] 		;charac = aSecret[i]+'0';
	 add ah, '0'
   	 mov BYTE[charac], ah     		
   
	 gsp_if2_end:
   
   	 call printchP1 			;printchP1_C();
	 add DWORD[col], 2  		;col = col + 2;
     inc esi
     jmp ps_fori
   ps_fori_end:
   
   ps_end:   
   pop rdi
   pop rsi
   pop rax
   	
   mov rsp, rbp
   pop rbp
   ret

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Compta els encerts a lloc i fora de lloc de la jugada (aPlay) 
; respecte de la combinació secreta (aSecret).
; Comparar cada element de la combinació secreta (aSecret) amb
; l'element que hi ha a la mateixa posició de la jugada (aPlay).
; Si un element de la combinació secreta (aSecret[i]) és igual a 
; l'element de la mateixa posició de la jugada(aPlay[i]): serà un 
; encert a lloc 'X' i s'han d'incrementar els encerts a lloc (hX++).
; Si totes les posicions de la combinació secreta (aSecret) i de la jugada
; (aPlay) són iguals (hX=ARRAYDIM) hem guanyat i s'ha de modificar l'estat
; del joc per a indicar-ho (state=3).
; Mostrar els encerts a lloc al tauler de joc cridant 
; a la subrutina printHitsP1.
; 
; Variables globals utilitzades:	
; (aSecret) : Array amb la combinació secreta.
; (aPlay)   : Array amb la jugada.
; (tries)   : Intents que queden.
; (state)   : Estat del joc.
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;  
checkPlayP1:
   push rbp
   mov  rbp, rsp
   
   push rax
   push rbx
   push rsi
   push rdi
    
   mov DWORD[hX],0						;hX = 0; 
   mov esi, 0							;i=0
   
   ch_fori:								;for (i=0;i<ARRAYDIM;i++) {
   cmp esi, ARRAYDIM
   jge ch_fori_end						;salta si és més gran o igual.
	ch_if1:
	mov edi, esi
	shl edi, 2
										
	mov eax,DWORD[aPlay+edi]	
	mov ebx,DWORD[aSecret+edi]	    
    cmp eax, ebx						;if (aSecret[i]==aPlay[i]) {
    jne ch_if1_end						;salta a l'etiqueta si diferent,
      inc DWORD[hX]						;hX++;
    ch_if1_end:
    inc esi
    jmp ch_fori   
   ch_fori_end:
   
   ch_if2:					 			;if (hX == ARRAYDIM ) {
   cmp DWORD[hX], ARRAYDIM
   jne ch_if2_end						;salta a l'etiqueta si diferent,
	mov DWORD[state], 3  				;state = 3;
   ch_if2_end:
   
   call printHitsP1						;printchP1_C()
   
   ch_end:
   pop rdi
   pop rsi
   pop rbx
   pop rax
   

   

   mov rsp, rbp
   pop rbp
   ret


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Mostrar els encerts a lloc i fora de lloc.
; Situar el cursor a la fila (row = 9+(ARRAYDIM-tries)*2) i la columna 
; (col = 22) (part dreta del tauler) per a mostrar els encerts.
; Es mostren tantes 'X' com encerts a lloc hi hagin (hX).
; Per a mostrar els encerts s'ha de cridar la subrutina gotoxyP1 per a 
; posicionar el cursor i printchP1 per a mostrar els caràcters. 
; Cada cop que es mostra un encert s'ha d'incrimentar en 2 la columna.
; NOTA: (hX ha de ser sempre més petit o igual que ARRAYDIM).
;
; Variables globals utilitzades:	
; (row)    : Fila de la pantalla on es situa el cursor.
; (col)    : Columna de la pantalla on on es situa el cursor.
; (tries)  : Intents que queden.
; (charac) : Caràcter a mostrar.
; (hX)     : Encerts a lloc.
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
printHitsP1:
   push rbp
   mov  rbp, rsp
	  
   push rax
   push rsi
   
   mov eax, ARRAYDIM         			;row = 9+(DimVector-tries)*2;
   sub eax, DWORD[tries]
   shl eax, 1
   add eax, 9
   mov DWORD[row], eax
   
   mov DWORD[col], 22
   mov BYTE[charac], 'X'     	
   
   mov esi, DWORD[hX]					; i=hX
   
   ph_fori:								;for(i=hX;i>0;i--) {
   cmp esi, 0
   jle ph_fori_end						;salta si és més petit o igual.
	call gotoxyP1
	call printchP1
	add DWORD[col], 2					;col = col + 2;
    dec esi								;i--
    jmp ph_fori   
   ph_fori_end:
   
   
   pop rsi
   pop rax
   	
   mov rsp, rbp
   pop rbp
   ret


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Aquesta subrutina es dóna feta. NO LA PODEU MODIFICAR.
; Mostra un missatge a sota del tauler cridant la funció 
; printMessageP1_C segons el valor de la variable (state).
; (state) 0: Estem entrant la combinació secreta. 
;          1: Estem entrant la jugada.
;          3: La combinació secreta té els valors inicials o valors repetits.
;          5: S'ha guanyat, jugada = combinació secreta.
;          6: S'han esgotat les jugades
;          7: S'ha premut ESC per sortir
; S'espera que es premi una tecla per a continuar. 
; Mostrar un missatge a sota al tauler per indicar-ho 
; i al prémer una tecla l'esborra.
;  
; Variables globals utilitzades:	
; (row)   : Fila de la pantalla on es situa el cursor.
; (col)   : Columna de la pantalla on on es situa el cursor.
; (state) : Estat del joc.
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
printMessageP1:
   push rbp
   mov  rbp, rsp
   ;guardem l'estat dels registres del processador perquè
   ;les funcions de C no mantenen l'estat dels registres.
   push rax
   push rbx
   push rcx
   push rdx
   push rsi
   push rdi
   push r8
   push r9
   push r10
   push r11
   push r12
   push r13
   push r14
   push r15
   push rbp

   call printMessageP1_C
 
   pop rbp
   pop r15
   pop r14
   pop r13
   pop r12
   pop r11
   pop r10
   pop r9
   pop r8
   pop rdi
   pop rsi
   pop rdx
   pop rcx
   pop rbx
   pop rax

   mov rsp, rbp
   pop rbp
   ret


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Aquesta subrutina es dóna feta. NO LA PODEU MODIFICAR.
; Subrutina principal del joc
; Llegeix la combinació secreta i verifica que sigui correcte.
; A continuació es llegeix una jugada, compara la jugada amb la
; combinació secreta per a determinar els encerts a lloc.
; Repetir el procés mentre no s'encerta la combinació secreta i mentre 
; queden intents. Si es prem la tecla 'ESC' durant la lectura de la 
; combinació secreta o d'una jugada sortir.
; 
; Pseudo codi:
; El jugador disposa de 5 intents per encertar la combinació secreta,
; l'estat inicial del joc és 0 i el cursor es posa a la posició 0.
; Mostrar el tauler de joc cridant la funció printBoardP1_C.
; Mostrar un missatge indicant que s'ha d'entrar la combinació secreta
; cridant la subrutina printMessageP1.
; Mentre (state==0) llegir combinació secreta o (state==2) llegir 
; la combinació secreta perquè no era correcte:
; - Posar l'estat inicial del joc a 0 (state=0).
;   Mentre no es premi (ESC) o (ENTER):
;   - Posicionar el cursor al tauler cridant la subrutina posCurBoardP1.
;   - Llegir una tecla cridant la subrutina getchP1.
;   - Si s'ha llegit una 'j'(esquerra) o una 'k' (dreta) moure el 
;     cursor per les 5 posicions de la combinació, actualitzant 
;     l'índex de l'array (pos +/-1) cridant la subrutina updatePosP1.
;     (no es pot sortir de la zona on estem escrivint (5 posicions))
;   - Si s'ha llegit un caràcter vàlid ['0'-'9'] el guardem a l'array
;     (aSecret), si (status==0) canviarem el caràcter llegit per un 
;     '*' per a què no es vegi la combinació secreta que escrivim i
;     mostrem el caràcter per pantalla a la posició on està el cursor
;     cridant la funció updateArrayP1_C.
;   - Si s'ha llegit un ESC(27) posar (state=5) per a sortir.
; 
;   Si no s'ha premut la tecla (ESC) (state!=5) cridar la subrutina 
;   checkSecretP1 per verificar si la combinació secreta te un -3 o
;   números repetits i mostrar un missatge cridant la subrutina
;   printMessageP1 indicant que ja es poden entrar jugades (state=1) 
;   si la combinació secreta és correcte o que la combinació secreta 
;   no és correcte (state=2).
; 
;  Mentre (state==1) estem introduint jugades:
;  - Inicialitzar la posició del cursor a 0 (pos=0).
;  - Mostrar els intents  que queden (tries) per a encertar la combinació 
;    secreta, situar el cursor a la fila 21, columna 5 cridant la subrutina
;    gotoxyP1 i mostra el caràcter associat al valor de la variable
;    (tries) sumant '0' i cridant a la subrutina printchP1.
;  - Mostrar la jugada que tenim a l'array (aPlay), inicialment serà 
;    ("00000") i es podrà modificar.
;    Mentre no es premi (ESC) o (ENTER):
;     - Posicionar el cursor al tauler cridant la subrutina posCurBoardP1.
;     - Llegir una tecla cridant la subrutina getchP1.
;     - Si s'ha llegit una 'j'(esquerra) o una 'k' (dreta) actualitzar
;       la posició del cursor, índex de l'array, (pos +/-1) cridant la 
;       subrutina updatePosP1.
;       (no es pot sortir de la zona on estem escrivint (5 posicions)).
;     - Si s'ha llegit un caràcter vàlid ['0'-'9'] el guardem a l'array
;       (aPlay) i mostrem el caràcter per pantalla a la posició on està 
;       el cursor cridant la funció updateArrayP1_C.
;     - Si s'ha llegit un ESC(27) posar (state=5) per a sortir.
; 
;    Si no s'ha premut (ESC)(state!=5) cridar la subrutina chekPlaysP1 
;    per compta els encerts a lloc de la jugada (aPlay)
;    respecte de la combinació secreta (aSecret), si la jugada és igual,
;    posició a posició, a la combinació secreta, hem guanyat (state=3).
;    Decrementem els intents (tries), i si no queden intents (tries==0) i
;    no hem encertat la combinació secreta (state==1), hem perdut (state=4).
; 
; Per a acabar, mostrar la combinació secreta cridant la subrutina
; printSecretPlayP1. Mostrar els intents que queden (tries) per a
; encertar la combinació secreta, situar el cursor a la fila 21, 
; columna 5 cridant la subrutina gotoxyP1 i mostra el caràcter associat 
; al valor de la variable (tries) sumant '0' i cridant a la subrutina
; printchP1, finalment mostrar el missatge indicant quin ha estat 
; el motiu cridant la subrutina printMessageP1.
; S'acaba el joc.
; 
; Variables globals utilitzades:	
; (state)  : Estat del joc.
; (tries)  : Intents que queden.
; (pos)    : Posició on està el cursor.
; (charac) : Caràcter llegit des del teclat i a mostrar.
; (row)    : Fila de la pantalla on es situa el cursor.
; (col)    : Columna de la pantalla on on es situa el cursor.
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;  
playP1:
   push rbp
   mov  rbp, rsp 
   
   push rcx
   
   mov  WORD[state], 0
   mov  DWORD[tries], 5
   mov  DWORD[pos], 0
   
   call printBoardP1_C        ;printBoardP1_C();
   call printMessageP1        ;printMessageP1_C();

   P1_while1:
   cmp WORD[state], 0         ;while (state == 0 
   je  P1_while1ok
   cmp WORD[state], 2         ;|| state==2) {
   jne P1_endwhile1
     P1_while1ok:
     mov WORD[state], 0       ;state=0;
     P1_do1:                  ;do {
       call posCurBoardP1     ;posCurBoardP1_C();
       call getchP1           ;charac = getchP1_C();
       mov  cl, BYTE[charac]
   
       cmp cl, 'j'            ;if ((charac=='j') 
       je  P1_if11
       cmp cl, 'k'            ;|| (charac=='k')){
       jne P1_endif11        
       P1_if11:
         call updatePosP1     ;pos = updatePosP1_C();
       P1_endif11:            ;}
       
       cmp cl, '0'            ;if (charac>='0' 
       jl P1_endif12
       cmp cl, '9'            ;&& charac<='9'){  
       jg P1_endif12
         call updateArrayP1   ;updateArrayP1_C();
       P1_endif12:            ;}
       
       cmp cl, 27             ;if (charac== 27) {
       jne P1_endif13
         mov WORD[state], 5   ;state = 5;    
       P1_endif13:            ;}
       
     cmp cl,10                ;} while ((c!=10) 
     je  P1_enddo1
     cmp cl, 27               ;&& (charac!=27)); 
     jne P1_do1
     P1_enddo1:              
     
     cmp WORD[state], 5       ;if (state!=5) {
     je  P1_endif14
       call checkSecretP1     ;checkSecretP1_C();
       call printMessageP1    ;printMessageP1_C();
     P1_endif14:              ;}
     
   jmp P1_while1 
   P1_endwhile1:              ;}
     
   P1_while2:                 ;while (state == 1)
   cmp WORD[state], 1                
   jne  P1_endwhile2
     mov  DWORD[pos], 0       ;pos=0;
     mov  DWORD[row], 21
     mov  DWORD[col], 5
     call gotoxyP1            ;gotoxyP1_C();
     mov  edi, DWORD[tries]
     add  dil, '0'
     mov  BYTE[charac], dil   ;charac=tries + '0';
     call printchP1           ;printchP1_C();
     call printSecretPlayP1   ;printSecretPlayP1_C();

     P1_do2:                  ;do {
       call posCurBoardP1     ;posCurBoardP1_C();
       call getchP1           ;getchP1_C();
	   mov  cl, BYTE[charac]
	   
       cmp cl, 'j'            ;if ((charac=='j') 
       je  P1_if21
       cmp cl, 'k'            ;|| (charac=='k')){
       jne P1_endif21        
       P1_if21:
         call updatePosP1     ;pos = updatePosP1_C();     
       P1_endif21:            ;}
       
       cmp cl, '0'            ;if (charac>='0' 
       jl P1_endif22
       cmp cl, '9'            ;&& charac<='9'){  
       jg P1_endif22
         call updateArrayP1   ;updateArrayP1_C();
       P1_endif22:            ;}
       
       cmp cl, 27             ;if (charac == 27) {
       jne P1_endif23
         mov WORD[state], 5   ;state = 5;    
       P1_endif23:            ;}
       
     cmp cl,10                ;} while ((charac!=10) 
     je  P1_enddo2
     cmp cl, 27               ;&& (charac!=27)); 
     jne P1_do2
     P1_enddo2:              
     
     cmp WORD[state], 5              ;if (state!=5) {
     je  P1_endif24
       call checkPlayP1       ;checkPlayP1_C();
	   dec DWORD[tries]       ;tries--;
	   cmp DWORD[tries], 0    ;if (tries == 0 
	   jne P1_endif25
	   cmp WORD[state], 1     ;&& state == 1) {
	   jne P1_endif25
         mov WORD[state], 4   ;state = 4;   
       P1_endif25:            ;}
     P1_endif24:              ;}
     
   jmp P1_while2
   P1_endwhile2:              ;} 
   
   mov  DWORD[row], 21
   mov  DWORD[col], 5
   call gotoxyP1              ;gotoxyP1_C();
   mov  edi, DWORD[tries]
   add  dil, '0'
   mov  BYTE[charac], dil     ;charac=tries + '0';
   call printchP1             ;printchP1_C();
   call printSecretPlayP1     ;printSecretPlayP1_C();
   call printMessageP1        ;printMessage_C();
   P1_end:
   
   pop rcx
   
   mov rsp, rbp
   pop rbp
   ret
