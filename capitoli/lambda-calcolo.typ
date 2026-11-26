#import "../template.typ": *

= Verso la Corrispondenza di Curry-Howard

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
dove $overline(0), overline(1) : "bit"$, $"tt", "ff" : "Bool"$, $"NOT" : "bit" -> "bit"$, e $"AND", "OR" : "bit" times "bit" -> "bit"$, mentre $"CNOT" : "bit" times "bit" -> "bit" times "bit"$. Un circuito è semplicemente, quindi, un termine ben tipato costruito a partire dall'applicazione di queste porte logiche classiche a variabili del $lambda$-calcolo di tipo $"bit"$. Si noti che la porta $"CNOT"$ riceve sempre due bit in _input_ e restituisce due bit in _output_. Il primo, detto bit di _controllo_, rimane invariato, mentre il secondo viene negato se e solo se il bit di controllo vale $1$. Alle regole di tipaggio si aggiunge, quindi, un assioma per le costanti, che assegna ad ogni costante $c$ il suo tipo $A_c$:
#albero(rule(name: [(const)], $Gamma tack c : A_c$))
Ad esempio, possiamo derivare il giudizio di tipo $tack "NOT" overline(0) : "bit"$, che esprime il fatto che la negazione di un bit è ancora un bit.
#albero(rule(name: [(app)], $tack "NOT" overline(0) : "bit"$, rule(name: [(const)], $tack "NOT" : "bit" -> "bit"$), rule(name: [(const)], $tack overline(0) : "bit"$)))
Consideriamo, ad esempio, il seguente circuito con tre ingressi $x$, $y$ e $z$.

#align(center, cetz.canvas(length: 1cm, {
  import cetz.draw: *
  set-style(stroke: line-thickness + black)
  let porta(c, nome, l: 1.1, h: 0.7) = {
    let (x, y) = c
    rect((x - l / 2, y - h / 2), (x + l / 2, y + h / 2))
    content(c, text(size: 0.8em, nome))
  }
  // ingressi
  content((-0.3, 2), $x$)
  content((-0.3, 1), $y$)
  content((-0.3, 0), $z$)
  // NOT su x
  line((0, 2), (1, 2))
  porta((1.55, 2), "NOT")
  // AND
  line((2.1, 2), (3, 2))
  line((0, 1), (3, 1))
  porta((3.55, 1.5), "AND", h: 1.4)
  // CNOT
  line((4.1, 1.5), (5, 1.5))
  line((0, 0), (5, 0))
  porta((5.55, 0.75), "CNOT", h: 1.9)
  // OR
  line((6.1, 1.5), (7, 1.5))
  line((6.1, 0), (7, 0))
  porta((7.55, 0.75), "OR", h: 1.9)
  line((8.1, 0.75), (8.9, 0.75), mark: (end: "straight", scale: 0.6))
}))

Leggendo il circuito da sinistra verso destra, ossia seguendo il flusso dei bit dagli ingressi all'uscita, otteniamo il $lambda$-termine
$
  C := lambda x^"bit". lambda y^"bit". lambda z^"bit". "OR"("CNOT" ⟨"AND" ⟨"NOT" x, y⟩, z⟩)
$
in cui ogni porta logica è applicata alla coppia dei suoi ingressi, e le tre astrazioni esterne rappresentano i tre bit di ingresso del circuito. Si noti che le due uscite della porta $"CNOT"$, che formano una coppia di tipo $"bit" times "bit"$, sono esattamente l'ingresso atteso dalla porta $"OR"$. Deriviamo il tipo del termine $C$. Siccome il corpo di $C$ contiene le variabili libere $x$, $y$ e $z$, il suo tipo può essere derivato soltanto nel contesto $Gamma = x : "bit", y : "bit", z : "bit"$, che assegna un tipo agli ingressi del circuito. Per non appesantire la notazione, costruiamo la derivazione per parti, seguendo il circuito da sinistra verso destra. Sia $cal(D)_1$ la derivazione che tipa la coppia degli ingressi della porta $"AND"$:
#albero(rule(name: [(pair)], $Gamma tack ⟨"NOT" x, y⟩ : "bit" times "bit"$,
  rule(name: [(app)], $Gamma tack "NOT" x : "bit"$, rule(name: [(const)], $Gamma tack "NOT" : "bit" -> "bit"$), rule(name: [(var)], $Gamma tack x : "bit"$)),
  rule(name: [(var)], $Gamma tack y : "bit"$)))
A partire da $cal(D)_1$, la derivazione $cal(D)_2$ tipa l'uscita della porta $"AND"$:
#albero(rule(name: [(app)], $Gamma tack "AND" ⟨"NOT" x, y⟩ : "bit"$,
  rule(name: [(const)], $Gamma tack "AND" : "bit" times "bit" -> "bit"$),
  deriv($cal(D)_1$, $Gamma tack ⟨"NOT" x, y⟩ : "bit" times "bit"$)))
La derivazione $cal(D)_3$ tipa, poi, la coppia di uscite della porta $"CNOT"$:
#albero(dimensione: 9pt, rule(name: [(app)], $Gamma tack "CNOT" ⟨"AND" ⟨"NOT" x, y⟩, z⟩ : "bit" times "bit"$,
  rule(name: [(const)], $Gamma tack "CNOT" : "bit" times "bit" -> "bit" times "bit"$),
  rule(name: [(pair)], $Gamma tack ⟨"AND" ⟨"NOT" x, y⟩, z⟩ : "bit" times "bit"$,
    deriv($cal(D)_2$, $Gamma tack "AND" ⟨"NOT" x, y⟩ : "bit"$),
    rule(name: [(var)], $Gamma tack z : "bit"$))))
