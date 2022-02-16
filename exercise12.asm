
.data 
STR: .space 48 ;# str 3*16
N: .space 24 ;# int[3] 8*3
stack: .space 32

p1sys5: .space 8;
ind_i: .space 8 ;#ris, 1° arg msg2 ::: int ris x il return funzione
N_i: .space 8 ;# 2° arg msg3

p1sys3: .word 0 ;# fd 0, stdin
ind: .space 8
dim: .word 16

msg1: .asciiz "inserire str con solo lettere minuscole"
msg2: .asciiz "stringa errata"
msg3: .asciiz "N[%d]=%d\n"

.code
;#init stack
daddi $sp,$0,stack
daddi $sp,$sp,32

daddi $s4,$0,-1 ;# lo uso per vedere se ris==-1 dopo

;#for i<3 (senza i++)
    daddi $s0,$0,0      ;# i=0 per STR (*16)
    daddi $s1,$0,0      ;# i=0 per N (*8)
for1: 
    slti $t0,$s0,48        ;# i<3*16
    beq $t0,$0,fine
    ;#printf msg1
    daddi $t0,$0,msg1
    sd $t0,p1sys5($0)
    daddi r14,$0,p1sys5
    syscall 5
    ;#scanf %s STR[i] con i=$s0 (*16 di incremento a fine ciclo --------------------------------------------------------)
    daddi $t0,$s0,STR ;# $t0= STR[i] (i=$s0),non $0. Passo STR[i][16]
    sd $t0,ind($0)
    daddi r14,$0,p1sys3
    syscall 3
    move $s2,r1         ;#$s2=strlen(STR[i])

    ;# ris=verifica(STR[i],strlen(STR[i])
    daddi $a0,$s0,STR   ;# $a0=STR[i]
    move $a1,$s2        ;# $a1=strlen(STR[i]
    jal verifica
    move $s3,r1         ;# return della funzione

    ;# if(ris==-1)
    bne $s3,$s4,else ;# se ris!==-1 --> else, se no continua e fa if
    ;# if ovvero printf msg2
    daddi $t0,$0,msg2
    sd $t0,p1sys5($0)
    daddi r14, $0,p1sys5
    syscall 5
    j for1 ;#  riprende il printf msg1
else:
    sd $s3,N($s1) ;# N[i]=ris
    ;#printf msg3
    dsra $t0,$s1,3 ;# $t0=$s1/8 (ricavo i dell'N, multiplo di 8) shift sx
    sd $t0,ind_i($0) ;# ind_i = i (non in multipli di 8)
    ld $t0,N($s1) ;# $t0 = N[i] con i =$s1 (multiplo di 8, x N)
    sd $t0,N_i($0)

    daddi $t0,$0,msg3
    sd $t0,p1sys5($0)
    daddi r14,$0,p1sys5
    syscall 5

    ;# i++ (nell'else)

    daddi $s0,$s0,16    ;# i++ per STR (*16)
    daddi $s1,$s1,8     ;# i++ per N (*8)

    j for1 ;# loop for

fine: syscall 0

;# int verifica  
verifica: 
    daddi $sp,$sp,-8
    sd $s0,0($sp)   ;# $s0 come i della funzione per scorrere for e str

    ;# for i<d d=strlen
    daddi $s0,$0,0 ;#i=0
for_ver:
    slt $t0,$s0,$a1     ;# $t0=0 se $s0 (i) >= $a1 (strlen) 
    beq $t0,$0, return  ;# fine for se $t0=0
    ;# if(str[i]<97||>=123) --> return1
    dadd $t0,$a0,$s0    ;# $t0 = &str[i] con i=$s0 
    lbu $t1,0($t0)      ;# carico il singolo byte

    slti $t2,$t1,97     ;# $t2=1 se str[i] < 97, =0 se str[i]>=97
    bne $t2,$0,return_1 ;# in alternativa beq $t2,$t3 (=1) , return1

    slti $t2,$t1,123    ;# $t2=1 se str[i] <123, =0 se >= 123
    beq $t2,$0,return_1 ;# $va a return_1 se >=123, $t2=0

    daddi $s0,$s0,1 ;# i++ per la funzione, non ha multipli in quanto lavora coi singoli bit
    j for_ver

return_1: ;# return -1
    daddi r1,$0,-1
    j ripristina
    ;# return d
return: 
    move r1,$a1
ripristina:
    ld $s0,0($sp)
    daddi $sp,$sp,8

    jr $ra
