#import "../template.typ": *

= Il $lambda$-Calcolo

Nel capitolo precedente, è stato osservato che, secondo l'interpretazione #pb[Bhk], una prova semantica di un'implicazione $alpha -> beta$ può essere intesa come una _costruzione_, ovvero una funzione che trasforma ogni prova di $alpha$ in una prova di $beta$, e abbiamo annotato le derivazioni in deduzione naturale con oggetti del tipo $h : a |-> a(⟨1, q⟩)$, i quali non sono altro che funzioni calcolabili e, quindi, piccoli programmi. Per formalizzare l'idea alla base della semantica #pb[Bhk], ovvero l'associazione di una funzione _calcolabile_, e quindi di un programma, ad ogni regola di derivazione, e poter fornire un fondamento formale alla _corrispondenza di Curry-Howard_, si necessita di un linguaggio formale in cui le prove e le funzioni siano oggetti matematici direttamente formalizzati dal linguaggio, e che, dunque, possano essere scritti, applicati ad argomenti, passati come argomenti ad altre funzioni e, soprattutto, _calcolati_. Per ragioni di similarità sintattica e formale, la praticità e l'ampio fondamento teorico già sviluppato, possiamo individuare il linguaggio formale di cui si necessita, per la formalizzazione delle funzioni e delle prove descritte dalla semantica #pb[Bhk], nel _$lambda$-calcolo_ introdotto da Alonzo Church negli anni \'30. Nelle prime sezioni del seguente capitolo, introdurremo la variante nota con il nome di $lambda$-calcolo _non tipato_, che è anche la sua versione più semplice, in cui i termini non sono corredati da alcun tipo formale. In particolare, ne ripercorreremo le motivazioni storiche, e ne daremo una definizione formale, con le regole di calcolo che lo caratterizzano. Successivamente, invece, introdurremo i tipi formali mediante i quali è possibile corredare i termini del $lambda$-calcolo, ottenendo il $lambda$-calcolo _semplicemente tipato_, che è lo strumento necessario per fornire un fondamento teorico formale alla _corrispondenza di Curry-Howard_ tra programmi calcolabili e derivazioni in deduzione naturale per la logica intuizionistica del primo ordine.

== _Un'Introduzione Storica alla Computazione delle Funzioni e al $lambda$-Calcolo_

Nella matematica moderna, la definizione prevalente di funzione è quella di _funzione come grafo_, nella quale ogni funzione $f$ possiede un dominio $X$ e un codominio $Y$ fissati, e una funzione $f : X -> Y$ è un insieme di coppie $f subset.eq X times Y$ tale che, per ogni $x in X$, esiste esattamente un $y in Y$ per cui $(x, y) in f$. In quest'ottica, due funzioni $f, g : X -> Y$ sono considerate uguali se producono lo stesso _output_ su ogni _input_, ossia se $f(x) = g(x)$ per ogni $x in X$. Questa è detta la visione _estensionale_ delle funzioni, poiché l'unica informazione osservabile di una funzione è il modo in cui essa associa gli _output_ agli _input_. In particolare, non ha alcuna importanza _come_ l'_output_ venga calcolato. Prima del XX secolo, tuttavia, le funzioni venivano raramente considerate in questo modo. Una nozione più antica è quella di _funzione come regola_, secondo la quale definire una funzione significa fornire una regola che descrive come calcolarla. Spesso, una tale regola è data da una formula, come le familiari $f(x) = x^2$ oppure $g(x) = sin(e^x)$ dell'analisi matematica. Come nel caso precedente, due funzioni sono estensionalmente uguali se hanno lo stesso comportamento _input_-_output_, ma ora possiamo parlare anche di un'altra nozione di uguaglianza, secondo la quale due funzioni sono _intensionalmente_ uguali se sono date, essenzialmente, dalla stessa formula. Ad esempio, le funzioni $f(x) = (x + 1)^2$ e $g(x) = x^2 + 2x + 1$ sono estensionalmente uguali, ma non intensionalmente, poiché descrivono due procedimenti di calcolo diversi. La differenza tra le due definizioni, però, è tutt'altro che filosofica. In informatica, ad esempio, due programmi che calcolano la stessa funzione possono differire enormemente per il tempo di esecuzione o per la memoria utilizzata, e queste sono proprietà intensionali dei programmi o, equivalentemente, delle funzioni che essi calcolano. Nella maggior parte della matematica, il paradigma delle funzioni come grafi è il modo più elegante e appropriato di trattare le funzioni. In informatica, invece, il paradigma delle funzioni come regole è spesso più adatto, poiché un programma è, per sua natura, una regola di calcolo.

In questo contesto, il $lambda$-calcolo è, invece, una _teoria delle funzioni come formule_, ovvero un sistema per manipolare le funzioni come _espressioni_. In matematica scriviamo, ad esempio, "sia $f$ la funzione $x |-> x^2$, e si consideri $A = f(5)$". Per poter applicare la funzione, quindi, dobbiamo prima assegnarle un nome. Nel $lambda$-calcolo, invece, possiamo scrivere direttamente
$
  A = (lambda x. x^2)(5)
$
dove l'espressione $lambda x. x^2$ denota la funzione che associa ad $x$ il valore $x^2$, senza bisogno di assegnarle un nome. Il vantaggio di questa notazione è che permette di parlare facilmente di _funzioni di ordine superiore_, ossia funzioni i cui _input_ o _output_ sono a loro volta funzioni. Inoltre, essendo il $lambda$-calcolo non tipato, è perfettamente lecito applicare una funzione a sé stessa. Ad esempio, considerato il $lambda$-termine $f = lambda x. x$, ossia la funzione identità, è lecito scrivere $f(f) = (lambda x. x)(f)$, che restituisce $f$. Si noti che l'equazione $f(f) = f$ non ha senso nella matematica ordinaria, poiché, per ragioni insiemistiche, una funzione non può appartenere al proprio dominio. Nel $lambda$-calcolo, invece, in cui le funzioni sono espressioni e non insiemi di coppie, questa restrizione non esiste.