Infine, la derivazione $cal(D)_4$ tipa l'intero corpo del termine $C$, ossia l'uscita della porta $"OR"$:
#albero(dimensione: 9pt, rule(name: [(app)], $Gamma tack "OR"("CNOT" ⟨"AND" ⟨"NOT" x, y⟩, z⟩) : "bit"$,
  rule(name: [(const)], $Gamma tack "OR" : "bit" times "bit" -> "bit"$),
  deriv($cal(D)_3$, $Gamma tack "CNOT" ⟨"AND" ⟨"NOT" x, y⟩, z⟩ : "bit" times "bit"$)))
Infine, applicando tre volte la regola (abs), le assunzioni sugli ingressi escono dal contesto, nell'ordine inverso rispetto a quello in cui sono state introdotte, fino ad ottenere un giudizio con contesto vuoto:
#albero(rule(name: [(abs)], $tack C : "bit" -> "bit" -> "bit" -> "bit"$,
  rule(name: [(abs)], $x : "bit" tack lambda y^"bit". lambda z^"bit". dots : "bit" -> "bit" -> "bit"$,
    rule(name: [(abs)], $x : "bit", y : "bit" tack lambda z^"bit". dots : "bit" -> "bit"$,
      deriv($cal(D)_4$, $Gamma tack "OR"("CNOT" ⟨"AND" ⟨"NOT" x, y⟩, z⟩) : "bit"$)))))
Il termine $C$ è, quindi, un termine chiuso di tipo $"bit"^3->"bit"$, ossia una funzione che riceve i tre bit di ingresso, uno alla volta, e restituisce il bit di uscita. Si osservi che il giudizio sul corpo del circuito vale soltanto nel contesto $Gamma$, mentre il giudizio su $C$ vale nel contesto vuoto, poiché le astrazioni hanno legato tutte le variabili libere.
]

Giusti a questo punto, siamo, dunque, in grado di studiare le proprietà fondamentali del $lambda$-calcolo semplicemente tipato. Esse si dividono in due gruppi principali. Il primo gruppo di proprietà garantisce la _sicurezza_, o _safety_, del sistema di tipi, ovvero che i tipi assegnati ai programmi siano affidabili durante tutta la computazione. Il secondo gruppo riguarda, invece, la _terminazione_ della computazione, che, come vedremo, ha conseguenze molto profonde sia sulla potenza espressiva del linguaggio, sia sulla _corrispondenza di Curry-Howard_. Per semplicità, nel seguito consideriamo la sola $beta$-riduzione, al posto del sistema deduttivo di riduzione $beta eta$, che è necessariamente più corposo da gestire. Il primo risultato è un lemma tecnico, che descrive come si comporta il tipaggio rispetto alla sostituzione.

#lemma(title: [Lemma di sostituzione])[
  Se $Gamma, x : B tack P : A$ e $Gamma tack Q : B$, allora $Gamma tack P[Q slash x] : A$.
]

Il lemma afferma che, se il termine $P$ ha tipo $A$ assumendo che la variabile $x$ abbia tipo $B$, allora sostituendo $x$ con un qualunque termine $Q$ che ha _effettivamente_ tipo $B$ si ottiene ancora un termine di tipo $A$. In altre parole, una variabile di tipo $B$ può agire come un _segnaposto_ per un qualunque termine di tipo $B$, e il tipaggio non dipende da quale termine venga effettivamente sostituito, purché il tipo sia quello corretto. Il lemma può essere dimostrato per induzione sulla struttura di $P$, e sfrutta in modo cruciale il fatto che $x$ e $Q$ hanno lo stesso tipo. Si noti la stretta analogia con la deduzione naturale, in quanto, se $A$ è derivabile dall'ipotesi $B$, e $B$ è derivabile, allora _innestando_ la derivazione di $B$ al posto delle occorrenze dell'ipotesi $B$ si ottiene una derivazione di $A$ senza l'ipotesi $B$.

#teorema(title: [Subject reduction, o preservazione dei tipi])[
  Se $Gamma tack M : A$ e $M scripts(->)_beta M'$, allora $Gamma tack M' : A$.
]

La proprietà di _subject reduction_ afferma che la computazione _preserva i tipi_. Infatti, se un programma possiede tipo $A$, allora anche ogni programma ottenuto da esso mediante un passo di calcolo ha tipo $A$ e, per induzione sul numero di passi, lo stesso vale per ogni programma ottenuto mediante un numero arbitrario di passi di calcolo. Ad esempio, se un programma di tipo $"Nat"$ termina, il suo risultato è un numero naturale, e non, ad esempio, una funzione. Il teorema può essere dimostrato per induzione sulla derivazione di $M scripts(->)_beta M'$, distinguendo i casi in base all'ultima regola utilizzata nella derivazione di $Gamma tack M : A$. Il caso più interessante è quello in cui $M = (lambda x^B. P) Q$ ed $M' = P[Q slash x]$. Infatti, siccome $Gamma tack M : A$, l'ultima regola applicata deve essere (app), preceduta da (abs) sul termine $lambda x^B. P$, per cui deve valere che $Gamma, x : B tack P : A$ e $Gamma tack Q : B$. Per il lemma di sostituzione, segue che $Gamma tack P[Q slash x] : A$. Gli altri casi sono simili, e richiedono di considerare anche le regole di congruenza ($"cong"_1$), ($"cong"_2$) e ($xi$). In generale, si sfrutta la regola di tipaggio necessaria a tipare correttamente $M'$, a partire dal tipaggio richiesto per $M$.

