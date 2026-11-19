#import "../template.typ": *

= Il $lambda$-Calcolo

Nel capitolo precedente abbiamo osservato che, secondo l'interpretazione #pb[Bhk], una dimostrazione di un'implicazione $alpha -> beta$ è una _costruzione_, ossia una funzione che trasforma ogni prova di $alpha$ in una prova di $beta$, e abbiamo annotato le derivazioni in deduzione naturale con oggetti come $a |-> a(⟨1, q⟩)$, che altro non sono che piccoli programmi. Per rendere precisa questa idea, e arrivare così alla corrispondenza di Curry-Howard, abbiamo bisogno di un linguaggio formale in cui le funzioni siano oggetti di prima classe, che possano essere scritti, applicati ad argomenti, passati come argomenti ad altre funzioni e, soprattutto, _calcolati_. Questo linguaggio è il _$lambda$-calcolo_, introdotto da Alonzo Church negli anni '30. In questo capitolo studiamo il $lambda$-calcolo _non tipato_, ossia la sua versione più semplice, in cui i termini non sono corredati da alcun tipo: ne ripercorriamo le motivazioni storiche e ne diamo una definizione formale, con le regole di calcolo che lo caratterizzano. Nei capitoli successivi introdurremo i tipi, ottenendo il $lambda$-calcolo semplicemente tipato, che è il protagonista della corrispondenza di Curry-Howard.

#nota[Il $lambda$-calcolo _puro_, ossia non tipato, non è oggetto d'esame. Questo capitolo ha lo scopo di introdurre i concetti e la notazione che saranno indispensabili per il $lambda$-calcolo tipato e per la normalizzazione delle dimostrazioni.]

== Introduzione Storica e Contestuale

=== Visione Estensionale e Intensionale delle Funzioni

Che cos'è una funzione? Nella matematica moderna, la nozione prevalente è quella di _funzione come grafo_: ogni funzione $f$ ha un dominio $X$ e un codominio $Y$ fissati, e una funzione $f : X -> Y$ è un insieme di coppie $f subset.eq X times Y$ tale che, per ogni $x in X$, esiste esattamente un $y in Y$ per cui $(x, y) in f$. In questa visione, due funzioni $f, g : X -> Y$ sono considerate uguali se producono lo stesso output su ogni input, ossia se $f(x) = g(x)$ per ogni $x in X$. Questa è detta la visione _estensionale_ delle funzioni, poiché l'unica cosa osservabile di una funzione è il modo in cui essa associa gli output agli input: non ha alcuna importanza _come_ l'output venga calcolato.

Prima del XX secolo, tuttavia, le funzioni venivano raramente considerate in questo modo. Una nozione più antica è quella di _funzione come regola_: dare una funzione significa dare una regola che descrive come calcolarla. Spesso, una tale regola è data da una formula, come le familiari $f(x) = x^2$ oppure $g(x) = sin(e^x)$ dell'analisi. Come nel caso precedente, due funzioni sono estensionalmente uguali se hanno lo stesso comportamento input-output, ma ora possiamo parlare anche di un'altra nozione di uguaglianza: due funzioni sono _intensionalmente_ uguali se sono date (essenzialmente) dalla stessa formula. Ad esempio, le funzioni $f(x) = (x + 1)^2$ e $g(x) = x^2 + 2x + 1$ sono estensionalmente uguali, ma non intensionalmente, poiché descrivono due procedimenti di calcolo diversi. La differenza è tutt'altro che filosofica: in informatica, due programmi che calcolano la stessa funzione possono differire enormemente per il tempo di esecuzione o per la memoria utilizzata, e queste sono proprietà intensionali.

Quando pensiamo alle funzioni come date da formule, non è sempre necessario conoscerne il dominio e il codominio. Si consideri, ad esempio, la funzione $f(x) = x$, ossia la funzione identità. Possiamo vederla come una funzione $f : X -> X$ per _qualunque_ insieme $X$: la regola "restituisci l'argomento" ha senso indipendentemente dalla natura dell'argomento. Nella maggior parte della matematica, il paradigma delle funzioni come grafi è il modo più elegante e appropriato di trattare le funzioni. In informatica, invece, il paradigma delle funzioni come regole è spesso più adatto, poiché un programma è, per sua natura, una regola di calcolo.

