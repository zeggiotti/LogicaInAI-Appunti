#import "../template.typ": *

= La Logica Intuizionistica

In questo capitolo si introduce la seconda parte del corso, il cui obiettivo è arrivare alla dimostrazione della _corrispondenza di Curry-Howard_, ossia la corrispondenza tra programmi e dimostrazioni. Con questo scopo, si affronteranno tre argomenti, ovvero la _logica intuizionistica_, che definiremo e studieremo per arrivare all'automatizzazione delle dimostrazioni, e in particolare l'interpretazione intuizionistica dei connettivi e dei principi classici e la semantica #pb[Bhk] della logica intuizionistica, il _$lambda$-calcolo_ e la _normalizzazione_ delle dimostrazioni, che sfrutta l'idea che le formule corrispondano a tipi in un linguaggio di programmazione, e le prove corrispondano a programmi, per computare mediante le prove. Successivamente, studieremo la logica modale, con la teoria della dimostrazione e la normalizzazione della logica modale, e le sue applicazioni ai sistemi multi-agente e all'epistemologia. Osserveremo che, scartando anche la regola _ex falso_ oltre a $#pb[Raa]$ e $#pb[Tnd]$, si ottiene la logica minimale, che corrisponde al tipaggio semplice dei linguaggi di programmazione. In particolare, il $lambda$-calcolo che studieremo è una variante del $lambda$-calcolo semplicemente tipato.

== _Sulla Differenza tra Ragionamento Classico e Costruttivo_

Il _costruttivismo_ è un approccio al ragionamento matematico in cui, con l'obiettivo di dimostrare che un particolare oggetto matematico esiste, è sempre necessario _costruirlo_. Nella matematica _classica_, invece, è possibile dimostrare l'esistenza di un oggetto matematico senza trovarlo esplicitamente, ad esempio dimostrando che la sua non esistenza porterebbe ad una contraddizione. In questo contesto, una prova in _logica intuizionistica_, la quale costituisce un sistema logico costruttivistico, deve sempre mostrare un'esecuzione, mediante la _corrispondenza di Curry-Howard_, in grado di validare quella specifica prova. L'_intuizionismo_, fondato dal matematico olandese L. E. J. Brouwer all'inizio del XX secolo, è una delle scuole di pensiero costruttiviste, ed è quella che studieremo, applicandola alla logica proposizionale, alla logica del primo ordine e alla logica minimale. Il punto centrale dell'intuizionismo è una nuova nozione di verità:
$
  "vero" quad <--> quad "dimostrabile"
$
ovvero, una formula è vera se e solo se siamo in grado di _costruirne_ una prova. Una conseguenza immediata è che i principi classici, come $#pb[Raa]$ e il terzo escluso, non sono ammessi. Da un punto di vista intuitivo, questo è necessario perché l'impiego di questi principi permetterebbe la dimostrabilità dell'esistenza di specifici oggetti matematici, senza fornirne, però, una costruzione esplicita. Da un punto di vista pratico, invece, scartare questi principi è necessario siccome la _corrispondenza di Curry-Howard_ funziona completamente soltanto per la logica intuizionistica. Intuitivamente, il motivo per cui è necessario ridursi alla logica intuizionistica per poter dimostrare la _corrispondenza di Curry-Howard_ è che i principi classici come #pb[Raa] o il terzo escluso non ammettono una controparte computazionale esplicita e, dunque, non possono rappresentare passi elementari di computazione. Si noti, tuttavia, che l'approccio costruttivista può essere applicato anche alla logica classica, ma non permetterebbe di ottenere l'intuizionismo esatto, e quindi non varrebbe la _corrispondenza di Curry-Howard_ per un tale sistema logico costruttivista. Analizziamo, dunque, come cambia il significato dei connettivi da un punto di vista costruttivo.

#definizione(title: [Quantificazione esistenziale])[
  Per dimostrare, costruttivamente, la validità della formula $sigma := exists x. phi(x)$ in un sistema logico intuizionistico, dove la variabile $x$ varia in un dominio di valori $D$, è necessario
  + esibire un elemento $a in D$, detto _testimone_, tale per cui vale $phi(a)$
  + fornire una prova, o una dimostrazione costruttiva, della validità di $phi(a)$
]

In logica intuizionistica, dunque, i testimoni devono essere forniti esplicitamente per dedurre la validità della formula $exists x. phi(x)$. Non è mai sufficiente, quindi, dimostrare che la non esistenza di un tale elemento $x$ porterebbe ad un assurdo.

#definizione(title: [Disgiunzione])[
  Per dimostrare, costruttivamente, la validità dell formula $phi or psi$, è necessario
  + fornire una prova costruttiva della formula $phi$, _oppure_
  + fornire una prova costruttiva della formula $psi$
]

Dunque, in logica intuizionistica, volendo fornire una dimostrazione per la fomula $phi or psi$, per l'approccio costruttivista è necessario indicare esplicitamente quale dei due disgiunti abbiamo dimostrato. Consideriamo, ad esempio, la formula $phi := bold("P") = bold("NP")$. In logica classica vale $phi or not phi$, ossia $bold("P") = bold("NP")$ oppure $bold("P") != bold("NP")$. In logica intuizionistica, invece, per affermare $phi or not phi$ dobbiamo mostrare una prova di $phi$ oppure una prova di $not phi$, e attualmente non disponiamo né dell'una né dell'altra. Non possiamo, dunque, affermare $phi or not phi$. In generale, il terzo escluso è rifiutato, così come $#pb[Raa]$, poiché non è lecito assumere che $phi or not phi$ sia sempre vero senza fornire una prova di $phi$ o di $not phi$. Ne consegue che, in logica intuizionistica, siamo in grado di dimostrare meno teoremi rispetto alla logica classica. Si noti, però, che il terzo escluso non è rifiutato in ogni sua istanza. Infatti, vi sono istanze accettate del terzo escluso, poiché è possibile mostrare una prova per entrambi i rami. Ad esempio, per $n in NN$, vale $(n = 0) or (n != 0)$, poiché l'uguaglianza tra numeri naturali è decidibile siccome, dato un numero $n$ naturale, possiamo sempre stabilire con un calcolo efficiente quale dei due disgiunti valga.

#definizione(title: [Implicazione])[
  Una dimostrazione costruttiva della formula $alpha -> beta$ è una _costruzione_, ovvero una trasformazione $f$ tale che, data una prova $pi$ di $alpha$, restituisce una prova $pi' = f(pi)$ di $beta$.
]

In altre parole, l'implicazione $->$ trasforma prove di $alpha$ in prove di $beta$. Per dimostrare $alpha -> beta$ in logica intuizionistica, quindi, è necessario mostrare che esiste una tale trasformazione $f$, e non che esistono le dimostrazioni per $not alpha$ oppure $beta$. Dunque, in logica intuizionistica, dimostrare $alpha -> beta$ significa trasformare una prova di $alpha$ in una prova di $beta$, e la dimostrazione diventa un oggetto matematico in logica intuizionistica, che è manipolato e trasformato dalla funzione $f$. In questo modo, si riesce a codificare il significato costruttivo dell'implicazione, ovvero che, data una prova per la formula $alpha$, dobbiamo essere in grado di esibire una prova per la formula $beta$ mediante la trasformazione calcolata dalla funzione $f$. Si noti che l'equivalenza classica $(A -> B) <-> (not A or B)$ non è ammissibile in logica intuizionistica, poiché altrimenti si potrebbe codificare il terzo escluso. Infatti, a partire dall'implicazione $A -> A$ che è banalmente dimostrabile, otterremmo il principio classico $not A or A$. In particolare, in logica intuizionistica vale il principio $phi -> not not phi$, mentre non vale il principio $not not phi -> phi$. Infatti, possiamo derivare, in logica intuizionistica, la seguente prova
#albero(rule(name: $-> I^1$, $phi -> not not phi$, rule(name: $-> I^2$, $not not phi$, rule(name: $-> E$, $bot$, $[phi]^1$, $[not phi]^2$))))
che non impiega la regola $#pb[Raa]$, né il terzo escluso. Intuitivamente, sebbene impareremo a formalizzare la nozione di derivabilità in logica intuizionistica, questa derivazione corrisponde alla trasformazione che, data una prova $p$ di $phi$, restituisce la funzione che a sua volta trasforma ogni prova $f$ di $not phi$ nella prova $f(p)$ di $bot$. Al contrario, è possibile dimostrare che ogni derivazione della formula $not not phi -> phi$ deve impiegare un principio classico, come la regola #pb[Raa], per cui questo principio non può essere ammesso in logica intuizionistica.