#teorema(title: [Progress])[
  Se $tack M : A$, ossia se $M$ è un termine chiuso e ben tipato, allora $M$ è un _valore_, ossia un'astrazione, una coppia oppure il termine $*$, oppure esiste un termine $M'$ tale che $M scripts(->)_beta M'$.
]

La proprietà di _progress_ afferma che un programma ben tipato non può mai rimanere _bloccato_ in uno stato privo di significato. Infatti, o la computazione è terminata, e allora il risultato è un valore, oppure è possibile eseguire un ulteriore passo di calcolo. Ad esempio, il termine $pi_1 (lambda x. x)$, che tenta di proiettare una funzione come se fosse una coppia, è in forma normale ma non è un valore. Infatti, questo si tratta di un errore di esecuzione, come avverrebbe in un linguaggio di programmazione reale, per cui la proprietà di _progress_ garantisce che tali termini non siano tipabili. Combinando le due proprietà precedenti si ottiene la _sicurezza_, o _safety_, del sistema di tipi. Per la _subject reduction_, ogni passo di calcolo a partire da un termine ben tipato produce un termine ben tipato e, per la proprietà di _progress_, un termine ben tipato non è mai bloccato. Dunque, nessuna computazione che parte da un termine ben tipato può mai incontrare un errore di esecuzione.

#teorema(title: [Unicità dei tipi])[
  Se $Gamma tack M : A$ e $Gamma tack M : B$, allora $A = B$.
]

L'unicità dei tipi afferma che, fissato il contesto, ogni termine ben tipato ha un unico tipo. Si dimostra facilmente per induzione su $M$, sfruttando il fatto, osservato in precedenza, che esiste esattamente una regola di tipaggio per ogni costrutto dei termini. In ogni passo della derivazione, quindi, il tipo della conclusione è determinato univocamente dai tipi delle premesse.

Ricordiamo, inoltre, che un termine è _fortemente normalizzabile_ se _ogni_ sequenza di riduzioni che parte da esso è finita, ossia se ogni computazione che parte da esso termina, indipendentemente dall'ordine con cui vengono ridotti i _redex_. Abbiamo osservato che il $lambda$-calcolo non tipato non gode di questa proprietà, poiché il termine $Omega$ dà origine ad una computazione infinita. Il risultato principale di questa sezione è che, nel $lambda$-calcolo semplicemente tipato, questo non può accadere.

#teorema(title: [Normalizzazione forte, Nederpelt, 1973])[
  Se $Gamma tack M : A$, allora $M$ è fortemente normalizzabile.
]

In altre parole, ogni sequenza di riduzioni che parte da un termine ben tipato termina in una forma normale, ossia in un termine che non contiene alcun _redex_ e che, quindi, non può essere ulteriormente ridotto. In sintesi, tutte le computazioni di termini ben tipati nel $lambda$-calcolo semplicemente tipato terminano. Prima di dimostrare il teorema, discutiamone le conseguenze, che sono molto rilevanti.

_Equivalenza delle strategie._ Il teorema di Church-Rosser, che vale anche nel $lambda$-calcolo semplicemente tipato, garantisce che, se un termine ammette una forma normale, essa è unica, ma non garantisce che essa esista, in quanto la confluenza non implica la terminazione. Nel caso non tipato, infatti, una strategia di riduzione può divergere anche su un termine che ammette una forma normale. Ad esempio, il termine $(lambda x. y) Omega$ si riduce in un passo alla forma normale $y$, ma una strategia che riduce sempre il _redex_ $Omega$ non termina mai. La normalizzazione forte elimina questo problema poiché, combinata con il teorema di Church-Rosser, essa garantisce che _qualunque_ strategia di riduzione termina, e restituisce sempre la stessa forma normale. Nel $lambda$-calcolo semplicemente tipato, dunque, tutte le strategie di valutazione sono equivalenti, e la scelta di una strategia (ad esempio, _call-by-name_ oppure _call-by-value_) influisce soltanto sull'efficienza del calcolo, e non sul suo risultato. Ne segue, inoltre, che la $beta$-equivalenza tra termini ben tipati è decidibile, poiché per stabilire se $M scripts(=)_beta N$, è sufficiente ridurre entrambi i termini in forma normale, con una strategia qualunque, e confrontare le due forme normali a meno di $alpha$-equivalenza.

_Perdita della Turing-completezza._ La normalizzazione forte, tuttavia, ha un prezzo. Infatti, il $lambda$-calcolo semplicemente tipato _non è Turing-Completo_. Infatti, in un linguaggio Turing-Completo devono essere esprimibili anche le computazioni che non terminano, come quella di una _Macchina di Turing_ che esegue un ciclo infinito, mentre nel $lambda$-calcolo semplicemente tipato ogni computazione termina. In particolare, i combinatori di punto fisso, come il combinatore $Y$, non sono tipabili, per cui non è possibile esprimere la ricorsione generale. Il linguaggio del $lambda$-calcolo semplicemente tipato, quindi, può esprimere soltanto un sottoinsieme stretto delle funzioni _totali_, ovvero le funzioni che terminano su ogni _input_. Per recuperare la Turing-Completezza, è necessario aggiungere al linguaggio un operatore di punto fisso, come avviene nel $lambda$-calcolo #pb[Pcf], perdendo però la normalizzazione forte.