Negli anni \'30, diversi matematici si interessarono alla seguente domanda, ovvero, che cosa significa, per una funzione $f : NN -> NN$, essere _calcolabile_? Intuitivamente, una funzione è calcolabile se esiste un procedimento meccanico, una _regola_ definita da un numero finito di passi, che dato un valore $n$ in _input_, permette di calcolare il valore $f(n)$ in _output_. Per rispondere rigorosamente, era però necessario formalizzare la nozione di procedimento meccanico, e furono proposte tre formalizzazioni indipendenti:
+ _Turing_ definì un calcolatore ideale, noto con il nome di _Macchina di Turing_, e postulò che una funzione sia calcolabile, in senso intuitivo, se e solo se può essere calcolata da una tale macchina
+ _Gödel_ e _Kleene_ definirono la classe delle _funzioni ricorsive generali_, come il più piccolo insieme di funzioni che contiene le funzioni costanti e la funzione successore e che è chiuso rispetto a specifiche operazioni, come la composizione e la ricorsione, e postularono che una funzione sia calcolabile se e solo se è ricorsiva generale
+ _Church_, insieme ai suoi studenti _Kleene_ e _Rosser_, e parallelamente a _Curry_, definì un linguaggio di programmazione ideale, il _$lambda$-calcolo_, e postulò che una funzione sia calcolabile se e solo se può essere scritta come un $lambda$-termine
Fu dimostrato da Church, Kleene, Rosser e Turing che i tre modelli di calcolo sono equivalenti, ossia ciascuno è in grado di definire esattamente le stesse funzioni calcolabili. L'affermazione che questi modelli catturino esattamente la nozione intuitiva di calcolabilità è nota come _Tesi di Church-Turing_. Si osserva, però, che si tratta di una tesi, e non di un teorema, poiché la nozione intuitiva di calcolabilità non è un oggetto matematico.

Si noti che, nelle intenzioni originarie di Church, il $lambda$-calcolo non era nato come modello di calcolo, ma come sistema per _formalizzare l'intera matematica_ a partire da un insieme ridotto di principi elementari, riformulandola in termini riduzionisti, in cui ogni concetto matematico fosse espresso mediante funzioni. Questo programma, tuttavia, fallì, siccome il sistema logico originale di Church si rivelò inconsistente. Per ovviare a questo problema, Church, insieme a Kleene e Rosser, suddivisero il sistema di Church in due componenti distinte: un $lambda$-calcolo non tipato, destinato alla descrizione della computazione, e un $lambda$-calcolo tipato, destinato alla formalizzazione della logica. Tale distinzione costituisce il filo conduttore dei capitoli successivi, poiché in queste sezioni introduttive verrà introdotto il $lambda$-calcolo non tipato, mentre la sua versione tipata sarà alla base della _corrispondenza di Curry-Howard_.

Infine, il $lambda$-calcolo è un linguaggio di programmazione estremamente idealizzato siccome è, probabilmente, il più semplice linguaggio di programmazione Turing-completo. Proprio grazie alla sua semplicità, è uno strumento utile per definire e dimostrare proprietà dei programmi. Infatti, molti linguaggi di programmazione reali possono essere visti come estensioni del $lambda$-calcolo e, in particolare, questo vale per tutti i _linguaggi di programmazione funzionali_, una classe che include Lisp, Scheme, Haskell e ML. Il collegamento del $lambda$-calcolo con la logica, che è quello che ci interessa maggiormente, passa invece per la nozione di dimostrazione. Nel XIX secolo e all'inizio del XX, vi fu una disputa filosofica tra matematici su che cosa fosse una dimostrazione. I cosiddetti _costruttivisti_, come Brouwer e Heyting, ritenevano che, per dimostrare l'esistenza di un oggetto matematico, fosse necessario essere in grado di costruirlo esplicitamente. I _matematici classici_, come Hilbert, ritenevano invece sufficiente derivare una contraddizione dall'ipotesi che l'oggetto non esista. Il legame tra il $lambda$-calcolo e le logiche costruttive avviene attraverso il paradigma delle _dimostrazioni come programmi_ (_proofs as programs_). Per un _costruttivista_, una dimostrazione, ad esempio di un enunciato esistenziale, deve essere una _costruzione_, ossia un programma. Il $lambda$-calcolo è, dunque, una notazione per tali programmi, e può quindi essere usato anche come notazione per le dimostrazioni costruttive. Questa è esattamente l'idea che abbiamo incontrato con l'interpretazione #pb[Bhk], e che sarà formalizzata mediante la _corrispondenza di Curry-Howard_.

== _Il $lambda$-Calcolo non Tipato_

Come ogni linguaggio formale, il $lambda$-calcolo è definito da una _sintassi_, che stabilisce quali espressioni sono termini ben formati nel linguaggio, e da un insieme di regole per manipolare i termini, che ne descrivono il _calcolo_.

#definizione(title: [$lambda$-termini])[
  Sia $#pb[Var]$ un insieme infinito numerabile di variabili, indicate con $x, y, z, dots$. L'insieme $Lambda$ dei _$lambda$-termini_ è definito dalla seguente grammatica:
  $
    M, N ::= x | M N | lambda x. M
  $
  dove $x in #pb[Var]$. I termini delle tre forme sono detti, rispettivamente, _variabili_, _applicazioni_ e _$lambda$-astrazioni_.
]

Il significato intuitivo dei termini è il seguente:
- l'_applicazione_ $M N$ rappresenta l'applicazione della funzione $M$ all'argomento $N$. Si noti che si scrive $M N$ invece del tradizionale $M(N)$ della matematica, il che permette di risparmiare parentesi e alleggerire la notazione
- la _$lambda$-astrazione_ $lambda x. M$ rappresenta la funzione che, dato un argomento $x$, restituisce $M$. Il termine $M$, detto _corpo_ dell'astrazione, può essere un termine arbitrariamente grande, in cui $x$ compare come parametro. Ad esempio, il termine $lambda x. x$ codifica la funzione identità

Si noti che in un $lambda$-termine non compaiono numeri, operazioni aritmetiche o costanti di alcun tipo, siccome nel $lambda$-calcolo _tutto_ è una funzione. Vedremo che, nonostante questo, il $lambda$-calcolo è in grado di codificare i valori booleani, i numeri naturali e tutte le funzioni calcolabili. Per evitare un numero eccessivo di parentesi, adottiamo le seguenti convenzioni:
- le parentesi più esterne vengono omesse
- l'applicazione associa a sinistra, ovvero $M N P$ indica $(M N) P$, e quindi $f x y z$ indica $((f x) y) z$
- il corpo di un'astrazione si estende il più possibile verso destra, ovvero $lambda x. M N$ indica $lambda x. (M N)$, e non $(lambda x. M) N$
- astrazioni multiple possono essere contratte, ovvero $lambda x y z. M$ abbrevia $lambda x. lambda y. lambda z. M$

Come nella logica dei predicati, in cui i quantificatori legano le variabili, nel $lambda$-calcolo è il simbolo $lambda$ a _legare_ le variabili. Un'occorrenza di una variabile $x$ all'interno di un termine della forma $lambda x. N$ si dice _legata_, il corrispondente $lambda x$ è detto _binder_, e il sottotermine $N$ è il suo _campo d'azione_, o _scope_. Un'occorrenza di variabile che non è legata si dice _libera_. Ad esempio, nel termine $(lambda x. x y)(lambda y. y z)$, la variabile $x$ è legata, la variabile $z$ è libera, mentre $y$ ha sia un'occorrenza libera che un'occorrenza legata.