#esempio(numbered: false, title: [Un ragionamento classico])[Consideriamo il problema che richiede se _esistono due numeri irrazionali $a$ e $b$ tali che $a^b$ sia razionale._ Applichiamo il seguente ragionamento, molto elegante. Si consideri il numero $sqrt(2)^sqrt(2)$. Se esso è razionale, allora abbiamo risolto il problema, con $a = b = sqrt(2)$. Se, invece, $sqrt(2)^sqrt(2)$ è irrazionale, allora
$
  (sqrt(2)^sqrt(2))^sqrt(2) = sqrt(2)^(sqrt(2) dot sqrt(2)) = sqrt(2)^2 = 2
$
è razionale, e il problema è risolto con $a = sqrt(2)^sqrt(2)$ e $b = sqrt(2)$. In entrambi i casi esiste una soluzione, per cui la risposta al problema, mediante un ragionamento puramente classico che deriva dal terzo escluso, è _sì_. Tuttavia, se fosse anche richiesto di produrre effettivamente una tale coppia di numeri $a, b$, dovremmo impegnarci in una serie di calcoli e dimostrazioni complesse della teoria dei numeri per stabilire quale delle due scelte sia quella corretta, ovvero se $sqrt(2)^sqrt(2)$ sia razionale o meno. La dimostrazione, infatti, è una _dimostrazione per casi_ che assume che il numero reale $sqrt(2)^sqrt(2)$ sia razionale oppure irrazionale, ossia usa il terzo escluso, e quindi non fornisce un testimone esplicito. In conclusione, essa è classicamente corretta, ma non costruttiva.]

#esempio(title: [Teorema di Euclide], numbered: false)[
  Possiamo anche domandarci se la seguente dimostrazione sia costruttiva.
  
  _Teorema_: L'insieme di tutti i numeri primi non è finito.
  
  _Dimostrazione_. Supponiamo che esista soltanto un numero finito $k$ di numeri primi $p_1 = 2, p_2 = 3, dots, p_k$. Sia $n := p_1 dot dots dot p_k + 1$, e scegliamo un divisore primo $p_i$ di $n$, ossia un divisore tale che $n = p_i dot n_1$ per qualche intero $n_1 in NN$. Per definizione, possiamo anche scrivere $n = p_i dot n_2 + 1$ per il valore $n_2=p_1dot dots dot p_(i-1) dot p_(i+1) dot dots dot p_k in NN$. Dunque $p_i dot n_1 = p_i dot n_2 + 1$, ossia $p_i dot (n_1 - n_2) = 1$. Nei numeri naturali, se $a dot b = 1$ allora $a = b = 1$, che contraddice l'ipotesi che $p_i$ sia primo. La dimostrazione procede per assurdo, ma dimostra un enunciato _negativo_, ossia che l'insieme dei numeri primi _non è finito_, e dunque la contraddizione è usata per introdurre una negazione mediante la regola di derivazione $-> I$ con conclusione $not A$, che è perfettamente lecito anche in logica intuizionistica. Inoltre, essa fornisce implicitamente un procedimento per costruire, a partire da una lista di numeri primi, un nuovo numero primo non presente nella lista.
]

== _La Deduzione Naturale Intuizionistica_

Dopo aver introdotto le basi del pensiero costruttivistico, e l'approccio intuizionistico alle dimostrazioni, derivazioni e al pensiero matematico, introduciamo il sistema deduttivo che permette di derivare meccanicamente, e in funzione della sola sintassi di una formula, una derivazione e, quindi, una dimostruzione per un enunciato che può essere considerato valido in logica intuizionistica. Indichiamo con $cal(N)_C$ la deduzione naturale classica, studiata nei capitoli precedenti, e con $cal(N)_I$ la deduzione naturale intuizionistica. Il sistema di deduzione naturale per l'intuizionismo si ottiene eliminando la regola $#pb[Raa]$, e mantenendo l'_ex falso_:
$
  cal(N)_I := cal(N)_C without {#pb[Raa]}
$
Si noti che il principio $bot -> delta$ è intuizionisticamente accettabile, ed è equivalente alla regola $bot_i$, mentre il principio $delta or not delta$ non è intuizionisticamente accettabile, ed è equivalente alla regola $#pb[Raa]$.
#alberi(
  rule(name: $bot_i$, $delta$, $bot$),
  rule(name: $#pb[Raa]$, $delta$, deriv($[not delta]$, $cal(D)$, $bot$)),
)
L'_ex falso_ è generalmente accettato in logica intuizionistica, poiché ammette un corrispettivo significato computazionale analogo. Infatti, esso rappresenta l'aver raggiunto un errore nella computazione, a partire dal quale si può _concludere_ qualunque cosa. Se si scarta anche l'_ex falso_, si ottiene la _logica minimale_, in cui non si gestisce la contraddizione $bot$. Per questo motivo, la logica minimale corrisponde al tipaggio semplice, da cui si sviluppa il $lambda$-calcolo semplicemente tipato. Indichiamo con $Gamma scripts(tack)_i A$ la relazione di derivabilità in logica intuizionistica, la cui definizione è analoga alla definizione fornita per la logica classica. Quando è chiaro dal contesto che stiamo trattando la logica intuizionistica, scriveremo semplicemente $Gamma tack A$.

#teorema[
  In logica intuizionistica, sono validi i seguenti teoremi.
  + $tack not phi <-> not not not phi$
  + $tack (phi and not psi) -> not (phi -> psi)$
  + $tack (phi -> psi) -> (not not phi -> not not psi)$
  + $tack not not (phi -> psi) <-> (not not phi -> not not psi)$
  + $tack not not (phi and psi) <-> (not not phi and not not psi)$
  + $tack not not forall x. phi(x) -> forall x. not not phi(x)$
]

Come è possibile osservare dal teorema appena enunciato, non possiamo aspettarci di ottenere, in logica intuizionistica, risultati forti come in logica classica. Infatti, riusciremo a dimostrare soltanto risultati più deboli, che solitamente coinvolgono negazioni e doppie negazioni. Per la direzione ($arrow.l$) del punto ($i$), sfruttiamo il teorema $phi -> not not phi$, che non appartiene all'insieme di ipotesi non scaricate dalla derivazione siccome è un teorema valido in logica intuizionistica.
#albero(rule(name: $-> I^2$, $not not not phi -> not phi$, rule(name: $-> I^1$, $not phi$, rule(name: $-> E$, $bot$, rule(name: $-> E$, $not not phi$, $[phi]^1$, $overline(phi -> not not phi)$), $[not not not phi]^2$))))
La direzione ($->$), invece, è un'istanza del teorema $psi -> not not psi$, dove si pone $psi = not phi$. Per il punto ($i i$), invece, costruiamo la seguente derivazione.
#albero(rule(name: $-> I^2$, $(phi and not psi) -> not (phi -> psi)$, rule(name: $-> I^1$, $not (phi -> psi)$, rule(name: $-> E$, $bot$, rule(name: $-> E$, $psi$, rule(name: $and E$, $phi$, $[phi and not psi]^2$), $[phi -> psi]^1$), rule(name: $and E$, $not psi$, $[phi and not psi]^2$)))))
In conclusione, questa _Legge di De Morgan_ _sopravvive_ in logica intuizionistica, mentre la direzione ($arrow.l$) no, in quanto ogni sua derivazione deve utilizzare la regola #pb[Raa], oppure un principio classico ad essa equivalente. Infine, per il punto ($i i i$), costruiamo la seguente derivazione.
#albero(rule(name: $-> I^4$, $(phi -> psi) -> (not not phi -> not not psi)$, rule(name: $-> I^3$, $not not phi -> not not psi$, rule(name: $-> I^2$, $not not psi$, rule(name: $-> E$, $bot$, rule(name: $-> I^1$, $not phi$, rule(name: $-> E$, $bot$, rule(name: $-> E$, $psi$, $[phi]^1$, $[phi -> psi]^4$), $[not psi]^2$)), $[not not phi]^3$)))))