Il $lambda$-calcolo è una _teoria delle funzioni come formule_, ossia un sistema per manipolare le funzioni come _espressioni_. In matematica scriviamo, ad esempio, "sia $f$ la funzione $x |-> x^2$, e si consideri $A = f(5)$": per poter applicare la funzione, dobbiamo prima darle un nome. Nel $lambda$-calcolo, invece, scriviamo direttamente
$
  A = (lambda x. x^2)(5)
$
dove l'espressione $lambda x. x^2$ denota la funzione che associa ad $x$ il valore $x^2$, senza bisogno di darle un nome. Il vantaggio di questa notazione è che permette di parlare facilmente di _funzioni di ordine superiore_, ossia funzioni i cui input o output sono a loro volta funzioni. Inoltre, essendo il $lambda$-calcolo non tipato, è perfettamente lecito applicare una funzione a sé stessa. Ad esempio, considerato il $lambda$-termine $f = lambda x. x$, ossia la funzione identità, è lecito scrivere $f(f) = (lambda x. x)(f)$, che restituisce $f$. Si noti che l'equazione $f(f) = f$ non ha senso nella matematica ordinaria, poiché, per ragioni insiemistiche, una funzione non può appartenere al proprio dominio. Nel $lambda$-calcolo, in cui le funzioni sono regole e non insiemi di coppie, questa restrizione non esiste.

=== Il $lambda$-Calcolo e la Computabilità

Negli anni '30, diversi matematici si interessarono alla seguente domanda: che cosa significa, per una funzione $f : NN -> NN$, essere _calcolabile_? Intuitivamente, una funzione è calcolabile se esiste un procedimento meccanico, una "ricetta" con un numero finito di passi, che dato $n$ permette di calcolare $f(n)$. Per rispondere rigorosamente, era però necessario formalizzare la nozione di procedimento meccanico, e furono proposte tre formalizzazioni indipendenti:
+ *Turing* definì un calcolatore ideale, che oggi chiamiamo _macchina di Turing_, e postulò che una funzione sia calcolabile, in senso intuitivo, se e solo se può essere calcolata da una tale macchina
+ *Gödel* e *Kleene* definirono la classe delle _funzioni ricorsive generali_, come il più piccolo insieme di funzioni che contiene le funzioni costanti e la funzione successore e che è chiuso rispetto ad alcune operazioni, come la composizione e la ricorsione, e postularono che una funzione sia calcolabile se e solo se è ricorsiva generale
+ *Church*, insieme ai suoi studenti *Kleene* e *Rosser*, e parallelamente a *Curry*, definì un linguaggio di programmazione ideale, il _$lambda$-calcolo_, e postulò che una funzione sia calcolabile se e solo se può essere scritta come un $lambda$-termine
Fu dimostrato da Church, Kleene, Rosser e Turing che i tre modelli di calcolo sono equivalenti, ossia ciascuno è in grado di definire esattamente le stesse funzioni calcolabili. L'affermazione che questi modelli catturino esattamente la nozione intuitiva di calcolabilità è nota come _tesi di Church-Turing_: si tratta di una tesi, e non di un teorema, poiché la nozione intuitiva di calcolabilità non è un oggetto matematico.

Si noti che, nelle intenzioni originarie di Church, il $lambda$-calcolo non era nato come modello di calcolo, ma come sistema per _formalizzare l'intera matematica_ a partire da un insieme ridotto di principi elementari, riformulandola in termini riduzionisti, in cui ogni concetto matematico fosse espresso mediante funzioni. Questo programma, tuttavia, fallì: il sistema logico originale di Church si rivelò inconsistente. Church, con l'aiuto di Kleene e Rosser, riuscì a salvare la situazione separando il sistema in due parti: un $lambda$-calcolo non tipato, dedicato alla computazione, e un $lambda$-calcolo tipato, dedicato alla logica. Ritroveremo questa stessa separazione nel corso dei prossimi capitoli.