#definizione(title: [Variabili libere])[
  L'insieme $#pb[Fv];(M)$ delle _variabili libere_ di un termine $M$ è definito per ricorsione:
  $
    #pb[Fv];(x) = {x}, quad quad #pb[Fv];(M N) = #pb[Fv];(M) union #pb[Fv];(N), quad quad #pb[Fv];(lambda x. M) = #pb[Fv];(M) without {x}
  $
  Un termine $M$ si dice _chiuso_ se $#pb[Fv];(M) = emptyset$.
]

Intuitivamente, i termini $lambda x. x$ e $lambda y. y$ sono la stessa funzione, in quanto differiscono soltanto per il nome della variabile legata, che è del tutto irrilevante, esattamente come $integral_0^1 x^2 thin d x$ e $integral_0^1 y^2 thin d y$ denotano lo stesso numero. Per formalizzare questa idea, indichiamo con $M{y slash x}$ il termine ottenuto da $M$ _rinominando_ ogni occorrenza di $x$ libera, legata o binder con $y$, dove $y$ è una variabile che non compare in $M$.

#definizione(title: [$alpha$-equivalenza])[
  L'_$alpha$-equivalenza_ $scripts(=)_alpha$ è la più piccola congruenza sui $lambda$-termini tale che, per ogni termine $M$ e ogni variabile $y$ che non compare in $M$, vale che
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

Le prime tre regole affermano che $scripts(=)_alpha$ è una relazione di equivalenza, mentre le regole (cong) e ($xi$) affermano che è una _congruenza_, ossia che è compatibile con la struttura dei termini, per cui termini equivalenti possono essere sostituiti l'uno all'altro all'interno di termini più grandi. Infine, la regola ($alpha$) è quella che effettivamente permette di rinominare le variabili legate. Si dimostra facilmente, per induzione, che ogni $lambda$-termine è $alpha$-equivalente ad un termine in cui tutte le variabili legate hanno nomi distinti tra loro e distinti dalle variabili libere. D'ora in avanti, quindi, considereremo i $lambda$-termini _a meno di $alpha$-equivalenza_, e assumeremo sempre, senza perdita di generalità, che le variabili legate siano state rinominate in modo opportuno.

L'operazione fondamentale del $lambda$-calcolo è la _sostituzione_ di un termine $N$ al posto delle occorrenze libere di una variabile $x$ in un termine $M$, che indichiamo con $M[N slash x]$. Intuitivamente, è l'operazione che si esegue quando si applica una funzione ad un argomento, in quanto, per calcolare $(lambda x. x^2)(5)$, si sostituisce $5$ al posto di $x$ nel corpo $x^2$. Come nella logica dei predicati, la definizione presenta due ostacoli, siccome è necessario sostituire soltanto le occorrenze _libere_ di $x$, ed è richiesto che le variabili libere di $N$ non vengano _catturate_ da un termine $lambda$ di $M$.

#definizione(title: [Sostituzione])[
  La _sostituzione_ di $N$ al posto delle occorrenze libere di $x$ in $M$, indicata con $M[N slash x]$, è definita come segue:
  $
    x[N slash x] & = N \
    y[N slash x] & = y, quad "se" x != y \
    (M_1 M_2)[N slash x] & = M_1 [N slash x] thin M_2 [N slash x] \
    (lambda x. M)[N slash x] & = lambda x. M \
    (lambda y. M)[N slash x] & = lambda y. (M[N slash x]), quad "se" x != y "e" y in.not #pb[Fv];(N) \
    (lambda y. M)[N slash x] & = lambda y'. (M{y' slash y}[N slash x]), quad "se" x != y, thin y in #pb[Fv];(N) "e" y' "nuova"
  $
]

L'esistenza di una variabile nuova è garantita dal fatto che l'insieme delle variabili è infinito e numerabile. Tuttavia, si noti che, assumendo la convenzione di rinominare sempre le variabili legate in modo che siano distinte dalle variabili libere, l'ultima clausola non è mai necessaria, e la definizione si riduce alle prime cinque clausole.

Possiamo ora definire il _calcolo_ vero e proprio, ossia la $beta$-riduzione, che rappresenta un singolo passo di computazione. L'idea è che applicare una funzione $lambda x. M$ ad un argomento $N$ significa sostituire $N$ al posto del parametro $x$ nel corpo $M$.

#definizione(title: [$beta$-riduzione])[
  Un termine della forma $(lambda x. M) N$ è detto _redex_, ovvero _reducible expression_, e il termine $M[N slash x]$ è detto il suo _ridotto_, ovvero _reduct_. La _$beta$-riduzione in un passo_ $scripts(->)_beta$ è la più piccola relazione sui termini che soddisfa le seguenti regole.
  #albero(rule(name: [($beta$)], $(lambda x. M) N scripts(->)_beta M[N slash x]$))
  #alberi(
    rule(name: [($xi$)], $lambda x. M scripts(->)_beta lambda x. M'$, $M scripts(->)_beta M'$),
    rule(name: [($"cong"_1$)], $M N scripts(->)_beta M' N$, $M scripts(->)_beta M'$),
    rule(name: [($"cong"_2$)], $M N scripts(->)_beta M N'$, $N scripts(->)_beta N'$),
  )
]

La regola ($beta$) è il cuore del calcolo, poiché definisce come un _redex_ viene trasformato nel suo ridotto, ossia nel termine _valutato_. Si tratta, inoltre, di una trasformazione _conservativa_, nel senso che il _redex_ e il ridotto rappresentano lo stesso valore, esattamente come $(lambda x. x^2)(5)$ e $5^2$. Le altre tre regole sono necessarie per descrivere un passo di computazione di un $lambda$-termine _generico_, in cui il _redex_ da ridurre può trovarsi in profondità all'interno del termine:
- la regola ($xi$) permette di ridurre all'interno del corpo di un'astrazione, ossia di calcolare _dentro_ una funzione prima ancora di averla applicata ad un argomento. Essa esprime una forma di _estensionalità debole_, per la quale, se due corpi sono legati da un passo di calcolo, lo sono anche le funzioni corrispondenti. Molti linguaggi di programmazione reali non adottano questa regola e non valutano mai il corpo di una funzione prima della sua applicazione. In tal caso, si parla di valutazione _lazy_
- la regola ($"cong"_1$) permette di ridurre la funzione $M$ in un'applicazione $M N$, lasciando l'argomento $N$ invariato. Privilegiare questa regola, passando l'argomento alla funzione senza valutarlo, corrisponde alla strategia _call-by-name_
- la regola ($"cong"_2$) permette di ridurre l'argomento $N$ in un'applicazione $M N$. Privilegiare questa regola, valutando l'argomento prima di passarlo alla funzione, corrisponde alla strategia _call-by-value_

In altre parole, $M scripts(->)_beta M'$ se e solo se $M'$ si ottiene da $M$ riducendo un singolo _redex_ di $M$, ovunque esso si trovi. Si osservi che il $lambda$-calcolo non impone un ordine con cui i _redex_ devono essere ridotti. Infatti, un termine può contenere più _redex_, e ridurne uno piuttosto che un altro può portare a termini diversi. Le diverse _strategie di valutazione_ dei linguaggi di programmazione corrispondono proprio a scelte diverse di quale _redex_ ridurre.