#esercizio(numbered: false)[
  Si derivino in deduzione naturale intuizionistica, $cal(N)_I$, i punti ($i v$), ($v$) e ($v i$) del precedente teorema.
]

In logica intuizionistica, inoltre, valgono i seguenti principi:
- _Ex falso quodlibet sequitur_: $bot -> P$
- _Principium contradictionis_: $not (P and not P)$
- _Proprietà di disgiunzione_: se $P or Q$ è dimostrabile, allora $P$ è dimostrabile oppure $Q$ è dimostrabile
- _Doppia negazione del terzo escluso_: $not not (P or not P)$ è dimostrabile

La proprietà di disgiunzione è la traduzione, a livello di sistema deduttivo, del significato costruttivo della disgiunzione, e chiaramente non sempre vale in logica classica, siccome si può derivare $scripts(tack)_c P or not P$ ma, in generale, né $P$ né $not P$ ammettono una derivazione nota. La doppia negazione del terzo escluso, invece, mostra che, sebbene non si possa affermare $P or not P$, non si può neanche negarlo. Dunque, il terzo escluso non è _falso_ in logica intuizionistica, semplicemente non è dimostrabile.

== _Sistemi Deduttivi Alternativi: la Presentazione alla Hilbert_

Oltre alla deduzione naturale, esistono altri sistemi deduttivi per la logica intuizionistica. Storicamente, il primo ad essere stato introdotto è il _sistema alla Hilbert_, in cui le dimostrazioni non sono alberi di derivazione, ma sequenze lineari di formule, ciascuna delle quali è un _assioma_, un'ipotesi, oppure è ottenuta da formule precedenti mediante un'unica regola di inferenza, il _modus ponens_. Tutto il _ragionamento_ compiuto dal sistema deduttivo, quindi, è codificato negli assiomi, che sono schemi di formule. Per la logica proposizionale intuizionistica, gli schemi di assiomi del _sistema alla Hilbert_ sono i seguenti:
+ $phi -> (psi -> phi)$
+ $(phi -> (psi -> sigma)) -> ((phi -> psi) -> (phi -> sigma))$
+ $phi and psi -> phi$ e $phi and psi -> psi$
+ $phi -> (psi -> phi and psi)$
+ $phi -> phi or psi$ e $psi -> phi or psi$
+ $(phi -> sigma) -> ((psi -> sigma) -> (phi or psi -> sigma))$
+ $bot -> phi$
e l'unica regola di inferenza è il _modus ponens_, ovvero da $phi$ e $phi -> psi$ si deduce $psi$. Per la logica del primo ordine, inoltre, si aggiungono al sistema deduttivo _alla Hilbert_ gli assiomi $forall x. phi -> phi[t slash x]$ e $phi[t slash x] -> exists x. phi$, con $t$ un termine libero per $x$ in $phi$, e le regole che, da $psi -> phi$, permettono di dedurre $psi -> forall x. phi$, e da $phi -> psi$ di dedurre $exists x. phi -> psi$, se $x in.not #pb[Fv];(psi)$. Aggiungendo lo schema $not not phi -> phi$ oppure $phi or not phi$, dunque, si ottiene la logica classica, mentre rimuovendo l'assioma ($v i i$) si ottiene la logica minimale. Si osservi la corrispondenza tra gli assiomi e le regole della deduzione naturale: l'assioma ($i i i$) corrisponde alla regola $and E$, l'assioma ($i v$) alla regola $and I$, l'assioma ($v$) alla regola $or I$, l'assioma ($v i$) alla regola $or E$, l'assioma ($v i i$) alla regola $bot_i$, e il _modus ponens_ alla regola $-> E$. La regola $-> I$, che scarica le ipotesi nel sistema di deduzione naturale, non ha un corrispondente diretto nel _sistema alla Hilbert_, siccome nessuno schema di assiomi permette di scaricare un'ipotesi. Il ruolo svolto da questa regola nella deduzione naturale, però, è svolto dagli assiomi ($i$) e ($i i$), grazie al seguente teorema.

#teorema(title: [Teorema di Deduzione])[
  Nel sistema di deduzione alla Hilbert, $Gamma, phi tack psi$ se e solo se $Gamma tack phi -> psi$.
]

La dimostrazione procede per induzione sulla lunghezza della derivazione della formula $psi$ dall'insieme di ipotesi $Gamma, phi$, ed utilizza proprio gli assiomi ($i$) e ($i i$) dello schema di assiomi. Grazie al teorema di deduzione, si può dimostrare che il _sistema alla Hilbert_ e la deduzione naturale intuizionistica sono sistemi deduttivi equivalenti, ovvero che derivano lo stesso insieme di formule. I _sistemi alla Hilbert_, tuttavia, hanno il vantaggio di definire un'unica regola di derivazione, che li rende semplici da studiare metamatematicamente. Ciò nonostante, le dimostrazioni derivate in questo sistema di deduzione sono molto meno naturali e leggibili. Ad esempio, già la dimostrazione di $phi -> phi$ richiede cinque passi:
+ $phi -> ((phi -> phi) -> phi)$, istanza dell'assioma ($i$)
+ $(phi -> ((phi -> phi) -> phi)) -> ((phi -> (phi -> phi)) -> (phi -> phi))$, istanza dell'assioma ($i i$)
+ $(phi -> (phi -> phi)) -> (phi -> phi)$, per _modus ponens_ da 1. e 2.
+ $phi -> (phi -> phi)$, istanza dell'assioma ($i$)
+ $phi -> phi$, per _modus ponens_ da 3. e 4.
Come vedremo nella sezione dedicata al $lambda$-calcolo, gli assiomi ($i$) e ($i i$) corrispondono ai combinatori $K$ e $S$ della logica combinatoria, e la dimostrazione appena vista corrisponde all'identità $I = S K K$.

== L'Interpretazione #pb[Bhk]

Rimane da formalizzare la nozione intuitiva di prova costruttiva che è stata introdotta, ovvero determinare lo strumento semantico per mezzo del quale, data una derivazione intuizionistica in deduzione naturale, permette di costruire la prova semantica della formula derivata. L'_interpretazione di Brouwer-Heyting-Kolmogorov_ (#pb[Bhk]) è l'_unica_ e sola interpretazione semantica, o costruttivista, _completa_ della logica intuizionistica. Questa interpretazione semantica, invece di definire quando una formula è _vera_, essa definisce che cosa sia una _prova_, o la _costruzione_, di una formula, per induzione sulla struttura della formula stessa. In questa interpretazione, le prove diventano oggetti matematici e semantici del dominio della struttura, che possiamo associare, grazie alla _corrispondenza Curry-Howard_, ai programmi, anche detti _realizzatori_.
$
  "prove" quad tilde quad "programmi" quad tilde quad "realizzatori"
