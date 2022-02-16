STR[3][16] e int N[3], ris. <br>Ciclo for di 3 in cui printf msg1: scanf su STR[i] e chiamo la funzione verifica, che ha args STR[i] e strlen.<br>
la funzione verifica vede se la str è fatta di lettere minuscole, ovvero char compresi tra 97 e 124. <br>scorre la str con l'indice i, del ciclo for che esegue max d = strlen cicli. Se non è mai soddisfatto l'if (cioè se tutte le lettere sono minuscole) torna d = strlen; altrimenti torna -1.
<br>la funzione ritorna l'int ris, se esso è -1 allora printf stringa errata msg2 altrimenti : N[i]=ris, printf msg3 con 2 args.<br>
nell'else (str senza problemi) va il i++ del ciclo for del main, ovvero se ris==-1 esco dal ciclo for.