#definizione[Si forniscono le seguenti definizioni utili.
  - Si scrive $M scripts(->>)_beta M'$ se $M$ si riduce ad $M'$ in zero o più passi, ossia $scripts(->>)_beta$ è la chiusura riflessiva e transitiva di $scripts(->)_beta$.
  - Si scrive $M scripts(=)_beta M'$, e si dice che $M$ e $M'$ sono _$beta$-equivalenti_, se $M$ può essere trasformato in $M'$ mediante zero o più passi di riduzione e passi di riduzione inversi, ossia $scripts(=)_beta$ è la chiusura riflessiva, simmetrica e transitiva di $scripts(->)_beta$.
  - Un termine si dice in _forma normale_ se non contiene alcun _redex_. Se $M scripts(->>)_beta M'$ e $M'$ è in forma normale, si dice che $M$ _valuta_ ad $M'$.
]

#esempio(numbered: false)[
  Consideriamo il termine $(lambda x. y)((lambda z. z z)(lambda w. w))$, che contiene due _redex_, ovvero il termine stesso e il sottotermine $(lambda z. z z)(lambda w. w)$. Riducendo prima il _redex_ interno, otteniamo
  $
    (lambda x. y)((lambda z. z z)(lambda w. w)) scripts(->)_beta (lambda x. y)((lambda w. w)(lambda w. w)) scripts(->)_beta (lambda x. y)(lambda w. w) scripts(->)_beta y
  $
  mentre riducendo direttamente il _redex_ esterno otteniamo, in un solo passo, $(lambda x. y)((lambda z. z z)(lambda w. w)) scripts(->)_beta y$, poiché $x$ non compare nel corpo $y$ e l'argomento viene semplicemente scartato. L'esempio mostra che ridurre un _redex_ può creare o cancellare altri _redex_, e che il numero di passi necessari per raggiungere la forma normale dipende dall'ordine di riduzione. Il risultato finale, invece, non sembra dipendere da tale ordine. Questo è vero in generale, ed è garantito dal _Teorema di Church-Rosser_.
]

Non tutti i termini, però, ammettono una forma normale. Consideriamo il termine $omega = lambda x. x x$, ossia la funzione che applica il proprio argomento a sé stesso, e il termine
$
  Omega = omega omega = (lambda x. x x)(lambda x. x x)
$
Il termine $Omega$ ammette almeno un _redex_, e riducendolo otteniamo, sostituendo $lambda x. x x$ al posto di $x$ nel corpo $x x$, il seguente termine
$
  Omega = (lambda x. x x)(lambda x. x x) scripts(->)_beta (lambda x. x x)(lambda x. x x) = Omega scripts(->)_beta Omega scripts(->)_beta dots
$
ossia $Omega$ si riduce in un passo a sé stesso, e la riduzione non termina mai. Il termine $Omega$ è il prototipo di una computazione _divergente_, ossia di un programma che non termina. Si noti che un termine come $Omega$ può esistere soltanto perché il $lambda$-calcolo non è tipato, e permette, quindi, di applicare una funzione a sé stessa.

Uno dei risultati più sorprendenti del $lambda$-calcolo non tipato è che, pur contenendo soltanto funzioni, permette di codificare dati, come i booleani e i numeri naturali, e i programmi che operano su di essi, senza aggiungere alcuna sintassi o assioma.

_Valori Booleani._ I valori di verità sono codificati come funzioni di due argomenti, che _scelgono_ uno dei due:
$
  "true" := lambda x. lambda y. x = lambda x y. x #h(4em) "false" := lambda x. lambda y. y = lambda x y. y
$
I termini $"true"$ e $"false"$ sono spesso indicati, rispettivamente, con $K$ e $overline(K)$. Si verifica immediatamente che, per ogni coppia di termini $M_1, M_2$, vale che
$
  K M_1 M_2 scripts(->)_beta (lambda y. M_1) M_2 scripts(->)_beta M_1 #h(4em) overline(K) M_1 M_2 scripts(->)_beta (lambda y. y) M_2 scripts(->)_beta M_2
$
ossia $"true"$ seleziona il primo argomento e $"false"$ il secondo, in due passi di $beta$-riduzione. Questa codifica rende il costrutto _if-then-else_, anche denotato con $B P Q$, immediato, in quanto, se $B in {"true", "false"}$, allora
$
  B P Q scripts(->>)_beta cases(P & "se" B = "true", Q & "se" B = "false")
$
per cui il termine $lambda x. lambda y. lambda z. x y z$, applicato a $B$, $P$ e $Q$, si comporta esattamente come "if $B$ then $P$ else $Q$". In modo analogo, si possono codificare i connettivi booleani. Ad esempio, il termine $lambda a b. a b "false"$ codifica la congiunzione $a and b$.

_Numeri Naturali._ In letteratura esistono due approcci principali alla codifica dei numeri naturali nel $lambda$-calcolo: la codifica di Church e la codifica di Scott. Cominciamo dalla prima. Dati due termini $F$ e $M$, definiamo l'iterazione $F^n (M)$ per ricorsione su $n in NN$:
$
  F^0 (M) = M, #h(4em) F^(n + 1) (M) = F(F^n (M))
$
ossia $F^n (M) = F(F(dots F(M) dots))$, con $n$ applicazioni della funzione $F$.

#definizione(title: [Numerali di Church])[
  Per ogni $n in NN$, il _numerale di Church_ $overline(n)$ è il termine
  $
    overline(n) := lambda f. lambda x. f^n (x)
  $
  dove $f^n = f compose dots compose f$, con $n$ occorrenze della funzione $f$.
]

In altre parole, il numero $n$ è codificato come la funzione che, data una funzione $f$ e un punto di partenza $x$, applica $f$ ad $x$ esattamente $n$ volte: $overline(0) = lambda f x. x$, $overline(1) = lambda f x. f x$, $overline(2) = lambda f x. f(f x)$, e così via. Equivalentemente, i numerali di Church possono essere generati a partire dallo zero e dal successore:
$
  overline(0) := lambda s. lambda z. z #h(4em) overline(S) := lambda n. lambda s. lambda z. s(n s z)
$
Il successore $overline(S)$, dato un numerale $n$, restituisce il numerale che applica $s$ una volta in più rispetto ad $n$. Ad esempio, $overline(S)(overline(0)) scripts(->>)_beta lambda s. lambda z. s z = overline(1)$. Si osservi che il numerale $overline(n)$ è esattamente l'_iteratore_ $n$ volte di una funzione: per questo motivo, con i numerali di Church la _ricorsione primitiva_ è codificata completamente. Si noti, inoltre, che $overline(0)$ coincide con $"false"$, dunque, in un'interpretazione pratica di un termine, bisogna sapere in anticipo se esso va inteso come booleano o come numerale. Su questa codifica, le operazioni aritmetiche diventano semplici termini. Ad esempio, l'addizione è codificata da
$
  overline(+) := lambda x. lambda y. lambda p. lambda q. x p (y p q)