=== Collegamenti con l'Informatica e con la Logica

Il $lambda$-calcolo è un linguaggio di programmazione estremamente idealizzato: è, probabilmente, il più semplice linguaggio di programmazione Turing-completo. Proprio grazie alla sua semplicità, è uno strumento utile per definire e dimostrare proprietà dei programmi. Molti linguaggi di programmazione reali possono essere visti come estensioni del $lambda$-calcolo: in particolare, questo vale per tutti i _linguaggi di programmazione funzionali_, una classe che include Lisp, Scheme, Haskell e ML.

Il collegamento con la logica, che è quello che ci interessa maggiormente, passa invece per la nozione di dimostrazione. Nel XIX secolo e all'inizio del XX, vi fu una disputa filosofica tra i matematici su che cosa fosse una dimostrazione. I cosiddetti _costruttivisti_, come Brouwer e Heyting, ritenevano che, per dimostrare l'esistenza di un oggetto matematico, fosse necessario essere in grado di costruirlo esplicitamente. I _matematici classici_, come Hilbert, ritenevano invece sufficiente derivare una contraddizione dall'ipotesi che l'oggetto non esista. Ironicamente, uno degli esempi più noti di dimostrazione non costruttiva è proprio la dimostrazione, dovuta a Brouwer, del suo _teorema del punto fisso_, il quale afferma che ogni funzione continua sul disco unitario ammette un punto fisso: la dimostrazione procede per assurdo, e non fornisce alcuna informazione su dove si trovi il punto fisso.

Il legame tra il $lambda$-calcolo e le logiche costruttive avviene attraverso il paradigma delle _dimostrazioni come programmi_ (_proofs as programs_). Per un costruttivista, una dimostrazione, ad esempio di un enunciato esistenziale, deve essere una "costruzione", ossia un programma. Il $lambda$-calcolo è una notazione per tali programmi, e può quindi essere usato anche come notazione per le dimostrazioni costruttive. Questa è esattamente l'idea che abbiamo incontrato con l'interpretazione #pb[Bhk], e che diventerà rigorosa con la corrispondenza di Curry-Howard.

== Il $lambda$-Calcolo non Tipato

Passiamo ora alla definizione formale. Come ogni linguaggio formale, il $lambda$-calcolo è definito da una _sintassi_, che stabilisce quali espressioni sono termini ben formati, e da un insieme di regole per manipolare i termini, che ne descrivono il _calcolo_.

=== I $lambda$-Termini

#definizione(title: [$lambda$-termini])[
  Sia $#pb[Var]$ un insieme infinito numerabile di variabili, indicate con $x, y, z, dots$ L'insieme $Lambda$ dei _$lambda$-termini_ è definito dalla seguente grammatica:
  $
    M, N ::= x | M N | lambda x. M
  $
  dove $x in #pb[Var]$. I termini delle tre forme sono detti, rispettivamente, _variabili_, _applicazioni_ e _$lambda$-astrazioni_.
]

