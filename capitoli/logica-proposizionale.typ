#import "../template.typ": *

= La Logica Proposizionale Classica

La logica proposizionale è il sistema logico elementare e più semplice che studieremo, ed è anche il punto di partenza di tutti i sistemi logici che saranno introdotti successivamente. In questa logica, le unità elementari delle argomentazioni sono le _proposizioni atomiche_, ovvero affermazioni indivisibili che possono essere vere o false, come "piove" oppure "$2 + 2 = 4$", le quali vengono combinate mediante i _connettivi_ logici per formare proposizioni più complesse. La logica proposizionale, per costruzione, non è in grado di osservare il valore di verità di una singola proposizione atomica. Infatti, per essa, le proposizioni atomiche "piove" e "$2 + 2 = 4$" sono semplicemente due simboli sintattici, $p_0$ e $p_1$, il cui unico attributo rilevante è il valore di verità. Questa limitazione, che verrà superata dalla logica dei predicati, rende la logica proposizionale poco espressiva, ma allo stesso tempo ci permette di introdurre, in un contesto semplice e diretto, tutti gli strumenti fondamentali del corso, ovvero la definizione induttiva della sintassi, la semantica, la deduzione naturale e i Teoremi di Correttezza e Completezza.

== La Sintassi della Logica Proposizionale

Come ogni linguaggio formale, il linguaggio della logica proposizionale è definito a partire da un _alfabeto_, ovvero un insieme di simboli, e da un insieme di regole formali che stabiliscono quali sequenze di simboli sono considerate formule ben formate. Queste due componenti, insieme, costituiscono la _sintassi_ della logica proposizionale.

#definizione[
  L'_alfabeto_ della logica proposizionale è composto dai seguenti simboli:
  - i _simboli proposizionali_ $p_0, p_1, p_2, dots$, che sono infiniti ma numerabili, ossia in quantità $aleph_0 = |NN|$
  - i _connettivi logici_ $and, or, ->, not, <->, bot$
  - i _simboli ausiliari_ $($ e $)$
  L'insieme dei _simboli atomici_ è $"AT" = {p_0, p_1, p_2, dots} union {bot}$.
]

Il significato intuitivo dei connettivi è quello usuale, ovvero $and$ si legge "e", $or$ si legge "oppure", $->$ si legge "se $P$, allora $Q$", $not$ si legge "non", $<->$ si legge "se e solo se", mentre $bot$, che si legge _falsum_, o _bottom_, è una costante che rappresenta la proposizione sempre falsa, ossia l'assurdo. Si noti che $bot$ è un connettivo di arietà zero, e per questo motivo è considerato un atomo. Le tre componenti dell'alfabeto, simboli proposizionali, connettivi e simboli ausiliari, sono le componenti fondamentali della logica proposizionale, a partire dalle quali definiamo l'insieme delle formule.

#definizione[
  L'insieme #pb[Prop] delle _proposizioni_ (o _formule proposizionali_) è il _più piccolo_ insieme $X$ che soddisfi le seguenti proprietà:
  + $p_i in X$ per ogni $i in NN$, e $bot in X$
  + se $phi, psi in X$, allora $(phi and psi), (phi or psi), (phi -> psi), (phi <-> psi) in X$
  + se $phi in X$, allora $(not phi) in X$
]

Osserviamo, in primo luogo, che questa definizione è _induttiva_. Infatti, il punto ($i$) fornisce i mattoni di base con cui costruire formule arbitrarie, ovvero gli _atomi_ della logica proposizionale, mentre i punti ($i i$) e ($i i i$) descrivono come costruire nuove formule a partire da sotto-formule già costruite e considerate ben formulate. La richiesta che #pb[Prop] sia il _più piccolo_ insieme con queste proprietà è fondamentale, in quanto garantisce che nell'insieme #pb[Prop] non esista nient'altro oltre alle formule proposizionali costruite soltanto applicando un numero finito di volte le regole ($i$), ($i i$) o ($i i i$). Infatti, esistono molti insiemi che soddisfano le tre proprietà, ad esempio, l'insieme di _tutte_ le sequenze finite di simboli dell'alfabeto, ma #pb[Prop] è l'intersezione di tutti questi insiemi. Per alleggerire la notazione, nel seguito ometteremo le parentesi più esterne e quelle deducibili dal contesto, e useremo il simbolo $square$ per indicare un generico connettivo binario, ossia $square in {and, or, ->, <->}$. Il seguente esempio mostra come la minimalità di #pb[Prop] possa essere sfruttata nelle dimostrazioni.

#esempio[
  Dimostriamo che $not -> bot in.not #pb[Prop]$. Intuitivamente, la sequenza di simboli $not -> bot$ non è una formula ben formata secondo le regole di sintassi della logica proposizionale, ma vogliamo dimostrarlo rigorosamente. Supponiamo, per assurdo, che $not -> bot in #pb[Prop]$, e consideriamo l'insieme $Y = #pb[Prop] without {not -> bot}$. Mostriamo che anche $Y$ soddisfa le proprietà ($i$), ($i i$) e ($i i i$):
  - $bot, p_i in Y$, poiché sono in #pb[Prop] e sono diversi da $not -> bot$
  - se $phi, psi in Y$, allora $phi, psi in #pb[Prop]$, per cui $(phi square psi) in #pb[Prop]$. Siccome $(phi square psi)$ comincia con una parentesi, esso è diverso da $not -> bot$, per cui $(phi square psi) in Y$
  - se $phi in Y$, allora $(not phi) in #pb[Prop]$ e, analogamente, $(not phi) != not -> bot$, per cui $(not phi) in Y$
  Ma, allora, l'insieme $Y subset.neq #pb[Prop]$ soddisfa le proprietà ($i$), ($i i$) e ($i i i$), per cui #pb[Prop] non è il più piccolo insieme con queste proprietà, che è assurdo. Ne segue che $not -> bot in.not #pb[Prop]$.
]

La struttura induttiva dell'insieme #pb[Prop] delle formule proposizionali ci permette di dimostrare proprietà di tutte le formule ben formate mediante il _principio di induzione_, che generalizza il principio di induzione sui numeri naturali alla struttura sintattica delle formule. Questa tecnica è detta _induzione strutturale_, e sarà lo strumento principale delle dimostrazioni del corso.

#teorema(title: [Principio di Induzione])[
  Sia $A$ una proprietà. Allora $A(phi)$ vale per ogni $phi in #pb[Prop]$ se
  + $A(p_i)$ vale per ogni $i$, e vale $A(bot)$
  + $A(phi)$ e $A(psi)$ implicano $A((phi square psi))$, per ogni $square in {and, or, ->, <->}$
  + $A(phi)$ implica $A((not phi))$
]

#dimostrazione[
  Sia $X = {phi in #pb[Prop] | A(phi)}$. Per le ipotesi ($i$), ($i i$) e ($i i i$), l'insieme $X$ soddisfa le tre proprietà della definizione di #pb[Prop]. Siccome #pb[Prop] è il più piccolo insieme con queste proprietà, vale che $#pb[Prop] subset.eq X$, ossia $A(phi)$ vale per ogni $phi in #pb[Prop]$.
]

In altre parole, per dimostrare che una proprietà vale per tutte le formule, basta dimostrare che vale per gli atomi, e che si _conserva_ quando si costruiscono formule più complesse mediante i connettivi. Analogamente, possiamo _definire_ funzioni sulle formule per ricorsione, o _induzione_, sulla loro struttura. Che questo processo di definizione sia legittimo, ovvero che una definizione ricorsiva individui esattamente una ed una sola funzione, è garantito dal seguente Teorema, dovuto a Kleene, che enunciamo prima nel caso dei numeri naturali.

#teorema(title: [Teorema di Ricorsione Primitiva di Kleene])[
  Siano $h : NN times A -> A$ e $c in A$. Allora esiste una ed una sola funzione $f : NN -> A$ tale che
  + $f(0) = c$
  + $f(n + 1) = h(n, f(n))$, per ogni $n in NN$
]

#dimostrazione(title: [Dimostrazione])[
  _Esistenza._ Sia $Omega$ la classe degli insiemi $Z subset.eq NN times A$ tali che ($i$) vale $(0, c) in Z$ e ($i i$) vale che, se $(n, x) in Z$, allora $(n + 1, h(n, x)) in Z$. Si noti che $Omega$ non è una classe vuota, poiché $NN times A in Omega$. Sia $f$ l'intersezione di tutti gli insiemi in $Omega$. Banalmente, anche $f$ soddisfa ($i$) e ($i i$), per cui $f in Omega$, ed è il più piccolo insieme in $Omega$. Dimostriamo, per induzione su $n$, che per ogni $n in NN$ esiste un unico $a in A$ tale che $(n, a) in f$, ovvero che $f$ è effettivamente una funzione. Per $n = 0$, vale $(0, c) in f$ per definizione. Supponiamo che esista $d != c$ tale che $(0, d) in f$. Allora, l'insieme $f without {(0, d)}$ soddisfa ancora i punti ($i$) e ($i i$), per cui esso appartiene a $Omega$ ed è strettamente contenuto in $f$, che è assurdo poiché $f$ è il più piccolo insieme di $Omega$. Supponiamo, ora, che esista un unico $x$ tale che $(n, x) in f$. Per costruzione di $f$, vale $(n + 1, h(n, x)) in f$. Se esistesse $e != h(n, x)$ tale che $(n + 1, e) in f$, allora $f without {(n + 1, e)}$ sarebbe ancora un insieme in $Omega$ e strettamente contenuto in $f$, che è ancora assurdo per la minimalità di $f$. Dunque, $f$ è una funzione per definizione.

  _Unicità._ Supponiamo che esistano due funzioni $f, g$ che soddisfano i punti ($i$) e ($i i$), e che $f != g$. Allora esiste un minimo numero naturale $i$ tale che $f(i) != g(i)$. Siccome $f(0) = c = g(0)$, deve valere $i > 0$, ma allora $g(i) = h(i - 1, g(i - 1)) = h(i - 1, f(i - 1)) = f(i)$, poiché $f(i - 1) = g(i - 1)$ per la minimalità di $i$, che è assurdo. Dunque $f = g$.
]

Il Teorema di Kleene si estende in modo naturale alle formule, sostituendo l'ordine dei numeri naturali con l'ordinamento sintattico e lessicografico sulle formule. L'idea è la stessa in quanto, per definire una funzione su tutte le formule, è sufficiente stabilire il suo valore sugli atomi e descrivere come calcolare il valore su una formula composta a partire dai valori sulle sue componenti immediate.

#teorema(title: [Definizione per Ricorsione])[
  Siano date le funzioni $H_square : A^2 -> A$ per ogni connettivo binario $square$, $H_not : A -> A$ e $H_"at" : "AT" -> A$. Allora esiste esattamente una funzione $F : #pb[Prop] -> A$ tale che
  $
    F(phi) = H_"at" (phi) "per" phi "atomica", quad F((phi square psi)) = H_square (F(phi), F(psi)), quad F((not phi)) = H_not (F(phi))
  $
]