_Conseguenze per la corrispondenza di Curry-Howard._ Ricordiamo che, attraverso la _corrispondenza di Curry-Howard_, i termini ben tipati del $lambda$-calcolo semplicemente tipato corrispondono alle dimostrazioni in deduzione naturale per la logica minimale, e i tipi corrispondono alle formule. In questa corrispondenza, la $beta$-riduzione ha un significato logico preciso. Infatti, un _redex_ del tipo $(lambda x^A. M) N$ corrisponde ad una derivazione in cui la regola $-> I$ è immediatamente seguita dalla regola $-> E$, ovvero ad una _deviazione_ inutile nella dimostrazione, in cui si dimostra un'implicazione al solo scopo di utilizzarla subito dopo. Ridurre il _redex_, quindi, significa eliminare questa deviazione, innestando direttamente la derivazione dell'argomento al posto dell'ipotesi scaricata. La normalizzazione forte afferma, dunque, che ogni dimostrazione in logica minimale può essere trasformata in una dimostrazione in _forma normale_, priva di deviazioni, e che il processo di semplificazione termina sempre. Questo ha due conseguenze importanti:
- _consistenza della logica_: se esistesse una dimostrazione del falso, ovvero un termine chiuso di tipo $bot$, essa ammetterebbe anche una forma normale, ma si verifica facilmente, mediante la proprietà di _progress_, che un $lambda$-termine chiuso in forma normale è un valore, ovvero un'astrazione, una coppia oppure un valore $*$, nessuno dei quali ha tipo $bot$. Dunque, non esiste alcuna dimostrazione del falso, e la logica minimale è, necessariamente, consistente.
- _quali programmi sono dimostrazioni_: siccome ogni dimostrazione corrisponde ad un programma che termina, mediante le dimostrazioni in logica minimale è possibile rappresentare soltanto programmi che terminano, ossia funzioni _totali_. I programmi che possono non terminare, invece, come quelli che impiegano la ricorsione generale, non ammettono alcuna controparte logica. Si osservi, tuttavia, che non si tratta di un difetto della _corrispondenza di Curry-Howard_, ma di una necessità formale. Infatti, un combinatore di punto fisso dovrebbe avere tipo $(A -> A) -> A$ nel $lambda$-calcolo semplicemente tipato, per ogni possibile tipo $A$, che, applicato all'identità $lambda x^A. x : A -> A$, produrrebbe un $lambda$-termine di tipo $A$, ovvero una _dimostrazione_ di qualunque formula $A$, per la _corrispondenza di Curry-Howard_. Una logica in cui ogni formula è dimostrabile, però, è inconsistente, per cui i combinatori di punto fisso non ammettono una controparte logica diretta. In altre parole, dal punto di vista logico, la ricorsione generale corrisponderebbe logicamente ad un ragionamento circolare, che è necessariamente inconsistente per la logica minimale, in quanto permette di dimostrare qualunque formula.

In conclusione, la _corrispondenza di Curry-Howard_ associa le dimostrazioni ai programmi _totali_, e la normalizzazione forte è la proprietà che garantisce che il calcolo dei programmi corrisponda alla _semplificazione_ delle dimostrazioni. La dimostrazione per il teorema di normalizzazione forte che studieremo è _minimalista_, nel senso che sfrutta soltanto un'opportuna induzione, e per questo motivo è relativamente semplice. Esiste, invece, una tecnica dovuta a Tait e Girard, detta dei _candidati di riducibilità_, che è molto più potente, poiché si estende a sistemi di tipi molto più ricchi come il sistema $F$, ma è anche molto più complessa, e per questo non la vedremo. Per semplicità, dimostriamo il teorema di normalizzazione forte per il solo frammento del $lambda$-calcolo semplicemente tipato con il solo tipo funzionale $->$ e la sola relazione di $beta$-riduzione, siccome l'estensione ai tipi $times$ e $1$, e alla relazione di $beta eta$-riduzione segue analogamente. Fissiamo, innanzitutto, la notazione.

#definizione[
  - Indichiamo con $#pb[Sn]$ l'insieme dei termini _fortemente normalizzabili_, ossia dei termini $t$ tali per cui non esiste alcuna sequenza infinita di riduzioni $t scripts(->)_beta t_1 scripts(->)_beta t_2 scripts(->)_beta dots$
  - Per ogni $t in #pb[Sn]$, indichiamo con $h(t)$ l'_altezza_ di $t$, ossia la lunghezza della più lunga sequenza di riduzioni che parte da $t$
  - Indichiamo con $|t|$ la _taglia_ di un termine $t$, ossia il numero di simboli che lo compongono
  - Indichiamo con $|alpha|$ la _taglia_ di un tipo $alpha$, definita come $|iota| = 1$ e $|alpha -> beta| = |alpha| + |beta| + 1$
]

Si noti che l'altezza $h(t)$ è ben definita per ogni termine $t in #pb[Sn]$ poiché, siccome ogni termine contiene un numero finito di _redex_, da ogni termine si diramano un numero finito di riduzioni in un passo, e l'albero di tutte le possibili riduzioni che partono da $t$ è un albero a diramazione finita privo di rami infiniti, per cui è finito. Questa proprietà segue come conseguenza del _lemma di König_. L'altezza $h(t)$, dunque, coincide con l'altezza di questo albero. Si faccia attenzione a non confondere un termine fortemente normalizzabile con un termine che _ammette_ una forma normale, poiché la seconda è la definizione di termine debolmente normalizzabile, mentre per la normalizzazione forte è richiesto che _tutte_ le sequenze di riduzioni terminino.