La notazione con cui è scritta la definizione, detta _Backus-Naur Form_ (#pb[Bnf]), è un'abbreviazione per la consueta definizione induttiva: $Lambda$ è il più piccolo insieme tale che ogni variabile appartiene a $Lambda$, se $M, N in Lambda$ allora $(M N) in Lambda$, e se $x in #pb[Var]$ e $M in Lambda$ allora $(lambda x. M) in Lambda$. Come per le formule della logica, quindi, possiamo definire funzioni sui termini per ricorsione e dimostrarne le proprietà per induzione strutturale. Il significato intuitivo dei termini è il seguente:
- l'_applicazione_ $M N$ rappresenta l'applicazione della funzione $M$ all'argomento $N$. Si noti che si scrive $M N$ invece del tradizionale $M(N)$ della matematica, il che permette di risparmiare parentesi; quando migliora la leggibilità, scriveremo comunque anche $M(N)$
- la _$lambda$-astrazione_ $lambda x. M$ rappresenta la funzione che, dato un argomento $x$, restituisce $M$. Il termine $M$, detto _corpo_ dell'astrazione, può essere un termine arbitrariamente grande, in cui $x$ compare come parametro. Ad esempio, il termine $lambda x. x$ codifica la funzione identità

Si noti che in un $lambda$-termine non compaiono numeri, operazioni aritmetiche o costanti di alcun tipo: _tutto_ è una funzione. Vedremo che, nonostante questo, il $lambda$-calcolo è in grado di codificare i booleani, i numeri naturali e tutte le funzioni calcolabili. Per evitare un numero eccessivo di parentesi, adottiamo le seguenti convenzioni:
- le parentesi più esterne vengono omesse
- l'applicazione associa a sinistra: $M N P$ indica $(M N) P$, e quindi $f x y z$ indica $((f x) y) z$
- il corpo di un'astrazione si estende il più possibile verso destra: $lambda x. M N$ indica $lambda x. (M N)$, e non $(lambda x. M) N$
- astrazioni multiple possono essere contratte: $lambda x y z. M$ abbrevia $lambda x. lambda y. lambda z. M$

=== Variabili Libere e $alpha$-Equivalenza

Come nella logica dei predicati, in cui i quantificatori legano le variabili, nel $lambda$-calcolo è il simbolo $lambda$ a _legare_ le variabili. Un'occorrenza di una variabile $x$ all'interno di un termine della forma $lambda x. N$ si dice _legata_; il corrispondente $lambda x$ è detto _binder_, e il sottotermine $N$ è il suo _campo d'azione_ (_scope_). Un'occorrenza di variabile che non è legata si dice _libera_. Ad esempio, nel termine $(lambda x. x y)(lambda y. y z)$, la variabile $x$ è legata, la variabile $z$ è libera, mentre $y$ ha sia un'occorrenza libera che un'occorrenza legata.

#definizione(title: [Variabili libere])[
  L'insieme $#pb[Fv] (M)$ delle _variabili libere_ di un termine $M$ è definito per ricorsione:
  $
    #pb[Fv] (x) = {x}, quad quad #pb[Fv] (M N) = #pb[Fv] (M) union #pb[Fv] (N), quad quad #pb[Fv] (lambda x. M) = #pb[Fv] (M) - {x}
  $
  Un termine $M$ si dice _chiuso_ se $#pb[Fv] (M) = emptyset$.
]

Intuitivamente, i termini $lambda x. x$ e $lambda y. y$ sono la stessa funzione: differiscono soltanto per il nome della variabile legata, che è del tutto irrilevante, esattamente come $integral_0^1 x^2 thin d x$ e $integral_0^1 y^2 thin d y$ denotano lo stesso numero. Per formalizzare questa idea, indichiamo con $M{y slash x}$ il termine ottenuto da $M$ _rinominando_ ogni occorrenza di $x$ (libera, legata o binder) con $y$, dove $y$ è una variabile che non compare in $M$.

#definizione(title: [$alpha$-equivalenza])[
  L'_$alpha$-equivalenza_ $scripts(=)_alpha$ è la più piccola congruenza sui $lambda$-termini tale che, per ogni termine $M$ e ogni variabile $y$ che non compare in $M$,
  $
    lambda x. M scripts(=)_alpha lambda y. (M{y slash x})
  $
  Equivalentemente, $scripts(=)_alpha$ è la più piccola relazione che soddisfa le seguenti regole.
  #alberi(
    rule(name: [(refl)], $M = M$),
    rule(name: [(symm)], $N = M$, $M = N$),
    rule(name: [(trans)], $M = P$, $M = N$, $N = P$),
  )
  #alberi(
    rule(name: [(cong)], $M N = M' N'$, $M = M'$, $N = N'$),
    rule(name: [($xi$)], $lambda x. M = lambda x. M'$, $M = M'$),
    rule(name: [($alpha$)], $lambda x. M = lambda y. (M{y slash x})$, $y in.not M$),
  )
]