Grazie a questo teorema, che si dimostra con un argomento del tutto analogo a quello utilizzato per dimostrare il Teorema di Kleene, possiamo definire funzioni sulle formule che sono _ben fondate_, ossia univocamente determinate.#footnote[La dimostrazione di questi due teoremi, tuttavia, non è richiesta in sede d'esame.] Un primo esempio di funzione definita per ricorsione è l'_albero sintattico_ (o _parsing tree_) di una formula, che rappresenta graficamente la struttura induttiva mediante la quale la formula è stata costruita. Un albero sintattico è definito induttivamente nel seguente modo: se $phi$ è una formula atomica, allora l'albero sintattico $T(phi)$ è il solo nodo $phi$; se $phi = (phi_1 square phi_2)$, l'albero sintattico $T(phi)$ ha radice $phi$ e, come sottoalberi, gli alberi sintattici $T(phi_1)$ e $T(phi_2)$; se $phi = (not phi_1)$, l'albero sintattico $T(phi)$ ha radice $phi$ e, come unico sottoalbero, l'albero sintattico $T(phi_1)$. Per il teorema precedente, l'albero sintattico di una formula proposizionale arbitraria è unico. Ad esempio, l'albero sintattico della formula $(p_1 -> (bot or (not p_3)))$ è il seguente, in cui la radice è in alto e le foglie sono gli atomi della formula.

#grafo(larghezza: 220pt, altezza: 135pt,
  nodi: (
    (110pt, 10pt, [], [$(p_1 -> (bot or (not p_3)))$]),
    (50pt, 50pt, [], [$p_1$]),
    (150pt, 50pt, [], [$(bot or (not p_3))$]),
    (120pt, 90pt, [], [$bot$]),
    (180pt, 90pt, [], [$(not p_3)$]),
    (180pt, 125pt, [], [$p_3$]),
  ),
  archi: ((0, 1), (0, 2), (2, 3), (2, 4), (4, 5))
)

Un'altra operazione sintattica definita per ricorsione, e della quale faremo un utilizzo estensivo durante il corso, è la _sostituzione_ di una formula al posto di un simbolo proposizionale.

#definizione[
  Sia $p$ un simbolo proposizionale, e siano $phi, psi in #pb[Prop]$, ovvero formule proposizionali. La _sostituzione_ della formula $psi$ al posto del simbolo $p$ in $phi$, indicata con $phi[psi slash p]$, è definita come
  $
    phi[psi slash p] &= cases(phi & "se" phi "è atomica e" phi != p, psi & "se" phi = p) \
    (phi_1 square phi_2)[psi slash p] &= phi_1[psi slash p] square phi_2[psi slash p] \ (not phi)[psi slash p] &= not phi[psi slash p]
  $
]

In altre parole, la sostituzione rimpiazza _ogni_ occorrenza del simbolo $p$ in $phi$ con la formula $psi$, lasciando invariato il resto della formula.

== La Semantica della Logica Proposizionale

Dopo aver definito rigorosamente la sintassi delle formule ben formate in logica proposizionale, il nostro scopo è quello di attribuire un significato alle formule. Nella logica proposizionale classica, il significato di una formula è semplicemente il suo _valore di verità_, che può essere $1$ (vero) oppure $0$ (falso). L'idea è che il valore di verità di una formula composta dipenda soltanto dai valori di verità delle sue componenti, secondo le usuali tabelle di verità dei connettivi.

#definizione[
  Una funzione $v : #pb[Prop] -> {0, 1}$ è detta _valutazione_ se
  $
    v(phi and psi) = min{v(phi), v(psi)} quad v(phi or psi) = max{v(phi), v(psi)} quad v(not phi) = 1 - v(phi) quad v(bot) = 0 \
    v(phi -> psi) = 0 <==> v(phi) = 1 "e" v(psi) = 0 quad quad v(phi <-> psi) = 1 <==> v(phi) = v(psi)
  $
]

Alternativamente, si può definire una valutazione elencando le condizioni sotto le quali una formula è vera, ossia $v(phi and psi) = 1$ se e solo se $v(phi) = 1$ e $v(psi) = 1$, $v(phi or psi) = 1$ se e solo se $v(phi) = 1$ oppure $v(psi) = 1$, $v(phi -> psi) = 1$ se e solo se $v(phi) = 0$ oppure $v(psi) = 1$, $v(not phi) = 1$ se e solo se $v(phi) = 0$, e infine $v(bot) = 0$. Le due definizioni sono, chiaramente, equivalenti. Si noti che una valutazione è una funzione che soddisfa una definizione per ricorsione. Per il precedente teorema, quindi, essa è completamente determinata dai valori che assume sugli atomi. Questo fatto è formalizzato dal seguente teorema.

#teorema[
  Sia $v : "AT" -> {0, 1}$ un assegnamento di valori di verità agli atomi tale che $v(bot) = 0$. Allora esiste un'unica valutazione $[| dot |]_v : #pb[Prop] -> {0, 1}$ tale che $[| phi |]_v = v(phi)$ per ogni $phi in "AT"$.
]

In altre parole, un assegnamento di verità agli atomi di una formula si estende in modo univoco ad una valutazione di tutta la formula. Inoltre, il valore di verità di una formula dipende soltanto dagli atomi che vi compaiono effettivamente, come affermato dal seguente lemma.

#lemma[
  Se $v$ e $w$ sono due assegnamenti tali che $v(p_i) = w(p_i)$ per ogni $p_i$ che occorre in $phi$, allora $[| phi |]_v = [| phi |]_w$.
]

Dunque, due assegnamenti che coincidono sugli atomi di una formula producono la stessa valutazione per quella formula. Possiamo ora definire le nozioni semantiche fondamentali.

#definizione[
  - Una formula $phi$ è una _tautologia_ se $[| phi |]_v = 1$ per ogni valutazione $v$, e si scrive $tack.rr phi$.
  - Sia $Gamma$ un insieme di formule. Si dice che $phi$ è _conseguenza semantica_ di $Gamma$, e si scrive $Gamma tack.rr phi$, se, per ogni valutazione $v$ tale che $[| psi |]_v = 1$ per ogni $psi in Gamma$, vale che $[| phi |]_v = 1$.
]

Intuitivamente, $Gamma tack.rr phi$ significa che, in ogni situazione in cui tutte le ipotesi in $Gamma$ sono vere, anche la formula $phi$ è vera. Si noti che $tack.rr phi$ è un caso particolare di conseguenza semantica, in cui $Gamma = emptyset$. Siccome la condizione sulle ipotesi è sempre soddisfatta, la formula $phi$ deve essere vera per ogni valutazione. Si noti anche che, per ora, la nozione $tack.rr phi$ è una nozione puramente semantica, legata alla verità della formula, mentre in seguito introdurremo la nozione sintattica $tack phi$, legata alla sua dimostrabilità nel sistema logico di deduzione. Vedremo che, grazie ai Teoremi di Correttezza e Completezza, le due nozioni coincidono.

#esempio(numbered: false)[
  Dimostriamo che $alpha -> beta, alpha tack.rr beta$, che è la versione semantica del _modus ponens_. Sia $v$ una valutazione tale che $[| alpha -> beta |]_v = 1$ e $[| alpha |]_v = 1$. Per definizione, $[| alpha -> beta |]_v = 1$ se e solo se $[| alpha |]_v = 0$ oppure $[| beta |]_v = 1$. Siccome $[| alpha |]_v = 1$ per ipotesi, deve necessariamente valere $[| beta |]_v = 1$. Dunque $alpha -> beta, alpha tack.rr beta$.
]

#esempio(numbered: false)[
  La dimostrazione per assurdo può essere formalizzata e giustificata semanticamente nel seguente modo:
  $
    Gamma, not alpha tack.rr bot quad ==> quad Gamma tack.rr alpha
  $
  ovvero, se assumendo $not alpha$ si raggiunge una contraddizione, allora deve valere $alpha$. Ricordiamo che, per ogni valutazione $v$, vale $[| bot |]_v = 0$. Cosa significa, allora, che $Delta tack.rr bot$? Per definizione, vale che per ogni $v$, se $[| Delta |]_v = 1$ allora $[| bot |]_v = 1$, ovvero, per ogni $v$, $[| Delta |]_v = 0$ oppure $[| bot |]_v = 1$. Siccome la seconda condizione non è mai soddisfatta, deve valere che $[| Delta |]_v = 0$ per ogni $v$, ossia non esiste una valutazione che renda vere tutte le formule di $Delta$ contemporaneamente. Ricordiamo, inoltre, che $not alpha$ è semanticamente equivalente ad $alpha -> bot$, e che se $Gamma, alpha tack.rr beta$ allora $Gamma tack.rr alpha -> beta$. Ponendo $Delta = Gamma union {not alpha}$ otteniamo
  $
    Gamma, not alpha tack.rr bot quad ==> quad Gamma tack.rr not alpha -> bot quad ==> quad Gamma tack.rr not not alpha quad ==> quad Gamma tack.rr alpha
  $
  dove l'ultimo passaggio sfrutta il fatto che $not not alpha$ e $alpha$ hanno sempre lo stesso valore di verità. Vedremo che proprio quest'ultimo passaggio, che dal punto di vista della logica classica è del tutto innocuo, non è accettato in logica intuizionistica, nella quale $not not alpha$ e $alpha$ non sono equivalenti. Per questo motivo, quindi, sarà necessario abbandonare il principio _classico_ di dimostrazione per assurdo quando si introdurranno le logiche intuizionistiche.
]

Elenchiamo, infine, alcune tautologie notevoli, che esprimono le proprietà algebriche dei connettivi. Per brevità, scriviamo $phi approx psi$ per indicare $tack.rr phi <-> psi$.
- _Associatività_: $(phi or psi) or sigma approx phi or (psi or sigma)$ e $(phi and psi) and sigma approx phi and (psi and sigma)$
- _Commutatività_: $phi or psi approx psi or phi$ e $phi and psi approx psi and phi$
- _Distributività_: $phi or (psi and sigma) approx (phi or psi) and (phi or sigma)$ e $phi and (psi or sigma) approx (phi and psi) or (phi and sigma)$
- _Leggi di De Morgan_: $not (phi or psi) approx not phi and not psi$ e $not (phi and psi) approx not phi or not psi$
- _Idempotenza_: $phi or phi approx phi$ e $phi and phi approx phi$
- _Doppia negazione_: $not not phi approx phi$
- _Connettivi definibili_: $(phi <-> psi) approx (phi -> psi) and (psi -> phi)$, $(phi -> psi) approx (not phi or psi)$, $(phi or psi) approx (not phi -> psi)$, $(phi or psi) approx not (not phi and not psi)$, $(phi and psi) approx not (not phi or not psi)$, $not phi approx (phi -> bot)$, $bot approx phi and not phi$

Le ultime equivalenze mostrano che alcuni connettivi sono ridondanti, poiché esprimibili mediante altri connettivi. In particolare, l'insieme ${and, ->, bot}$, oppure soltanto l'insieme ${->, bot}$, costituisce una _base completa_ di connettivi, ovvero ogni formula proposizionale risulta semanticamente equivalente ad una formula proposizionale che usa soltanto questi connettivi. Per questo motivo, d'ora in avanti adotteremo la seguente convenzione, che semplificherà notevolmente il sistema deduttivo.

#definizione[
  La negazione è un'abbreviazione dell'implicazione ad assurdo, ovvero $not alpha := alpha -> bot$.
]

#esercizio(numbered: false)[
  Si dimostri che la relazione $approx thin subset.eq #pb[Prop] times #pb[Prop]$ è una relazione di equivalenza su #pb[Prop].
]