$
Con la notazione _$a$ prova $phi$_, o anche $a : phi$, indichiamo che la prova $a$ è una prova, o una costruzione, di $phi$.

#definizione(title: [Interpretazione #pb[Bhk]])[Si definisce, di seguito, l'interpretazione semantica delle formule in logica intuizionistica del primo ordine, che costituisce l'interpretazione #pb[Bhk]. In particolare, per l'interpretazione #pb[Bhk], una formula $phi$ è semanticamente valida se e solo se ammette una prova $a$, anche detta costruzione. La prova $a$ può essere costruita per mezzo delle seguenti regole induttive:
  - ($and$) $a$ prova $phi and psi$ se $a$ è una coppia ordinata $⟨b, c⟩$ tale che $b$ prova $phi$ e $c$ prova $psi$
  - ($or$) $a$ prova $phi or psi$ se $a$ è una coppia ordinata $⟨b, c⟩$ tale che $b$ è un numero naturale e, se $b = 0$ allora $c$ prova $phi$, mentre se $b != 0$ allora $c$ prova $psi$
  - ($->$) $a$ prova $phi -> psi$ se $a$ è una costruzione, o funzione di trasformazione, che converte qualunque prova $p$ di $phi$ in una prova $a(p)$ di $psi$
  - ($bot$) nessun $a$ prova $bot$
  Per trattare i quantificatori, assumiamo che sia dato un dominio $D$ di oggetti semantici. Per questa assunzione, $b in D$ è un oggetto semantico del dominio, mentre $overline(b)$ è l'etichetta che denota l'oggetto semantico $b$ nel linguaggio formale definito dalla logica intuizionistica del primo ordine in considerazione.
  - ($forall$) $a$ prova $forall x. phi(x)$ se $a$ è una costruzione tale che, per ogni $b in D$, $a(b)$ prova $phi(overline(b))$
  - ($exists$) $a$ prova $exists x. phi(x)$ se $a$ è una coppia $⟨b, c⟩$ tale che $b in D$ e $c$ prova $phi(overline(b))$
  Se, data una formula $phi$ del primo ordine arbitraria, esiste una costruzione $a$ in grado di provare la formula $phi$, allora $phi$ è semanticamente vera per l'interpretazione #pb[Bhk]. Si noti che, siccome $not phi = phi -> bot$, una prova di $not phi$ è una costruzione che trasforma ogni prova di $phi$ in una prova di $bot$. Siccome non esistono prove di $bot$ per definizione, questo significa che non possono esistere prove di $phi$.
]

#esempio[
  Mostriamo che $phi and psi -> phi$ è vero secondo l'interpretazione #pb[Bhk]. Sia $⟨a, b⟩$ una prova di $phi and psi$. Allora la costruzione $c$ tale che $c(⟨a, b⟩) = a$ converte una prova di $phi and psi$ in una prova di $phi$. Dunque $c$ prova $phi and psi -> phi$.
]

#esempio[
  Mostriamo che $(phi and psi -> sigma) -> (phi -> (psi -> sigma))$ è vero secondo l'interpretazione #pb[Bhk]. Sia $a$ una prova di $phi and psi -> sigma$, ossia $a$ converte ogni prova $⟨b, c⟩$ di $phi and psi$ in una prova $a(⟨b, c⟩)$ di $sigma$. La prova $p$ di $phi -> (psi -> sigma)$ che cerchiamo è una costruzione che converte ogni prova $b$ di $phi$ in una prova $p(b)$ di $psi -> sigma$. Dunque $p(b)$ è una costruzione che converte una prova $c$ di $psi$ in una prova $(p(b))(c)$ di $sigma$. Ricordando che avevamo una prova $a(⟨b, c⟩)$ di $sigma$, poniamo $(p(b))(c) = a(⟨b, c⟩)$. Sia $q$ la costruzione definita da $q(c) = a(⟨b, c⟩)$, allora $p$ è definita da $p(b) = q$. Chiaramente, quanto descritto è una costruzione che converte $a$ in una prova $p$ di $phi -> (psi -> sigma)$. In analogia con la notazione del $lambda$-calcolo, questa costruzione corrisponde al termine $p = lambda b. lambda c. a(⟨b, c⟩)$, per cui la prova cercata è $lambda a. lambda b. lambda c. a(⟨b, c⟩)$, ovvero si è codificata esattamente la proprietà di _currying_.
]

L'interpretazione #pb[Bhk], per costruzione, suggerisce una possibile _decorazione_ induttiva delle derivazioni in deduzione naturale mediante le prove, ovvero i programmi, che esse costruiscono. Partendo dalle ipotesi, l'idea è quella di annotare una derivazione con gli oggetti semantici che la validano nella semantica #pb[Bhk]. Ad ogni ipotesi, quindi, si associa una variabile che corrisponde alla costruzione che la prova, e che si suppone esista per definizione di ipotesi, e ad ogni regola si associa l'operazione corrispondente sulle prove della semantica #pb[Bhk]. Ad esempio, $and E$ estrae una componente da una coppia, $-> E$ applica una funzione ad un argomento, $-> I$ costruisce una funzione, e $or I$ costruisce una coppia con un'etichetta.

#esempio(title: [Principium contradictionis])[
  Mostriamo $scripts(tack)_i not (A and not A)$. La derivazione non decorata è la seguente.
  #albero(rule(name: $-> I^1$, $not (A and not A)$, rule(name: $-> E$, $bot$, rule(name: $and E$, $A$, $[A and not A]^1$), rule(name: $and E$, $not A$, $[A and not A]^1$))))
  Ragioniamo in termini di semantica #pb[Bhk]. Per definizione, vale che $not (A and not A) = (A and not A) -> bot$, per cui dobbiamo trovare un realizzatore, o una funzione di trasformazione, per $(A and not A) -> bot$, ossia una costruzione che trasformi ogni prova di $A and not A$ in una prova di $bot$. Immaginiamo di considerare la coppia $⟨p, f⟩$, in cui $p$ è una prova di $A$ e $f$ è una prova di $not A$, ossia $f : A -> bot$. Annotiamo la prova precedente nel seguente modo.
  #albero(rule(name: $-> I^1$, $g:⟨p, f⟩ |-> f(p) : not (A and not A)$, rule(name: $-> E$, $f(p) : bot$, rule(name: $and E$, $p : A$, $[⟨p, f⟩ : A and not A]^1$), rule(name: $and E$, $f : not A$, $[⟨p, f⟩ : A and not A]^1$))))
  Dunque $f$ è la trasformazione che, data una prova $p$ di $A$, la trasforma in una prova di $bot$, e la prova di $not (A and not A)$ è la funzione $g : ⟨p, f⟩ |-> f(p)$.
]

#esempio(title: [Doppia negazione del terzo escluso])[
  Mostriamo $scripts(tack)_i not not (p or not p)$. Siccome $not not (p or not p) != p or not p = #pb[Tnd]$, questo è un teorema potenzialmente valido in logica intuizionistica. Annotiamo direttamente la derivazione, in cui assumiamo che $a$ sia una prova di $not (p or not p)$, ossia $a : (p or not p) -> bot$, e $p$#footnote[Con un pesante abuso di notazione, usiamo la stessa lettera per la formula atomica e per la sua prova.] sia una prova di $p$.
  #albero(rule(name: $-> I^2$, $a |-> a(⟨1, q⟩) : not not (p or not p)$, rule(name: $-> E$, $a(⟨1, q⟩) : bot$,
    rule(name: $or I_2$, $⟨1, q⟩ : p or not p$, rule(name: $-> I^1$, $q := p |-> a(⟨0, p⟩) : not p$, rule(name: $-> E$, $a(⟨0, p⟩) : bot$, rule(name: $or I_1$, $⟨0, p⟩ : p or not p$, $[p : p]^1$), $[a : not (p or not p)]^2$))),
    $[a : not (p or not p)]^2$)))
  Ancora una volta, partendo dalle ipotesi si annota la prova con gli oggetti semantici che la validano in semantica #pb[Bhk]. Si noti che la prova per $-> I$ ha sempre la forma di un _mapping_. Infatti, la prova di $not p$ è la funzione $q : p |-> a(⟨0, p⟩)$, che trasforma una prova di $p$ in una prova di $bot$, iniettando $p$ nella disgiunzione con l'etichetta $0$ e applicando $a$. La semantica #pb[Bhk] della prova è la funzione che, per la prova $a$, costruisce
  $
    a |-> a(⟨1, q⟩)
  $
]