Le prime tre regole affermano che $scripts(=)_alpha$ è una relazione di equivalenza; le regole (cong) e ($xi$) affermano che è una _congruenza_, ossia che è compatibile con la struttura dei termini, per cui termini equivalenti possono essere sostituiti l'uno all'altro all'interno di termini più grandi; infine, la regola ($alpha$) è quella che effettivamente permette di rinominare le variabili legate. Si dimostra facilmente, per induzione, che ogni $lambda$-termine è $alpha$-equivalente ad un termine in cui tutte le variabili legate hanno nomi distinti tra loro e distinti dalle variabili libere. D'ora in avanti, quindi, considereremo i $lambda$-termini _a meno di $alpha$-equivalenza_, e assumeremo sempre, senza perdita di generalità, che le variabili legate siano state rinominate in modo opportuno.

=== La Sostituzione

L'operazione fondamentale del $lambda$-calcolo è la _sostituzione_ di un termine $N$ al posto delle occorrenze libere di una variabile $x$ in un termine $M$, che indichiamo con $M[N slash x]$. Intuitivamente, è l'operazione che si esegue quando si applica una funzione ad un argomento: per calcolare $(lambda x. x^2)(5)$, si sostituisce $5$ al posto di $x$ nel corpo $x^2$. Come nella logica dei predicati, la definizione presenta due insidie: bisogna sostituire soltanto le occorrenze _libere_ di $x$, e bisogna evitare che le variabili libere di $N$ vengano _catturate_ da un $lambda$ di $M$.

#definizione(title: [Sostituzione])[
  La _sostituzione_ di $N$ al posto delle occorrenze libere di $x$ in $M$, indicata con $M[N slash x]$, è definita come segue:
  $
    x[N slash x] & = N \
    y[N slash x] & = y, quad "se" x != y \
    (M_1 M_2)[N slash x] & = M_1 [N slash x] thin M_2 [N slash x] \
    (lambda x. M)[N slash x] & = lambda x. M \
    (lambda y. M)[N slash x] & = lambda y. (M[N slash x]), quad "se" x != y "e" y in.not #pb[Fv] (N) \
    (lambda y. M)[N slash x] & = lambda y'. (M{y' slash y}[N slash x]), quad "se" x != y, thin y in #pb[Fv] (N) "e" y' "nuova"
  $
]

Commentiamo le ultime tre clausole. Se l'astrazione lega proprio la variabile $x$, allora in $lambda x. M$ non ci sono occorrenze libere di $x$, e la sostituzione non ha effetto. Se l'astrazione lega un'altra variabile $y$, si procede all'interno del corpo, a patto che $y$ non compaia libera in $N$. Se, invece, $y in #pb[Fv] (N)$, procedere direttamente farebbe sì che la $y$ libera di $N$ venga catturata dal $lambda y$. Si consideri, ad esempio, $M = lambda x. y x$ e $N = lambda z. x z$, e si voglia calcolare $M[N slash y]$. Procedendo ingenuamente si otterrebbe $lambda x. (lambda z. x z) x$, in cui la $x$, che era libera in $N$, è diventata legata, cambiando il significato del termine. La soluzione è rinominare prima la variabile legata con una variabile _nuova_ $x'$, ossia non ancora utilizzata, ottenendo $M[N slash y] = lambda x'. (lambda z. x z) x'$. L'esistenza di una variabile nuova è garantita dal fatto che l'insieme delle variabili è infinito. Si noti che, assumendo la convenzione di rinominare sempre le variabili legate in modo che siano distinte dalle variabili libere, l'ultima clausola non è mai necessaria, e la definizione si riduce alle prime cinque clausole.

=== La $beta$-Riduzione