Concludiamo la sezione con un teorema che giustifica la sostituzione di formule equivalenti all'interno di altre formule proposizionali, il cui risultato analogo in logiche del primo ordine classiche ed intuizionistiche sarà utilizzato estensivamente nel corso dei capitoli successivi.

#teorema(title: [Teorema di Sostituzione])[
  Siano $phi_1, phi_2, psi in #pb[Prop]$, ovvero formule proposizionali arbitrarie, e sia $p$ un simbolo atomico.
  + Se $tack.rr phi_1 <-> phi_2$, allora $tack.rr psi[phi_1 slash p] <-> psi[phi_2 slash p]$
  + $tack.rr (phi_1 <-> phi_2) -> (psi[phi_1 slash p] <-> psi[phi_2 slash p])$
]

In altre parole, due formule semanticamente equivalenti possono essere sostituite in modo intercambiabile al posto di un simbolo atomico presente in una terza formula proposizionale $psi$ arbitraria.

== La Deduzione Naturale in Logica Proposizionale

Nei sistemi logici che considereremo in questo capitolo e nei successivi, dedurre significa _dimostrare qualcosa a partire da un insieme di ipotesi_ in modo formale, ossia in modo tale che la dimostrazione possa essere verificata ed, idealmente, costruita da una macchina. Le ipotesi sono le premesse da cui ha inizio il ragionamento, mentre la _tesi_ è la formula che desideriamo dimostrare. Se la semantica descrive la verità matematica di formule ben formate, ovvero $Gamma tack.rr alpha$, il sistema deduttivo descrive la derivabilità sintattica delle stesse formule ben formate, ovvero $Gamma tack alpha$, che si ottiene applicando un insieme finito di regole di deduzione. Quando $Gamma = emptyset$, e quindi $tack alpha$, si dice che $alpha$ è un _teorema_. In altre parole, la formula ben formata $alpha$ è un teorema quando è sempre derivabile, senza dover assumere alcuna ipotesi. Il collegamento tra le due nozioni è dato dai Teoremi di Correttezza e Completezza, che dimostreremo al termine del capitolo. Storicamente, negli anni \'30 il logico tedesco Gerhard Gentzen introdusse due sistemi deduttivi che, a differenza dei sistemi assiomatici dell'epoca, avevano l'obiettivo di riprodurre il modo in cui i matematici ragionano effettivamente quando sono costretti a fornire la dimostrazione di un teorema. Questi due sistemi deduttivi sono il _calcolo dei sequenti_ e la _deduzione naturale_. La deduzione naturale fu successivamente sviluppata e studiata in modo sistematico da Dag Prawitz nel 1965. Altri sistemi deduttivi noti sono i _tableaux semantici_ e i sistemi alla Hilbert. L'obiettivo comune di questi sistemi è la completa formalizzazione del ragionamento e delle dimostrazioni, che è il primo passo verso la loro _automatizzazione_. Vedremo che, tuttavia, per automatizzare la deduzione naturale in modo che le dimostrazioni abbiano un contenuto computazionale, è necessario scartare alcune regole e principi logici _classici_, come la riduzione all'assurdo, e dunque costruire una logica intuizionistica.

Le dimostrazioni, in deduzione naturale, hanno la forma di _alberi di derivazione_. In questi alberi, di struttura induttiva e ricorsiva per costruzione, le foglie sono etichettate con le ipotesi, la radice è etichettata con la conclusione, e ogni nodo interno corrisponde all'applicazione di una regola, che a partire dalle formule dei nodi figli (le _premesse_) produce la formula del nodo padre (la _conclusione_). Per questo motivo, useremo indifferentemente i termini _albero di prova_, _deduzione_ e _derivazione_. Ad esempio, una regola binaria che dalle premesse $phi$ e $sigma$ conclude $psi$, e una regola unaria che dalla premessa $phi$ conclude $psi$, si scrivono in forma di alberi di derivazione nel seguente modo:
#alberi(rule($psi$, $phi$, $sigma$), rule($psi$, $phi$))
Per ogni connettivo esistono due tipi di regole, ovvero le _regole di introduzione_, che formalizzano come dimostrare una formula il cui connettivo principale è quello in esame, e le _regole di eliminazione_, che formalizzano come utilizzare una formula di quella forma per dedurne un'altra. Come anticipato, restringiamo per il momento il linguaggio ai connettivi $and$, $->$ e $bot$, ricordando che $not phi = phi -> bot$. La regola di _eliminazione dell'implicazione_ è la più naturale di tutte, ed è il ben noto _modus ponens_. Infatti, se sappiamo che vale $phi$ e che $phi$ implica $psi$, allora possiamo concludere $psi$.
#albero(rule(name: $-> E$, $psi$, $phi$, $phi -> psi$))
La regola di introduzione dell'implicazione è, invece, più interessante. Per dimostrare $phi -> psi$, in matematica si procede tipicamente assumendo $phi$ come ipotesi temporanea, e dimostrando $psi$. Una volta dimostrato $psi$, l'ipotesi temporanea $phi$ non è più necessaria, poiché la sua _dipendenza_, ovvero la necessità di assumerla come valida, è stata trasferita all'interno della formula $phi -> psi$. Si dice, in questo caso, che l'ipotesi $phi$ viene _scartata_, o _cancellata_/_scaricata_, e la si indica racchiudendola tra parentesi quadre.
#albero(rule(name: $-> I$, $phi -> psi$, deriv($[phi]$, $dots.v$, $psi$)))
Ogni ipotesi scartata viene contrassegnata da un indice numerico, che compare anche accanto alla regola $-> I$ che la scarta, in modo da rendere esplicito, in ogni derivazione, quale regola ha scartato quale ipotesi. Formalmente, se $cal(D)_1$ è una derivazione di $beta$, e $cal(D)$ è la derivazione ottenuta da $cal(D)_1$ applicando la regola $-> I$ con conclusione $alpha -> beta$, allora l'insieme delle ipotesi non scartate di $cal(D)$ è il seguente
$
  "hp"(cal(D)) = "hp"(cal(D)_1) without {alpha}
$
ovvero, l'ipotesi $alpha$ viene rimossa dall'insieme delle ipotesi _per definizione_ della regola $-> I$. Si osservi che la formula $alpha$ potrebbe anche non comparire tra le ipotesi della derivazione $cal(D)_1$. In questo caso, la regola è comunque applicabile, e si parla di _scaricamento vacuo_. Lo scaricamento delle ipotesi è il meccanismo fondamentale che ci permette di ottenere alberi finiti con $"hp"(cal(D)) = emptyset$, ossia insieme vuoto di ipotesi e, quindi, teoremi. Le regole per la congiunzione, invece, sono del tutto intuitive. Per dimostrare $alpha and beta$ basta dimostrare $alpha$ e dimostrare $beta$, mentre da $alpha and beta$ possiamo dedurre sia $alpha$ che $beta$.
#alberi(
  rule(name: $and I$, $alpha and beta$, $alpha$, $beta$),
  rule(name: $and E_1$, $alpha$, $alpha and beta$),
  rule(name: $and E_2$, $beta$, $alpha and beta$),
)
Infine, le regole per l'assurdo $bot$ sono due, entrambe di eliminazione. La prima è l'_ex falso quodlibet sequitur_, in italiano, dal falso segue qualunque cosa, indicata con $bot_i$ oppure #pb[Ef], mentre la seconda è la _riduzione all'assurdo_, indicata con #pb[Raa], che formalizza la dimostrazione per contraddizione: Se assumendo $not phi$ si deriva $bot$, allora possiamo concludere $phi$, scaricando l'ipotesi $not phi$.
#alberi(
  rule(name: $bot_i$, $phi$, $bot$),
  rule(name: $#pb[Raa]$, $phi$, deriv($[not phi]$, $dots.v$, $bot$)),
)
Le regole sono riassunte nella seguente tabella.
#align(center, table(
  columns: 2, stroke: none, align: center + horizon, inset: 8pt,
  table.header([*Regole di introduzione*], [*Regole di eliminazione*]),
  table.hline(stroke: 0.4pt),
  prooftree(rule(name: $and I$, $phi and psi$, $phi$, $psi$)),
  stack(dir: ltr, spacing: 1.5em, prooftree(rule(name: $and E_1$, $phi$, $phi and psi$)), prooftree(rule(name: $and E_2$, $psi$, $phi and psi$))),
  prooftree(rule(name: $-> I$, $phi -> psi$, deriv($[phi]$, $dots.v$, $psi$))),
  prooftree(rule(name: $-> E$, $psi$, $phi$, $phi -> psi$)),
  [], stack(dir: ltr, spacing: 1.5em, prooftree(rule(name: $bot_i$, $phi$, $bot$)), prooftree(rule(name: $#pb[Raa]$, $phi$, deriv($[not phi]$, $dots.v$, $bot$)))),
))

#nota[
  L'_ex falso quodlibet_ è ammissibile sia in logica classica che in logica intuizionistica, per cui può essere usato per automatizzare le prove. La riduzione all'assurdo, invece, è un principio strettamente _classico_, che non vale in logica intuizionistica. Si faccia attenzione a non confondere la regola $#pb[Raa]$ con la regola $-> I$ applicata alla formula $not A = A -> bot$:
  #alberi(
    rule(name: $#pb[Raa]$, $A$, deriv($[not A]$, $dots.v$, $bot$)),
    rule(name: $-> I$, $not A$, deriv($[A]$, $dots.v$, $bot$)),
  )
  La seconda è un'applicazione della regola di introduzione dell'implicazione, ed è perfettamente lecita anche in logica intuizionistica. Infatti, se assumendo $A$ si ottiene una contraddizione, allora vale $not A$. La prima, invece, permette di concludere $A$ da una contraddizione ottenuta assumendo $not A$, e questo equivale a sostenere che $not not A -> A$ che, come vedremo, richiede proprio la regola $#pb[Raa]$ per essere dimostrato. Senza entrambe le regole per $bot$, invece, si ottiene la _logica minimale_, alla base della teoria dei tipi nei linguaggi di programmazione, mentre senza la sola $#pb[Raa]$ si ottiene la _logica intuizionistica_.
]

#esempio(numbered: false)[
  Dimostriamo $tack alpha -> (alpha and alpha)$ e $tack alpha -> (beta -> alpha)$.
  #alberi(
    rule(name: $-> I^1$, $alpha -> (alpha and alpha)$, rule(name: $and I$, $alpha and alpha$, $[alpha]^1$, $[alpha]^1$)),
    rule(name: $-> I^1$, $alpha -> (beta -> alpha)$, rule(name: $-> I$, $beta -> alpha$, $[alpha]^1$)),
  )
  Nella prima derivazione, un'unica applicazione di $-> I$ scarica _entrambe_ le occorrenze dell'ipotesi $alpha$. Nella seconda, invece, la prima applicazione di $-> I$ scarica un'ipotesi $beta$ che non compare nella derivazione. Quindi, possiamo pensare di introdurre $beta$ come ipotesi e scaricarla subito con $-> I$. Questo è un esempio di scaricamento vacuo, ed è perfettamente lecito.
]