$
e si verifica che $overline(+) thin overline(n) thin overline(m) scripts(->>)_beta overline(n + m)$. Intuitivamente, $y p q$ applica $p$ a $q$ esattamente $m$ volte, e $x p (dots)$ applica $p$ al risultato altre $n$ volte, per un totale di $n + m$ applicazioni. Più in generale, si dice che un termine $M$ _rappresenta_ una funzione $f : NN^k -> NN$ se, per ogni $n_1, dots, n_k in NN$, vale $M overline(n_1) dots overline(n_k) scripts(->>)_beta overline(f(n_1, dots, n_k))$. Una possibile seconda codifica dei numeri naturali è la _codifica di Scott_, in cui la costante zero e il successore sono definiti come
$
  overline(0) := lambda s. lambda z. z #h(4em) overline(S) := lambda n. lambda s. lambda z. s n
$
per cui $overline(1) := overline(S)(overline(0))$, $overline(2) := overline(S)(overline(S)(overline(0)))$, e così via. A differenza dei numerali di Church, un numerale di Scott non itera la funzione $s$, ma la applica una sola volta al _predecessore_, ovvero $overline(S)(overline(n)) scripts(->>)_beta lambda s. lambda z. s thin overline(n)$. In altre parole, un numerale di Scott si comporta come un costrutto di _pattern matching_, per cui se il parametro $z$ è zero, restituisce $z$, altrimenti passa alla funzione $s$ il proprio predecessore. Per questo motivo, la ricorsione non è codificata direttamente nei numerali, ma deve essere ottenuta con un combinatore di punto fisso. Indichiamo con $"Fix"$ il combinatore $Y$ definito in precedenza:
$
  "Fix" := lambda f. (lambda x. f(x x))(lambda x. f(x x)), #h(3em) "Fix" thin g scripts(=)_beta g("Fix" thin g)
$
Un _operatore di ricorsione_ può allora essere definito come
$
  "Rec" := "Fix" (lambda r. lambda n. lambda f. lambda v. n (lambda m. f (r thin m thin f thin v) thin m) thin v)
$
e si verifica che soddisfa le equazioni della ricorsione primitiva:
$
  "Rec" thin overline(0) thin f thin v scripts(=)_beta v #h(4em) "Rec" thin overline(S)(overline(n)) thin f thin v scripts(=)_beta f("Rec" thin overline(n) thin f thin v) thin overline(n)
$
Infatti, grazie al punto fisso, $"Rec" thin overline(n) thin f thin v scripts(=)_beta overline(n) (lambda m. f("Rec" thin m thin f thin v) thin m) thin v$, per cui, se $n = 0$, il numerale seleziona $v$. Se, invece, $n$ è il successore di $n'$, il numerale applica la funzione al predecessore $overline(n')$, ottenendo $f("Rec" thin overline(n') thin f thin v) thin overline(n')$.

_Punti Fissi e Ricorsione._ Rimane da descrivere soltanto come codificare le funzioni definite per ricorsione, come il fattoriale, e, dunque, ogni funzione calcolabile per la _Tesi di Church-Turing_. A questo scopo, si usano i _combinatori di punto fisso_. Il più noto è il _combinatore $Y$_, dovuto a Curry:
$
  Y := lambda f. (lambda x. f(x x))(lambda x. f(x x))
$
che, per ogni termine $F$, soddisfa
$
  Y F scripts(=)_beta F(Y F)
$
ossia $Y F$ è un _punto fisso_ di $F$. Infatti, $Y F scripts(->)_beta (lambda x. F(x x))(lambda x. F(x x)) scripts(->)_beta F((lambda x. F(x x))(lambda x. F(x x)))=F(Y F)$. Si osservi la somiglianza con il combinatore $Omega$, in quanto il combinatore $Y$ sfrutta la stessa auto-applicazione $x x$, ma inserisce il calcolo della funzione $F$ ad ogni passo. Grazie ai punti fissi, una definizione ricorsiva della forma $g = F g$, in cui $g$ compare sia a sinistra che a destra, può essere risolta ponendo $g = Y F$. Combinando booleani, numerali e punti fissi, si può dimostrare che il $lambda$-calcolo non tipato è _Turing-completo_, ossia in grado di rappresentare tutte le funzioni calcolabili.

Si noti, però, che la Turing-Completezza ha un prezzo. Infatti un linguaggio in cui si possono scrivere tutte le funzioni calcolabili permette inevitabilmente di scrivere anche programmi che non terminano, come il combinatore $Omega$. Introducendo un _sistema di tipi_, si impongono dei vincoli sui termini ammessi, ad esempio richiedendo che una funzione sia applicata soltanto ad argomenti del tipo corretto, il che vieta l'auto-applicazione $x x$ e, con essa, termini come $Omega$ e $Y$. Questo restringe inevitabilmente la potenza espressiva del $lambda$-calcolo. Ad esempio, il sistema di tipi semplice corrispondente alla logica minimale, che introdurremo nella prossima sezione, garantisce che ogni calcolo termini, ma proprio per questo non può garantire la Turing-Completezza. Per recuperarla, pur mantenendo i tipi, si possono aggiungere esplicitamente operatori di punto fisso al linguaggio, come avviene nel linguaggio #pb[Pcf] (_Programming Computable Functions_) di Plotkin e Scott.

Concludiamo la presentazione del $lambda$-calcolo non tipato con le sue proprietà principali, che valgono, più in generale, per molti _sistemi di riscrittura_, ossia sistemi formali in cui il calcolo è implementato trasformando i termini del linguaggio mediante regole di sostituzione. Per prima cosa, si osservi che la $beta$-riduzione da sola non cattura l'_estensionalità_ delle funzioni, ossia il principio per cui due funzioni che si comportano allo stesso modo su ogni argomento sono semanticamente uguali. Ad esempio, i termini $lambda x. M x$ e $M$, dove $x in.not #pb[Fv];(M)$, si comportano allo stesso modo su ogni argomento $N$, poiché $(lambda x. M x) N scripts(->)_beta M N$, ma, per la precedente definizione della relazione $beta$, nessuno dei due si $beta$-riduce all'altro. Per codificare l'estensionalità, quindi, è necessario affiancare alla $beta$-riduzione alla relazione di _$eta$-riduzione_, ovvero:
#albero(rule(name: [($eta$)], $lambda x. M x scripts(->)_eta M$, $x in.not #pb[Fv] (M)$))
e considerare l'unione delle due relazioni, ossia $scripts(->)_(beta eta)$.

#teorema(title: [Teorema di Church-Rosser])[
  Sia $M$ un $lambda$-termine. Se $M scripts(->>)_beta N_1$ e $M scripts(->>)_beta N_2$, allora esiste un $lambda$-termine $N$ tale che $N_1 scripts(->>)_beta N$ e $N_2 scripts(->>)_beta N$. Il teorema vale anche sostituendo la relazione $scripts(->>)_beta$ con la relazione $scripts(->>)_(beta eta)$.

  #align(center, cetz.canvas(length: 1cm, {
    import cetz.draw: *
    set-style(stroke: line-thickness + black)
    // vertici del diamante
    content((0, 2), $M$)
    content((-2, 0), $N_1$)
    content((2, 0), $N_2$)
    content((0, -2), $N$)
    // freccia a doppia punta (->>): la seconda punta è arretrata di `d` lungo la freccia
    let freccia(a, b, d: 0.25, ..stile) = {
      let (x1, y1) = a
      let (x2, y2) = b
      let l = calc.sqrt(calc.pow(x2 - x1, 2) + calc.pow(y2 - y1, 2))
      let b2 = (x2 - d * (x2 - x1) / l, y2 - d * (y2 - y1) / l)
      let punta = (end: "straight", scale: 0.8,
        stroke: (thickness: line-thickness, paint: black, dash: "solid"))
      line(a, b, mark: punta, ..stile)
      line(a, b2, mark: punta, ..stile)
    }
    // frecce: continue le riduzioni date, tratteggiate quelle garantite dal teorema
    freccia((-0.35, 1.65), (-1.65, 0.35))
    freccia((0.35, 1.65), (1.65, 0.35))
    freccia((-1.65, -0.35), (-0.35, -1.65), stroke: (dash: "dashed"))
    freccia((1.65, -0.35), (0.35, -1.65), stroke: (dash: "dashed"))
  }))
]