Possiamo ora definire il _calcolo_ vero e proprio, ossia la $beta$-riduzione, che rappresenta un singolo passo di computazione. L'idea è semplice: applicare una funzione $lambda x. M$ ad un argomento $N$ significa sostituire $N$ al posto del parametro $x$ nel corpo $M$.

#definizione(title: [$beta$-riduzione])[
  Un termine della forma $(lambda x. M) N$ è detto _redex_ (_reducible expression_), e il termine $M[N slash x]$ è detto il suo _ridotto_ (_reduct_). La _$beta$-riduzione in un passo_ $scripts(->)_beta$ è la più piccola relazione sui termini che soddisfa le seguenti regole.
  #albero(rule(name: [($beta$)], $(lambda x. M) N scripts(->)_beta M[N slash x]$))
  #alberi(
    rule(name: [($xi$)], $lambda x. M scripts(->)_beta lambda x. M'$, $M scripts(->)_beta M'$),
    rule(name: [($"cong"_1$)], $M N scripts(->)_beta M' N$, $M scripts(->)_beta M'$),
    rule(name: [($"cong"_2$)], $M N scripts(->)_beta M N'$, $N scripts(->)_beta N'$),
  )
]

La regola ($beta$) è il cuore del calcolo: un redex viene trasformato nel suo ridotto, ossia nel termine "valutato". Si tratta di una trasformazione _conservativa_, nel senso che il redex e il ridotto rappresentano lo stesso valore, esattamente come $(lambda x. x^2)(5)$ e $5^2$. Le altre tre regole sono necessarie per descrivere un passo di computazione di un $lambda$-termine _generico_, in cui il redex da ridurre può trovarsi in profondità all'interno del termine:
- la regola ($xi$) permette di ridurre all'interno del corpo di un'astrazione, ossia di calcolare "dentro" una funzione prima ancora di averla applicata ad un argomento. Essa esprime una forma di _estensionalità debole_: se due corpi sono legati da un passo di calcolo, lo sono anche le funzioni corrispondenti. Molti linguaggi di programmazione reali non adottano questa regola e non valutano mai il corpo di una funzione prima della sua applicazione: si parla, in questo caso, di valutazione _lazy_
- la regola ($"cong"_1$) permette di ridurre la funzione $M$ in un'applicazione $M N$, lasciando l'argomento $N$ invariato. Privilegiare questa regola, passando l'argomento alla funzione senza valutarlo, corrisponde alla strategia _call-by-name_
- la regola ($"cong"_2$) permette di ridurre l'argomento $N$ in un'applicazione $M N$. Privilegiare questa regola, valutando l'argomento prima di passarlo alla funzione, corrisponde alla strategia _call-by-value_

In altre parole, $M scripts(->)_beta M'$ se e solo se $M'$ si ottiene da $M$ riducendo un singolo redex di $M$, ovunque esso si trovi. Si osservi che il $lambda$-calcolo non impone un ordine con cui i redex devono essere ridotti: un termine può contenere più redex, e ridurne uno piuttosto che un altro può portare a termini diversi. Le diverse _strategie di valutazione_ dei linguaggi di programmazione corrispondono proprio a scelte diverse di quale redex ridurre.

#definizione[
  - Si scrive $M scripts(->>)_beta M'$ se $M$ si riduce ad $M'$ in zero o più passi, ossia $scripts(->>)_beta$ è la chiusura riflessiva e transitiva di $scripts(->)_beta$.
  - Si scrive $M scripts(=)_beta M'$, e si dice che $M$ e $M'$ sono _$beta$-equivalenti_, se $M$ può essere trasformato in $M'$ mediante zero o più passi di riduzione e passi di riduzione inversi, ossia $scripts(=)_beta$ è la chiusura riflessiva, simmetrica e transitiva di $scripts(->)_beta$.
  - Un termine si dice in _forma normale_ se non contiene alcun redex. Se $M scripts(->>)_beta M'$ e $M'$ è in forma normale, si dice che $M$ _valuta_ ad $M'$.
]