#esempio(numbered: false)[
  Dimostriamo $tack (alpha -> (beta -> gamma)) -> ((alpha -> beta) -> (alpha -> gamma))$. Si noti la struttura della prova: le tre applicazioni finali di $-> I$ scaricano, nell'ordine inverso rispetto a quello in cui compaiono nella formula, le tre premesse delle implicazioni.
  #albero(rule(name: $-> I^3$, $(alpha -> (beta -> gamma)) -> ((alpha -> beta) -> (alpha -> gamma))$,
    rule(name: $-> I^2$, $(alpha -> beta) -> (alpha -> gamma)$,
      rule(name: $-> I^1$, $alpha -> gamma$,
        rule(name: $-> E$, $gamma$,
          rule(name: $-> E$, $beta$, $[alpha]^1$, $[alpha -> beta]^2$),
          rule(name: $-> E$, $beta -> gamma$, $[alpha]^1$, $[alpha -> (beta -> gamma)]^3$),
        )))))
]

#esempio(numbered: false)[
  Dimostriamo che $tack ((phi and psi) -> sigma) -> (phi -> (psi -> sigma))$ e, viceversa, $tack (phi -> (psi -> sigma)) -> ((phi and psi) -> sigma)$. Queste due formule esprimono il fatto che una funzione di due argomenti può essere vista come una funzione che restituisce una funzione, proprietà nota con il nome di _currying_, che sarà ritrovata all'interno del $lambda$-calcolo.
  #albero(rule(name: $-> I^3$, $((phi and psi) -> sigma) -> (phi -> (psi -> sigma))$,
    rule(name: $-> I^2$, $phi -> (psi -> sigma)$,
      rule(name: $-> I^1$, $psi -> sigma$,
        rule(name: $-> E$, $sigma$,
          rule(name: $and I$, $phi and psi$, $[phi]^2$, $[psi]^1$),
          $[(phi and psi) -> sigma]^3$)))))
  \
  #albero(rule(name: $-> I^2$, $(phi -> (psi -> sigma)) -> ((phi and psi) -> sigma)$,
    rule(name: $-> I^1$, $(phi and psi) -> sigma$,
      rule(name: $-> E$, $sigma$,
        rule(name: $and E_2$, $psi$, $[phi and psi]^1$),
        rule(name: $-> E$, $psi -> sigma$,
          rule(name: $and E_1$, $phi$, $[phi and psi]^1$),
          $[phi -> (psi -> sigma)]^2$)))))
]

#esempio(numbered: false)[
  Dimostriamo $tack phi -> not not phi$ e $tack not not phi -> phi$, ricordando che $not phi = phi -> bot$.
  #alberi(
    rule(name: $-> I^2$, $phi -> not not phi$, rule(name: $-> I^1$, $not not phi$, rule(name: $-> E$, $bot$, $[phi]^2$, $[not phi]^1$))),
    rule(name: $-> I^2$, $not not phi -> phi$, rule(name: $#pb[Raa]^1$, $phi$, rule(name: $-> E$, $bot$, $[not phi]^1$, $[not not phi]^2$))),
  )
  Esplicitando le negazioni, la prima derivazione dimostra $phi -> ((phi -> bot) -> bot)$, e non usa alcuna regola per $bot$. Ne segue che questa derivazione rimarrà valida anche in logica minimale e intuizionistica. La seconda derivazione, invece, richiede necessariamente la regola $#pb[Raa]$. Si può dimostrare, infatti, che ogni prova di $not not phi -> phi$ deve usare $#pb[Raa]$,#footnote[Tuttavia, questa tipologia di dimostrazioni non sarà richiesta in sede d'esame.] per cui in logica intuizionistica non possiamo sempre assumere che $not not alpha equiv alpha$. Questo ha conseguenze importanti sull'automatizzazione delle prove. Infatti, mentre $tack phi -> not not phi$ è codificabile in logica intuizionistica, ogni prova di $not not phi -> phi$ usa un principio _sconosciuto_, privo di contenuto computazionale, e quindi non codificabile in logica intuizionistica.
]

#esempio(numbered: false)[
  Dimostriamo $tack alpha -> (not alpha -> beta)$, che usa la regola _ex falso_. Questo è un assioma che, spesso, viene utilizzato nelle implementazioni automatizzate dei sistemi di deduzione per rimpiazzare la regola $#pb[Raa]$.
  #albero(rule(name: $-> I^2$, $alpha -> (not alpha -> beta)$, rule(name: $-> I^1$, $not alpha -> beta$, rule(name: $bot_i$, $beta$, rule(name: $-> E$, $bot$, $[alpha]^2$, $[not alpha]^1$)))))
]

#esempio(title: [Legge di Peirce])[
  La _Legge di Peirce_, $tack ((alpha -> beta) -> alpha) -> alpha$, è un teorema della logica proposizionale classica, ed è l'equivalente del _terzo escluso_ senza l'uso della disgiunzione. Vale, infatti, che la _Legge di Peirce_ è equivalente alla regola $#pb[Raa]$ e al _terzo escluso_.
  #albero(rule(name: $-> I^3$, $((alpha -> beta) -> alpha) -> alpha$,
    rule(name: $#pb[Raa]^2$, $alpha$,
      rule(name: $-> E$, $bot$,
        rule(name: $-> E$, $alpha$,
          rule(name: $-> I^1$, $alpha -> beta$, rule(name: $bot_i$, $beta$, rule(name: $-> E$, $bot$, $[alpha]^1$, $[not alpha]^2$))),
          $[(alpha -> beta) -> alpha]^3$),
        $[not alpha]^2$))))
  Si noti che l'ipotesi $not alpha$ viene usata due volte, ed entrambe le occorrenze sono scaricate dalla stessa applicazione di $#pb[Raa]$. Questo è un utilizzo lecito delle ipotesi e dello scaricamento in deduzione naturale.
]

#esempio(title: [Contrapposizione])[
  Dimostriamo $tack (not psi -> not phi) -> (phi -> psi)$, che giustifica le dimostrazioni per contrapposizione.
  #albero(rule(name: $-> I^3$, $(not psi -> not phi) -> (phi -> psi)$,
    rule(name: $-> I^2$, $phi -> psi$,
      rule(name: $#pb[Raa]^1$, $psi$,
        rule(name: $-> E$, $bot$, $[phi]^2$, rule(name: $-> E$, $not phi$, $[not psi]^1$, $[not psi -> not phi]^3$))))))
  La formula opposta, ovvero $tack (phi -> psi) -> (not psi -> not phi)$, non richiede la regola $#pb[Raa]$ e, quindi, vale anche in logica intuizionistica.
]

#esercizio[
  Si dimostrino i seguenti teoremi della logica proposizionale:
  + $tack phi and psi -> psi and phi$
  + $tack (phi -> psi) -> ((psi -> sigma) -> (phi -> sigma))$
  + $tack (phi -> psi) -> (not psi -> not phi)$
  + $tack not not not phi <-> not phi$
  + $tack (phi -> (psi -> sigma)) <-> (phi and psi -> sigma)$
  + $tack bot <-> (phi and not phi)$
]

Dopo aver acquisito familiarità con le derivazioni, possiamo, dunque, definirle formalmente. Come per le formule proposizionali, l'insieme delle derivazioni è definito induttivamente mediante una struttura ricorsiva. Intuitivamente, si definiscono le derivazioni atomiche o elementari, composte da una sola formula, e si costruiscono derivazioni complesse applicando le regoledi deduzione naturale. Indichiamo con $cal(D)$ una derivazione, e scriviamo $cal(D)$ sopra la sua conclusione $phi$.

#definizione[
  L'insieme delle _derivazioni_ è il più piccolo insieme $X$ tale che
  + l'albero composto dal solo nodo $phi$ appartiene a $X$, per ogni $phi in #pb[Prop]$
  + ($and$) se le derivazioni $cal(D)$ e $cal(D)'$, con conclusioni $phi$ e $phi'$, appartengono a $X$, allora la derivazione ottenuta applicando $and I$ con conclusione $phi and phi'$ appartiene a $X$. Se la derivazione $cal(D)$, con conclusione $phi and psi$, appartiene a $X$, allora le derivazioni ottenute applicando $and E_1$ e $and E_2$ appartengono a $X$
  + ($->$) se la derivazione $cal(D)$, con conclusione $psi$, appartiene a $X$, allora la derivazione ottenuta applicando $-> I$, con conclusione $phi -> psi$ e scaricando l'ipotesi $phi$, appartiene a $X$. Se le derivazioni $cal(D)$ e $cal(D)'$, con conclusioni $phi$ e $phi -> psi$, appartengono a $X$, allora la derivazione ottenuta applicando $-> E$ con conclusione $psi$ appartiene a $X$
  + ($bot$) se la derivazione $cal(D)$, con conclusione $bot$, appartiene a $X$, allora la derivazione ottenuta applicando $bot_i$ con conclusione $phi$ appartiene a $X$, e la derivazione ottenuta applicando $#pb[Raa]$ con conclusione $phi$, scaricando l'ipotesi $not phi$, appartiene a $X$
  Con $"hp"(cal(D))$ si indica l'insieme, eventualmente vuoto, delle ipotesi non scaricate dalla derivazione $cal(D)$, ossia delle foglie della derivazione $cal(D)$ non marcate come scaricate. Si noti che, per costruzione, ogni derivazione $cal(D)$ utilizza un numero finito di regole di deduzione naturale e, di conseguenza, richiede un numero finito di ipotesi.
]

#definizione(title: [Derivabilità])[
  Sia $Gamma$ un insieme di formule proposizionali. Si dice che una formula $phi$ è _derivabile_ dall'insieme di ipotesi $Gamma$, e si scrive $Gamma tack phi$, se esiste una derivazione $cal(D)$ con conclusione $phi$ tale che $"hp"(cal(D)) subset.eq Gamma$. Se $"hp"(cal(D)) = emptyset$, ossia $emptyset tack phi$, si scrive $tack phi$ e si dice che $phi$ è un _teorema_.
]

In altre parole, la notazione $Gamma tack phi$ significa che esiste una derivazione di $phi$ le cui ipotesi non scaricate sono tutte contenute in $Gamma$. Si noti che non è richiesto che tutte le formule di $Gamma$ vengano usate, ed infatti $Gamma$ può anche essere infinito, mentre ogni derivazione, essendo un albero finito e potendo, eventualmente, essere automatizzata, usa soltanto un numero finito di ipotesi. Dalla definizione seguono immediatamente alcune proprietà della relazione di derivabilità, che riflettono le regole di deduzione:
- $Gamma tack phi$ se $phi in Gamma$
- se $Gamma tack phi$ e $Gamma' tack psi$, allora $Gamma union Gamma' tack phi and psi$
- se $Gamma tack phi and psi$, allora $Gamma tack phi$ e $Gamma tack psi$
- se $Gamma union {phi} tack psi$, allora $Gamma tack phi -> psi$
- se $Gamma tack phi$ e $Gamma' tack phi -> psi$, allora $Gamma union Gamma' tack psi$
- se $Gamma tack bot$, allora $Gamma tack phi$
- se $Gamma union {not phi} tack bot$, allora $Gamma tack phi$

== Il Principio del Terzo Escluso