_L'idea della dimostrazione._ Vorremmo dimostrare che $t in #pb[Sn]$, per ogni termine $t$ ben tipato, per induzione sulla struttura di $t$. I casi $t = x$ e $t = lambda x. v$ sono banali, poiché una variabile è in forma normale, e le riduzioni di $lambda x. v$ sono esattamente le riduzioni di $v$. L'unico caso non banale è quello dell'applicazione $t = u v$, siccome un'eventuale ipotesi induttiva garantisce che $u$ e $v$ siano fortemente normalizzabili, ma questo non basta, poiché applicando $u$ a $v$ si possono creare nuovi _redex_. Infatti, se $u$ si riduce ad un'astrazione $lambda x. u_1$, il termine $u v$ si riduce a $u_1 [v slash x]$, che non è un sottotermine di $t$, e può essere anche molto più grande di $t$, poiché $v$ viene copiato in tutte le occorrenze di $x$. Per gestire questo caso, abbiamo bisogno di un lemma di sostituzione per la normalizzazione, per il quale, se $u_1$ e $v$ sono fortemente normalizzabili, allora anche $u_1 [v slash x]$ è fortemente normalizzabile. La difficoltà, a sua volta, è che anche la sostituzione può creare nuovi _redex_. Infatti, se $u_1$ contiene un sottotermine $x w$ e $v$ è un'astrazione, allora $u_1 [v slash x]$ contiene il nuovo _redex_ $x[v slash x] (w[v slash x]) = v (w[v slash x])$. L'osservazione chiave, che rende possibile la dimostrazione, è che i _redex_ creati per sostituzione, in questo modo, coinvolgono tipi _sempre più piccoli_. Infatti, se $x$ ha tipo $alpha = alpha_1 -> alpha_2$, allora il suo argomento $w$ ha tipo $alpha_1$ e, se $v = lambda y. s$, la variabile legata $y$ ha tipo $alpha_1$. Il nuovo _redex_ $v(w[v slash x])$ ha, dunque, tipo $alpha_2$, e la sua contrazione, che restituisce $s[w[v slash x] slash y]$, consiste nel sostituire una variabile di tipo $alpha_1$, dunque, entrambi i tipi hanno taglia strettamente minore di $alpha=alpha_1->alpha_2$. È per questo motivo che la dimostrazione procede per induzione, prima di tutto, sulla taglia dei tipi.

Raccogliamo, innanzitutto, alcuni fatti elementari sui $lambda$-termini fortemente normalizzabili, che seguono direttamente dalle definizioni.

#lemma[Valgono le seguenti proprietà di normalizzazione forte:
  + Un termine $t$ appartiene a $#pb[Sn]$ se e solo se ogni termine $t'$ tale che $t scripts(->)_beta t'$ appartiene a $#pb[Sn]$. Inoltre, in tal caso vale $h(t') < h(t)$.
  + Se $t in #pb[Sn]$, allora ogni sottotermine $s$ di $t$ appartiene a $#pb[Sn]$, e vale $h(s) <= h(t)$.
  + Vale che $lambda y. t in #pb[Sn]$ se e solo se $t in #pb[Sn]$, e in tal caso $h(lambda y. t) = h(t)$.
  + Vale che $y t_1 dots t_n in #pb[Sn]$ se e solo se $t_1, dots, t_n in #pb[Sn]$.
]

Il punto ($i$) afferma che un termine è fortemente normalizzabile se e solo se lo sono tutti i termini che si ottengono da esso con un passo di riduzione, e sarà il modo principale con cui dimostreremo che un termine appartiene a $#pb[Sn]$. Il punto ($i i$) vale poiché ogni sequenza di riduzioni di un sottotermine è anche una sequenza di riduzioni del termine che lo contiene. Il punto ($i v$) vale poiché, in un termine della forma $y t_1 dots t_n$, non esiste alcun _redex_ in testa, essendo $y$ una variabile, per ipotesi. Le riduzioni di $y t_1 dots t_n$ avvengono, quindi, all'interno dei singoli argomenti $t_i$, indipendentemente l'uno dall'altro. Ci servirà, inoltre, il seguente risultato.

#lemma(title: [Espansione di testa])[
  Se $w in #pb[Sn]$ e $s[w slash y] t_1 dots t_n in #pb[Sn]$, allora $(lambda y. s) w t_1 dots t_n in #pb[Sn]$.
]

#dimostrazione[
  Si osservi, innanzitutto, che $s, t_1, dots, t_n in #pb[Sn]$, poiché ogni riduzione di $s$ induce una riduzione di $s[w slash y]$, e i termini $t_i$ sono sottotermini di un termine fortemente normalizzabile. Procediamo per induzione su $h(s) + h(w) + sum_i h(t_i)$, mostrando che ogni termine ottenuto da $(lambda y. s) w t_1 dots t_n$ con un passo di riduzione appartiene a $#pb[Sn]$. Se si riduce il _redex_ di testa, si ottiene $s[w slash y] t_1 dots t_n$, che appartiene a $#pb[Sn]$ per ipotesi. Altrimenti, si riduce un _redex_ all'interno di $s$, di $w$ o di uno dei $t_i$. In ciascuno di questi casi, il termine ottenuto ha ancora la forma $(lambda y. s') w' t'_1 dots t'_n$ e soddisfa ancora le ipotesi del lemma. Ad esempio, se $w scripts(->)_beta w'$, allora $w' in #pb[Sn]$, e $s[w' slash y] t_1 dots t_n$ si ottiene da $s[w slash y] t_1 dots t_n$ con zero o più passi di riduzione, per cui appartiene a $#pb[Sn]$. Siccome la quantità $h(s) + h(w) + sum_i h(t_i)$ è diminuita, possiamo applicare l'ipotesi induttiva, per cui possiamo concludere che $(lambda y. s) w t_1 dots t_n in #pb[Sn]$.
]