Il teorema, che enunciamo senza dimostrazione, garantisce che la strategia con cui si riducono i _redex_ non è influente, in quanto due computazioni, che partono dallo stesso termine e prendono percorsi diversi, possono sempre essere ricongiunte. Questa proprietà è detta anche _confluenza_. Da essa ne conseguono alcune proprietà fondamentali:
- _Unicità della forma normale_: se un termine ammette una forma normale, allora essa è unica. Infatti, se $M$ si riducesse a due forme normali $N_1$ e $N_2$, per il teorema di Church-Rosser esse dovrebbero ridursi ad un termine comune, ma, non contenendo _redex_ per definizione, possono ridursi soltanto a sé stesse. Ne segue che le forme normali $N_1$ e $N_2$ sono necessariamente uguali
- _Equivalenza delle forme normali_: due forme normali sono $beta$-equivalenti se e solo se sono $alpha$-equivalenti. Dunque, ridurre due $lambda$-termini in forma normale è un modo per decidere l'uguaglianza tra termini che ammettono una forma normale, in quanto la proprietà di $alpha$-equivalenza tra termini in forma normale è una proprietà decidibile in funzione della sola sintassi
- _Esistenza di $lambda$-termini non $beta$-equivalenti_. Infatti, ad esempio, i termini $"true"$ e $"false"$ sono due forme normali distinte, per cui non sono $beta$-equivalenti. In altre parole, la $beta$-equivalenza non identifica tutti i termini, da cui deduciamo che il $lambda$-calcolo è _consistente_

La seconda proprietà fondamentale riguarda la terminazione di una computazione nel $lambda$-calcolo non tipato. Infatti, si dice che un termine è _debolmente normalizzabile_ se _esiste_ una sequenza di riduzioni in grado di ridurlo in forma normale, mentre è _fortemente normalizzabile_ se _ogni_ sequenza di riduzioni che parte da esso termina in una forma normale. Corrispondentemente, si distinguono due proprietà del calcolo:
- _Normalizzazione debole_: si verifica quando, nella variante considerata del $lambda$-calcolo, esiste una strategia di riduzione che restituisce la forma normale di un termine, se essa esiste. Nel $lambda$-calcolo non tipato, questa strategia è la riduzione _leftmost_ (o _normal order_) $scripts(->)_(beta eta)$, che riduce sempre il _redex_ più a sinistra
- _Normalizzazione forte_: si verifica quando, nella variante considerata del $lambda$-calcolo, tutte le strategie di riduzione restituiscono una forma normale per ogni termine, ovvero non esiste alcuna computazione divergente. Questa proprietà _non_ può valere per il $lambda$-calcolo non tipato, siccome, ad esempio, il termine $Omega$ non ammette alcuna forma normale

Come vedremo nella sezione seguente, l'introduzione dei tipi permetterà di recuperare la normalizzazione fortem nel $lambda$-calcolo semplicemente tipato, al prezzo di rinunciare alla Turing-Completezza del linguaggio di calcolo.

== Il $lambda$-Calcolo Semplicemente Tipato

Nel $lambda$-calcolo non tipato si trattano generiche funzioni, senza definire il loro dominio di applicazione, e il loro codominio. In un certo senso, possiamo concludere che il dominio e il codominio di ogni funzione sono l'insieme di tutti i $lambda$-termini del linguaggio. Il passo successivo, per giungere alla _corrispondenza di Curry-Howard_, è l'introduzione di un _sistema di tipi_ nel $lambda$-calcolo, ottenendo una nozione di dominio e codominio per le funzioni. Questo passaggio è fondamentale per poter dimostrare la _corrispondenza di Curry-Howard_ poiché, volendo dimostrare che ad una prova è associato un programma, dobbiamo essere in grado di assumere che ogni $lambda$-termine sia caratterizzato da un tipo, per cui è necessaria la _normalizzazione forte_. Si noti la differenza tra tipi e insiemi, in quanto i tipi sono oggetti _sintattici_, ovvero possiamo discutere dei tipi senza dover considerare i loro elementi semantici. Assumiamo di aver definito un insieme di _tipi di base_ arbitrario, che indichiamo con la lettera greca $iota$ (_iota_). Ad esempio, possiamo semplicemente definire $iota subset.eq {"Bool", "Nat"}$.

#definizione(title: [Tipi semplici])[
  L'insieme dei _tipi semplici_ è definito dalla seguente grammatica:
  $
    A, B ::= iota | A -> B | A times B | 1
  $
]

Il tipo $iota$ è un tipo nell'insieme dei _tipi di base_. Il tipo $A -> B$ è il tipo delle funzioni da $A$ a $B$, il tipo $A times B$ è il tipo delle coppie, il cui primo elemento ha tipo $A$ e il secondo ha tipo $B$, e infine $1$ è il tipo _unit_, ossia un tipo che contiene un unico elemento $*$. Si osservi che questa grammatica corrisponde, a tutti gli effetti, alla sintassi delle formule in _logica minimale_, dove l'implicazione $->$ è rappresentata da una funzione, e la congiunzione $and$ è rappresentata dal prodotto cartesiano $times$. Per convenzione, l'operatore $times$ ha priorità su $->$, e l'operatore $->$ associa a destra, per cui $A times B -> C$ indica $(A times B) -> C$, e $A -> B -> C$ indica $A -> (B -> C)$.