Introduciamo, allora, le regole per il connettivo logico di disgiunzione, che è stato inizialmente escluso. Infatti, il connettivo $or$ è molto più complesso da codificare rispetto al connettivo $and$, sia dal punto di vista delle regole di deduzione naturale che da un punto di vista computazionale, quando ad ogni dimostrazione associamo una computazione. Per questo motivo, talvolta, non viene codificato all'interno di implementazioni automatizzate di un sistema logico.#footnote[Allo stesso modo, talvolta, in logica del primo ordine si sceglie di codificare soltanto il quantificatore $forall$, e non il quantificatore $exists$.] Le regole di introduzione sono semplici, in quanto, per dimostrare $phi or psi$ è sufficiente dimostrare $phi$, oppure dimostrare $psi$.
#alberi(
  rule(name: $or I_1$, $phi or psi$, $phi$),
  rule(name: $or I_2$, $phi or psi$, $psi$),
  rule(name: $or E$, $sigma$, $phi or psi$, deriv($[phi]$, $dots.v$, $sigma$), deriv($[psi]$, $dots.v$, $sigma$)),
)
La regola di eliminazione formalizza, invece, la _dimostrazione per casi_. Informalmente, per dimostrare che "$A$ oppure $B$ implica $C$", dobbiamo dimostrare i due casi "$A$ implica $C$" _e_ "$B$ implica $C$". Dunque, se sappiamo che vale $phi or psi$, e sappiamo derivare $sigma$ sia assumendo $phi$ che assumendo $psi$, allora possiamo concludere $sigma$, scaricando le ipotesi $phi$ e $psi$ nelle due sotto-derivazioni di $sigma$. Si noti che la premessa principale, $phi or psi$, non viene scaricata da questa regola. Dunque, se essa è, a sua volta, un'ipotesi della derivazione, deve essere scaricata successivamente mediante un'altra regola, che solitamente è l'introduzione $-> I$. Semanticamente, la regola è giustificata dal fatto che
$
  Gamma, alpha tack.rr gamma quad "e" quad Delta, beta tack.rr gamma quad "e" quad Sigma tack.rr alpha or beta quad ==> quad Gamma, Delta, Sigma tack.rr gamma
$
e, in particolare, con $Sigma = {alpha or beta}$, da $Gamma, alpha tack.rr gamma$ e $Delta, beta tack.rr gamma$ segue $Gamma, Delta, alpha or beta tack.rr gamma$, siccome $alpha or beta tack.rr alpha or beta$ è banalmente vero. Per dimostrare $(phi or psi) -> sigma$ in deduzione naturale, dunque, si assume $phi or psi$, si dimostrano i due casi con le derivazioni $cal(D)_1$ e $cal(D)_2$, si applica $or E$ e infine si scarica l'ipotesi $phi or psi$ con la regola $-> I$:
#albero(rule(name: $-> I^2$, $(phi or psi) -> sigma$, rule(name: $or E^1$, $sigma$, $[phi or psi]^2$, deriv($[phi]^1$, $cal(D)_1$, $sigma$), deriv($[psi]^1$, $cal(D)_2$, $sigma$))))

#esempio(numbered: false)[
  Dimostriamo $tack (alpha or beta) -> (alpha or (beta or gamma))$, una delle due direzioni della proprietà di associatività della disgiunzione. Le due sotto-derivazioni $cal(D)_1$ e $cal(D)_2$ corrispondono ai due casi della dimostrazione, in cui si assume rispettivamente $alpha$ e $beta$.
  #albero(rule(name: $-> I^2$, $(alpha or beta) -> (alpha or (beta or gamma))$,
    rule(name: $or E^1$, $alpha or (beta or gamma)$,
      $[alpha or beta]^2$,
      rule(name: $or I_1$, $alpha or (beta or gamma)$, $[alpha]^1$),
      rule(name: $or I_2$, $alpha or (beta or gamma)$, rule(name: $or I_1$, $beta or gamma$, $[beta]^1$)))))
]

#esempio(numbered: false)[
  Dimostriamo $tack (phi and psi) or sigma -> (phi or sigma) and (psi or sigma)$. Il suggerimento è ragionare per casi, poiché la premessa dell'implicazione è una disgiunzione. Per non appesantire la notazione, mostriamo la derivazione di $(phi or sigma) and (psi or sigma)$ a partire dall'ipotesi $(phi and psi) or sigma$, a cui basta poi applicare $-> I$.
  #albero(rule(name: $and I$, $(phi or sigma) and (psi or sigma)$,
    rule(name: $or E^1$, $phi or sigma$, $(phi and psi) or sigma$,
      rule(name: $or I$, $phi or sigma$, rule(name: $and E$, $phi$, $[phi and psi]^1$)),
      rule(name: $or I$, $phi or sigma$, $[sigma]^1$)),
    rule(name: $or E^2$, $psi or sigma$, $(phi and psi) or sigma$,
      rule(name: $or I$, $psi or sigma$, rule(name: $and E$, $psi$, $[phi and psi]^2$)),
      rule(name: $or I$, $psi or sigma$, $[sigma]^2$))))
]

#esempio(numbered: false)[
  Dimostriamo $tack (phi -> psi) or (psi -> phi)$. A differenza degli esempi precedenti, questa formula non è dimostrabile senza l'utilizzo di principi classici come la riduzione all'assurdo. L'idea è di supporre che $(phi -> psi) or (psi -> phi)$ non valga, ovvero assumere $not ((phi -> psi) or (psi -> phi))$, e derivare una contraddizione.
  #albero(dimensione: 8.5pt, rule(name: $#pb[Raa]^2$, $(phi -> psi) or (psi -> phi)$,
    rule(name: $-> E$, $bot$,
      rule(name: $or I$, $(phi -> psi) or (psi -> phi)$,
        rule(name: $-> I^1$, $phi -> psi$,
          rule(name: $bot_i$, $psi$,
            rule(name: $-> E$, $bot$,
              rule(name: $or I$, $(phi -> psi) or (psi -> phi)$, rule(name: $-> I$, $psi -> phi$, $[phi]^1$)),
              $[not ((phi -> psi) or (psi -> phi))]^2$)))),
      $[not ((phi -> psi) or (psi -> phi))]^2$)))
  Si osservi attentamente la struttura ricorsiva della prova. Per derivare $bot$ dall'ipotesi $not ((phi -> psi) or (psi -> phi))$ dobbiamo esibire una prova della disgiunzione, ma non sappiamo quale dei due disgiunti valga. Allora, assumendo $phi$, otteniamo banalmente $psi -> phi$ e quindi la disgiunzione, da cui una contraddizione e, per la regola _ex falso_, la formula $psi$. Questo permette di scaricare la formula $phi$, ottenendo l'implicazione $phi -> psi$, e quindi nuovamente la disgiunzione, che contraddice l'ipotesi.
]

#esempio(title: [Legge di De Morgan])[
  Dimostriamo $tack not (phi and psi) -> not phi or not psi$. Anche in questo caso è necessario l'uso della regola $#pb[Raa]$, per cui questa _Legge di De Morgan_ non può valere anche in logica intuizionistica.
  #albero(dimensione: 8.5pt, rule(name: $-> I^4$, $not (phi and psi) -> not phi or not psi$,
    rule(name: $#pb[Raa]^3$, $not phi or not psi$,
      rule(name: $-> E$, $bot$,
        rule(name: $and I$, $phi and psi$,
          rule(name: $#pb[Raa]^1$, $phi$, rule(name: $-> E$, $bot$, rule(name: $or I$, $not phi or not psi$, $[not phi]^1$), $[not (not phi or not psi)]^3$)),
          rule(name: $#pb[Raa]^2$, $psi$, rule(name: $-> E$, $bot$, rule(name: $or I$, $not phi or not psi$, $[not psi]^2$), $[not (not phi or not psi)]^3$))),
        $[not (phi and psi)]^4$))))
]

Il principio del _terzo escluso_, o _tertium non datur_ ($#pb[Tnd]$), detto anche _excluded middle_ ($#pb[Em]$), afferma che, per ogni formula $phi$, deve valere che $phi or not phi$. Semanticamente, $tack.rr phi or not phi$ è banalmente vero. Infatti, per ogni valutazione, o $phi$ è vera, oppure $not phi$ deve essere vera. Tuttavia, il connettivo $or$ ha un significato molto diverso in logica classica e in logica intuizionistica. In logica classica, la formula $phi or not phi$ esprime il fatto che una delle due alternative deve valere, ma non ci è dato sempre sapere _quale_ delle due valga. Si consideri, ad esempio, la proposizione $R := bold("P") != bold("NP")$. Classicamente, vale $R or not R$, ma ad oggi non sappiamo quale delle due possibilità sia vera. In altre parole, sebbene vale certamente $R or not R$, non possiamo concludere né $tack R$ né $tack not R$. Questo esempio, dunque, spiega anche perché la disgiunzione sia un connettivo più difficile da codificare rispetto all'implicazione. In logica intuizionistica, invece, una dimostrazione della formula $phi or psi$ deve sempre indicare _quale_ dei due disgiunti è stato dimostrato, e fornirne una dimostrazione valida. Dimostriamo, allora, il teorema $tack phi or not phi$ in deduzione naturale. Procediamo con un ragionamento per assurdo, supponendo che $phi or not phi$ non valga, ossia assumendo $not (phi or not phi)$.
#albero(rule(name: $#pb[Raa]^2$, $phi or not phi$,
  rule(name: $-> E$, $bot$,
    rule(name: $or I_2$, $phi or not phi$,
      rule(name: $-> I^1$, $not phi$,
        rule(name: $-> E$, $bot$, rule(name: $or I_1$, $phi or not phi$, $[phi]^1$), $[not (phi or not phi)]^2$))),
    $[not (phi or not phi)]^2$)))
Assumendo $phi$, otteniamo la formula $phi or not phi$, che contraddice l'ipotesi. Dunque, deve valere $not phi$, da cui nuovamente si deriva $phi or not phi$, e quindi una contraddizione. Si noti che, per derivare il terzo escluso, abbiamo dovuto usare la regola $#pb[Raa]$, e si può dimostrare che qualunque derivazione per il terzo escluso deve usare tale regola. Di conseguenza, sono necessari principi logici forti, ovvero principi _classici_ nel senso che non sono validi anche il logica intuizionistica, per esprimere il terzo escluso.

Quando il terzo escluso viene considerato come una regola del sistema di deduzione, che è possibile in quanto è un teorema in un sistema logico equivalente, permette di rendere alcune derivazioni più semplici e dirette. Consideriamo, ad esempio, il teorema $tack (alpha -> beta) -> (not alpha or beta)$, che esprime il significato classico dell'implicazione. Usando il solo principio classico $#pb[Raa]$, la derivazione è la seguente.
#albero(rule(name: $-> I^3$, $(alpha -> beta) -> (not alpha or beta)$,
  rule(name: $#pb[Raa]^2$, $not alpha or beta$,
    rule(name: $-> E$, $bot$,
      rule(name: $or I_2$, $not alpha or beta$,
        rule(name: $-> E$, $beta$,
          rule(name: $#pb[Raa]^1$, $alpha$, rule(name: $-> E$, $bot$, rule(name: $or I_1$, $not alpha or beta$, $[not alpha]^1$), $[not (not alpha or beta)]^2$)),
          $[alpha -> beta]^3$)),
      $[not (not alpha or beta)]^2$))))