#esempio[
  Dimostriamo $scripts(tack)_i (phi and not psi) -> not (phi -> psi)$ in logica intuizionistica, decorando la derivazione associata.
  #albero(rule(name: $-> I^2$, $c : ⟨p, q⟩ |-> (a |-> q(a(p))) : (phi and not psi) -> not (phi -> psi)$, rule(name: $-> I^1$, $b : a |-> q(a(p)) : not (phi -> psi)$, rule(name: $-> E$, $q(a(p)) : bot$, rule(name: $-> E$, $a(p) : psi$, rule(name: $and E$, $p : phi$, $[⟨p, q⟩ : phi and not psi]^2$), $[a : phi -> psi]^1$), rule(name: $and E$, $q : not psi$, $[⟨p, q⟩ : phi and not psi]^2$)))))
]

Si noti che una prova $p$ è associata alla formula $phi$ sintatticamente, ovvero, per ogni altra assunzione $phi$, sarà associata ad essa la stessa prova $p$. Le annotazioni che associamo alle formule, infatti, corrispondono al _tipo_ che associamo a quella formula in un linguaggio tipato come il $lambda$-calcolo. Queste annotazioni saranno il ponte che collega una prova ad un'interpretazione algoritmica, e costituiscono il primo passo verso la _corrispondenza di Curry-Howard_.

== La Semantica di Kripke per la Logica Intuizionistica

La _semantica di Kripke_, invece, è un'interpretazione semantica alternativa alla logica intuizionistica, introdotta da Saul Kripke negli anni \'60, e deve il suo successo e la sua fama alla concretezza e la semplicità che la distinguono dalla semantica #pb[Bhk], o della semantica della logica del primo ordine classica. L'idea di questa semantica è quella di rappresentare il processo di acquisizione della conoscenza da parte di un matematico, mediante una notazione che si presta a facili rappresentazioni grafiche ed intuitive. Ogni _mondo_, o stato del modello, infatti, rappresenta la conoscenza acquisita in un punto arbitrario della dimostrazione, ovvero la _conoscenza ad uno stadio_ (_knowledge at a stage_). I mondi sono rappresentati dai nodi di un grafo, e gli archi rappresentano le possibili transizioni tra stati, ossia i possibili sviluppi futuri della conoscenza. Per onore del vero, alcune interpretazioni della _semantica di Kripke_, come i sistemi agentici, assegnano un significato semantico anche alle transizioni tra stati, per fornire informazioni riguardo la transizione stessa. Tuttavia, nel caso della semantica per la logica intuizionistica, consideriamo soltanto la semantica dei mondi. Questo concetto di _conoscenza rappresentabile_, proprio a causa della versatilità di questa semantica, è stato riutilizzato estensivamente in diversi sistemi modali e di intelligenza artificiale. Tra gli stati del modello, inoltre, è definita una _relazione di transizione_ $w_i <= w_j$, che rappresenta il fatto che la conoscenza nello stato $w_j$ è un'estensione di quella nello stato $w_i$. In particolare, in un modello della _semantica di Kripke_ la conoscenza è _monotona_, ovvero, una volta che una proposizione è stata verificata, essa rimane valida in ogni stato futuro.

#definizione[
  Formalmente, un _modello di Kripke_ per la logica proposizionale intuizionistica è una quadrupla, definita come
  $
    cal(K) = ⟨K, <=, V, forces⟩
  $
  tale che
  - $K$ è un insieme di _mondi_ ${w_1, dots, w_j, dots}$
  - $<=$ è un _ordine parziale_ su $K$
  - $V : K -> 2^"PROP"$ è una _funzione di valutazione_, tale che, se $p in V(k)$ e $k <= k'$, allora $p in V(k')$. In altre parole, la _funzione di valutazione_, che rappresenta la conoscenza acquisita in uno stato del modello, deve essere _monotona_
  - $forces subset.eq K times "FORM"$ è una _relazione di forcing_, ovvero una relazione di inferenza di una proposizione arbitraria in uno stato del modello, che soddisfa le seguenti condizioni:
    - $k forces p$ se e solo se $p in V(k)$, per una formula $p$ atomica
    - $k forces phi and psi$ se e solo se $k forces phi$ e $k forces psi$
    - $k forces phi or psi$ se e solo se $k forces phi$ oppure $k forces psi$
    - $k forces.not bot$, ovvero nessuno stato raccoglie informazione, e, dunque, conoscenza, contraddittoria
    - $k forces phi -> psi$ se e solo se, per ogni $k'$ tale che $k <= k'$, se $k' forces phi$ allora $k' forces psi$
    - $k forces not phi$ se e solo se, per ogni $k'$ tale che $k <= k'$, vale $k' forces.not phi$
]

La funzione di valutazione $V$ associa, ad ogni mondo del modello, l'insieme delle proposizioni atomiche che sono vere in quel mondo. La monotonia, inoltre, richiede che tutte le proposizioni che valgono in un mondo valgano anche in tutti i mondi successivi, per cui l'ordine parziale non può _falsificare_ proposizioni vere scendendo lungo una catena di mondi del modello in relazione di ordinamento $<=$. Si noti che la relazione di _forcing_ è definita in modo classico per i connettivi $and$ e $or$, mentre l'implicazione e la negazione guardano agli stati _futuri_ nel modello, ovvero $phi -> psi$ è forzata in $k$ se, in ogni stato futuro in cui si verifica $phi$, si verifica anche $psi$. Inoltre, $not phi$ è forzata in $k$ se $phi$ non sarà _mai_ verificata in futuro. Si noti che, in un mondo del modello, non possono mai valere sia $k forces phi$ che $k forces not phi$, altrimenti si potrebbe codificare il terzo escluso siccome il nodo che soddisfa $phi$ e $not phi$ porterebbe, per monotonia, ad una contraddizione. Tuttavia, in un mondo del modello possono non valere né $k forces phi$ né $k forces not phi$ e, in questo caso, si dice che la conoscenza attuale non è sufficiente per stabilire la validità $phi$ nel mondo attuale, ma potrebbe essere possibile stabilire la validità di $phi$ in mondi _futuri_. Si noti, infine, che la _semantica di Kripke_ non è direttamente compatibile con la _corrispondenza di Curry-Howard_. Per garantire una piena compatibilità tra le due, infatti, è necessario che la _semantica di Kripke_ coincida con la semantica #pb[Bhk] della logica intuizionistica, e questo è vero soltanto se l'ordine $<=$ sui mondi del modello è un _preordine_, oppure un _ordine parziale_.

#corollario[
  + $k forces not phi$ se e solo se, per ogni $l >= k$, vale $l forces.not phi$
  + $k forces not not phi$ se e solo se, per ogni $l >= k$, esiste $p >= l$ tale che $p forces phi$
]