#definizione(title: [Termini tipati grezzi])[
  L'insieme dei _termini tipati grezzi_, anche detto _raw typed lambda terms_, è definito dalla seguente grammatica:
  $
    M, N ::= x | M N | lambda x^A. M | ⟨M, N⟩ | pi_1 M | pi_2 M | *
  $
]

I primi tre costrutti sono i termini del $lambda$-calcolo non tipato, e corrispondono al connettivo $->$ e all'operatore di funzione $->$. L'unica differenza è che, nell'astrazione $lambda x^A. M$, la variabile $x$ è annotata con il suo tipo $A$. Gli ultimi costrutti corrispondono, invece, al connettivo $and$, dove $⟨M, N⟩$ è la coppia formata da $M$ ed $N$, mentre $pi_i$ è la _proiezione_ di una coppia $⟨M_1, M_2⟩$ sulla sua $i$-esima componente $M_i$. Infine, $*$ è il _termine iniziale_ associato al tipo unit $1$, ossia il suo unico elemento. I termini si dicono _grezzi_ poiché la grammatica non garantisce che essi siano correttamente tipati. Ad esempio, $pi_1 (lambda x. M)$ è un termine grezzo valido per la grammatica fornita, ma proiettare una funzione non ha alcun senso e, dunque, il termine non è tipato correttamente. I termini corretti, anche detti _ben tipati_, saranno selezionati dalle regole di tipaggio. Il collegamento tra la logica minimale e il linguaggio di programmazione $lambda$-calcolo, in versione semplicemente tipata, che sta emergendo, può essere riassunto nella seguente tabella.

#align(center, table(columns: 2, stroke: none, align: left, inset: (x: 1.2em, y: 4pt),
  [*Logica*], [*Linguaggi*],
  table.hline(stroke: 0.4pt),
  [proposizioni], [tipi],
  [proposizione $P -> Q$], [tipo $P -> Q$],
  [proposizione $P and Q$], [tipo $P times Q$],
  [dimostrazione della proposizione $P$], [termine $t$ di tipo $P$],
  [la proposizione $P$ è dimostrabile], [il tipo $P$ è _abitato_ da un qualche termine],
))

L'ultima riga è particolarmente significativa, siccome un tipo $P$ è abitato da almeno un elemento se esiste un termine $t$ di tipo $P$, che corrisponde, in quest'ottica, ad un programma e, quindi, per la _corrispondenza di Curry-Howard_, ad una prova della proposizione $P$. Definiamo, dunque, le regole di tipaggio che permettono di determinare i $lambda$-termini tipati correttamente.

#definizione(title: [Giudizio di tipo])[
  Un _contesto_ è un insieme $Gamma = {x_1 : A_1, dots, x_n : A_n}$ di assunzioni sui tipi delle variabili, in cui ogni variabile compare al più una volta. Un _giudizio di tipo_, anche detto _typing judgement_, è un'espressione della forma
  $
    Gamma tack M : A
  $
  che significa che $M$ è un termine di tipo $A$ nel contesto $Gamma$.
]

Nella _corrispondenza di Curry-Howard_, il contesto $Gamma$ svolge il ruolo dell'insieme di ipotesi in deduzione naturale. I giudizi di tipo derivabili sono definiti dalle seguenti _regole di tipaggio_, insieme alle quali indichiamo anche la corrispondente regola di deduzione naturale.
#alberi(
  rule(name: [(var)], $Gamma, x : A tack x : A$),
  rule(name: [(abs)], $Gamma tack lambda x^A. M : A -> B$, $Gamma, x : A tack M : B$),
)
#alberi(
  rule(name: [(app)], $Gamma tack M N : B$, $Gamma tack M : A -> B$, $Gamma tack N : A$),
  rule(name: [(pair)], $Gamma tack ⟨M, N⟩ : A times B$, $Gamma tack M : A$, $Gamma tack N : B$),
)
#alberi(
  rule(name: [($pi_1$)], $Gamma tack pi_1 M : A$, $Gamma tack M : A times B$),
  rule(name: [($pi_2$)], $Gamma tack pi_2 M : B$, $Gamma tack M : A times B$),
  rule(name: [($*$)], $Gamma tack * : 1$),
)
La regola (var) afferma che una variabile ha esattamente il tipo che le assegna il contesto, e corrisponde all'utilizzo di un'ipotesi. La regola (app) corrisponde alla regola $-> E$, ossia al _modus ponens_. Infatti, se $M$ è una funzione da $A$ a $B$ ed $N$ ha tipo $A$, allora $M N$ ha tipo $B$. La regola (abs) corrisponde alla regola $-> I$. Infatti, se, assumendo che $x$ abbia tipo $A$, il termine $M$ ha tipo $B$, allora $lambda x^A. M$ è una funzione da $A$ a $B$. Si osservi che nella conclusione l'assunzione $x : A$ _esce dal contesto_, esattamente come nell regola $-> I$ l'ipotesi $A$ viene scaricata dall'insieme di ipotesi della derivazione. Infine, la regola (pair) corrisponde alla regola $and I$, le regole ($pi_1$) e ($pi_2$) corrispondono ad $and E_1$ e $and E_2$, mentre la regola ($*$) afferma che il tipo $1$ è sempre abitato dall'elemeto $*$.

Un'importante proprietà di queste regole è che esiste _esattamente una regola per ogni costrutto_ dei termini. Dunque, quando si costruisce una derivazione di tipo dal basso verso l'alto, ovvero con strategia _bottom-up_, la scelta della regola da applicare è sempre univoca, e l'unica scelta che deve essere presa concretamente riguarda i tipi da assegnare alle variabili. Per _assegnare un tipo_ ad un termine, si intende assegnare dei tipi alle sue variabili, libere e legate, in modo che il giudizio di tipo corrispondente sia derivabile mediante le regole di tipaggio. Un termine si dice _tipabile_, o _ben tipato_ nel linguaggio in considerazione, se gli si può assegnare un tipo.

#esempio[
  Mostriamo che $tack lambda x^(A -> A). lambda y^A. x(x y) : (A -> A) -> A -> A$. Per brevità, poniamo $Gamma = x : A -> A, y : A$.
  #albero(rule(name: [(abs)], $tack lambda x^(A -> A). lambda y^A. x(x y) : (A -> A) -> A -> A$,
    rule(name: [(abs)], $x : A -> A tack lambda y^A. x(x y) : A -> A$,
      rule(name: [(app)], $Gamma tack x(x y) : A$,
        rule(name: [(var)], $Gamma tack x : A -> A$),
        rule(name: [(app)], $Gamma tack x y : A$, rule(name: [(var)], $Gamma tack x : A -> A$), rule(name: [(var)], $Gamma tack y : A$))))))
  Le due applicazioni di (abs) fanno uscire dal contesto, nell'ordine, le assunzioni $y : A$ e $x : A -> A$, fino ad ottenere un giudizio con contesto vuoto. Si noti che, cancellando i termini e lasciando soltanto i tipi, si ottiene esattamente la derivazione in deduzione naturale di $(A -> A) -> A -> A$. A partire da questo punto, quindi, possiamo incominciare ad osservare la validità della _corrispondenza di Curry-Howard_.
]