Se, invece, ammettiamo il terzo escluso come regola del sistema deduttivo, la derivazione diventa una semplice dimostrazione per casi.
#albero(rule(name: $-> I^2$, $(alpha -> beta) -> (not alpha or beta)$,
  rule(name: $or E^1$, $not alpha or beta$,
    rule(name: $#pb[Tnd]$, $alpha or not alpha$),
    rule(name: $or I_2$, $not alpha or beta$, rule(name: $-> E$, $beta$, $[alpha]^1$, $[alpha -> beta]^2$)),
    rule(name: $or I_1$, $not alpha or beta$, $[not alpha]^1$))))
Tuttavia, questa tipologia di sistemi logici con assiomi, ovvero regole aggiuntive che non richiedono alcune premesse, perdono la _struttura del ragionamento_ necessario per produrre una dimostrazione, poiché l'assioma introduce una formula _dal nulla_, senza alcuna giustificazione, nascondendo il ragionamento che servirebbe per ottenerla. In generale, quindi, considereremo soltanto sistemi logici che non definiscono assiomi, ma solo regole di derivazione da premesse a conclusione.

== L'Equivalenza tra #pb[Raa] e Terzo Escluso

Abbiamo osservato che la regola $#pb[Raa]$ permette di derivare il principio classico del terzo escluso, e che il principio del terzo escluso, a sua volta, sembra poter rimpiazzare la regola $#pb[Raa]$ nelle derivazioni, quando assunto come regola del sistema deduttivo. Lo scopo di questa sezione, quindi, è quello di dimostrare che i due principi classici sono equivalenti, nel senso che i due sistemi deduttivi ottenuti aggiungendo l'uno o l'altro principio alle regole del sistema di derivazione, dimostrano esattamente lo stesso insieme di formule proposizionali. Inanzitutto, per poter confrontare sistemi deduttivi diversi, è utile formalizzare il concetto di regola ridondante e di equivalenza tra sistemi.

#definizione(title: [Eliminazione di una regola])[
  Sia $R$ una regola di un sistema di deduzione. La regola $R$ può essere _eliminata_ se, per ogni derivazione $cal(D)$ di una formula $phi$ in cui la regola $R$ è usata, esiste un'altra derivazione $cal(D)^*$ della formula $phi$ che non usa la regola $R$ e tale per cui $"hp"(cal(D)^*) subset.eq "hp"(cal(D))$.
]

#definizione(title: [Equivalenza tra sistemi di deduzione])[
  Due sistemi di deduzione $I$ e $J$ sono _equivalenti_ se, per ogni insieme di ipotesi $Gamma$ e per ogni formula $phi$, vale che $Gamma scripts(tack)_I phi <==> Gamma scripts(tack)_J phi$, ovvero se essi sono in grado di dimostrare lo stesso insieme di formule, a partire dallo stesso insieme di ipotesi.
]

#definizione[
  Sia $cal(N)$ il frammento della deduzione naturale che utilizza le sole regole ${#pb[Ef], #pb[Raa], and I slash E, -> I slash E, or I slash E}$, e sia $cal(N)^*$ il frammento della deduzione naturale che utilizza le sole regole ${#pb[Ef], #pb[Tnd], and I slash E, -> I slash E, or I slash E}$, dove $#pb[Tnd]$ è la regola senza premesse
  #albero(rule(name: $#pb[Tnd]$, $phi or not phi$))
  Indichiamo, inoltre, con $cal(N)_I$ il sistema ottenuto da $cal(N)$ rimuovendo $#pb[Raa]$, che definiremo, successivamente, come la deduzione naturale intuizionistica. Dunque, vale che $cal(N) = cal(N)_I union #pb[Raa]$, e $cal(N)^* = cal(N)_I union #pb[Tnd]$.
]

#teorema(title: [Equivalenza tra #pb[Raa] e #pb[Tnd]])[
  I sistemi $cal(N)$ e $cal(N)^*$ sono equivalenti nella logica proposizionale. In particolare, per ogni derivazione $Pi$ di $phi$ in $cal(N)$ esiste una derivazione $Pi^*$ di $phi$ in $cal(N)^*$ con $"hp"(Pi^*) = "hp"(Pi)$, e viceversa.
]

#dimostrazione[
  Sia $Pi$ una derivazione per la formula $phi$ nel sistema di deduzione naturale $cal(N)$. Mostriamo la direzione ($cal(N) => cal(N)^*$) per induzione sulla struttura della derivazione $Pi$ per la formula $phi$ in $cal(N)$.

  _Caso base._ Se $Pi = phi$, allora non si applicano regole, per cui $Pi$ è anche una derivazione in $cal(N)^*$, per costruzione di $cal(N)^*$.

  _Passo induttivo._ Sia $Pi$ una derivazione in $cal(N)$ la cui ultima regola è $r$, applicata alle sotto-derivazioni $Pi_1, dots, Pi_k$. Se $r != #pb[Raa]$, allora, per ipotesi induttiva, esistono le derivazioni $Pi_1^*, dots, Pi_k^*$ in $cal(N)^*$ equivalenti a $Pi_1, dots, Pi_k$, e siccome $r$ è anche una regola di $cal(N)^*$, la derivazione $Pi^*$ ottenuta applicando $r$ a $Pi_1^*, dots, Pi_k^*$ è una derivazione di $phi$ in $cal(N)^*$, per costruzione di $cal(N)^*$. Se, invece, $r = #pb[Raa]$, allora $Pi$ è una derivazione della forma
  #albero(rule(name: $#pb[Raa]$, $phi$, deriv($[not phi]$, $Pi_1$, $bot$)))
  Per ipotesi induttiva, esiste una derivazione $Pi_1^*$ in $cal(N)^*$ equivalente a $Pi_1$, ossia una derivazione di $bot$ dall'ipotesi $not phi$. Costruiamo, allora, la seguente derivazione per casi, in cui il caso $phi$ è banale e il caso $not phi$ si risolve con l'_ex falso_.
  #albero(rule(name: $or E^1$, $phi$, rule(name: $#pb[Tnd]$, $phi or not phi$), $[phi]^1$, rule(name: $#pb[Ef]$, $phi$, deriv($[not phi]^1$, $Pi_1^*$, $bot$))))
  Dunque, la formula $phi$ è derivabile in $cal(N)^*$. Si noti che le occorrenze di $not phi$ scaricate da $#pb[Raa]$ in $Pi$ sono ora scaricate da $or E$, per cui vale $"hp"(Pi) = "hp"(Pi^*)$.

  La direzione opposta, ($cal(N)^* => cal(N)$), segue analogamente, per induzione sulla struttura della derivazione. L'unico caso non banale è quello in cui la regola applicata è $r=#pb[Tnd]$, ossia la derivazione è il solo assioma $phi or not phi$. Ma abbiamo già mostrato, nell'esempio sul terzo escluso, che $phi or not phi$ è derivabile in $cal(N)$ senza ipotesi, usando la regola $#pb[Raa]$. Dunque, è sufficiente sostituire ogni occorrenza dell'assioma nella derivazione, con la derivazione del terzo escluso.
]

Il teorema ci dice che, in presenza di un insieme di regole di deduzione intuizionistiche, aggiungere la regola $#pb[Raa]$ oppure il principio del terzo escluso è indifferente, in quanto entrambi i principi permettono di codificare la logica classica. Un risultato analogo vale per l'_ex falso_ che, quando il sistema di deduzione include la regola $#pb[Raa]$, diventa ridondante.

#teorema[
  La regola $#pb[Ef]$ è ridondante in $cal(N)$, ovvero può essere rimpiazzata da $#pb[Raa]$.
]

#dimostrazione[
  La dimostrazione è per induzione sulla struttura della derivazione $Pi$ che deriva la formula $phi$. Se $Pi = phi$, allora $Pi$ è una derivazione immediata che non usa l'_ex falso_. Sia, quindi, $r$ l'ultima regola di $Pi$, applicata alle sotto-derivazioni $Pi_1, dots, Pi_k$. Se $r != #pb[Ef]$, per ipotesi induttiva, esistono $Pi_1^*, dots, Pi_k^*$ che non usano la regola $#pb[Ef]$, per cui è possibile derivare $phi$ applicando $r$ a $Pi_1^*, dots, Pi_k^*$ senza l'utilizzo della regola $#pb[Ef]$. Se $r = #pb[Ef]$, allora $Pi$ deriva $phi$ da una sotto-derivazione $Pi_1$ di $bot$ e, per ipotesi induttiva, esiste una derivazione $Pi_1^*$ che deriva $bot$ senza l'utilizzo della regola $#pb[Ef]$. Possiamo allora costruire la seguente derivazione
  #albero(rule(name: $#pb[Raa]$, $phi$, deriv($Pi_1^*$, $bot$)))
  dove le occorrenze dell'ipotesi $not phi$ possono essere scaricate con uno scaricamento vacuo, in modo da mantenere invariato l'insieme di ipotesi della derivazione. Di conseguenza, deve valere che $"hp"(Pi) = "hp"(Pi^*)$.
]

In conclusione, tutti i teoremi della logica proposizionale classica che utilizzano la regola $#pb[Raa]$, il principio del terzo escluso o la _Legge di Peirce_ in modo non-ridondante, ossia non è possibile derivare il teorema senza l'utilizzo di queste regole, sono teoremi che non valgono in logica intuizionistica. Di conseguenza, i teoremi della logica classica 
- $tack not (phi and psi) -> not phi or not psi$
- $tack not not phi -> phi$
- $tack (alpha -> beta) -> (not alpha or beta)$
- $tack (phi -> psi) or (psi -> phi)$
sono esempi di teoremi classici che non possono valere anche in logica intuizionistica.


== I Teoremi di Correttezza e di Completezza

Per concludere il capitolo riguardante la logica proposizionale, colleghiamo le nozioni di sintassi e di semantica definite in questo sistema logico, per mezzo dei Teoremi di Correttezza e di Completezza. Il primo risultato che dimostriamo è il Teorema di Correttezza, il quale afferma che il sistema deduttivo della logica proposizionale non permette di derivare formule semanticamente false. Quindi, ogni formula che è derivabile dall'insieme di ipotesi $Gamma$, è necessariamente una conseguenza semantica dell'insieme $Gamma$. Per la dimostrazione, useremo le seguenti proprietà della conseguenza semantica, tutte di immediata verifica, dove scriviamo $Gamma, Gamma'$ per $Gamma union Gamma'$, $Gamma, phi$ per $Gamma union {phi}$, e $[| Gamma |]_v = 1$ per indicare che $[| A |]_v = 1$ per ogni $A in Gamma$:
- se $Gamma tack.rr phi$ e $Gamma subset.eq Gamma'$, allora $Gamma' tack.rr phi$
- $phi tack.rr phi$ e $Gamma, phi tack.rr phi$
- se $Gamma tack.rr phi$ e $Gamma' tack.rr phi'$, allora $Gamma, Gamma' tack.rr phi and phi'$
- se $Gamma tack.rr phi and phi'$, allora $Gamma tack.rr phi$ e $Gamma tack.rr phi'$
- per ogni formula $phi$, $bot tack.rr phi$, e se $Gamma tack.rr bot$ allora $Gamma tack.rr phi$
- se $Gamma, not phi tack.rr bot$, allora $Gamma tack.rr phi$, e quindi se $Gamma tack.rr bot$ allora $Gamma without {not phi} tack.rr phi$
- se $Gamma tack.rr phi -> sigma$ e $Gamma' tack.rr phi$, allora $Gamma, Gamma' tack.rr sigma$
- se $Gamma, phi tack.rr sigma$, allora $Gamma tack.rr phi -> sigma$, e quindi se $Gamma tack.rr sigma$ allora $Gamma without {phi} tack.rr phi -> sigma$
- se $Gamma tack.rr sigma$ e $Gamma', sigma tack.rr phi$, allora $Gamma, Gamma' tack.rr phi$