In altre parole, $k forces not not phi$ significa che, da qualunque stato futuro, è sempre possibile raggiungere uno stato in cui la formula $phi$ è verificata. Si noti come l'interpretazione della formula $not not phi$ sia distinta dall'interpretazione della formula $phi$, per un generico stato $k$ del modello. Infatti, se le due interpretazioni fossero equivalenti, allora la _semantica di Kripke_ sarebbe sufficientemente espressiva da poter codificare la formula $phi <-> not not phi$, per cui anche #pb[Raa] e il principio del terzo escluso.

#definizione[
  - $cal(K) forces phi$, ovvero _$phi$ è vera nel modello_ $cal(K)$, se $k forces phi$ per ogni $k in cal(K)$
  - $forces phi$, ovvero _$phi$ è valida_, se $cal(K) forces phi$ per ogni modello $cal(K)$, ossia per ogni struttura semantica per la logica intuizionistica del primo ordine nell'_interpretazione di Kripke_
  - $Gamma forces phi$ se, per ogni modello $cal(K)$ e per ogni $k in cal(K)$, se $k forces Gamma$ allora $k forces phi$
]

Come per le altre semantiche analizzate fino a questo punto, valgono i Teoremi di Correttezza e Completezza, che, tuttavia, non dimostriamo.

#teorema(title: [Correttezza e Completezza per la Logica Intuizionistica])[
  $Gamma scripts(tack)_i phi$ se e solo se $Gamma forces phi$.
]

In particolare, i teoremi valgono anche per la logica dei predicati intuizionistica, la cui _semantica di Kripke_ non è stata introdotta, con un'opportuna estensione dei modelli di Kripke alle formule che contengono quantificatori esistenziali ed universali, in cui ad ogni mondo deve essere associato un dominio di oggetti semantici sul quale verificare la validità della formula.

Prima di presentare la costruzione dei contromodelli, osserviamo alcuni esempi della procedura necessaria a verificare il forcing di una formula in un _modello di Kripke_. Nei disegni successivi, i mondi sono i nodi del grafo, l'ordine $<=$ è rappresentato dal basso verso l'alto, e accanto ad ogni mondo è indicato l'insieme $V(w)$ delle proposizioni atomiche in esso verificate.

#esempio[
  Consideriamo la struttura con due mondi $w_0 <= w_1$, e la formula $p -> q$. Sia $V(w_0) = emptyset$ e $V(w_1) = {q}$. Ci domandiamo se sia lecito affermare che $w_0 forces p -> q$. Sappiamo che $w_0 forces.not p$, perciò l'implicazione è vera in $w_0$. Inoltre, per $w_0 <= w_1$, vale che $w_1 forces.not p$, per cui l'implicazione è vera anche in $w_1$. Quindi l'affermazione è lecita. Se, invece, avessimo posto $V(w_0) = emptyset$ e $V(w_1) = {p}$, allora $w_1 forces p$ e $w_1 forces.not q$, per cui $w_0 forces.not p -> q$. Dunque, quest'ultimo è un contromodello che dimostra $forces.not p -> q$. Da un certo punto di vista, questa semantica è più concreta, semplice e versatile della semantica #pb[Bhk] o della semantica della logica del primo ordine classica.
]

#esempio[
  Consideriamo la formula $w forces not p$, che vale se e solo se per ogni $w'$ tale che $w <= w'$ vale $w' forces.not p$. Consideriamo una struttura con un mondo $w_0$ e due successori $w_1, w_2$, con $V(w_0) = emptyset$, $V(w_1) = {q}$ e $V(w_2) = emptyset$.
  #grafo(larghezza: 120pt, altezza: 70pt,
    nodi: ((60pt, 60pt, [$w_0$], []), (20pt, 10pt, [$w_1$], [${q}$]), (100pt, 10pt, [$w_2$], [$emptyset$])),
    archi: ((0, 1), (0, 2)))
  Questa struttura di Kripke è un modello per $w_0 forces not p$, poiché in nessun successore si forza $p$. Se, invece, $V(w_2) = {p}$, allora la struttura è un contromodello per $w_0 forces not p$, poiché $w_0 <= w_2$ e $w_2 forces p$. Si noti che i successori non devono necessariamente essere successori immediati, ma un qualunque successore in una catena di mondi definiti dal _preordine_ $<=$.
]

#esempio[
  Consideriamo la formula $w forces not not p$, che vale se e solo se per ogni $w'$ tale che $w <= w'$ esiste $w''$ tale che $w' <= w''$ e $w'' forces p$. Nella struttura con due mondi $w_0 <= w_1$, con $V(w_0) = emptyset$ e $V(w_1) = {p}$, vale $w_0 forces not not p$, poiché $w_0 <= w_1 <= w_1$ e $w_1 forces p$. Si noti, però, che $w_0 forces.not p$. Dunque, in questo modello $not not p$ è forzata, mentre $p$ no. Questo esempio mostra che le formule $p$ e $not not p$ sono semanticamente diverse in logica intuizionistica o, in questo caso specifico, nella _semantica di Kripke_.
]

Come conseguenza del Teorema di Correttezza, infine, possiamo dimostrare la _non derivabilità_ dei principi classici in logica intuizionistica esibendo contromodelli di _Kripke_. Infatti, poiché $scripts(tack)_i phi ==> forces phi$, vale che $forces.not phi ==> scripts(tack.not)_i phi$. Impieghiamo, quindi, il Teorema di Correttezza per dimostrare che una formula non è derivabile, ovvero troviamo un modello di Kripke in cui un mondo non forza la formula desiderata.

#esempio(title: [Terzo escluso])[
  Mostriamo che $scripts(tack.not)_i p or not p$. Consideriamo il modello con due mondi $0 <= 1$, tali per cui $V(0) = emptyset$ e $V(1) = {p}$.
  #grafo(larghezza: 60pt, altezza: 60pt, nodi: ((30pt, 52pt, [0], []), (30pt, 8pt, [1], [${p}$])), archi: ((0, 1),))
  Vale che $0 forces.not p$, poiché $p in.not V(0)$, e $0 forces.not not p$, poiché esiste $1 >= 0$ tale che $1 forces p$. Dunque $0 forces.not p or not p$. Si osservi che, nel mondo $0$, non sappiamo dire se $0 forces p$ o $0 forces not p$, poiché $V(0) = emptyset$. Come è stato precedentemente evidenziato, la conoscenza attuale non è sufficiente per decidere $p$, anche se, in futuro, la formula $p$ diventerà vera.
]

#esempio(title: [Eliminazione della doppia negazione])[
  Mostriamo che $scripts(tack.not)_i not not p -> p$, utilizzando lo stesso contromodello dell'esempio precedente. Vale che $0 forces not not p$, poiché da ogni mondo successivo a $0$, ovvero $0$ e $1$, si può raggiungere il mondo $1$, in cui viene forzata $p$. Analogamente, $1 forces not not p$. Tuttavia, $0 forces.not p$. Dunque $0 forces.not not not p -> p$, poiché $0 <= 0$, $0 forces not not p$ e $0 forces.not p$. Quindi, in generale, in logica intuizionistica non vale l'equivalenza $p equiv not not p$, quando la _semantica di Kripke_ coincide con l'interpretazione #pb[Bhk] della logica intuizionistica.
]

#esempio(title: [Legge di De Morgan])[
  Mostriamo che $scripts(tack.not)_i not (phi and psi) -> (not phi or not psi)$. Consideriamo il modello con un mondo $0$ e due successori $1, 2$, tali per cui $V(0) = emptyset$, $V(1) = {phi}$ e $V(2) = {psi}$.
  #grafo(larghezza: 120pt, altezza: 70pt,
    nodi: ((60pt, 60pt, [0], []), (20pt, 10pt, [1], [${phi}$])  , (100pt, 10pt, [2], [${psi}$])),
    archi: ((0, 1), (0, 2)))
  In nessun mondo successore di $0$ valgono sia $phi$ che $psi$, per cui ${0, 1, 2} forces.not phi and psi$, e quindi $0 forces not (phi and psi)$. Ne segue che l'implicante è vero. D'altra parte, $0 forces not phi or not psi$ se e solo se $0 forces not phi$ oppure $0 forces not psi$. Ma $0 forces.not not phi$ poiché $1 forces phi$, e $0 forces.not not psi$ poiché $2 forces psi$. Dunque l'implicato è falso, per il quale concludiamo che $0 forces.not not (phi and psi) -> (not phi or not psi)$.
]