#nota[
  Nel $lambda$-calcolo semplicemente tipato non è possibile codificare il costrutto _if-then-else_ con i booleani di Church, esattamente come nel caso del $lambda$-calcolo non tipato. Dunque, un tale costrutto deve essere aggiunto esplicitamente al linguaggio, con la regola di tipaggio associata.
  #albero(rule($Gamma tack "if" M "then" N "else" L : A$, $Gamma tack M : "Bool"$, $Gamma tack N : A$, $Gamma tack L : A$))
]

Consideriamo, inoltre, il termine $Omega = omega omega = (lambda x. x x)(lambda x. x x)$. Abbiamo anticipato che, nel $lambda$-calcolo semplicemente tipato, è garantita la normalizzazione forte. Di conseguenza, ogni $lambda$-termine ammette una $beta$-riduzione ad un termine in forma normale, per cui la computazione non può mai divergere. Ne concludiamo che il termine $Omega$ non possa essere _ben tipato_, poiché, altrimenti, esso ammetterebbe un tipo e potremmo costruire una derivazione terminante per esso. Infatti, nel termine $x x$ la variabile $x$ dovrebbe avere contemporaneamente un tipo funzionale $A -> B$, poiché è applicata ad un argomento, e il tipo $A$ del suo stesso argomento. In altre parole, $omega$ non può essere tipato sia come funzione che come valore. Dunque, sebbene $Omega$ sia un termine valido del $lambda$-calcolo non tipato, il $lambda$-calcolo semplicemente tipato non può esprimere né il termine $Omega$, né altri termini semanticamente equivalenti, con rispetto della relazione di equivalenza $beta$ o $beta eta$. La divergenza, tuttavia, può essere codificata mediante specifiche estensioni del $lambda$-calcolo tipato, ad esempio la variante #pb[Pcf], che aggiunge al linguaggio un operatore di punto fisso. Un altro esempio di estensione tipata è il _sistema $T$ di Gödel_, che aggiunge al $lambda$-calcolo semplicemente tipato i numeri naturali e un operatore di ricorsione primitiva, mantenendo la terminazione di tutti i calcoli.

Analogamente, ci si può chiedere se esista una dimostrazione decorata della _Legge di Peirce_, ossia un termine di tipo $((sigma -> tau) -> sigma) -> sigma$. Anche in questo caso, la risposta è _no_. Infatti, provando a costruire la derivazione dal basso verso l'alto, si arriva al seguente punto:
#albero(rule(name: [(abs)], $tack lambda x. (x(lambda y. M)) : ((sigma -> tau) -> sigma) -> sigma$,
  rule(name: [(app)], $x : (sigma -> tau) -> sigma tack x(lambda y. M) : sigma$,
    rule(name: [(var)], $x : (sigma -> tau) -> sigma tack x : (sigma -> tau) -> sigma$),
    rule(name: [(abs)], $x : (sigma -> tau) -> sigma tack lambda y. M : sigma -> tau$,
      rule(name: [?], $x : (sigma -> tau) -> sigma, y : sigma tack M : tau$, $arrow.zigzag$)))))
ma non esiste alcun termine $M$ di tipo $tau$ costruibile a partire da $x$ e $y$. Il tipo $((sigma -> tau) -> sigma) -> sigma$ è, quindi, _inabitato_. Questo è coerente con quanto visto nel capitolo precedente, siccome la _Legge di Peirce_ è un principio classico, non dimostrabile in logica minimale, e dunque non può essere esprimibile consistentemente nel $lambda$-calcolo semplicemente tipato.

#esercizio(numbered: false)[
  Si fornisca una derivazione di tipo per ciascuno dei seguenti giudizi di tipo:
  - $tack lambda x^((A -> A) -> B). x(lambda y^A. y) : ((A -> A) -> B) -> B$
  - $tack lambda x^(A times B). ⟨pi_2 x, pi_1 x⟩ : (A times B) -> (B times A)$
  Si stabilisca, inoltre, se è possibile assegnare un tipo ai termini $pi_1 (lambda x. M)$ e $⟨M, N⟩(P)$.
]

Le regole di riduzione del $lambda$-calcolo semplicemente tipato, inoltre, estendono le relazioni di $beta$-riduzione e $eta$-riduzione ai nuovi costrutti:
$
  (beta_->) & quad (lambda x^A. M) N & -> & quad M[N slash x] \
  (eta_->) & quad lambda x^A. M x & -> & quad M, quad "se" x in.not #pb[Fv];(M) \
  (beta_(times, 1)) & quad pi_1 ⟨M, N⟩ & -> & quad M \
  (beta_(times, 2)) & quad pi_2 ⟨M, N⟩ & -> & quad N \
  (eta_times) & quad ⟨pi_1 M, pi_2 M⟩ & -> & quad M \
  (eta_1) & quad M & -> & quad *, quad "se" M : 1
$
Le regole $beta$ descrivono la computazione, che consiste nell'applicare una funzione ad un argomento, oppure nel proiettare una coppia sulle sue componenti. Le regole $eta$ esprimono, invece, l'estensionalità, in quanto una funzione che si limita ad applicare $M$ al proprio argomento è $M$ stessa, una coppia formata dalle due proiezioni di $M$ è $M$ stessa, e ogni termine di tipo $1$ è uguale all'unico elemento $*$. Come nel caso non tipato, inoltre, si definiscono la chiusura riflessiva e transitiva $scripts(->)^*$, e l'equivalenza $=$, indotte da queste regole di riduzione.

#esempio(title: [Un linguaggio per i circuiti booleani], numbered: false)[
  Un linguaggio per la descrizione di circuiti booleani classici può essere ottenuto come istanza del $lambda$-calcolo semplicemente tipato. Infatti, scegliamo i tipi di base $iota ::= "Bool" | "Nat" | "bit"$, ed estendiamo i $lambda$-termini, definiti in precedenza, con le seguenti costanti
  $
    M, N ::= dots | overline(0) | overline(1) | "tt" | "ff" | "NOT" | "AND" | "OR" | "CNOT"
  $
  dove $overline(0), overline(1) : "bit"$, $"tt", "ff" : "Bool"$, $"NOT" : "bit" -> "bit"$, e $"AND", "OR" : "bit" times "bit" -> "bit"$, mentre $"CNOT" : "bit" times "bit" -> "bit" times "bit"$. Un circuito è semplicemente, quindi, un termine ben tipato costruito a partire dall'applicazione di queste porte logiche classiche a variabili del $lambda$-calcolo di tipo $"bit"$.
]