#esempio[
  Consideriamo il termine $(lambda x. y)((lambda z. z z)(lambda w. w))$, che contiene due redex: il termine stesso e il sottotermine $(lambda z. z z)(lambda w. w)$. Riducendo prima il redex interno, otteniamo
  $
    (lambda x. y)((lambda z. z z)(lambda w. w)) scripts(->)_beta (lambda x. y)((lambda w. w)(lambda w. w)) scripts(->)_beta (lambda x. y)(lambda w. w) scripts(->)_beta y
  $
  mentre riducendo direttamente il redex esterno otteniamo, in un solo passo, $(lambda x. y)((lambda z. z z)(lambda w. w)) scripts(->)_beta y$, poiché $x$ non compare nel corpo $y$ e l'argomento viene semplicemente scartato. L'esempio mostra che ridurre un redex può creare o cancellare altri redex, e che il numero di passi necessari per raggiungere la forma normale dipende dall'ordine di riduzione. Il risultato finale, invece, non sembra dipendere da tale ordine: questo è vero in generale, ed è il contenuto del _teorema di Church-Rosser_.
]

Non tutti i termini, però, ammettono una forma normale. Consideriamo il termine $omega = lambda x. x x$, ossia la funzione che applica il proprio argomento a sé stesso, e il termine
$
  Omega = omega omega = (lambda x. x x)(lambda x. x x)
$
Il termine $Omega$ è un redex, e riducendolo otteniamo, sostituendo $lambda x. x x$ al posto di $x$ nel corpo $x x$,
$
  Omega = (lambda x. x x)(lambda x. x x) scripts(->)_beta (lambda x. x x)(lambda x. x x) = Omega scripts(->)_beta Omega scripts(->)_beta dots
$
ossia $Omega$ si riduce in un passo a sé stesso, e la riduzione non termina mai. Il termine $Omega$ è il prototipo di una computazione _divergente_, ossia di un programma che non termina. Si noti che un termine come $Omega$ può esistere soltanto perché il $lambda$-calcolo non è tipato, e permette quindi di applicare una funzione a sé stessa.

=== Programmare nel $lambda$-Calcolo

Uno dei fatti più sorprendenti del $lambda$-calcolo non tipato è che, pur contenendo soltanto funzioni, permette di codificare dati, come i booleani e i numeri naturali, e i programmi che operano su di essi, senza aggiungere alcuna sintassi o assioma. Vediamo alcuni esempi.

_Booleani._ I valori di verità sono codificati come funzioni di due argomenti, che "scelgono" uno dei due:
$
  "true" := lambda x. lambda y. x = lambda x y. x #h(4em) "false" := lambda x. lambda y. y = lambda x y. y
$
I termini $"true"$ e $"false"$ sono spesso indicati, rispettivamente, con $K$ e $overline(K)$. Si verifica immediatamente che, per ogni coppia di termini $M_1, M_2$,
$
  K M_1 M_2 scripts(->)_beta (lambda y. M_1) M_2 scripts(->)_beta M_1 #h(4em) overline(K) M_1 M_2 scripts(->)_beta (lambda y. y) M_2 scripts(->)_beta M_2
$
ossia $"true"$ seleziona il primo argomento e $"false"$ il secondo, in due passi di $beta$-riduzione. Questa codifica rende il costrutto _if-then-else_ immediato: se $B in {"true", "false"}$, allora
$
  B P Q scripts(->>)_beta cases(P & "se" B = "true", Q & "se" B = "false")
$
per cui il termine $lambda x. lambda y. lambda z. x y z$, applicato a $B$, $P$ e $Q$, si comporta esattamente come "if $B$ then $P$ else $Q$". In modo analogo si possono codificare i connettivi booleani: ad esempio, il termine $lambda a b. a b "false"$ codifica la congiunzione.

_Numeri Naturali._ Per codificare i numeri naturali, dati due termini $F$ e $M$ definiamo l'iterazione $F^n (M)$ per ricorsione su $n in NN$:
$
  F^0 (M) = M, #h(4em) F^(n + 1) (M) = F(F^n (M))