Si noti che l'ipotesi $w in #pb[Sn]$ è necessaria. Infatti, se $y$ non compare in $s$, il termine $w$ scompare in $s[w slash y]$, e potrebbe, ad esempio, essere $Omega$, che non ammette normalizzazione forte nel $lambda$-calcolo semplicemente tipato, siccome esiste una strategia di riduzione non terminante per un tale $lambda$-termine. Siamo, ora, pronti a dimostrare i due lemmi principali. Il primo gestisce il caso dell'applicazione, assumendo che la sostituzione preservi la normalizzazione forte per un tipo fissato.

#lemma(title: [Applicazione])[
  Sia $alpha$ un tipo tale per cui, per ogni $s, v in #pb[Sn]$ con $v$ di tipo $alpha$ e $y$ una variabile di tipo $alpha$, valga $s[v slash y] in #pb[Sn]$. Allora, per ogni $u, v in #pb[Sn]$ con $u : alpha -> beta$ e $v : alpha$, vale che $u v in #pb[Sn]$.
]

#dimostrazione[
  Procediamo per induzione su $h(u) + h(v)$, mostrando che ogni termine ottenuto da $u v$ con un passo di riduzione appartiene a $#pb[Sn]$. I casi possibili sono tre:
  - $u v scripts(->)_beta u' v$, con la regola $u scripts(->)_beta u'$. Allora $u' in #pb[Sn]$ con $h(u') < h(u)$, e $u' v in #pb[Sn]$ per ipotesi induttiva
  - $u v scripts(->)_beta u v'$, con la regola $v scripts(->)_beta v'$. Analogamente, $u v' in #pb[Sn]$ per ipotesi induttiva
  - $u = lambda y. s$, e $u v scripts(->)_beta s[v slash y]$, ossia si riduce il _redex_ creato dall'applicazione. Allora $s in #pb[Sn]$, poiché $u in #pb[Sn]$, e $y$ ha tipo $alpha$, per cui $s[v slash y] in #pb[Sn]$ per l'ipotesi del lemma
  Dunque tutti i termini ottenuti da $u v$ con un passo di riduzione appartengono a $#pb[Sn]$, per cui $u v in #pb[Sn]$.
]

#lemma(title: [Sostituzione])[
  Siano $t, v in #pb[Sn]$ tali che $Gamma, x : alpha tack t : beta$ e $Gamma tack v : alpha$. Allora $t[v slash x] in #pb[Sn]$.
]

#dimostrazione[
  Procediamo per induzione sulla tripla $(|alpha|, h(t), |t|)$, ordinata lessicograficamente. Più semplicemente, l'ipotesi induttiva può essere applicata se la taglia del tipo diminuisce, oppure se la taglia del tipo è la stessa e l'altezza di $t$ diminuisce, oppure se taglia del tipo e altezza sono le stesse, e la taglia di $t$ diminuisce. Per brevità, scriviamo $t^* = t[v slash x]$ per ogni termine $t$. Ogni $lambda$-termine ha una delle seguenti forme: un'astrazione $lambda y. t_1$, un'applicazione $y t_1 dots t_n$ di una variabile ad $n >= 0$ argomenti, oppure un'applicazione $(lambda y. s) w t_1 dots t_n$ di un _redex_ ad $n >= 0$ argomenti. Distinguiamo i casi, separando l'applicazione di una variabile in base al fatto che essa sia $x$ oppure no.

  _Caso $t = lambda y. t_1$._ Allora $t^* = lambda y. t_1^*$. Vale $h(t_1) = h(t)$ e $|t_1| < |t|$, per cui $t_1^* in #pb[Sn]$ per ipotesi induttiva, e quindi $t^* in #pb[Sn]$.

  _Caso $t = y t_1 dots t_n$, con $y != x$._ Allora $t^* = y t_1^* dots t_n^*$. Per ogni $i$, vale $h(t_i) <= h(t)$ e $|t_i| < |t|$, per cui $t_i^* in #pb[Sn]$ per ipotesi induttiva, e quindi $t^* in #pb[Sn]$.

  _Caso $t = (lambda y. s) w t_1 dots t_n$._ Allora $t^* = (lambda y. s^*) w^* t_1^* dots t_n^*$. Per il lemma di espansione di testa, è sufficiente mostrare che $w^* in #pb[Sn]$ e che $s^* [w^* slash y] t_1^* dots t_n^* in #pb[Sn]$. Il primo fatto segue dall'ipotesi induttiva, poiché $w$ è un sottotermine di $t$, per cui $h(w) <= h(t)$ e $|w| < |t|$. Per il secondo fatto, si osservi che $s^* [w^* slash y] t_1^* dots t_n^* = (s[w slash y] t_1 dots t_n)^*$, e che il termine $s[w slash y] t_1 dots t_n$ si ottiene da $t$ riducendo il _redex_ di testa, per cui ha altezza strettamente minore di $h(t)$. Dunque, la tesi segue dall'ipotesi induttiva.

  _Caso $t = x t_1 dots t_n$._ Questo è il caso cruciale, in cui la sostituzione può creare nuovi _redex_. Se $n = 0$, allora $t^* = v in #pb[Sn]$. Sia, quindi, $n >= 1$. Siccome $x$ è applicata ad almeno un argomento, il suo tipo deve essere funzionale, ossia $alpha = alpha_1 -> alpha'$, dove $t_1$ ha tipo $alpha_1$. Vale $t^* = v t_1^* t_2^* dots t_n^*$ e, come nei casi precedenti, $t_i^* in #pb[Sn]$ per ogni $i$, per ipotesi induttiva. Se $v$ è un'astrazione, il termine $v t_1^*$ è un nuovo _redex_, che non era presente in $t$. Mostriamo, innanzitutto, che $v t_1^* in #pb[Sn]$. Siccome $|alpha_1| < |alpha|$, per ipotesi induttiva la sostituzione preserva la normalizzazione forte per le variabili di tipo $alpha_1$, per cui, per il lemma di applicazione, applicato con il tipo $alpha_1 -> alpha'$, vale $v t_1^* in #pb[Sn]$. Se $n = 1$, abbiamo concluso. Altrimenti, per gestire i restanti argomenti, rendiamo _silente_ il calcolo del termine $v t_1^*$, sostituendolo con una variabile $z$ fresca, di tipo $alpha'$. Possiamo, infatti, scrivere
  $
    t^* = (z t_2^* dots t_n^*)[v t_1^* slash z]
  $
  Il termine $z t_2^* dots t_n^*$ appartiene a $#pb[Sn]$, poiché è un'applicazione di una variabile ad argomenti fortemente normalizzabili, e il termine $v t_1^*$, che sostituisce $z$, appartiene a $#pb[Sn]$ ed ha tipo $alpha'$. Siccome $|alpha'| < |alpha|$, per ipotesi induttiva segue che $t^* in #pb[Sn]$. Più chiaramente, si applica, per ipotesi induttiva, il lemma di sostituzione dove $t=z t^*_2 dots t^*_n$, $v=v t_1$ e $x=z$. Siccome, per ipotesi induttiva sulla lunghezza di $t^*_i$ vale che $z t^*_2 dots t^*_n in$ #pb[Sn], e $|alpha'|<|alpha|$, per ipotesi induttiva sulla taglia del tipo $alpha'$ possiamo concludere che $t^* = (z t_2^* dots t_n^*)[v t_1^* slash z] in$ #pb[Sn].
]