#esempio(title: [Significato classico dell'implicazione])[
  Mostriamo che $scripts(tack.not)_i (phi -> psi) -> (not phi or psi)$. Consideriamo il modello con due mondi $0 <= 1$, con $V(0) = emptyset$ e $V(1) = {phi, psi}$. Vale che $0 forces phi -> psi$, poiché per ogni $i in {0,1}$, se $i forces phi$ allora $i forces psi$, in quanto l'unico mondo che forza $phi$ è $1$, il quale forza anche $psi$. D'altra parte, $0 forces.not not phi or psi$ siccome $0 forces.not not phi$ poiché $1 forces phi$, e $0 forces.not psi$ poiché $psi in.not V(0)$. Dunque, concludiamo che $0 forces.not (phi -> psi) -> (not phi or psi)$.
]

#esempio[
  Mostriamo che $scripts(tack.not)_i (p -> q) or (q -> p)$. Consideriamo il modello con un mondo $0$ e due successori $1, 2$, tali per cui $V(0) = emptyset$, $V(1) = {p}$ e $V(2) = {q}$.
  #grafo(larghezza: 120pt, altezza: 70pt,
    nodi: ((60pt, 60pt, [0], []), (20pt, 10pt, [1], [${p}$]), (100pt, 10pt, [2], [${q}$])),
    archi: ((0, 1), (0, 2)))
  Vale che $0 forces (p -> q) or (q -> p)$ se e solo se $0 forces p -> q$ oppure $0 forces q -> p$, ossia se e solo se, per ogni $i >= 0$, $i forces p ==> i forces q$, oppure, per ogni $i >= 0$, $i forces q ==> i forces p$. Ma, per $i = 1$, vale che $1 forces p$ e $1 forces.not q$, mentre per $i = 2$ vale $2 forces q$ e $2 forces.not p$. Dunque $0 forces.not (p -> q) or (q -> p)$.
]

#esempio(title: [Legge di Peirce])[
  Mostriamo che $scripts(tack.not)_i ((p -> q) -> p) -> p$. Ricordiamo che $k forces a -> b$ se e solo se, per ogni $k' >= k$, se $k' forces a$ allora $k' forces b$. Definiamo una struttura con un mondo $w$ tale che $w forces alpha := (p -> q) -> p$, ma $w forces.not p$. In questo modo, esisterà un mondo $w' >= w$ tale che $w' forces alpha$ e $w' forces.not p$. Consideriamo il modello con due mondi $0 <= 1$, con $V(0) = emptyset$ e $V(1) = {p}$. Allora $0 forces.not p$ e $0 forces.not q$, mentre $1 forces p$ e $1 forces.not q$. Osserviamo che $0 forces.not p -> q$, poiché $1 >= 0$, $1 forces p$ e $1 forces.not q$. Analogamente, $1 forces.not p -> q$. Dunque $0 forces (p -> q) -> p$, poiché per ogni $w in {0,1}$ vale $w forces.not p -> q$, e l'implicazione è vacuamente vera. Siccome $0 forces alpha$ e $0 forces.not p$, vale che $0 forces.not alpha -> p$.
]

#esempio(title: [Un tentativo fallito di contromodello])[
  Proviamo a costruire un contromodello per l'altra _Legge di De Morgan_ fino ad ora non discussa, ovvero $not (p or q) -> not p and not q$. Se un mondo $0$ forza $not (p or q)$, allora per ogni $k >= 0$ varrebbe che $k forces.not p or q$, ossia $k forces.not p$ e $k forces.not q$. Ma allora, per definizione, vale che $0 forces not p$ e $0 forces not q$, per cui $0 forces not p and not q$. Dunque non può esistere alcun contromodello per questa _Legge di De Morgan_. Infatti, questa legge è derivabile in logica intuizionistica, ed è un buon esercizio scriverne la derivazione in $cal(N)_I$.
]

#esercizio[
  Si trovino contromodelli di _Kripke_ per le seguenti formule
  - $not not p -> p$
  - $p or not p$
  - $not (p and q) -> not p or not q$
  - $(p -> q) -> (not p or q)$
  - $((p -> q) -> p) -> p$
  diversi da quelli mostrati negli esempi precedenti.
]

== _Immergere la Logica Classica nella Logica Intuizionistica: La Traduzione di Gödel_

Abbiamo precedentemente osservato che la logica intuizionistica è piuttosto debole rispetto alla dimostrabilità, in quanto permette di derivare meno teoremi rispetto alla logica classica. Tuttavia, è sufficientemente espressiva da riuscire a _codificare_ ed _immergere_ la logica classica al proprio interno. Lo strumento che permette questa codifica è la _traduzione di Gödel_, anche detta _traduzione negativa_, che associa ad ogni formula una formula classicamente equivalente, in cui la disgiunzione e il quantificatore esistenziale, ossia i connettivi che in logica intuizionistica hanno un significato costruttivo forte e distinto rispetto al significato ad essi attribuito dalla logica classica, vengono sostituiti dalle loro versioni _deboli_, ovvero il significato espresso mediante la loro negazione.

#definizione(title: [Traduzione di Gödel])[
  La _traduzione di Gödel_ è la funzione iniettiva $g : #pb[Form] -> #pb[Form]$ definita per induzione nel modo seguente.
  + $g(bot) = bot$
  + $g(p) = not not p$, per ogni formula atomica $p != bot$
  + $g(phi and psi) = g(phi) and g(psi)$ e $g(phi -> psi) = g(phi) -> g(psi)$
  + $g(forall x. phi) = forall x. g(phi)$
  + $g(phi or psi) = not (not g(phi) and not g(psi))$
  + $g(exists x. phi) = not forall x. not g(phi)$
]

In letteratura, la traduzione è spesso indicata con $phi^circle.small$ al posto di $g(phi)$. Si osservi che la traduzione lascia invariati i connettivi logici $bot$, $and$, $->$ e $forall$, mentre interviene sulle formule atomiche, aggiungendo una doppia negazione, e sui connettivi $or$ ed $exists$, i quali vengono rimpiazzati dalle loro formulazioni classiche in termini di $not$, $and$ e $forall$. Questo intervento è necessario poiché è esattamente il significato forte attribuito dalla logica classica a questi due connettivi a generare la distinzione tra le due interpretazioni, ovvero quella classica e quella intuizionistica. Siccome $not not p <-> p$, $not (not phi and not psi) <-> phi or psi$ e $not forall x. not phi <-> exists x. phi$ sono tutte equivalenze classicalmente valide, la traduzione non altera il significato _classico_ delle formule.

#proposizione[
  Per ogni formula $phi$, vale che $scripts(tack)_c phi <-> g(phi)$.
]

L'idea di questa proposizione è che le formule tradotte mediante  _traduzione di Gödel_ appartengono ad una classe di formule che, in logica intuizionistica, si comportano in modo _classico_, ossia per cui vale l'eliminazione della doppia negazione. Allo stesso tempo, però, la formula tradotta $g(phi)$ non cambia di significato nel sistema logico classico.

#definizione(title: [Formule negative])[
  Una formula $phi in #pb[Form]_cal(L)$ è detta _negativa_ se è costruita a partire da $bot$ e da formule atomiche negate mediante i soli connettivi $forall$, $and$ e $->$. In altre parole, $phi$ è negativa se contiene soltanto i connettivi $and$, $->$, $forall$ e $bot$.
]