$
ossia $F^n (M) = F(F(dots F(M) dots))$, con $n$ applicazioni di $F$.

#definizione(title: [Numerali di Church])[
  Per ogni $n in NN$, il _numerale di Church_ $overline(n)$ è il termine
  $
    overline(n) := lambda f. lambda x. f^n (x)
  $
  dove $f^n = f compose dots compose f$, con $n$ occorrenze di $f$.
]

In altre parole, il numero $n$ è codificato come la funzione che, data una funzione $f$ e un punto di partenza $x$, applica $f$ ad $x$ esattamente $n$ volte: $overline(0) = lambda f x. x$, $overline(1) = lambda f x. f x$, $overline(2) = lambda f x. f(f x)$, e così via. Si noti che $overline(0)$ coincide con $"false"$: interpretando un termine, bisogna sapere in anticipo se va letto come booleano o come numerale. Su questa codifica, le operazioni aritmetiche diventano semplici termini. Ad esempio, l'addizione è codificata da
$
  overline(+) := lambda x. lambda y. lambda p. lambda q. x p (y p q)
$
e si verifica che $overline(+) thin overline(n) thin overline(m) scripts(->>)_beta overline(n + m)$. Intuitivamente, $y p q$ applica $p$ a $q$ esattamente $m$ volte, e $x p (dots)$ applica $p$ al risultato altre $n$ volte, per un totale di $n + m$ applicazioni. Più in generale, si dice che un termine $M$ _rappresenta_ una funzione $f : NN^k -> NN$ se, per ogni $n_1, dots, n_k in NN$, vale $M overline(n_1) dots overline(n_k) scripts(->>)_beta overline(f(n_1, dots, n_k))$.

_Punti Fissi e Ricorsione._ Rimane da capire come codificare le funzioni definite per ricorsione, come il fattoriale. A questo scopo si usano i _combinatori di punto fisso_. Il più noto è il _combinatore $Y$_, dovuto a Curry:
$
  Y := lambda f. (lambda x. f(x x))(lambda x. f(x x))
$
che, per ogni termine $F$, soddisfa
$
  Y F scripts(=)_beta F(Y F)
$
ossia $Y F$ è un _punto fisso_ di $F$. Infatti, $Y F scripts(->)_beta (lambda x. F(x x))(lambda x. F(x x)) scripts(->)_beta F((lambda x. F(x x))(lambda x. F(x x)))$, e il termine tra parentesi è proprio ciò a cui si riduce $Y F$. Si osservi la somiglianza con $Omega$: il combinatore $Y$ sfrutta la stessa auto-applicazione $x x$, ma inserisce $F$ ad ogni passo. Grazie ai punti fissi, una definizione ricorsiva della forma $g = F g$, in cui $g$ compare sia a sinistra che a destra, può essere risolta ponendo $g = Y F$. Combinando booleani, numerali e punti fissi, si dimostra che il $lambda$-calcolo non tipato è _Turing-completo_, ossia in grado di rappresentare tutte le funzioni calcolabili.

Si noti, però, che la Turing-completezza ha un prezzo: un linguaggio in cui si possono scrivere tutte le funzioni calcolabili permette inevitabilmente di scrivere anche programmi che non terminano, come $Omega$. Introducendo un _sistema di tipi_, si impongono dei vincoli sui termini ammessi, ad esempio richiedendo che una funzione sia applicata soltanto ad argomenti del tipo corretto, il che vieta l'auto-applicazione $x x$ e, con essa, termini come $Omega$ e $Y$. Questo restringe la potenza espressiva del $lambda$-calcolo: il sistema di tipi corrispondente alla logica minimale, che studieremo nel prossimo capitolo, garantisce che ogni calcolo termini, ma proprio per questo non garantisce la Turing-completezza. Per recuperarla, pur mantenendo i tipi, si possono aggiungere esplicitamente operatori di punto fisso al linguaggio, come avviene nel linguaggio #pb[Pcf] (_Programming Computable Functions_) di Plotkin e Scott.