Ad esempio, verifichiamo la penultima proprietà. Per definizione, $Gamma, phi tack.rr sigma$ significa che, per ogni valutazione $v$, se $[| Gamma |]_v = 1$ e $[| phi |]_v = 1$, allora $[| sigma |]_v = 1$, ovvero per ogni valutazione $v$ vale $[| Gamma |]_v = 0$, oppure $[| phi |]_v = 0$, oppure $[| sigma |]_v = 1$. Si osserva, però, che la disgiunzione delle ultime due condizioni equivale a $[| phi -> sigma |]_v = 1$ per definizione della funzione $[|dot|]_v$, per cui per ogni valutazione $v$, se $[| Gamma |]_v = 1$, allora $[| phi -> sigma |]_v = 1$, ovvero $Gamma tack.rr phi -> sigma$.

#teorema(title: [Correttezza della Logica Proposizionale])[
  Se $Gamma tack phi$, allora $Gamma tack.rr phi$.
]

#dimostrazione[
  Dimostriamo, per induzione sulla lunghezza delle derivazioni, che per ogni derivazione $cal(D)$ con conclusione $phi$, e per ogni insieme $Gamma$ tale che $"hp"(cal(D)) subset.eq Gamma$, vale che $Gamma tack.rr phi$. In particolare, useremo l'ipotesi induttiva nella forma $"hp"(cal(D)) tack.rr phi$, da cui segue che $Gamma tack.rr phi$ per la prima proprietà.

  _Caso base._ Se $cal(D) = phi$, allora $phi in Gamma$, per cui $Gamma tack.rr phi$.

  _Caso $and I$._ Sia $cal(D)''$ la derivazione ottenuta applicando $and I$ alle derivazioni $cal(D)$ di $phi$ e $cal(D)'$ di $phi'$, con $"hp"(cal(D)'') subset.eq Gamma''$. Per ipotesi induttiva, $"hp"(cal(D)) tack.rr phi$ e $"hp"(cal(D)') tack.rr phi'$, per cui $"hp"(cal(D)) union "hp"(cal(D)') tack.rr phi and phi'$. Siccome $"hp"(cal(D)'') = "hp"(cal(D)) union "hp"(cal(D)') subset.eq Gamma''$, vale che $Gamma'' tack.rr phi and phi'$.

  _Caso $and E$._ Sia $cal(D)'$ la derivazione ottenuta applicando $and E_1$ ad una derivazione $cal(D)$ di $phi and psi$. Per ipotesi induttiva, vale che $"hp"(cal(D)) tack.rr phi and psi$, per cui $"hp"(cal(D)) tack.rr phi$, e quindi vale che $Gamma' tack.rr phi$. Il caso $and E_2$ è analogo.

  _Caso $-> I$._ Sia $cal(D)'$ la derivazione ottenuta applicando $-> I$ ad una derivazione $cal(D)$ di $psi$, con conclusione $phi -> psi$. Per ipotesi induttiva, vale che $"hp"(cal(D)) tack.rr psi$, per cui $"hp"(cal(D)) without {phi} tack.rr phi -> psi$. Siccome $"hp"(cal(D)') = "hp"(cal(D)) - {phi}$, vale che $Gamma' tack.rr phi -> psi$.

  _Caso $-> E$._ Sia $cal(D)''$ la derivazione ottenuta applicando $-> E$ alle derivazioni $cal(D)$ di $phi$ e $cal(D)'$ di $phi -> psi$. Per ipotesi induttiva, vale che $"hp"(cal(D)) tack.rr phi$ e $"hp"(cal(D)') tack.rr phi -> psi$, per cui $"hp"(cal(D)) union "hp"(cal(D)') tack.rr psi$, e quindi vale che $Gamma'' tack.rr psi$.

  _Caso $#pb[Raa]$._ Sia $cal(D)'$ la derivazione ottenuta applicando $#pb[Raa]$ ad una derivazione $cal(D)$ di $bot$. Per ipotesi induttiva, vale che $"hp"(cal(D)) tack.rr bot$, per cui $"hp"(cal(D)) without {not phi} tack.rr phi$. Siccome $"hp"(cal(D)') = "hp"(cal(D)) without {not phi}$, vale che $Gamma' tack.rr phi$. Il caso $bot_i$ è analogo, ed i casi relativi alla disgiunzione si trattano allo stesso modo.
]

Il teorema di correttezza è molto utile per dimostrare che una formula _non_ è derivabile. Infatti, per contrapposizione, vale che
$
  tack phi space ==> space tack.rr phi quad <==> quad tack.rr.not phi space ==> space tack.not phi
$
Dimostrare direttamente che $tack.not phi$ è difficile, poiché bisognerebbe mostrare che _nessuna_ delle infinite possibili derivazioni nel sistema deduttivo ha come conclusione la formula $phi$. Grazie al Teorema di Correttezza, invece, è sufficiente trovare un _contromodello_, ossia una valutazione $v$ tale che $[| phi |]_v = 0$, da cui $tack.rr.not phi$, e quindi $tack.not phi$. Si noti che, in logica proposizionale, la ricerca di un contromodello è un problema decidibile, in quanto è sufficiente provare tutte le valutazioni dei simboli atomici di $phi$, sebbene sia computazionalmente difficile essendo strettamente legata al problema #pb[Sat], che è $bold("NP")$-completo.

#esempio(numbered: false)[
  Dimostriamo che $tack.not phi -> (phi and sigma)$. Siano $phi = p_0$ e $sigma = p_1$, e consideriamo una valutazione $v$ tale che $v(p_0) = 1$ e $v(p_1) = 0$. Allora $[| p_0 and p_1 |]_v = 0$, per cui $[| p_0 -> (p_0 and p_1) |]_v = 0$. Dunque $tack.rr.not p_0 -> (p_0 and p_1)$ e, per il Teorema di Correttezza, $tack.not p_0 -> (p_0 and p_1)$. Analogamente, si può mostrare che $tack.not (phi -> psi) -> phi and psi$ trovando una valutazione che falsifichi la formula.
]

La direzione opposta del Teorema di Correttezza, ovvero $Gamma tack.rr phi ==> Gamma tack phi$, è noto come Teorema di Completezza, e garantisce che il sistema deduttivo della logica proposizionale sia sufficientemente potente da poter derivare qualunque verità semantica proposizionale. La dimostrazione è più articolata, e la sua struttura sarà ripresa, in forma più complessa, per la logica del primo ordine. L'idea è di dimostrare il teorema per contrapposizione, osservando che se $Gamma tack.not phi$, allora possiamo esibire una valutazione che rende vere tutte le formule di $Gamma$, e falsifica $phi$. Per costruire una tale valutazione, abbiamo bisogno della nozione di consistenza.

#definizione[
  Un insieme $Gamma$ di formule èdetto  _consistente_ se $Gamma tack.not bot$, mentre è detto _inconsistente_ se $Gamma tack bot$.
]

Si noti che la consistenza è una nozione puramente _sintattica_, in quanto un insieme è consistente se non permette di derivare una contraddizione nel sistema deduttivo. La seguente proposizione fornisce tre caratterizzazioni equivalenti degli insiemi di formule consistenti.

#proposizione[
  Le seguenti affermazioni sono equivalenti, per ogni insieme di formule $Gamma$ e per ogni formula proposizionale $phi$:
  + $Gamma$ è consistente
  + non esiste $phi$ tale che $Gamma tack phi$ e $Gamma tack not phi$
  + esiste almeno una formula $phi$ tale che $Gamma tack.not phi$
]

#dimostrazione[
  Dimostriamo l'equivalenza delle negazioni, ovvero che le seguenti affermazioni sono equivalenti: (1) $Gamma$ è inconsistente, (2) esiste $phi$ tale che $Gamma tack phi$ e $Gamma tack not phi$, (3) per ogni $phi$ vale $Gamma tack phi$.

  (1) $=>$ (3). Se $Gamma tack bot$, allora esiste una derivazione $cal(D)$ con conclusione $bot$ e tale per cui $"hp"(cal(D)) subset.eq Gamma$. Applicando la regola $bot_i$ a $cal(D)$, possiamo costruire una derivazione per ogni formula proposizionale $phi$, per cui $Gamma tack phi$ per ogni formula $phi$.

  (3) $=>$ (2). Immediato, scegliendo una qualunque formula $phi$.

  (2) $=>$ (1). Se esistono le derivazioni $cal(D)'$ di $phi$ e $cal(D)''$ di $not phi$ con ipotesi contenute in $Gamma$, applicando la regola $-> E$ e ricordando che $not phi = phi -> bot$, possiamo costruire una derivazione di $bot$ con ipotesi contenute in $Gamma$, per cui $Gamma tack bot$.
]

Il collegamento tra consistenza e semantica è dato dalla seguente proposizione, la quale afferma che un insieme di formule che può essere validato da una valutazione arbitraria, non può permettere di derivare l'assurdo nel sistema di deduzione.

#proposizione[
  Se esiste una valutazione $v$ tale che $[| psi |]_v = 1$ per ogni $psi in Gamma$, ovvero $[|Gamma|]_v=1$, allora $Gamma$ è consistente.
]

#dimostrazione[
  Supponiamo che esista una valutazione $v$ tale che $[|Gamma|]_v=1$. Supponiamo, per assurdo, che $Gamma tack bot$. Per il Teorema di Correttezza vale che $Gamma tack.rr bot$, per cui, per ogni valutazione $v$ tale che $[| psi |]_v = 1$ per ogni $psi in Gamma$, deve anche valere che $[| bot |]_v = 1$. Ma $[| bot |]_v = 0$ per ogni valutazione $v$, per cui non può esistere una valutazione che rende vere tutte le formule di $Gamma$. Questa è una contraddizione con l'ipotesi iniziale, per cui dobbiamo concludere che l'insieme $Gamma$ è consistente.
]

Il Teorema di Completezza sarà ottenuto dimostrando la direzione opposta di questa proposizione, ovvero che ogni insieme consistente ammette una valutazione che ne rende vere tutte le formule. Il seguente lemma collega la consistenza alla derivabilità.

#lemma[
  - Se $Gamma union {not phi}$ è inconsistente, allora $Gamma tack phi$.
  - Se $Gamma union {phi}$ è inconsistente, allora $Gamma tack not phi$.
]

#dimostrazione[
  Se $Gamma union {not phi}$ è inconsistente, esiste una derivazione $cal(D)'$ di $bot$ con $"hp"(cal(D)') subset.eq Gamma union {not phi}$. Applicando la regola $#pb[Raa]$ e scaricando l'ipotesi $not phi$, otteniamo una derivazione di $phi$ con ipotesi contenute in $Gamma$. Analogamente, se $Gamma union {phi}$ è inconsistente, applicando la regola $-> I$ e scaricando l'ipotesi $phi$, otteniamo una derivazione di $phi -> bot = not phi$ con ipotesi contenute in $Gamma$.
]