Si osservi come l'induzione sul tipo sia essenziale nell'ultimo caso. Infatti, i termini sostituiti, ovvero $v t_1^*$ e il parametro di $v$, hanno tipi $alpha'$ ed $alpha_1$ strettamente più piccoli di $alpha$, ma possono avere altezza e taglia arbitrariamente grandi, per cui un'induzione sulla sola altezza o sulla sola taglia dei termini non sarebbe sufficiente. Possiamo, finalmente, dimostrare il teorema di normalizzazione forte.

#dimostrazione(title: [Dimostrazione (Teorema di normalizzazione forte)])[
  Dimostriamo che, se $Gamma tack t : A$, allora $t in #pb[Sn]$, per induzione sulla struttura di $t$.
  - Se $t = x$, allora $t$ è in forma normale, per cui $t in #pb[Sn]$.
  - Se $t = lambda x. v$, allora $v in #pb[Sn]$ per ipotesi induttiva, e quindi $t in #pb[Sn]$.
  - Se $t = u v$, con $u : alpha -> beta$ e $v : alpha$, allora $u, v in #pb[Sn]$ per ipotesi induttiva. Per il lemma di sostituzione, la sostituzione preserva la normalizzazione forte per le variabili di _qualunque_ tipo, e in particolare di tipo $alpha$. Dunque, per il lemma di applicazione, $u v in #pb[Sn]$. Ricordando la dimostrazione del lemma di applicazione, si osservi che ciò significa esattamente che, se $u v scripts(->)_beta u' v$ oppure $u v scripts(->)_beta u v'$, la tesi segue per induzione, mentre se $u = lambda x. u_1$ e $u v scripts(->)_beta u_1 [v slash x]$, allora $u_1 [v slash x] in #pb[Sn]$ per il lemma di sostituzione.
]

Concludiamo, in ultima istanza, che ogni termine del $lambda$-calcolo semplicemente tipato ammette soltanto computazioni che terminano. Infine, il $lambda$-calcolo semplicemente tipato è il più semplice dei sistemi di tipi per il $lambda$-calcolo, ed ha, di conseguenza, una potenza espressiva minima. Il logico olandese Henk Barendregt ha mostrato che molti dei sistemi di tipi più importanti possono essere organizzati in modo sistematico, come vertici di un cubo, detto _$lambda$-cubo di Barendregt_. L'idea è che, nel $lambda$-calcolo semplicemente tipato, i termini possono dipendere soltanto da altri termini. Ad esempio, una funzione $lambda x^A. M$ riceve un termine e restituisce un termine. A partire dal $lambda$-calcolo semplicemente tipato $lambda_(->)$, però, è possibile aggiungere tre ulteriori forme di _dipendenza_, ognuna delle quali corrisponde ad uno spigolo del cubo uscente dal vertice $lambda_->$:
- _termini che dipendono da tipi_, ossia il _polimorfismo_ (spigolo verticale). Ad esempio, l'identità polimorfa $Lambda X. lambda x^X. x$ riceve un tipo $X$ e restituisce la funzione identità su $X$, ed ha tipo $forall X. X -> X$
- _tipi che dipendono da tipi_, ossia gli _operatori di tipo_ (spigolo in profondità). Ad esempio, $"List"$ è una funzione che riceve un tipo $X$ e restituisce il tipo $"List"(X)$ delle liste di elementi di tipo $X$
- _tipi che dipendono da termini_, ossia i _tipi dipendenti_ (spigolo orizzontale). Ad esempio, il tipo $C(k)$ dei circuiti con $k$ ingressi dipende dal numero naturale $k$, che è un termine. Dunque, una funzione che trasforma un circuito di arietà $k$ in un circuito della stessa arietà ha tipo $C(k) -> C(k)$, ed è parametrica nel termine $k$