Si noti che, per ogni formula $phi$, la traduzione $g(phi)$ è una formula negativa, in quanto gli atomi compaiono soltanto nella forma $not not p = not p -> bot$, mentre i connettivi $or$ ed $exists$ sono stati eliminati. Il seguente lemma permette di stabilire l'equivalenza $phi <-> not not phi$ la quale, sebbene non sia valida, in generale, in logica intuizionistica, essa è valida per le formule negative in logica intuizionistica.

#lemma[
  Se $phi$ è una formula negativa, allora $scripts(tack)_i phi <-> not not phi$.
]

#dimostrazione[
  La direzione $scripts(tack)_i phi -> not not phi$ è valida in logica intuizionistica per ogni formula $phi$, come abbiamo già mostrato. Dimostriamo, quindi, $scripts(tack)_i not not phi -> phi$ per induzione sulla struttura di una formula negativa $phi$.

  _Caso base._ Se $phi = bot$, la derivazione è banale. Infatti, siccome $not bot = bot -> bot$ è un'istanza di $A -> A$, otteniamo
  #albero(rule(name: $-> I^2$, $not not bot -> bot$, rule(name: $-> E$, $bot$, rule(name: $-> I^1$, $not bot$, $[bot]^1$), $[not not bot]^2$)))
  Se $phi = not p$ è una formula atomica negata, allora $not not not p -> not p$ è il punto ($i$) del teorema sulle negazioni dimostrato nella sezione dedicata alla deduzione naturale intuizionistica.

  _Passo induttivo._ Mostriamo soltanto il caso del quantificatore universale, ovvero $phi = forall x. psi$, dove per ipotesi induttiva vale $scripts(tack)_i not not psi -> psi$.
  #albero(rule(name: $-> I^3$, $not not forall x. psi -> forall x. psi$, rule(name: $forall I$, $forall x. psi$, rule(name: $-> E$, $psi$,
    rule(name: $-> I^2$, $not not psi$, rule(name: $-> E$, $bot$,
      rule(name: $-> I^1$, $not forall x. psi$, rule(name: $-> E$, $bot$, rule(name: $forall E$, $psi$, $[forall x. psi]^1$), $[not psi]^2$)),
      $[not not forall x. psi]^3$)),
    $overline(not not psi -> psi) " (IH)"$))))
  L'applicazione di $forall I$ è corretta, poiché l'unica ipotesi non scaricata in quel punto è $not not forall x. psi$, in cui $x$ non è libera, mentre l'ipotesi induttiva è un teorema. I casi $phi = psi_1 and psi_2$ e $phi = psi_1 -> psi_2$ sono analoghi, e sfruttano i punti ($v$) e ($i v$) del teorema sulle negazioni discusso nella sezione dedicata alla deduzione naturale intuizionistica, insieme all'ipotesi induttiva.
]

Intuitivamente, il lemma afferma che, per le formule negative, la regola di deduzione #pb[Raa] non è più necessaria per la loro derivazione. Siccome le traduzioni sono formule negative, questo è esattamente quanto serve per simulare, sulle formule tradotte, le derivazioni classiche mediante derivazioni intuizionistiche. In particolare, la possibilità di derivare ogni teorema della logica classica in un sistema logico intuizionistico, è garantita dal Teorema di Traduzione di Gödel enunciato di seguito.

#teorema(title: [Traduzione di Gödel])[
  $Gamma scripts(tack)_c phi$ se e solo se $g(Gamma) scripts(tack)_i g(phi)$, dove $g(Gamma) = {g(psi) | psi in Gamma}$.
]

In altre parole, una formula è derivabile classicamente se e solo se la sua traduzione negativa è derivabile intuizionisticamente. La logica classica, quindi, è interamente codificata all'interno della logica intuizionistica. Ne consegue che, sebbene la _corrispondenza di Curry-Howard_ valga soltanto per la logica intuizionistica con semantica #pb[Bhk], attraverso questa traduzione è sempre possibile esprimere le prove della logica classica in logica intuizionistica, e quindi mediante algoritmi. Una conseguenza immediata riguarda le formule che sono già negative, in quanto la logica dei predicati classica e la logica proposizionale classica sono _conservative_ rispetto alle loro versioni intuizionistiche sulle formule negative. In altre parole, quando ristretta alle sole formule negative, la logica classica non permette di dimostrare un insieme di teoremi più grande di quelli dimostrabili dalla logica intuizionistica, dal momento che le formule negative non richiedono la regola #pb[Raa] o principi classici equivalenti per la loro derivazione, che è anche l'unico insieme di regole non direttamente codificabile in logica intuizionistica.

#teorema[
  Se $phi$ è una formula negativa, allora $scripts(tack)_c phi$ se e solo se $scripts(tack)_i phi$.
]

In altre parole, sulle formule negative le due logiche dimostrano esattamente gli stessi teoremi, per cui le differenze tra logica classica e logica intuizionistica emergono soltanto in presenza di formule atomiche non negate, di disgiunzioni o di quantificatori esistenziali. I teoremi che distinguono la logica classica da quella intuizionistica, tuttavia, possono comunque essere tradotti in forma negativa e dimostrati in logica intuizionistica. Questo permette di fornire una dimostrazione intuizionistica per una formula classicalmente equivalente al teorema originale, ovvero, la _traduzione di Gödel_ è in grado di _immergere_ completamente la logica classica nella logica intuizionistica.

Nel caso della logica proposizionale, inoltre, vale un risultato ancora più semplice, che non richiede di tradurre l'intera formula. Il seguente teorema, noto come _Teorema di Glivenko_, garantisce che, per poter _immergere_ completamente la logica proposizionale classica nella logica proposizionale intuizionistica, è sufficiente anteporre una doppia negazione ad ogni formula contenente formule atomiche non negate o connettivi di disgiunzione. In questo modo, si costruisce una formula $not not phi$, dimostrabile in logica proposizionale intuizionistica che, sebbene non sia equivalente all'aver dimostrato la formula $phi$ in logica intuizionistica, ci permette di ottenere una prova intuizionistica, e, dunque, un programma associato, per la formula $phi$, siccome in logica proposizionale classica le formule $phi$ e $not not phi$ sono equivalenti.

#teorema(title: [Teorema di Glivenko])[
  Per la logica proposizionale vale che $scripts(tack)_c phi$ se e solo se $scripts(tack)_i not not phi$.
]

La dimostrazione segue dal lemma sulle formule negative, e dal Teorema di _Traduzione di Gödel_. Infatti, se $scripts(tack)_c phi$, allora, per il Teorema di _Traduzione di Gödel_, vale che $scripts(tack)_i g(phi)$, e nel caso proposizionale si verifica, per induzione su $phi$ e grazie ai teoremi sulle doppie negazioni dimostrati nella sezione dedicata alla deduzione naturale intuizionistica, che $g(phi)$ è intuizionisticamente equivalente a $not not phi$. Viceversa, se $scripts(tack)_i not not phi$, allora $scripts(tack)_c not not phi$, e quindi $scripts(tack)_c phi$. Ad esempio, siccome $scripts(tack)_c p or not p$, per il _Teorema di Glivenko_ vale che $scripts(tack)_i not not (p or not p)$, come è già stato dimostrato nella sezione dedicata alla deduzione naturale intuizionistica. Si noti che il teorema vale soltanto per la logica proposizionale in quanto, per la logica del primo ordine, il punto ($v i$) del teorema sulle negazioni vale in una sola direzione, ossia $not not forall x. phi -> forall x. not not phi$ ma non il viceversa, e la doppia negazione non può quindi essere spostata all'esterno della formula.