L'idea chiave della dimostrazione è quella di estendere un insieme consistente $Gamma$ al più grande insieme consistente che lo contiene, ovvero che contenga, per ogni formula, o la formula stessa o la sua negazione. In seguito, un tale insieme ci permetterà di descrivere completamente una valutazione.

#definizione[
  Un insieme $Gamma$ è _massimalmente consistente_ se
  + $Gamma$ è consistente
  + se $Gamma subset.eq Gamma'$ e $Gamma'$ è consistente, allora $Gamma = Gamma'$
]

In altre parole, un insieme massimalmente consistente non può essere esteso aggiungendo formule proposizionali senza diventare inconsistente. Un esempio di insieme massimalmente consistente è dato dall'insieme delle formule vere in una valutazione. Infatti, sia $v$ una valutazione e sia $Gamma = {phi | [| phi |]_v = 1}$. Per la proposizione precedente, $Gamma$ è consistente. Si consideri, allora, l'insieme consistente $Gamma'$ tale che $Gamma subset.eq Gamma'$, e supponiamo che esista $psi in Gamma'$ tale che $psi in.not Gamma$. Di conseguenza, deve valere che $[| psi |]_v = 0$, per cui $[| not psi |]_v = 1$ e, quindi, $not psi in Gamma subset.eq Gamma'$. Ma allora $psi, not psi in Gamma'$, per cui $Gamma'$ è inconsistente, che è una contraddizione. Dunque $Gamma$ è un insieme massimalmente consistente.

#teorema(title: [Lemma di Lindenbaum])[
  Ogni insieme consistente $Gamma$ è contenuto in un insieme massimalmente consistente $Gamma^*$.
]

#dimostrazione[
  Siccome l'insieme dei simboli della logica proposizionale è numerabile, allora anche l'insieme delle formule è numerabile mediante una enumerazione induttiva, per cui possiamo etichettare tutte le formule proposizionali come $phi_0, phi_1, phi_2, dots$. Definiamo la seguente sequenza non decrescente di insiemi:
  $
    Gamma_0 = Gamma, quad quad Gamma_(n + 1) = cases(Gamma_n union {phi_n} & "se" Gamma_n union {phi_n} "è consistente", Gamma_n & "altrimenti")
  $
  e definiamo $Gamma^* = union.big_(n >= 0) Gamma_n$. Dimostriamo che $Gamma^*$ è massimalmente consistente.

  (a) Vale che $Gamma_n$ è consistente per ogni $n$, per il principio di induzione su $n$.

  (b) Vale che $Gamma^*$ è consistente. Supponiamo, per assurdo, che $Gamma^* tack bot$. Allora esiste una derivazione $cal(D)$ del falso $bot$ con $"hp"(cal(D)) = {psi_0, dots, psi_k} subset.eq Gamma^*$. Siccome $Gamma^* = union.big_n Gamma_n$, per ogni $i <= k$ esiste $n_i$ tale che $psi_i in Gamma_(n_i)$. Sia $n = max{n_i | i <= k}$. Siccome la sequenza è non decrescente con rispetto alla relazione di contenimento, vale che $psi_0, dots, psi_k in Gamma_n$, per cui vale $Gamma_n tack bot$, che contraddice (a).

  (c) Vale che $Gamma^*$ è massimalmente consistente. Sia $Delta$ un insieme consistente tale che $Gamma^* subset.eq Delta$. Supponiamo che $psi in Delta$ e $psi in.not Gamma^*$. Allora, esiste un intero $m$ tale che $psi = phi_m$. Siccome $Gamma_m subset.eq Gamma^* subset.eq Delta$ e $Delta$ è consistente, deve valere che anche $Gamma_m union {phi_m}$ è consistente, per cui, per costruzione della sequenza di insiemi $Gamma_n$, vale che $Gamma_(m + 1) = Gamma_m union {phi_m}$, ossia $phi_m in Gamma_(m + 1) subset.eq Gamma^*$. Possiamo iterare questo argomento per ogni formula $psi in Delta$ e $psi in.not Gamma^*$, e costruire un insieme di formule che contiene $Delta$ e che è un sottoinsieme dell'insieme $Gamma^*$. Dunque, vale che $Delta subset.eq Gamma^*$, per cui $Gamma^* = Delta$.
]

Il punto (b) della dimostrazione sfrutta l'osservazione che ogni derivazione è un oggetto finito, e utilizza, quindi, soltanto un numero finito di ipotesi. Dimostriamo le seguenti proprietà degli insiemi massimamente consistenti.

#lemma[
  Se $Gamma$ è un insieme massimalmente consistente, allora $Gamma$ è chiuso rispetto alla derivabilità, ovvero se $Gamma tack phi$ allora $phi in Gamma$.
]

#dimostrazione[
  Suponiamo che $Gamma$ sia massimalmente consistente, che esista $phi$ tale che $Gamma tack phi$ e, per assurdo, vale che $phi in.not Gamma$. Per la massimalità dell'insieme consistente $Gamma$, deve valere che $Gamma union {phi}$ è inconsistente, per cui, per il lemma precedente, vale che $Gamma tack not phi$. Ma allora vale che $Gamma tack phi$ e $Gamma tack not phi$, per cui $Gamma$ è inconsistente, che è una contraddizione.
]

#lemma[
  Sia $Gamma$ un insieme massimalmente consistente. Allora
  + per ogni $phi$, vale $phi in Gamma$ oppure $not phi in Gamma$
  + per ogni $phi, psi$, vale $phi -> psi in Gamma <==> (phi in Gamma ==> psi in Gamma)$
]

#dimostrazione[
  (a) Sappiamo che $phi$ e $not phi$ non possono appartenere entrambe a $Gamma$, altrimenti $Gamma$ sarebbe inconsistente. Consideriamo l'insieme $Gamma' = Gamma union {phi}$. Se l'insieme $Gamma'$ è inconsistente, allora vale che $Gamma tack not phi$ e, per la chiusura rispetto alla derivabilità, vale che $not phi in Gamma$. Se, invece, $Gamma'$ è consistente, allora $phi in Gamma$ per la massimalità di $Gamma$.

  (b) ($=>$) Siano $phi -> psi in Gamma$ e $phi in Gamma$. Applicando $-> E$ alle ipotesi $phi->psi$ e $phi$ in $Gamma$, otteniamo $Gamma tack psi$, e quindi $psi in Gamma$ per la chiusura rispetto alla derivabilità. ($arrow.l.double$) Supponiamo che $phi in Gamma ==> psi in Gamma$. Se $phi in Gamma$, allora deve valere che $psi in Gamma$, per cui $Gamma tack psi$ e quindi, introducendo l'implicazione con scaricamento vacuo, vale che $Gamma tack phi -> psi$. Se $phi in.not Gamma$, allora $not phi in Gamma$ per il punto (a), per cui $Gamma tack not phi$ e quindi, per l'esempio precedente con l'_ex falso_, possiamo derivare $Gamma tack phi -> psi$ usando solo $not phi$ come ipotesi non scaricata. In entrambi i casi, vale che $phi -> psi in Gamma$ per la chiusura rispetto alla derivabilità.
]

A seguito di questo lemma, è possibile dimostrare il seguente corollario, di particolare utilità alla dimostrazione del Teorema di Completezza.
#corollario[
  Se $Gamma$ è massimalmente consistente, allora $phi in Gamma <==> not phi in.not Gamma$, e $not phi in Gamma <==> phi in.not Gamma$.
]

Possiamo ora dimostrare il risultato chiave del Teorema di Completezza, ossia l'esistenza di un modello per ogni insieme consistente. Si noti che ci riconduciamo ad un insieme di connettivi logici elemetare, mediante i quali è possibile, successivamente, esprimere gli altri connettivi logici precedentemente introdotti.

#lemma[
  Se $Gamma$ è consistente, allora esiste una valutazione $v$ tale che $[| psi |]_v = 1$ per ogni $psi in Gamma$.
]

#dimostrazione[
  Per il _Lemma di Lindenbaum_, l'insieme $Gamma$ è contenuto in un insieme massimalmente consistente $Gamma^*$. Definiamo l'assegnamento
  $
    v(p_i) = cases(1 & "se" p_i in Gamma^*, 0 & "altrimenti")
  $
  ed estendiamolo alla valutazione $[| dot |]_v$. Dimostriamo, per induzione su una formula $phi$ arbitraria, che $[| phi |]_v = 1 <==> phi in Gamma^*$. Per una formula $phi$ atomica, l'affermazione vale per definizione, in quanto $bot in.not Gamma^*$ siccome $Gamma^*$ è consistente. Se $phi = psi and sigma$, allora $[| phi |]_v = 1$ se e solo se $[| psi |]_v = [| sigma |]_v = 1$. Dunque, per ipotesi induttiva, $[| phi |]_v = 1$ se e solo se $psi, sigma in Gamma^*$. Quindi, siccome supponendo $psi, sigma in Gamma^*$ possiamo derivare nel sistema logico proposizionale che $Gamma tack psi and sigma$ mediante la regola $and I$, per la chiusura rispetto alla derivabilità vale che $psi and sigma in Gamma^*$. Se, invece, $phi = psi -> sigma$, allora $[| phi |]_v = 0$ se e solo se $[| psi |]_v = 1$ e $[| sigma |]_v = 0$. Dunque, per ipotesi induttiva, vale che $psi in Gamma^*$ e $sigma in.not Gamma^*$. Per il lemma precedente, deve valere che $psi -> sigma in.not Gamma^*$. In altre parole, $[|psi->sigma|]_v=1$ se e solo se $psi->sigma in Gamma^*$. Infine, siccome $Gamma subset.eq Gamma^*$, deve valere che $[| psi |]_v = 1$ per ogni formula $psi in Gamma$.
]

#corollario[
  $Gamma tack.not phi$ se e solo se esiste una valutazione $v$ tale che $[| psi |]_v = 1$ per ogni $psi in Gamma$ e $[| phi |]_v = 0$.
]

#dimostrazione[
  Se $Gamma tack.not phi$, allora $Gamma union {not phi}$ è consistente altrimenti, per il lemma precedente, varrebbe $Gamma tack phi$. Dunque, esiste una valutazione $v$ tale che $[| psi |]_v = 1$ per ogni $psi in Gamma union {not phi}$, ossia $[| psi |]_v = 1$ per ogni $psi in Gamma$ e $[| phi |]_v = 0$. La direzione opposta segue dal Teorema di Correttezza siccome, assumendo che $Gamma tack phi$, deve valere che, per ogni valutazione $v$ tale che per ogni formula $psi in Gamma$ vale che $[|psi|]_v=1$, vale $[|phi|]_v=1$.
]

#teorema(title: [Teorema di Completezza])[
  Se $Gamma tack.rr phi$, allora $Gamma tack phi$.
]

#dimostrazione[
  Per contrapposizione, se $Gamma tack.not phi$, allora per il corollario precedente esiste una valutazione che rende vere tutte le formule di $Gamma$ e falsifica $phi$, per cui $Gamma tack.rr.not phi$.
]

Combinando i Teoremi di Correttezza e Completezza, otteniamo che, nella logica proposizionale classica, le nozioni di derivabilità e di conseguenza semantica coincidono, per cui
$
  Gamma tack.rr phi quad <==> quad Gamma tack phi
$