#align(center, cetz.canvas(length: 1cm, {
  import cetz.draw: *
  set-style(stroke: line-thickness + black)
  let (dx, dy) = (1.8, 1.3)
  let v = (
    sta: (0, 0), p: (4, 0), due: (0, 4), p2: (4, 4),
    w: (dx, dy), pw: (4 + dx, dy), fw: (dx, 4 + dy), cc: (4 + dx, 4 + dy),
  )
  // spigoli nascosti (tratteggiati)
  for (a, b) in (("sta", "w"), ("w", "pw"), ("w", "fw")) {
    line(v.at(a), v.at(b), stroke: (dash: "dashed"))
  }
  // spigoli visibili
  for (a, b) in (("sta", "p"), ("sta", "due"), ("p", "p2"), ("due", "p2"),
                 ("p", "pw"), ("due", "fw"), ("p2", "cc"), ("fw", "cc"), ("pw", "cc")) {
    line(v.at(a), v.at(b))
  }
  for (k, c) in v { circle(c, radius: 0.06, fill: black) }
  content(v.sta, $lambda_->$, anchor: "north-east", padding: 0.12)
  content(v.p, $lambda P$, anchor: "north-west", padding: 0.12)
  content(v.due, $lambda 2$, anchor: "south-east", padding: 0.12)
  content(v.p2, $lambda P 2$, anchor: "north-west", padding: 0.12)
  content(v.w, $lambda underline(omega)$, anchor: "south-east", padding: 0.12)
  content(v.pw, $lambda P underline(omega)$, anchor: "west", padding: 0.15)
  content(v.fw, $lambda omega$, anchor: "south-east", padding: 0.12)
  content(v.cc, $lambda C$, anchor: "south-west", padding: 0.12)
}))

Descriviamo i vertici del cubo.
- $lambda_->$ (vertice in basso a sinistra, sul fronte) è il _$lambda$-calcolo semplicemente tipato_, in cui i termini dipendono soltanto da termini. Attraverso la _corrispondenza di Curry-Howard_, corrisponde alla logica minimale proposizionale. È il sistema con la potenza espressiva minima, ed è il punto di partenza di tutti gli altri
- $lambda 2$ (in alto a sinistra, sul fronte) è il _sistema $F$_ di Girard e Reynolds, ossia il $lambda$-calcolo _polimorfo_, in cui i termini possono dipendere anche dai tipi. Corrisponde alla logica proposizionale del secondo ordine, in cui è possibile quantificare sulle proposizioni, come in $forall X. X -> X$
- $lambda P$ (in basso a destra, sul fronte) è il $lambda$-calcolo con _tipi dipendenti_, in cui i tipi possono dipendere dai termini, ossia i tipi sono _parametrici_. È noto anche come #pb[Lf] (_Logical Framework_), e corrisponde alla logica dei predicati minimale, in cui i predicati $P(x)$ sono tipi che dipendono dal termine $x$
- $lambda P 2$ (in alto a destra, sul fronte) combina il polimorfismo di $lambda 2$ con i tipi dipendenti di $lambda P$, e corrisponde alla logica dei predicati del secondo ordine
- $lambda underline(omega)$ (in basso a sinistra, sul retro) estende il $lambda$-calcolo semplicemente tipato con gli _operatori di tipo_, ossia con funzioni che trasformano tipi in tipi
- $lambda P underline(omega)$ (in basso a destra, sul retro) combina gli operatori di tipo con i tipi dipendenti
- $lambda omega$ (in alto a sinistra, sul retro) è il _sistema $F_omega$_, che combina il polimorfismo del sistema $F$ con gli operatori di tipo, e corrisponde alla logica di ordine superiore
- $lambda C$ (in alto a destra, sul retro) è il _calcolo delle costruzioni_, ovvero #pb[Cc], _Calculus of Constructions_, di Coquand e Huet, che contiene tutte e tre le dipendenze aggiuntive. È il sistema più espressivo del cubo, e una sua estensione, il _calcolo delle costruzioni induttive_, è alla base dell'assistente alla dimostrazione Coq

Si noti che tutti i sistemi del $lambda$-cubo godono della normalizzazione forte, per cui nessuno di essi è Turing-Completo. Dunque, i sistemi più espressivi possono rappresentare un numero molto più grande di funzioni totali, ma non le computazioni che non terminano. Ad esempio, il sistema $F$ rappresenta tutte le funzioni la cui totalità è dimostrabile nell'aritmetica del secondo ordine. Questo è coerente con la _corrispondenza di Curry-Howard_, dimostrabile per ciascuno di questi sistemi logici, siccome ogni vertice del cubo corrisponde ad una logica consistente, e ogni dimostrazione corrisponde ad un programma che termina.
