#import "../template.typ": *

= La Logica dei Predicati Classica

Nel precedente capitolo, abbiamo osservato come la logica proposizionale classica tratti le proposizioni atomiche come scatole chiuse, il cui unico attributo semantico è il valore di verità. Questo la rende inadatta a descrivere buona parte del ragionamento matematico, che discute di _oggetti matematici_ (come numeri, insiemi, punti, nodi di un grafo), delle loro _proprietà_ e delle _relazioni_ tra di essi. Si consideri, ad esempio, l'affermazione "ogni numero naturale ha un successore maggiore di esso". In logica proposizionale, questa proposizione può essere rappresentata soltanto con un unico simbolo $p$, in quanto non definisce connettivi logici elementari, perdendo completamente la struttura interna dell'affermazione. Infatti, l'affermazione parla di _tutti_ i numeri naturali, e afferma l'_esistenza_ di un altro numero in relazione con ciascuno di essi. Per colmare il _deficit_ di potenza espressiva che caratterizza la logica proposizionale introduciamo, quindi, la logica dei predicati, detta anche _logica del primo ordine_ (_First Order Logic_, o #pb[Fol]), la quale estende la logica proposizionale classica con la nozione di _variabili_, ovvero uno strumento sintattico in grado di denotare gli oggetti di un dominio, i _simboli di funzione_ e di _costante_, che permettono di costruire _termini_ che denoiano singoli e specifici oggetti, i _simboli di predicato_, o di relazione, che esprimono proprietà e relazioni tra oggetti, e infine i _quantificatori_ $forall$, "per ogni", ed $exists$, "esiste". L'affermazione precedente diventa, allora, $forall x. exists y. (x < y)$. La logica del primo ordine è il linguaggio in cui è formalizzata la maggior parte della matematica per come la conosciamo, e rappresenta un ottimo compromesso tra tre proprietà desiderabili di un sistema logico:
- è sufficientemente _espressiva_, ossia permette di descrivere strutture matematiche ricche e complesse
- è _automatizzabile_, nel senso che le dimostrazioni possono essere verificate, e, con i limiti dovuti all'indecidibilità, ricercate meccanicamente
- è _corretta e completa_, ossia la derivabilità coincide con la conseguenza semantica

Il termine _del primo ordine_ si riferisce al fatto che i quantificatori agiscono soltanto sugli _oggetti_ del dominio, e non sulle proprietà o sugli insiemi di oggetti, come accade invece nelle logiche _del secondo ordine_. Alcuni esempi di formule, con il loro significato intuitivo, sono le seguenti.
#align(center, table(columns: 2, stroke: none, align: (left, left), inset: 5pt,
  [*Formula*], [*Significato intuitivo*],
  table.hline(stroke: 0.4pt),
  $exists x. P(x)$, [esiste un numero $x$ con la proprietà $P$],
  $forall y. P(y)$, [per ogni numero $y$ vale la proprietà $P$],
  $forall x. exists y. (x = 2 y)$, [per ogni numero $x$ esiste un numero $y$ tale che $x$ è il doppio di $y$],
  $forall epsilon. (epsilon > 0 -> exists n. (1 / n < epsilon))$, [per ogni numero $epsilon$ positivo esiste un numero $n$ tale che $1 / n < epsilon$],
  $x < y -> exists z. (x < z and z < y)$, [se $x < y$, allora esiste un numero $z$ compreso tra $x$ e $y$],
  $forall x. exists y. (x dot y = 1)$, [ogni numero $x$ ammette un inverso moltiplicativo],
))

Prima di definire la sintassi della logica del primo ordine, è utile capire di quali oggetti e formule ci permette di discutere questa logica. Le formule del primo ordine descrivono _strutture_ matematiche, ossia insiemi di oggetti dotati di relazioni, funzioni e costanti distinte. Ad esempio, i numeri naturali con l'ordinamento, la somma, il prodotto e lo zero formano la struttura $⟨ NN, <=, +, dot, 0 ⟩$.

#definizione[
  Una _struttura_ è una $n$-upla
  $
    frak(A) = ⟨ A, R_1, dots, R_n, F_1, dots, F_m, {c_i | i in I} ⟩
  $
  dove $A$ è un insieme non vuoto, detto _dominio_, o _universo_, della struttura, $R_1, dots, R_n$ sono relazioni su $A$, $F_1, dots, F_m$ sono funzioni su $A$, e $c_i in A$ sono elementi distinti del dominio, detti _costanti_. Con $|frak(A)|$ si indica il dominio $A$ della struttura.
]

#definizione[
  Il _tipo di similarità_ di una struttura $frak(A)$ è la sequenza $⟨ r_1, dots, r_n; a_1, dots, a_m; kappa ⟩$, dove $R_i subset.eq A^(r_i)$, $F_j : A^(a_j) -> A$ e $kappa = |{c_i | i in I}|$ è il numero di costanti.
]

In altre parole, il tipo di similarità descrive la _forma_ di una struttura matematica, ovvero il numero di relazioni considerate e la loro arietà, il numero di funzioni considerate e la loro arietà, e il numero di costanti. Ad esempio, $⟨ NN, <, +, S, 0 ⟩$, dove $S(x) = x + 1$ è la funzione successore, ha tipo di similarità $⟨ 2; 2, 1; 1 ⟩$, che rappresenta una relazione binaria, una funzione binaria, una funzione unaria e una costante. Si noti che può valere $n = 0$, $m = 0$ o $kappa = 0$.

#esercizio[
  Si scriva il tipo di similarità delle seguenti strutture: $⟨ QQ, <, 0 ⟩$, $⟨ NN, +, dot, S, 0, 1, 2, dots ⟩$, $⟨ cal(P)(NN), subset.eq, union, inter, ""^c, emptyset ⟩$, $⟨ ZZ slash (5), +, dot, -, ""^(-1), 0, 1, 2, 3, 4 ⟩$, $⟨ {0, 1}, and, or, ->, not, 0, 1 ⟩$, $⟨ RR, 1 ⟩$ e $⟨ RR ⟩$. Si forniscano, inoltre, esempi di strutture di tipo $⟨ 1, 1; -; 3 ⟩$ e $⟨ 4; -; 0 ⟩$.
]

A partire dal tipo di similarità si può costruire il linguaggio formale utilizzato per descrivere le strutture matematiche caratterizzate da quel tipo di similarità. L'idea è di avere un simbolo per ogni relazione, funzione e costante della struttura, che a livello sintattico non ha alcun significato, e che riceverà un significato soltanto quando verrà _interpretato_ in una struttura concreta mediante l'interpretazione semantica della struttura stessa.

#definizione[
  Il _linguaggio_ (o _alfabeto_) $cal(L)$ di tipo $⟨ r_1, dots, r_n; a_1, dots, a_m; kappa ⟩$ è composto dai seguenti simboli:
  - i _simboli di predicato_ $P_1, dots, P_n, =$, dove $P_i$ ha arietà $r_i>0$
  - i _simboli di funzione_ $f_1, dots, f_m$, dove $f_j$ ha arietà $a_j > 0$
  - i _simboli di costante_ $overline(c)_i$, per $i in I$
  - le _variabili_ $x_0, x_1, x_2, dots$, in quantità numerabile
  - i _connettivi_ $and, or, ->, not, <->, bot$ e i _quantificatori_ $forall, exists$
  - i simboli ausiliari $($, $)$ e $,$
]

Si osservi la differenza tra il simbolo $overline(c)_i$, che è un oggetto sintattico, e l'elemento $c_i in A$ di una struttura matematica, che è un oggetto semantico. Analogamente, il simbolo di predicato $P_i$ è solo un oggetto sintattico, mentre la relazione $R_i$ è un sottoinsieme del dominio che descrive una relazione tra oggetti matematici del dominio, ed è rappresentato dal simbolo $P_i$. Il simbolo di uguaglianza $=$ è un predicato binario sempre presente, che riceve un'interpretazione fissata. Ad esempio, un linguaggio di tipo $⟨ 2; 2, 1; 1 ⟩$ ha i simboli di predicato $L$ e $=$, i simboli di funzione binaria $p$ e funzione unaria $s$, e il simbolo di costante $overline(0)$. Interpretando questo tipo di similarità nella struttura matematica $⟨ NN, <, +, S, 0 ⟩$, il simbolo $L$ denoterà la relazione $<$ e il simbolo $p$ la somma $+$.

== _La Sintassi della Logica dei Predicati_

La sintassi della logica del primo ordine prevede due _categorie sintattiche_, ovvero i _termini_, che denotano oggetti del dominio, e le _formule_, che esprimono affermazioni riguardo tali oggetti, e a cui sarà associato un valore di verità. Come per la logica proposizionale, entrambe le categorie sono definite induttivamente.

#definizione[
  L'insieme $#pb[Term]$ dei _termini_ è il più piccolo insieme $X$ tale che
  + $overline(c)_i in X$ per ogni $i in I$, e $x_i in X$ per ogni $i in NN$
  + se $t_1, dots, t_(a_i) in X$, allora $f_i (t_1, dots, t_(a_i)) in X$, per $1 <= i <= m$
]

In altre parole, i termini sono costruiti a partire da costanti e variabili mediante l'applicazione di simboli di funzione: il risultato dell'applicazione di una funzione ad una sequenza di $a_i$ termini è ancora un termine, ossia un oggetto matematico del dominio. Ad esempio, nel linguaggio dell'aritmetica, $p(x, s(overline(0)))$ è un termine, che denota sintatticamente la proposizione semantica $x + 1$.

#definizione[
  L'insieme $#pb[Form]$ delle _formule_ è il più piccolo insieme $X$ tale che
  + $bot in X$; $P_i in X$ se $r_i = 0$; se $t_1, dots, t_(r_i) in #pb[Term]$, allora $P_i (t_1, dots, t_(r_i)) in X$; se $t_1, t_2 in #pb[Term]$, allora $t_1 = t_2 in X$
  + se $phi, psi in X$, allora $(phi square psi) in X$, per $square in {and, or, ->, <->}$
  + se $phi in X$, allora $(not phi) in X$
  + se $phi in X$, allora $((forall x_i) phi), ((exists x_i) phi) in X$
  Le formule al punto ($i$) sono dette _formule atomiche_.
]

Si noti la differenza fondamentale tra termini e formule. Il risultato dell'applicazione di un simbolo di funzione è un termine, ossia un oggetto matematico del dominio, mentre il risultato dell'applicazione di un simbolo di predicato è una formula, ossia un'affermazione che può essere vera o falsa. Si noti che, nella logica classica del primo ordine affrontata in questo capitolo, l'uguaglianza è definita soltanto tra termini. Si noti, inoltre, che i predicati di arietà zero si comportano esattamente come i simboli proposizionali e, per questo motivo, la logica proposizionale è considerata un frammento della logica del primo ordine. Come per la logica proposizionale, possiamo definire funzioni per ricorsione sui termini e sulle formule, e dimostrare proprietà per induzione sulla loro struttura.

#teorema(title: [Definizione per ricorsione su #pb[Term] e #pb[Form]])[
  - Siano $H_0 : "Var" union "Const" -> A$ e $H_i : A^(a_i) -> A$. Allora esiste un'unica funzione $H : #pb[Term] -> A$ tale che $H(t) = H_0 (t)$ se $t$ è una variabile o una costante, e $H(f_i (t_1, dots, t_(a_i))) = H_i (H(t_1), dots, H(t_(a_i)))$.
  - Siano $H_"at" : "At" -> A$, $H_square : A^2 -> A$, $H_not : A -> A$, $H_forall : A times NN -> A$ e $H_exists : A times NN -> A$. Allora esiste un'unica funzione $H : #pb[Form] -> A$ tale che $H(phi) = H_"at" (phi)$ per una formula $phi$ atomica, $H(phi square psi) = H_square (H(phi), H(psi))$, $H(not phi) = H_not (H(phi))$, $H(forall x_i. phi) = H_forall (H(phi), i)$ e $H(exists x_i. phi) = H_exists (H(phi), i)$.
]

Un concetto centrale nella sintassi della logica del primo ordine è la distinzione tra le occorrenze _libere_ e _legate_ delle variabili. Ad esempio, nella formula $forall x. (x < y)$, la variabile $x$ è _legata_ al quantificatore $forall$, ed infatti il significato della formula non dipende dal nome scelto per essa. Per questo motivo, è coerente osservare che la formula $forall z. (z < y)$ esprime esattamente lo stesso concetto. La variabile $y$, invece, è _libera_, ed il valore di verità della formula dipende dall'oggetto che essa denota. In particolare, a determinare se una variabile è libera o legata in una specifica formula del primo ordine, è l'occorrenza della variabile stessa in una quantificazione universale o esistenziale.

#definizione[
  L'insieme $#pb[Fv];(t)$ delle _variabili libere_ di un termine $t$ è definito come
  $
    #pb[Fv];(x_i) = {x_i}, quad #pb[Fv];(overline(c)_i) = emptyset, quad #pb[Fv];(f(t_1, dots, t_n)) = #pb[Fv];(t_1) union dots union #pb[Fv];(t_n)
  $
  L'insieme $#pb[Fv];(phi)$ delle _variabili libere_ di una formula $phi$ è definito come
  $
    #pb[Fv];(P(t_1, dots, t_n)) = union.big_i #pb[Fv];(t_i), quad #pb[Fv];(t_1 = t_2) = #pb[Fv];(t_1) union #pb[Fv];(t_2), quad #pb[Fv];(bot) = #pb[Fv];(P) = emptyset \
    #pb[Fv];(phi square psi) = #pb[Fv];(phi) union #pb[Fv];(psi), quad #pb[Fv];(not phi) = #pb[Fv];(phi) \
    #pb[Fv];(forall x_i. phi) = #pb[Fv];(exists x_i. phi) = #pb[Fv];(phi) without {x_i}
  $
  Un termine $t$ è _chiuso_ se $#pb[Fv];(t) = emptyset$, e una formula $phi$ è _chiusa_, anche detta un _enunciato_, se $#pb[Fv];(phi) = emptyset$. Una formula senza quantificatori è detta _aperta_.
]

#esercizio(numbered: false)[
  Si definisca, per ricorsione, l'insieme $#pb[Bv];(phi)$ delle _variabili legate_ di una formula $phi$, ossia delle variabili che compaiono in $phi$ nello _scope_ di un quantificatore.
]

Analogamente alla logica proposizionale, possiamo definire l'insieme delle _sottoformule_ di una formula come $"Sub"(phi) = {phi}$ per una formula $phi$ atomica, $"Sub"(phi_1 square phi_2) = "Sub"(phi_1) union "Sub"(phi_2) union {phi_1 square phi_2}$, $"Sub"(not phi) = "Sub"(phi) union {not phi}$ e $"Sub"(Q x. phi) = "Sub"(phi) union {Q x. phi}$, per $Q in {forall, exists}$.

Nel ragionamento matematico, si transita continuamente da un'affermazione generale ad una sua istanza particolare. Ad esempio se vale la formula $forall x. phi(x)$, dove $phi$ è definita in funzione di una variabile, allora deve valere la formula $phi(t)$ per ogni termine $t$, dove $phi$ è definita in funzione di generico termine. Per formalizzare questo passaggio abbiamo bisogno dell'operazione di _sostituzione_ di un termine al posto di una variabile, che è sorprendentemente delicata.

#definizione[
  Siano $s, t$ termini. La sostituzione $s[t slash x]$ di $t$ al posto di $x$ in $s$ è definita come
  $
    y[t slash x] = cases(y & "se" y != x, t & "se" y equiv x) quad quad c[t slash x] = c quad quad f(t_1, dots, t_p)[t slash x] = f(t_1 [t slash x], dots, t_p [t slash x])
  $
  Sia $phi$ una formula logica del primo ordine. La sostituzione $phi[t slash x]$ è definita come
  $
    bot[t slash x] = bot, quad P[t slash x] = P, quad P(t_1, dots, t_p)[t slash x] = P(t_1 [t slash x], dots, t_p [t slash x]) \
    (t_1 = t_2)[t slash x] = (t_1 [t slash x] = t_2 [t slash x]) \
    (phi square psi)[t slash x] = phi[t slash x] square psi[t slash x], quad (not phi)[t slash x] = not phi[t slash x] \
    (forall y. phi)[t slash x] = cases(forall y. phi[t slash x] & "se" x != y, forall y. phi & "se" x equiv y) quad quad (exists y. phi)[t slash x] = cases(exists y. phi[t slash x] & "se" x != y, exists y. phi & "se" x equiv y)
  $
]

Si noti che la sostituzione agisce soltanto sulle occorrenze _libere_ di una variabile $x$. Dunque, se la variabile $x$ è legata da un quantificatore in una formula arbitraria, la sostituzione non agisce nello _scope_ del quantificatore. Le variabili legate, infatti, non vanno mai sostituite siccome, altrimenti, è facile catturare formule semanticamente false mediante derivazione nel sistema di deduzione della logica del primo ordine. Si può definire, analogamente, la _sostituzione simultanea_ $phi[t_1, dots, t_n slash x_1, dots, x_n]$, che sostituisce contemporaneamente i termini $t_i$ alle variabili $x_i$. Tuttavia, la definizione di sostituzione come è stata precedentemente descritta nasconde un problema. Consideriamo, infatti, la formula $exists x. (y < x)$, che intuitivamente afferma che "esiste un numero maggiore di $y$", ed è vera nei numeri naturali per ogni valore di $y$. Sostituendo $x$ al posto di $y$ otteniamo
$
  exists x. (y < x)[x slash y] = exists x. (x < x)
$
che afferma che "esiste un numero minore di sé stesso", la quale è intuitivamente falsa. In questo caso, si dice che la variabile $x$ del termine sostituito è stata _catturata_ dal quantificatore $exists x$, e la sostituzione ha alterato il significato semantico della formula. Dobbiamo, quindi, proibire questa categoria di sostituzioni pericolose, introducendo la seguente nozione.

#definizione[
  Il termine $t$ è detto _libero per_ $x$ in $phi$ se
  + $phi$ è atomica, oppure
  + $phi = phi_1 square phi_2$ (oppure $phi = not phi_1$) e $t$ è libero per $x$ in $phi_1$ e $phi_2$, oppure
  + $phi = exists y. psi$ (oppure $phi = forall y. psi$) e, se $x in #pb[Fv];(phi)$, allora $y in.not #pb[Fv];(t)$ e $t$ è libero per $x$ in $psi$
]

Il caso interessante, naturalmente, è il terzo. Infatti, se dovessimo davvero sostituire la variabile $x$ all'interno di $exists y. psi$, allora il termine $t$ non deve contenere la variabile $y$, altrimenti essa verrebbe catturata dal quantificatore. Schematicamente, se $t = (dots y dots)$ e $phi = (dots (exists y dots x dots) dots)$, allora $phi[t slash x] = (dots (exists y dots (dots y dots) dots) dots)$, e la variabile $y$ del termine $t$ viene legata nella nuova formula. In questo caso, si dice che il termine $t$ _non_ è libero per $x$ in $phi$.

#proposizione[
  Il termine $t$ è libero per $x$ in $phi$ se e solo se le variabili di $t$ in $phi[t slash x]$ non sono legate da alcun quantificatore.
]

La dimostrazione è per induzione su $phi$, ed è lasciata come esercizio. D'ora in avanti, quando scriveremo $phi[t slash x]$, assumeremo sempre implicitamente che $t$ sia libero per $x$ in $phi$.

#esempio(numbered: false)[
  Sia definita la formula $sigma = (forall x. R(x, y, z)) and (forall z. Q(x, z))$, e chiamiamo $sigma_1$ e $sigma_2$ le due componenti della congiunzione.
  + Il termine $f(x)$ è libero per $z$ in $sigma$? Sostituendo, otteniamo $forall x. R(x, y, f(x)) and sigma_2$, dove la variabile $x$ di $f(x)$ viene legata al quantificatore $forall x$. Dunque il termine $f(x)$ non è libero per $z$ in $sigma$.
  + Il termine $f(x)$ è libero per $x$ in $sigma$? Sostituendo, otteniamo $sigma_1 and forall z. Q(f(x), z)$. Nella formula $sigma_1$ non si esegue alcuna sostituzione, poiché la variabile $x$ è legata, mentre in $sigma_2$ la variabile $x$ di $f(x)$ non viene legata ad alcun quantificatore. Dunque il termine $f(x)$ è libero per $x$ in $sigma$.
  + Il termine $f(x)$ è libero per $y$ in $sigma$? Sostituendo, otteniamo $forall x. R(x, f(x), z) and sigma_2$, dove la variabile $x$ è catturata dal quantificatore $forall x$. Dunque il termine $f(x)$ non è libero per $y$ in $sigma$.
]

#esercizio[
  Si verifichi quali termini sono liberi nei seguenti casi, e si esegua la sostituzione:
  - $x$ per $x$ in $x = x$
  - $y$ per $x$ in $x = x$
  - $x + y$ per $y$ in $z = overline(0)$
  - $overline(0) + y$ per $y$ in $exists x. (y = x)$
  - $x + y$ per $z$ in $exists w. (w + x = overline(0))$
  - $x + w$ per $z$ in $forall w. (x + z = overline(0))$
  - $x + y$ per $z$ in $forall w. (x + z = overline(0)) and exists y. (z = x)$
  - $x + y$ per $z$ in $forall u. (u = v) -> forall z. (z = y)$
]

Concludiamo la sezione con alcuni lemmi tecnici sulla sostituzione, che sono utili per la manipolazione delle formule.

#lemma[
  Siano $x$ e $y$ variabili distinte tali che $x in.not #pb[Fv];(r)$. Allora
  + $(t[s slash x])[r slash y] = (t[r slash y])[s[r slash y] slash x]$
  + se $x in.not #pb[Fv];(s)$ e $t, s$ sono liberi per $x$ e $y$ in $phi$, allora $(phi[t slash x])[s slash y] = (phi[s slash y])[t[s slash y] slash x]$
]

#dimostrazione[
  Dimostriamo il punto ($i$) per induzione sulla lunghezza di $t$, notando il punto ($i i$) segue analogamente, per induzione strutturale sulla formula $phi$. Se $t = c$, l'uguaglianza è banale. Se $t = x$, allora $t[s slash x] = s$ e $(t[s slash x])[r slash y] = s[r slash y]$, mentre $(t[r slash y])[s[r slash y] slash x] = x[s[r slash y] slash x] = s[r slash y]$. Se $t = y$, allora $(t[s slash x])[r slash y] = y[r slash y] = r$, mentre $(t[r slash y])[s[r slash y] slash x] = r[s[r slash y] slash x] = r$, poiché $x in.not #pb[Fv];(r)$. Se $t = z$, con $z != x, y$, l'uguaglianza è banale. Infine, se $t = f(t_1, dots, t_n)$, allora per ipotesi induttiva
  $
    (t[s slash x])[r slash y] = f((t_1 [s slash x])[r slash y], dots) = f((t_1 [r slash y])[s[r slash y] slash x], dots) = (t[r slash y])[s[r slash y] slash x]
  $
]

#corollario[
  + Se $z in.not #pb[Fv];(t)$, allora $t[a slash x] = (t[z slash x])[a slash z]$.
  + Se $z in.not #pb[Fv];(phi)$ e $z$ è libera per $x$ in $phi$, allora $phi[a slash x] = (phi[z slash x])[a slash z]$.
]

Il corollario garantisce che è sempre possibile _rinominare_ una variabile con una variabile nuova, prima di sostituirla. Più in generale, rinominare le variabili legate non cambia il significato di una formula. In tal caso, si dice che due formule sono _$alpha$-equivalenti_, e si scrive $alpha tilde alpha'$, se differiscono soltanto per il nome delle variabili legate. Formalmente, la relazione $tilde$ è definita come la più piccola relazione tale che $alpha tilde alpha$, che è chiusa rispetto ai connettivi (se $alpha tilde alpha'$ e $beta tilde beta'$, allora $not alpha tilde not alpha'$, $alpha and beta tilde alpha' and beta'$, e così via), e tale che, se $z$ non occorre in $alpha$ e $beta$ e $alpha(z) tilde beta(z)$, allora $forall x. alpha(x) tilde forall y. beta(y)$. Valgono i seguenti risultati riguardanti la relazione $tilde$:
- la relazione $tilde$ è una relazione di equivalenza
- data una formula $alpha$, è possibile trovare una formula $beta$ tale che $alpha tilde beta$, nessuna variabile di $beta$ è sia libera che legata, e ogni variabile legata di $beta$ compare nello _scope_ di un solo quantificatore
- se $phi tilde sigma$, allora $tack.rr phi <-> sigma$

Grazie al secondo risultato, possiamo sempre assumere, a meno di rinominare le variabili legate, che i termini oggetto di sostituzione siano sempre liberi per le variabili sostituite.

== _La Deduzione Naturale per la Logica dei Predicati_

Siccome la logica proposizionale può essere interpretata come un frammento della logica al primo ordine, possiamo estendere il sistema di deduzione naturale per la logica proposizionale classica con le regole di deduzione per i quantificatori, ottenendo il sistema di deduzione naturale per la logica del primo ordine. Nello stesso contesto, scriveremo $phi(x)$ e $phi(t)$ per indicare, rispettivamente, $phi$ e $phi[t slash x]$, e, come al solito, $"hp"(cal(D))$ indica l'insieme delle ipotesi non scaricate della derivazione $cal(D)$. Le regole di deduzione naturale proposizionale restano invariate, così come le nozioni di derivazione e di derivabilità. Similmente alla logica proposizionale, restringeremo spesso il linguaggio ai soli connettivi ${and, ->, bot, forall}$, definendo $not phi := phi -> bot$ ed $exists x. phi := not forall x. not phi$.

Le regole di deduzione naturale per il quantificatore universale sono le seguenti
#alberi(
  rule(name: $forall I$, $forall x. phi(x)$, deriv($cal(D)$, $phi(x)$)),
  rule(name: $forall E$, $phi(t)$, deriv($cal(D)$, $forall x. phi(x)$)),
)
Si noti che, nella regola $forall I$, deve valere che $x in.not #pb[Fv];("hp"(cal(D)))$, mentre nella regola $forall E$, il termine $t$ deve essere libero per $x$ in $phi$. La regola di eliminazione è intuitiva in quanto, se la formula $phi(x)$ vale per ogni valore della variabile $x$, allora essa vale anche per un particolare termine $t$. La condizione sul termine $t$, invece, serve ad evitare la cattura dei nomi delle variabili. La regola di introduzione formalizza, invece, il ragionamento matematico del tipo "sia $x$ arbitrario; dimostriamo che vale $phi(x)$; siccome $x$ era arbitrario, vale $forall x. phi(x)$". La condizione $x in.not #pb[Fv];("hp"(cal(D)))$ esprime proprio l'arbitrarietà di $x$, in quanto, per introdurre il quantificatore $forall x$, la variabile $x$ non deve essere libera nelle ipotesi non scaricate, poiché se $x$ comparisse libera nelle ipotesi, essa non sarebbe più arbitraria, bensì soggetta alle condizioni imposte dalle ipotesi stesse. Si noti la differenza tra le due regole: nella regola $forall E$, il fatto che $phi(x)$ valga per ogni $x$ ci permette di sostituire la variabile $x$ con qualunque termine $t$ libero per $x$ in $phi$. Nella regola $forall I$, invece, l'universalità va _guadagnata_, e la condizione sulle ipotesi garantisce che non stiamo generalizzando un fatto che vale soltanto per un particolare valore della variabile $x$.

#esempio[
  La condizione su $forall I$ è indispensabile. Infatti, consideriamo la seguente _derivazione_:
  #albero(rule(name: $forall E$, $0 = 0 -> forall x. (x = 0)$, rule(name: $forall I$, $forall x. (x = 0 -> forall x. (x = 0))$, rule(name: $-> I^1$, $x = 0 -> forall x. (x = 0)$, rule(name: [$forall I$ ✗], $forall x. (x = 0)$, $[x = 0]^1$)))))
  La conclusione è semanticamente assurda, in quanto afferma che, se $0 = 0$, allora ogni elemento è uguale a $0$. L'errore è nella prima applicazione della regola $forall I$, che viola la condizione imposta dalla regola stessa. Infatti, la variabile $x$ è libera nell'ipotesi $x = 0$, che non è ancora stata scaricata, per cui $x$ non è una variabile arbitraria.
]

#esempio[
  Anche la condizione su $forall E$ è indispensabile. Infatti, consideriamo la seguente _derivazione_:
  #albero(rule(name: $-> I^1$, $forall x. not forall y. (x = y) -> not forall y. (y = y)$, rule(name: [$forall E$ ✗], $not forall y. (y = y)$, $[forall x. not forall y. (x = y)]^1$)))
  La premessa afferma che, per ogni $x$, non tutti gli elementi sono uguali ad $x$, ed è vera in ogni struttura con almeno due elementi, mentre la conclusione afferma che non tutti gli elementi sono uguali a sé stessi, ed è sempre falsa. L'errore è nell'applicazione della regola $forall E$, in quanto si sta eseguendo la sostituzione $[y slash x]$, con il termine $y$ che non è libero per $x$ in $not forall y. (x = y)$, per cui la variabile $y$ sostituita viene catturata dal quantificatore.
]

#esempio[
  Dimostriamo $tack forall x. phi -> forall z. phi[z slash x]$, dove $z$ è una variabile nuova, che non compare in $phi$.
  #albero(rule(name: $-> I^1$, $forall x. phi -> forall z. phi[z slash x]$, rule(name: $forall I$, $forall z. phi[z slash x]$, rule(name: $forall E$, $phi[z slash x]$, $[forall x. phi]^1$))))
  L'applicazione della regola $forall E$ è corretta, poiché la variabile $z$ è nuova e, quindi, non può essere catturata in $phi$. L'applicazione della regola $forall I$ è corretta, poiché $z$ non è tra le variabili libere delle ipotesi non scaricate, ovvero di $forall x. phi$. Questo teorema esprime il fatto che rinominare una variabile legata non cambia il significato di una formula.
]

#esempio[
  Dimostriamo $tack forall x. forall y. phi(x, y) -> forall y. forall x. phi(x, y)$, ossia che i quantificatori universali commutano.
  #albero(rule(name: $-> I^1$, $forall x. forall y. phi(x, y) -> forall y. forall x. phi(x, y)$, rule(name: $forall I$, $forall y. forall x. phi(x, y)$, rule(name: $forall I$, $forall x. phi(x, y)$, rule(name: $forall E$, $phi(x, y)$, rule(name: $forall E$, $forall y. phi(x, y)$, $[forall x. forall y. phi(x, y)]^1$))))))
  Le due eliminazioni sostituiscono $x$ a $x$ e $y$ a $y$, mentre le due introduzioni sono corrette poiché né $x$ né $y$ sono libere nell'ipotesi.
]

#esempio[
  Dimostriamo $tack forall x. (phi and psi) -> (forall x. phi and forall x. psi)$.
  #albero(rule(name: $-> I^1$, $forall x. (phi and psi) -> (forall x. phi and forall x. psi)$, rule(name: $and I$, $forall x. phi and forall x. psi$,
    rule(name: $forall I$, $forall x. phi$, rule(name: $and E_1$, $phi$, rule(name: $forall E$, $phi and psi$, $[forall x. (phi and psi)]^1$))),
    rule(name: $forall I$, $forall x. psi$, rule(name: $and E_2$, $psi$, rule(name: $forall E$, $phi and psi$, $[forall x. (phi and psi)]^1$))))))
]

#esempio[
  Dimostriamo $tack forall x. (phi -> psi(x)) -> (phi -> forall x. psi(x))$, che vale se $x in.not #pb[Fv];(phi)$. Se, invece, la variabile $x$ fosse libera in $phi$, la formula ammetterebbe un contromodello.
  #albero(rule(name: $-> I^2$, $forall x. (phi -> psi(x)) -> (phi -> forall x. psi(x))$, rule(name: $-> I^1$, $phi -> forall x. psi(x)$, rule(name: $forall I$, $forall x. psi(x)$, rule(name: $-> E$, $psi(x)$, $[phi]^1$, rule(name: $forall E$, $phi -> psi(x)$, $[forall x. (phi -> psi(x))]^2$))))))
  L'applicazione della regola $forall I$ è corretta proprio perché $x$ non è libera nelle ipotesi non scaricate, $phi$ e $forall x. (phi -> psi(x))$, siccome $x in.not #pb[Fv];(phi)$.
]

Sebbene il quantificatore $exists$ possa essere definito come $not forall not$, è utile avere a disposizione delle regole dirette, che corrispondono al modo in cui si ragiona con il quantificatore esistenziale in matematica.
#alberi(
  rule(name: $exists I$, $exists x. phi(x)$, $phi(t)$),
  rule(name: $exists E$, $psi$, deriv($cal(D)$, $exists x. phi(x)$), deriv($[phi(x)]$, $cal(D)'$, $psi$)),
)
La regola $exists I$ richiede che il termine $t$ sia libero per la variabile $x$ in $phi$, per evitare la cattura dei nomi delle variabili, mentre la regola $exists E$ richiede che $x in.not #pb[Fv];(psi)$ e $x in.not #pb[Fv];("hp"(cal(D)') without {phi(x)})$. La regola di introduzione è intuitiva in quanto, se $phi$ vale per un particolare termine $t$, allora esiste un oggetto per cui vale la formula $phi$. La regola di eliminazione, invece, assomiglia molto alla regola $or E$, e infatti un esistenziale può essere visto come una disgiunzione, eventualmente infinita, su tutti gli elementi del dominio. Essa formalizza il ragionamento matematico del tipo "sappiamo che esiste un $x$ tale che $phi(x)$; sia, allora, $x$ un tale oggetto; da $phi(x)$ deduciamo $psi$; siccome $psi$ non dipende da quale particolare $x$ del dominio abbiamo scelto, concludiamo $psi$". Le condizioni garantiscono proprio che $x$ sia un _nome nuovo_ per l'oggetto di cui si afferma l'esistenza, per cui $x$ non deve comparire libera nella conclusione $psi$, né nelle altre ipotesi usate per derivarla.

#esempio[
  Dimostriamo $tack exists x. (phi(x) and psi(x)) -> exists x. phi(x)$.
  #albero(rule(name: $-> I^2$, $exists x. (phi(x) and psi(x)) -> exists x. phi(x)$, rule(name: $exists E^1$, $exists x. phi(x)$, $[exists x. (phi(x) and psi(x))]^2$, rule(name: $exists I$, $exists x. phi(x)$, rule(name: $and E_1$, $phi(x)$, $[phi(x) and psi(x)]^1$)))))
  Si noti che non avremmo potuto applicare la regola $exists E$ concludendo direttamente $phi(x)$ e poi $exists x. phi(x)$ con la regola $exists I$ in quanto, siccome $x in #pb[Fv];(phi(x))$, la condizione della regola $exists E$ sarebbe violata. Bisogna, quindi, prima reintrodurre il quantificatore con $exists I$, e soltanto dopo eliminare la formula esistenziale nelle ipotesi.
]

#esempio[
  Dimostriamo $tack forall x. (phi(x) -> psi) -> (exists x. phi(x) -> psi)$, che vale se $x in.not #pb[Fv];(psi)$.
  #albero(rule(name: $-> I^3$, $forall x. (phi(x) -> psi) -> (exists x. phi(x) -> psi)$, rule(name: $-> I^2$, $exists x. phi(x) -> psi$, rule(name: $exists E^1$, $psi$, $[exists x. phi(x)]^2$, rule(name: $-> E$, $psi$, $[phi(x)]^1$, rule(name: $forall E$, $phi(x) -> psi$, $[forall x. (phi(x) -> psi)]^3$))))))
]

#esempio[
  Dimostriamo $tack exists x. (phi(x) or psi(x)) -> exists x. phi(x) or exists x. psi(x)$, combinando le regole per l'esistenziale con quelle per la disgiunzione.
  Per brevità, mostriamo la derivazione della conclusione a partire dall'ipotesi $exists x. (phi(x) or psi(x))$, a cui basta applicare $-> I$, e scriviamo $sigma = exists x. phi(x) or exists x. psi(x)$.
  #albero(rule(name: $exists E^2$, $sigma$, $exists x. (phi(x) or psi(x))$,
    rule(name: $or E^1$, $sigma$, $[phi(x) or psi(x)]^2$,
      rule(name: $or I$, $sigma$, rule(name: $exists I$, $exists x. phi(x)$, $[phi(x)]^1$)),
      rule(name: $or I$, $sigma$, rule(name: $exists I$, $exists x. psi(x)$, $[psi(x)]^1$)))))
]

#esempio[
  Dimostriamo $tack forall x. (x = x) -> exists y. (x = y)$, ovvero che, se ogni elemento è uguale a sé stesso, allora esiste un elemento uguale ad $x$. La derivazione è corretta, poiché $x$ è libero per $y$ in $x = y$.
  #albero(rule(name: $exists I$, $exists y. (x = y)$, rule(name: $forall E$, $x = x$, $forall x. (x = x)$)))
]

Notiamo che la differenza tra la logica dei predicati classica e la logica dei predicati intuizionistica non è legata all'espressività dei sistemi, ma ai principi logici classici che si usano o si scartano. Ad esempio, nella logica del primo ordine classica possiamo derivare il teorema $tack (not exists x. not phi) -> forall x. phi$ usando la regola $#pb[Raa]$, ma si può anche dimostrare che non è possibile rimuovere la regola $#pb[Raa]$ da questa derivazione.
#albero(rule(name: $-> I^2$, $(not exists x. not phi) -> forall x. phi$, rule(name: $forall I$, $forall x. phi$, rule(name: $#pb[Raa]^1$, $phi$, rule(name: $-> E$, $bot$, rule(name: $exists I$, $exists x. not phi$, $[not phi]^1$), $[not exists x. not phi]^2$)))))
Dunque, l'eventuale differenza di espressività tra i due sistemi è una conseguenza dei principi logici impiegati nel sistema deduttivo, nel caso in cui il teorema non ammetta un analogo senza l'utilizzo della regola $#pb[Raa]$ in logica intuizionistica.

#esempio[
  Dimostriamo $tack (phi -> exists x. psi(x)) -> exists x. (phi -> psi(x))$, quando $x in.not #pb[Fv];(phi)$. La prova si può costruire soltanto con $#pb[Raa]$, per cui il teorema, così come è enunciato, è derivabile soltanto in logica classica. Osserviamo che, nella derivazione, vorremmo _distruggere_ il quantificatore $exists x. psi(x)$ per ricavare la formula $psi(x)$, da poter usare in $phi -> psi(x)$. Per farlo, eliminiamo il quantificatore esistenziale, e dalla formula $psi(x)$ deriviamo _qualcosa di interessante_ in modo da poter derivare $exists x. (phi -> psi(x))$. Dunque, posto $beta = exists x. (phi -> psi(x))$, vorremmo partire da $not beta$, derivare $bot$ e quindi concludere $beta$ con $#pb[Raa]$.
  Per leggibilità, separiamo la derivazione in due parti. Sia $cal(D)_1$ la seguente derivazione di $bot$ a partire dalle ipotesi $psi(x)$ e $not beta$:
  #albero(rule(name: $-> E$, $bot$, rule(name: $exists I$, $exists x. (phi -> psi(x))$, rule(name: $-> I$, $phi -> psi(x)$, $[psi(x)]^1$)), $[not exists x. (phi -> psi(x))]^3$))
  La derivazione completa è allora la seguente.
  #albero(dimensione: 9pt, rule(name: $-> I^4$, $(phi -> exists x. psi(x)) -> exists x. (phi -> psi(x))$, rule(name: $#pb[Raa]^3$, $exists x. (phi -> psi(x))$, rule(name: $-> E$, $bot$,
    rule(name: $exists I$, $exists x. (phi -> psi(x))$, rule(name: $-> I^2$, $phi -> psi(x)$, rule(name: $bot_i$, $psi(x)$, rule(name: $exists E^1$, $bot$,
      rule(name: $-> E$, $exists x. psi(x)$, $[phi]^2$, $[phi -> exists x. psi(x)]^4$),
      deriv($[psi(x)]^1 quad [not beta]^3$, $cal(D)_1$, $bot$))))),
    $[not exists x. (phi -> psi(x))]^3$))))
  Si noti che, nella derivazione $cal(D)_1$, potremmo scaricare soltanto la formula $phi$ tra le ipotesi del sottoalbero che porta a $phi -> psi(x)$. Siccome in tale sottoalbero non esiste l'ipotesi $phi$, non la si può scaricare. Tuttavia, se $psi(x)$ è vera per ipotesi, allora è corretto dedurre $phi -> psi(x)$ senza scaricare alcuna ipotesi, ovvero mediante scaricamento vacuo. L'applicazione di $exists E^1$ richiede, inoltre, $x in.not #pb[Fv];(phi)$, poiché $phi$ è tra le ipotesi non scaricate e quindi, per definizione, la condizione sull'esistenziale vale soltanto se $x in.not #pb[Fv];(phi)$. Questo è un esercizio difficile, ma molto istruttivo.
]

#esercizio[
  Si dimostrino i seguenti teoremi in deduzione naturale:
  + $tack exists x. (phi(x) and psi) <-> exists x. phi(x) and psi$, se $x in.not #pb[Fv];(psi)$
  + $tack forall x. (phi(x) or psi) <-> forall x. phi(x) or psi$, se $x in.not #pb[Fv];(psi)$
  + $tack forall x. phi(x) <-> not exists x. not phi(x)$
  + $tack not forall x. phi(x) <-> exists x. not phi(x)$
  + $tack not exists x. phi(x) <-> forall x. not phi(x)$
  + $tack exists x. (phi(x) -> psi) <-> (forall x. phi(x) -> psi)$, se $x in.not #pb[Fv];(psi)$
  + $tack exists x. (phi -> psi(x)) <-> (phi -> exists x. psi(x))$, se $x in.not #pb[Fv];(phi)$
  + $tack exists x. exists y. phi <-> exists y. exists x. phi$
  + $tack exists x. phi <-> phi$, se $x in.not #pb[Fv];(phi)$
]

Dalle regole di derivazione per il quantificatore $forall$, seguono immediatamente le seguenti proprietà della derivabilità:
- se $Gamma tack phi(x)$ e $x in.not #pb[Fv];(psi)$ per ogni $psi in Gamma$, allora $Gamma tack forall x. phi(x)$
- se $Gamma tack forall x. phi(x)$ e $t$ è libero per $x$ in $phi$, allora $Gamma tack phi(t)$

Il simbolo di uguaglianza, invece, deve ricevere un trattamento speciale, poiché vogliamo che esso si comporti come la vera uguaglianza tra oggetti. In particolare, l'uguaglianza deve essere almeno una relazione di equivalenza, e deve essere compatibile con le funzioni e i predicati del linguaggio. Questo è garantito dai seguenti _assiomi dell'identità_:
+ $forall x. (x = x)$
+ $forall x y. (x = y -> y = x)$
+ $forall x y z. (x = y and y = z -> x = z)$
+ $forall x_1 dots x_n y_1 dots y_n. (and.big_(i = 1)^n x_i = y_i -> t(x_1, dots, x_n) = t(y_1, dots, y_n))$
+ $forall x_1 dots x_n y_1 dots y_n. (and.big_(i = 1)^n x_i = y_i -> (phi(x_1, dots, x_n) -> phi(y_1, dots, y_n)))$
I primi tre assiomi affermano che la relazione $=$ è una relazione di equivalenza, mentre gli ultimi due affermano che termini uguali possono essere sostituiti all'interno di termini e formule. In deduzione naturale, gli assiomi corrispondono alle seguenti regole di derivazione:
#alberi(
  rule(name: $#pb[Ri]_1$, $x = x$),
  rule(name: $#pb[Ri]_2$, $y = x$, $x = y$),
  rule(name: $#pb[Ri]_3$, $x = z$, $x = y$, $y = z$),
)
#alberi(
  rule(name: $#pb[Ri]_4$, $t(x_1, dots, x_n) = t(y_1, dots, y_n)$, $x_1 = y_1 quad dots quad x_n = y_n$),
  rule(name: $#pb[Ri]_5$, $phi(y_1, dots, y_n)$, $x_1 = y_1 quad dots quad x_n = y_n$, $phi(x_1, dots, x_n)$),
)
dove $y_1, dots, y_n$ sono liberi per $x_1, dots, x_n$ in $phi$. Si può dimostrare che è sufficiente richiedere le regole $#pb[Ri]_4$ e $#pb[Ri]_5$ per i soli simboli di predicato e di funzione del linguaggio, ossia
#alberi(
  rule($P_i (y_1, dots, y_(r_i))$, $x_1 = y_1 quad dots quad x_(r_i) = y_(r_i)$, $P_i (x_1, dots, x_(r_i))$),
  rule($f_j (x_1, dots, x_(a_j)) = f_j (y_1, dots, y_(a_j))$, $x_1 = y_1 quad dots quad x_(a_j) = y_(a_j)$),
)
poiché, a partire da queste due regole, le regole generali di uguaglianza $#pb[Ri]_1$, $#pb[Ri]_2$ e $#pb[Ri]_3$ sono derivabili mediante deduzione naturale.

== _La Semantica della Logica dei Predicati_

Dopo aver definito la nozione di derivabilità e le regole di deduzione naturale per la logica del primo ordine, vorremmo attribuire un significato semantico alle formule del primo ordine. A differenza della logica proposizionale, in cui era sufficiente assegnare un valore di verità agli atomi, per la logica del primo ordine dobbiamo stabilire di quali oggetti discutano le formule, ossia fissare una struttura che determini come interpretare i simboli del linguaggio derivante dal suo tipo di similarità. Lo scopo è quello di fornire un significato semantico, ossia _denotare_, ad ogni oggetto sintattico del linguaggio formale.

#definizione[
  Sia $cal(L)$ un linguaggio di tipo $⟨ r_1, dots, r_n; a_1, dots, a_m; kappa ⟩$ e sia $frak(A) = ⟨ A, R_1, dots, R_n, F_1, dots, F_m, {c_i}_(i < kappa) ⟩$ una struttura dello stesso tipo di similarità. Una _interpretazione_ di $cal(L)$ in $frak(A)$ è una funzione $I$ di interpretazione che associa ad ogni simbolo dell'alfabeto un elemento della struttura:
  $
    I(P_i) = R_i, quad quad I(f_j) = F_j, quad quad I(overline(c)_i) = c_i
  $
]

In altre parole, l'interpretazione è una corrispondenza biunivoca tra i simboli dell'alfabeto, ovvero la struttura sintattica, e gli elementi della struttura matematica, ovvero la struttura semantica. Rimane da stabilire, dunque, soltanto il significato delle variabili libere di una formula. Con questo scopo, introduciamo la nozione di _ambiente_, ovvero l'oggetto semantico che assegna un oggetto matematico del dominio della struttura ad ogni variabile.

#definizione[
  Data una struttura $frak(A)$ e un'interpretazione $I$, un _ambiente_, o _assegnamento_, è una funzione $rho : "Var" -> |frak(A)|$. L'insieme di tutti gli ambienti è $#pb[Env] = {rho | rho : "Var" -> |frak(A)|}$.
]

Si noti che, siccome le variabili sono infinite, un ambiente è una funzione con dominio infinito. A partire da un'interpretazione e da un ambiente, quindi, possiamo calcolare il valore di ogni termine, ovvero l'oggetto matematico del dominio ad esso associato.

#definizione[
  L'_interpretazione dei termini_ del linguaggio $cal(L)$ in $frak(A)$ è la funzione $[| dot |]_frak(A) : #pb[Term] times #pb[Env] -> |frak(A)|$ tale che
  $
    [| overline(c) |]_frak(A)^rho = I(overline(c)), quad quad [| x |]_frak(A)^rho = rho(x), quad quad [| f(t_1, dots, t_k) |]_frak(A)^rho = I(f)([| t_1 |]_frak(A)^rho, dots, [| t_k |]_frak(A)^rho)
  $
  Quando $frak(A)$ è chiara dal contesto, la omettiamo, e scriviamo $[| t |]_rho$ oppure $t^rho$.
]

Si noti che $overline(c)$ è un elemento sintattico, mentre $I(overline(c))$ è l'elemento semantico corrispondente, e che le funzioni $[| dot |]$ assegnano un significato semantico ai termini. Ad esempio, nella struttura $⟨ NN, +, 0 ⟩$, con l'ambiente $rho(x) = 3$, il termine $f(x, overline(c))$ è interpretato come $[| f(x, overline(c)) |]_rho = I(f)(rho(x), I(overline(c))) = 3 + 0 = 3$. Possiamo, ora, definire quando una formula è soddisfatta in una struttura, rispetto ad un ambiente. Per la definizione dei quantificatori, usiamo la notazione
$
  rho[a slash x](y) = cases(a & "se" y = x, rho(y) & "altrimenti")
$
che indica l'ambiente che coincide con $rho$ su tutte le variabili, tranne $x$, a cui è assegnato il valore $a$.

#definizione[
  La _relazione di soddisfacibilità_ $frak(A), rho tack.rr phi$, che si legge "la formula $phi$ è soddisfatta nella struttura $frak(A)$ con l'ambiente $rho$", è definita per induzione sulla struttura della formula $phi$:
  + $frak(A), rho tack.rr P(t_1, dots, t_k)$ se e solo se $([| t_1 |]_rho, dots, [| t_k |]_rho) in I(P)$
  + $frak(A), rho tack.rr t_1 = t_2$ se e solo se $[| t_1 |]_rho = [| t_2 |]_rho$
  + $frak(A), rho tack.rr.not bot$
  + $frak(A), rho tack.rr phi and psi$ se e solo se $frak(A), rho tack.rr phi$ e $frak(A), rho tack.rr psi$
  + $frak(A), rho tack.rr phi or psi$ se e solo se $frak(A), rho tack.rr phi$ oppure $frak(A), rho tack.rr psi$
  + $frak(A), rho tack.rr not phi$ se e solo se $frak(A), rho tack.rr.not phi$
  + $frak(A), rho tack.rr phi -> psi$ se e solo se $frak(A), rho tack.rr.not phi$ oppure $frak(A), rho tack.rr psi$
  + $frak(A), rho tack.rr forall x. phi$ se e solo se $frak(A), rho[a slash x] tack.rr phi$ per ogni $a in |frak(A)|$
  + $frak(A), rho tack.rr exists x. phi$ se e solo se $frak(A), rho[a slash x] tack.rr phi$ per qualche $a in |frak(A)|$
]

Commentiamo brevemente la definizione. Il punto ($i$) afferma che una formula atomica è vera se la tupla dei valori dei termini appartiene alla relazione che interpreta il predicato. Ad esempio, $frak(A), rho tack.rr overline(2) <= overline(3)$ se e solo se $(2, 3) in thin <=$, ovvero se e solo se $2 <= 3$, che è banalmente vero. Si noti che la relazione semantica coincide con quella sintattica quando l'uguaglianza è sintatticamente vera, per cui il punto ($i i$) afferma che $t_1 = t_2$ è soddisfatta quando i due termini denotano lo stesso oggetto. Ad esempio, i termini $f(x)$ e $g(x)$ possono essere termini sintatticamente diversi, ma denotare lo stesso elemento. Il punto ($i i i$) afferma che non si può soddisfare il falso. I punti ($i v$)-($v i i$) sono la traduzione, nel metalinguaggio, dei connettivi logici. Infine, i punti ($v i i i$) e ($i x$) affermano che $forall x. phi$ è vera se $phi$ è vera per _ogni_ valore assegnato ad $x$, mentre $exists x. phi$ è vera se $phi$ è vera per _almeno un_ valore assegnato ad $x$. Si noti, in particolare, che queste affermazioni sono indecidibili in generale, in quanto non esiste un algoritmo che, data una struttura e una formula, stabilisca se la formula è soddisfatta, poiché il dominio della struttura può essere infinito, e la verifica dei quantificatori richiederebbe di esaminare infiniti elementi. Analogamente a quanto fatto per i termini, possiamo definire una funzione di interpretazione semantica delle formule logiche del primo ordine
$
  [| dot |]_frak(A) : #pb[Form] times #pb[Env] -> {top, bot}, quad quad [| beta |]_frak(A)^rho = top <==> frak(A), rho tack.rr beta
$
e, quando non c'è ambiguità, scriveremo semplicemente $beta^rho$ al posto di $[| beta |]_frak(A)^rho$. A partire dalla relazione di soddisfacibilità, definiamo le nozioni semantiche fondamentali.

#definizione[Si dice che:
  - $frak(A) tack.rr phi$, ovver $frak(A)$ è un _modello_ di $phi$, se $frak(A), rho tack.rr phi$ per ogni ambiente $rho$
  - $tack.rr phi$, ovvero $phi$ è _valida_, o _vera_, se $frak(A) tack.rr phi$ per ogni struttura $frak(A)$ del tipo appropriato
  - $frak(A) tack.rr Gamma$, ovvero $frak(A)$ è un _modello_ di $Gamma$, se $frak(A) tack.rr psi$ per ogni $psi in Gamma$
  - $Gamma tack.rr phi$, ovvero $phi$ è _conseguenza semantica_ di $Gamma$ se, per ogni struttura $frak(A)$ e ogni ambiente $rho$, se $frak(A), rho tack.rr psi$ per ogni $psi in Gamma$, allora $frak(A), rho tack.rr phi$
]

Si noti che, per le formule chiuse, l'ambiente è irrilevante:, in quanto il valore di verità di un enunciato dipende soltanto dalla sua struttura sintattica, poiché tutte le variabili sono legate.

#nota[
  Valgono, per le interpretazioni, alcune proprietà che legano la sostituzione sintattica alla modifica semantica dell'ambiente. In particolare, il seguente _lemma di sostituzione_ afferma che sostituire un termine $t$ al posto di $x$ equivale a valutare la formula in un ambiente in cui $x$ assume il valore di $t$:
  $
    [| s[t slash x] |]_rho = [| s |]_(rho[[| t |]_rho slash x]), quad quad frak(A), rho tack.rr phi[t slash x] <==> frak(A), rho[[| t |]_rho slash x] tack.rr phi
  $
  dove, nel secondo caso, $t$ è un termine libero per $x$ in $phi$. Inoltre, vale il seguente _teorema di sostituzione_:
  $ tack.rr t' = t'' => s[t' slash x] = s[t'' slash x] $
  $ tack.rr t' = t'' => (phi[t' slash x] <-> phi[t'' slash x]) $
  ossia termini uguali possono essere scambiati in termini e formule senza alterare il valore semantico del termine o della formula in cui è avvenuta la sostituzione.
]

== _Il Teorema di Correttezza per i Contromodelli_

Come è stato anticipato nel primo capitolo introduttivo, a partire da una sintassi e una semantica ben definite, è possibile dimostrare i Teoremi di Correttezza e Completezza per la logica del primo ordine:
$
  "(correttezza)" quad Gamma tack phi ==> Gamma tack.rr phi #h(4em) "(completezza)" quad Gamma tack.rr phi ==> Gamma tack phi
$
In particolare, il Teorema di Correttezza per la logica dei predicati afferma che, se la formula $phi$ è un teorema, ossia un risultato dimostrabile sintatticamente, allora ogni struttura e ogni ambiente devono renderlo semanticamente vero.

#teorema(title: [Teorema di Correttezza per #pb[Fol]])[
  Se $Gamma tack phi$, allora $Gamma tack.rr phi$.
]

La dimostrazione, che non è stata svolta a lezione e non sarà richiesta in sede d'esame, procede per induzione sulla derivazione, in modo del tutto analogo alla dimostrazione del Teorema di Completezza per la logica proposizionale. I casi nuovi sono quelli relativi alle regole di derivazione dei quantificatori, e per gestirli è necessario il lemma di sostituzione precedentemente enunciato. Il Teorema di Correttezza ha due conseguenze importanti.
- Il Teorema di Correttezza implica la _consistenza_ della logica del primo ordine in quanto, siccome $tack.rr.not bot$, vale anche $tack.not bot$. In altre parole, il sistema di deduzione della logica del primo ordine non può derivare contraddizioni.
- Per contrapposizione, per ogni formula $phi$ del primo ordine vale che $tack.rr.not phi ==> tack.not phi$. Dunque, per una formula $phi$ del primo ordine possiamo ottenere risultati di _non derivabilità_ esibendo un _contromodello_, ovvero una struttura $frak(A)$ e un ambiente $rho$ tali che $frak(A), rho tack.rr.not phi$. Se la formula è falsificata da una tale struttura e da un tale ambiente, allora $phi$ non può essere un teorema, per cui non può essere derivata nel sistema deduttivo della logica del primo ordine.

Si noti che il problema $tack.not^? phi$ è un problema indecidibile a causa della ricerca per ogni possibile dimostrazione derivabile nel sistema deduttivo, per cui il Teorema di Correttezza è lo strumento principale per dimostrare risultati di non derivailità come $tack.not phi$. Per esibire un _contromodello_ di una formula $phi$, ovvero la struttura e l'ambiente in grado di falsificare semanticamente la formula $phi$, osserviamo che
$
  tack.rr.not phi quad <==> quad exists frak(A). frak(A) tack.rr.not phi quad <==> quad exists frak(A), rho. frak(A), rho tack.rr.not phi
$
dunque dobbiamo cercare una struttura e un ambiente che falsifichino la formula $phi$. Vediamo alcuni esempi.

#esempio[
  Dimostriamo che $tack.not phi(x) -> forall x. phi(x)$. Intuitivamente, se una proprietà vale per un particolare $x$, non è detto che valga per tutti i valori della variabile $x$. Consideriamo la struttura $frak(A) = ⟨ {a, b}, P ⟩$ con $P = {a}$, ossia $P(a)$ vale e $P(b)$ no, e interpretiamo $phi$ come il predicato $P$. Sia $rho$ un ambiente tale che $rho(x) = a$. Allora $frak(A), rho tack.rr P(x)$, poiché $a in P$, ma $frak(A), rho tack.rr.not forall x. P(x)$, in quanto non è vero che $frak(A), rho[u slash x] tack.rr P(x)$ per ogni $u in {a, b}$, poiché $frak(A), rho[b slash x] tack.rr.not P(x)$. Dunque $frak(A), rho tack.rr.not P(x) -> forall x. P(x)$, e la formula non è derivabile mediante deduzione naturale. Questo esempio mostra, inoltre, perché la regola $forall I$ richiede che la variabile $x$ non sia libera nelle ipotesi. Infatti, altrimenti, assumendo $phi(x)$ nelle ipotesi e applicando la regola $forall I$, deriveremmo proprio questa formula, che è assurdo poiché la formula non è derivabile in deduzione naturale.
]

#esempio[
  Dimostriamo che $tack.not exists x. phi -> forall x. phi$. Consideriamo la struttura $frak(A) = ⟨ {a, b}, P ⟩$ con $P = {a}$, e interpretiamo $phi$ come $P(x)$. Vale che
  $
    frak(A), rho tack.rr.not exists x. phi -> forall x. phi quad <==> quad frak(A), rho tack.rr exists x. phi and exists x. not phi quad <==> quad frak(A), rho tack.rr exists x. phi "e" frak(A), rho tack.rr exists x. not phi
  $
  Osserviamo che esiste $u in {a, b}$ tale che $frak(A), rho[u slash x] tack.rr P(x)$, ossia $u = a$, ed esiste $w in {a, b}$ tale che $frak(A), rho[w slash x] tack.rr not P(x)$, ossia $w = b$. Dunque $frak(A), rho tack.rr.not exists x. phi -> forall x. phi$, per cui $tack.not exists x. phi -> forall x. phi$.
]

#esempio[
  Dimostriamo che $tack.not (forall x. phi(x) -> forall x. psi(x)) -> forall x. (phi(x) -> psi(x))$. Rinominiamo $alpha$ la premessa e $beta$ la conclusione della formula in considerazione. Il nostro scopo è quello di dimostrare che $tack.not alpha -> beta$, ossia trovare una struttura e un ambiente tali che $frak(A), rho tack.rr alpha$ e $frak(A), rho tack.rr.not beta$. Consideriamo $frak(A) = ⟨ {a, b}, P, Q ⟩$ con $P = {a}$ e $Q = {b}$, e interpretiamo $phi$ come $P$ e $psi$ come $Q$. Osserviamo che $frak(A), rho tack.rr alpha$, poiché
  $
    frak(A), rho tack.rr forall x. P(x) -> forall x. Q(x) quad <==> quad frak(A), rho tack.rr exists x. not P(x) or forall x. Q(x)
  $
  che è vero, poiché esiste $b$ tale che $frak(A), rho[b slash x] tack.rr not P(x)$, ossia $frak(A), rho[b slash x] tack.rr.not P(x)$. D'altra parte,
  $
    frak(A), rho tack.rr not beta quad <==> quad frak(A), rho tack.rr exists x. (P(x) and not Q(x)) quad <==> quad exists u in {a, b}. thick frak(A), rho[u slash x] tack.rr P(x) and not Q(x)
  $
  che è vero per $u = a$, siccome $a in P$ e $a in.not Q$. Dunque $frak(A), rho tack.rr.not alpha -> beta$, e quindi $tack.not alpha -> beta$.
]

#esempio[
  Dimostriamo che $tack.not forall x. exists y. (x < y)$, ossia che esistono almeno una struttura ed un ambiente in cui la formula non è valida. Si noti che, sebbene la formula sia vera nei numeri naturali, è sufficiente fornire una struttura diversa ed un ambiente che la falsifichino semanticamente. Questo ragionamento è giustificato perché, per contrapposizione, l'affermazione $tack.rr forall x. exists y. (x < y)$ implicherebbe che la formula sia valida in ogni struttura e per ogni ambiente. Vale che $tack.rr.not forall x. exists y. (x < y) <==> exists frak(A), rho. thick frak(A), rho tack.rr.not forall x. exists y. (x < y)$. Consideriamo la struttura $frak(A) = ⟨ {1, 2, 3}, < ⟩$, con l'usuale ordinamento. Per $x = 3$ non esiste alcun $y in {1, 2, 3}$ tale che $3 < y$, per cui abbiamo costruito un contromodello. Formalmente, dovrebbe valere che per ogni $a in {1, 2, 3}$ esiste $b in {1, 2, 3}$ tale che $frak(A), rho[a slash x, b slash y] tack.rr x < y$, che è falso per $a = 3$.
]

#esempio[
  Dimostriamo che $tack.not exists y. forall x. (x < y)$, ovvero che esistono almeno una struttura ed un ambiente in cui non esiste un elemento maggiore di tutti. Consideriamo la struttura $frak(A) = ⟨ NN, < ⟩$. Applicando la definizione di semantica, vale che $frak(A), rho tack.rr.not exists y. forall x. (x < y)$ se e solo se non esiste $a in NN$ tale che, per ogni $b in NN$, $frak(A), rho[a slash y, b slash x] tack.rr x < y$. Questo è vero, poiché per $b = a + 1$ la disuguaglianza non vale. Alternativamente, possiamo verificare che $frak(A), rho tack.rr forall y. exists x. not (x < y)$ se e solo se per ogni $a in NN$ esiste $b in NN$ tale che $frak(A), rho[a slash y, b slash x] tack.rr not (x < y)$, ossia $b >= a$, che è sempre vero scegliendo $b = a + 1$.
]

#esempio[
  Dimostriamo che $tack.not exists x. phi(x) and exists x. psi(x) -> exists x. (phi(x) and psi(x))$. Chiamiamo $sigma_1$ la premessa e $sigma_2$ la conclusione, e cerchiamo $frak(A), rho$ tali che $frak(A), rho tack.rr sigma_1$ ma $frak(A), rho tack.rr.not sigma_2$. Consideriamo $frak(A) = ⟨ {a, b}, P, Q ⟩$ con $P = {a}$ e $Q = {b}$. Allora $frak(A), rho tack.rr exists x. P(x) and exists x. Q(x)$ se e solo se esiste $u in {a, b}$ tale che $frak(A), rho[u slash x] tack.rr P(x)$ ed esiste $w in {a, b}$ tale che $frak(A), rho[w slash x] tack.rr Q(x)$, che è vero per $u = a$ e $w = b$. D'altra parte, $frak(A), rho tack.rr sigma_2$ richiederebbe che esista $u in {a, b}$ tale che $frak(A), rho[u slash x] tack.rr P(x)$ e $frak(A), rho[u slash x] tack.rr Q(x)$, che è impossibile. Verifichiamolo formalmente: $frak(A), rho tack.rr not exists x. (P(x) and Q(x))$ se e solo se $frak(A), rho tack.rr forall x. (not P(x) or not Q(x))$, se e solo se per ogni $u in {a, b}$ vale $frak(A), rho[u slash x] tack.rr not P(x) or not Q(x)$, che è vero, poiché per $u = a$ vale $not Q$ e per $u = b$ vale $not P$.
]

#esercizio[
  Si dimostri, mediante contromodelli, che
  - $tack.not exists x. phi -> forall x. phi$
  - $tack.not forall x. exists y. phi -> exists y. forall x. phi$
  - $tack.not forall x. exists y. (x < y)$
  sono formule falsificabili in almeno una struttura finita ed un ambiente, per cui non sono derivabili nel sistema di deduzione della logica dei predicati.
]

== Il Teorema di Completezza di Henkin

Il Teorema di Completezza per la logica dei predicati, invece, dimostrato per la prima volta da Kurt Gödel nel 1929, afferma che
$
  tack.rr phi quad ==> quad tack phi
$
dove $tack.rr phi$ rappresenta la verità semantica della formula $phi$, e $tack phi$ la sua verità derivabile nel sistema logico deduttivo. In altre parole, ogni formula semanticamente vera ammette una dimostrazione nella logica del primo ordine, che è quindi completamente espressiva. Si noti che il problema di determinare se $tack phi$ a partire da una formula $phi$ del primo ordine è, in generale, indecidibile. Questo non significa che il sistema logico deduttivo non sia abbastanza potente, né che esistano formule del primo ordine tali che $tack.rr phi$ ma $tack.not phi$, ma significa soltanto che non può esistere un algoritmo in grado di risolvere il problema $tack^? phi$. Nella precedente sezione è stato presentato il Teorema di Correttezza della logica del primo ordine, per il quale vale che, per ogni formula $phi$ del primo ordine, si ha $tack phi ==> tack.rr phi$. Questo risultato non è stato dimostrato ma, in generale, determina la verità semantica dei teoremi che è possibile derivare nel sistema logico deduttivo. Sfortunatamente, però, il problema $tack^? phi$ è un problema indecidibile, per cui il Teorema di Correttezza è stato impiegato per dimostrare che $tack.not phi$ mediante la costruzione di contromodelli. Il Teorema di Completezza, invece, descrive la potenza espressiva del sistema logico e, in particolare, afferma che, se una formula è semanticamente vera in ogni struttura ed ogni ambiente, allora esiste una derivazione per tale formula nel sistema logico deduttivo. Per dimostrare il Teorema di Completezza, dimostriamo prima una verità più debole, ovvero
$
  Gamma tack.rr phi quad ==> quad Gamma tack phi
$
dove $Gamma$ è un insieme di formule del primo ordine, che costituisce un insieme di ipotesi. In questa sezione, con la notazione $cal(L)$ indicheremo un linguaggio arbitrario del primo ordine, mentre con la notazione $#pb[Wff]_cal(L)$, ovvero l'insieme di _Well-Formed Formulas in_ $cal(L)$, indicheremo l'insieme delle formule ben formate per la sintassi del linguaggio $cal(L)$.

#definizione(numbered: false)[
  Un insieme di formule ben formate in un sistema logico $cal(L)$, ossia $Gamma subset.eq #pb[Wff]_cal(L)$, è detto _consistente_ se e solo se $Gamma tack.not bot$, ovvero se non è possibile derivare il falso, o l'assurdo.
]

La notazione $Gamma subset.eq #pb[Wff]_cal(L)$ indica che $Gamma$ è un insieme di formule sintatticamente corrette secondo le regole di sintassi del linguaggio $cal(L)$. Si noti che, la consistenza di un insieme di formule $Gamma$, è definita a livello _sintattico_ delle formule in $Gamma$, ovvero $Gamma tack.not bot$, e non a livello _semantico_, ovvero $Gamma tack.rr.not bot$. La consistenza dell'insieme di formule $Gamma$, quindi, indica che non è possibile derivare, nel sistema logico deduttivo definito dal linguaggio $cal(L)$, una contraddizione, mediante l'applicazione di regole di derivazione a partire da un'insieme di ipotesi contenuto in $Gamma$.

#proposizione(numbered: false)[
  Un insieme inconsistente può essere caratterizzato in tre modi diversi ma equivalenti:
  $
    Gamma tack bot quad <==> quad forall phi. thick Gamma tack phi quad <==> quad exists phi. thick Gamma tack phi "e" Gamma tack not phi
  $
]

Questo ci permette di caratterizzare la consistenza di un insieme di formule $Gamma$ in tre modi distinti, ognuno dei quali sarà utile nel corso della dimostrazione. Come nella dimostrazione del Teorema di Completezza per la logica proposizionale, sarà utile ragionare mediante insiemi di formule $Gamma$ massimalmente consistenti, in quanto, per questa tipologia di insiemi di formule, valgono una serie di proprietà utili e pratiche per la dimostrazione del teorema. 

#definizione(numbered: false)[
  Un insieme di formule $Gamma$ è detto _massimalmente consistente_ se
  + $Gamma$ è consistente, ovvero $Gamma tack.not bot$
  + se esiste un insieme $Delta$ consistente, ovvero $Delta tack.not bot$, tale che $Gamma subset.eq Delta$, allora $Gamma = Delta$. In altre parole, l'insieme $Gamma$ non può essere esteso mediante formule aggiuntive, garantendone ancora la consistenza
]

La seguente proposizione permette di collegare la consistenza sintattica di un insieme di formule $Gamma$ alla sua validità semantica. Questo è il primo ponte tra sintassi e semantica costruito dalla dimostrazione, su insiemi di formule consistenti.

#proposizione(numbered: false)[
  Sia $Gamma subset.eq #pb[Wff]_cal(L)$. Se $Gamma tack bot$, allora per ogni $cal(L)$-interpretazione $(frak(A), rho_frak(A))$, ovvero ogni interpretazione semantica del linguaggio $cal(L)$ costituita da una struttura $frak(A)$ ed un ambiente $rho_frak(A)$, vale che $frak(A), rho_frak(A) tack.rr.not Gamma$. Equivalentemente, per contrapposizione, se esistono $frak(A), rho_frak(A)$ tali che $frak(A), rho_frak(A) tack.rr Gamma$, allora $Gamma$ è consistente.
]

Questa proposizione è una conseguenza del Teorema di Correttezza. Il risultato chiave del Teorema di Completezza, invece, sarà la direzione opposta di questa proposizione, e costituisce il risultato obiettivo della dimostrazione del teorema.

#proposizione(numbered: false, title: [Obiettivo da dimostrare])[
  Sia $Gamma subset.eq #pb[Wff]_cal(L)$. Se $Gamma tack.not bot$, ovvero $Gamma$ è consistente, allora $Gamma$ è semanticamente soddisfacibile, ovvero esistono $frak(A), rho_frak(A)$ tali che $frak(A), rho_frak(A) tack.rr Gamma$. Equivalentemente, per contrapposizione, se non esistono $frak(A), rho_frak(A)$ tali che $frak(A), rho_frak(A) tack.rr Gamma$, allora $Gamma$ è inconsistente, ovvero $Gamma tack bot$.
]

Per alleggerire e semplificare la dimostrazione, useremo soltanto l'insieme minimo e indispensabile delle regole di derivazione e dei connettivi logici. In particolare, nella dimostrazione non useremo i connettivi $or$ ed $exists$, che possono essere espressi mediante gli altri operatori. Infatti, il frammento della logica del primo ordine usato nella prova dispone dei connettivi ${and, ->, bot, forall}$. Useremo anche, talvolta, abbreviazioni del tipo $not phi := phi -> bot$ ed $exists x. phi := not forall x. not phi$. Sebbene la prima dimostrazione del Teorema di Completezza è dovuta a Kurt Gödel nel 1929, quella che forniremo nel corso della presente sezione è una formalizzazione successiva, dovuta a Leon Henkin, costruita con lo scopo di semplificare e alleggerire la comprensione della dimostrazione. In questa formalizzazione, l'idea della prova è quella di costruire un modello semantico dell'insieme di formule $Gamma$ a partire dalla _sintassi_ stessa delle formule in $Gamma$, dove il dominio del modello sarà costituito dai termini del linguaggio. Affinché questa idea funzioni, però, è necessario che ogni formula esistenziale derivabile nel sistema logico deduttivo garantisca l'esistenza di un _testimone_ sintattico, ovvero un termine del dominio che permetta di garantire la validità semantica di una formula esistenziale. Questo perché, con l'obiettvo di costruire un modello semantico a partire dalla sintassi di una formula, è necessario, nel caso in cui la formula contenga un quantificatore esistenzale, che la costruzione sia in grado di determinare quale oggetto del dominio permetta di garantire la validità semantica della formula esistenziale. Siccome il dominio del modello saranno i termini del linguaggio, è necessario, quindi, che ad ogni formula esistenziale sia associato un termine specifico del linguaggio, che permetta di determinare l'oggetto semantico del dominio in grado di validare semanticamente la formula esistenziale. Per questo motivo, introduciamo la seguente costruzione degli _insiemi di Henkin_.

#definizione(numbered: false, title: [Insieme di Henkin])[
  Sia $Gamma subset.eq #pb[Wff]_cal(L)$. Si dice che $Gamma$ è un _insieme di Henkin_ se, per ogni formula esistenziale $exists x. phi(x)$, esiste una costante $c$ tale che $Gamma tack exists x. phi(x) -> phi(c)$. Si noti che tale costante $c$ è un termine del linguaggio a livello sintattico, alla quale sarà associato, soltanto successivamente, un elemento semantico del dominio del modello. In sintesi, la costante $c$ deve essere tale per cui è possibile derivare sintatticamente la formula $phi(c)$ nel sistema logico deduttivo, a partire dall'ipotesi $exists x . phi(x)$.
]

In altre parole, per ogni formula contenente un quantificatore esistenziale, esiste un testimone sintattico $c$ nella sintassi del linguaggio formale $cal(L)$, che è in grado di garantire la validità sintattica della formula $phi(c)$ a partire dall'insieme di ipotesi $Gamma$. Naturalmente, l'esistenza della costante $c$ per ogni formula $phi$ a livello sintattico del linguaggio non è una proprietà banale, ed è una restrizione forte sull'insieme di formule in $Gamma$.

#proposizione(tdc: 2)[
  Se $Gamma$ è un insieme di Henkin in un linguaggio $cal(L)$, e $Delta subset.eq #pb[Wff]_cal(L)$ con $Gamma subset.eq Delta$, allora $Delta$ è un insieme di Henkin.
]

Questa proposizione ci permetterà di considerare, nelle successive argomentazioni, soltanto insiemi di Henkin $Gamma$, in quanto i risultati ottenuti per l'insieme $Gamma$ saranno naturalmente estendibili a tutti gli insiemi $Delta$ tali che $Gamma subset.eq Delta$, siccome anche $Delta$ è un insieme di Henkin. Lo scoglio principale riguarda il fatto che il risultato di completezza per la logica del primo ordine non riguarda soltanto insiemi di ipotesi $Gamma$ che sono anche insiemi di Henkin, ma insiemi di ipotesi $Gamma$ generici. Dunque, per rendere un insieme qualunque un insieme di Henkin, dobbiamo estendere il linguaggio formale $cal(L)$ con le costanti necessarie a rendere $Gamma$ un insieme di Henkin, e le formule che rendono tali costanti dei veri e propri testimoni sintattici.

#definizione(tdc: 3, title: [Estensione di Henkin])[
  + Sia $cal(L)$ un linguaggio formale. Definiamo la _H-estensione_ del linguaggio $cal(L)$ come un nuovo linguaggio formale $cal(L)^sharp$ ottenuto aggiungendo all'insieme di costanti del linguaggio $cal(L)$ l'insieme
    $
      H C = {c_phi "costante" | exists x. phi "è una" cal(L)"-formula"}
    $
    ovvero, per ogni formula esistenziale del tipo $exists x. phi in #pb[Wff]_cal(L)$, si aggiunge una costante $c_phi$ al linguaggio.
  + Dato un insieme di formule $Gamma subset.eq #pb[Wff]_cal(L)$, la _H-estensione_ dell'insieme $Gamma$ con $cal(L)^sharp$-formule, ovvero le formule ben formate nel linguaggio $cal(L)^sharp$, è definita come
  $
    Gamma^sharp = Gamma union {exists x. phi(x) -> phi(c_phi) | exists x. phi "è in" cal(L) "e" c_phi in H C}
  $
]

Il punto ($i$) della definizione aggiunge al linguaggio formale una costante per ogni formula esistenziale ben formata, mentre il punto ($i i$) aggiunge all'insieme di formule $Gamma$ le formule che permettono di rendere $Gamma$ un insieme di Henkin, usando le costanti aggiunte in $H C$. Per i linguaggi costruiti mediante estensioni di Henkin, vale il seguente risultato importante.

#lemma(tdc: 4)[
  Supponiamo $Gamma union {phi} subset.eq #pb[Wff]_cal(L)$. Se $Gamma scripts(tack)_(cal(L)^sharp) phi$, allora $Gamma scripts(tack)_cal(L) phi$.
]

In altre parole, ogni formula che è possibile derivare nel sistema logico deduttivo definito dal linguaggio $cal(L)^sharp$, è possibile derivarlo anche nel linguaggio $cal(L)$ originale. Questo lemma permette, quindi, di considerare soltanto insiemi di formule $Gamma$ nel linguaggio $cal(L)^sharp$, siccome i risultati dimostrati sulla derivabilità delle formule nel sistema logico deduttivo definito dal linguaggio $cal(L)^sharp$ si estendono naturalmente anche al linguaggio $cal(L)$. Inoltre, vale che $\#[cal(L)] = \#[cal(L)^sharp]$, ossia le cardinalità dei due linguaggi formali sono uguali. Infatti
$
  \#[cal(L)] = max{\#[R], \#[F], \#[C], aleph_0} = \#[cal(L)^sharp]
$
dove $R$, $F$ e $C$ sono gli insiemi di predicati, funzioni e costanti, e $aleph_0 = |NN|$. Si ha sempre almeno cardinalità pari a $aleph_0$, poiché le variabili in logica del primo ordine sono sempre infinite e numerabili, e l'unione non fa transitare la cardinalità da $aleph_0$ ad $aleph_1$. Infatti, soltanto la costruzione dell'insieme delle parti fa transitare la cardinalità da $aleph_0$ ad $aleph_1$.

#nota[
  Si evidenzia che i principi classici usati all'intero di questa dimostrazione del Teorema di Completezza possono essere sistematicamente rimossi e, quindi, è possibile dimostrare il Teorema di Completezza anche per le logiche intuizionistiche, modificando soltanto la semantica associata al sistema logico intuizionistico e del metalinguaggio usato per discutere la dimostrazione dei risultati del Teorema di Completezza. Tuttavia, questa estensione del teorema alle logiche intuizionistiche è particolarmente complessa e richiede diverse intuizioni e costruzioni non banali, e per questo motivo non sarà richiesta in sede d'esame. Uno scoglio che deve essere affrontato da una tale estensione alle logiche intuizionistiche, ad esempio, riguarda il fatto che non sappiamo, data una formula $exists x. phi$, derivare algoritmicamente la costante testimone $c_phi$ per la formula, per cui non è banale costruire una dimostrazione della formula $exists x . phi -> phi(c_phi)$ in logica intuizionistica. Noi ci limitiamo a dimostrare il Teorema di Completezza per la logica classica del primo ordine poiché, in questo caso, è sufficiente sapere che tale costante testimone esiste, senza doverla determinare effettivamente.
]

Possiamo anche estendere i risultati di derivabilità dimostrati per gli insiemi di Henkin $Gamma^sharp$ a generici insiemi di formule $Gamma$.

#lemma(tdc: 6)[
  Sia $Gamma$ un insieme di formule contenuto in $#pb[Wff]_cal(L)$. Allora, per ogni formula $phi in #pb[Wff]_cal(L)$, vale che, se $Gamma^sharp scripts(tack)_(cal(L)^sharp) phi$, allora $Gamma scripts(tack)_cal(L) phi$.
]

Questo lemma amplia il Lemma TdC.4 considerando anche l'estensione di Henkin dell'insieme di ipotesi, e non solo a livello di sistema logico deduttivo. Dunque, le formule di Henkin aggiunte all'insieme di formule $Gamma$ generico, non aumentano il potere espressivo del sistema logico deduttivo definito da $cal(L)$.

#proposizione(tdc: 7)[
  Sia $Gamma subset.eq #pb[Wff]_cal(L)$. Se $Gamma tack.not bot$, ovvero $Gamma$ è consistente, allora anche $Gamma^sharp tack.not bot$, ovvero anche $Gamma^sharp$ è consistente.
]

#dimostrazione[
  La prova è per contrapposizione in quanto, grazie al Lemma TdC.6, se $Gamma^sharp tack bot$, allora $Gamma tack bot$.
]

Costruendo l'estensione di Henkin $Gamma^sharp$ per un insieme di formule $Gamma$ e, quindi, aggiungendo a $Gamma^sharp$ le formule di Henkin, si introducono nuove formule esistenziali nel linguaggio $cal(L)^sharp$, le quali, a loro volta, richiedono nuovi testimoni sintattici. Dobbiamo, quindi, iterare la costruzione fintantoché ciascuna formula esistenziale introdotta dalla costruzione di un'estensione di Henkin ha un testimone sintattico ad essa associato.

#definizione(tdc: 8, title: [Chiusura di Henkin])[
  Sia $Gamma subset.eq #pb[Wff]_cal(L)$. Consideriamo la seguente costruzione induttiva, detta _sequenza della chiusura di Henkin_:
  - _caso base_: $Gamma_0 = Gamma$, se $cal(L) = cal(L)_0$
  - _passo induttivo_: $Gamma_(i + 1) = (Gamma_i)^sharp$, se $cal(L)_(i + 1) = (cal(L)_i)^sharp$
  Si definisce la _chiusura di Henkin_ dell'insieme di formule $Gamma$ come
  $
    Gamma^* = union.big_(i < omega) Gamma_i, quad "dove" Gamma^* subset.eq #pb[Wff]_(cal(L)^*) "con" cal(L)^* = union.big_(i < omega) cal(L)_i
  $
  ovvero, la chiusura di Henkin di un insieme di formule $Gamma$ è l'unione, per ogni valore $i in NN$, delle estensioni di Henkin $Gamma_i$ costruite induttivamente.
]

#teorema(tdc: 9, title: [Proprietà della chiusura di Henkin])[
  Sia l'insieme di formule $Gamma subset.eq #pb[Wff]_cal(L)$ un insieme consistente. Valgono le seguenti proprietà:
  + $\#[Gamma^*] = \#[Gamma]$
  + $Gamma^* tack.not bot$, ovvero $Gamma^*$ è consistente
  + $Gamma^*$ è un insieme di Henkin
  + per ogni $phi in #pb[Wff]_cal(L)$, vale che, se $Gamma^* scripts(tack)_(cal(L)^*) phi$, allora $Gamma scripts(tack)_cal(L) phi$
]

La proprietà ($i$) è valida siccome l'unione insiemistica non altera la cardinalità dei linguaggi anche quando l'unione avviene su un numero infinito ma numerabile di insiemi, mentre la proprietà ($i i i$) è valida poiché, per ogni formula $phi$, è sempre possibile trovare un testimone sintattico $c_phi$ nel linguaggio formale $cal(L)^*$, per costruzione della chiusura di Henkin del linguaggio $cal(L)$. Dunque considereremo, nelle argomentazioni successive, un insieme di formule $Gamma^*$ costruito mediante la chiusura di Henkin come rappresentante per tutti gli insiemi di Henkin $Gamma^sharp$ i quali, a loro volta, agiscono da testimoni per tutti gli insiemi di formule arbitrari $Gamma subset.eq #pb[Wff]_cal(L)$.

#dimostrazione(title: [Dimostrazione (Proprietà (ii))])[
  Supponiamo, per assurdo, che $Gamma^* tack bot$. Siccome stiamo utilizzando un ragionamento per assurdo, la presente dimostrazione è intrinsecamente classica. Per garantire che questa prova valga anche per le logiche intuizionistiche, è necessario utilizzare una tecnica di prova diversa. Di conseguenza, per definizione di derivazione in deduzione naturale, esiste un insieme finito di ipotesi $Sigma_1^0$ tale che $Sigma_1^0 tack bot$, con $Sigma_1^0 subset.eq Gamma^*$ e $Sigma_1^0 != emptyset$. Infatti, deve sempre esistere un insieme finito che permetta di derivare $bot$, siccome una derivazione è un oggetto finito che usa un numero finito di regole, formule ed ipotesi. Siccome $Sigma_1^0$ è finito, sia $Sigma_1^0 = {phi_1, dots, phi_n}$. Allora, per costruzione, esistono degli indici $i_1,dots,i_n$ tali che $Gamma_(i_1), dots, Gamma_(i_n)$, nella sequenza della chiusura di Henkin, contengono $Sigma_1^0$, ovvero $phi_1 in Gamma_(i_1), dots, phi_n in Gamma_(i_n)$. Sia $m := max{i_1, dots, i_n}$. Allora $Sigma_1^0 subset.eq Gamma_m$, poiché la sequenza è crescente, e ogni formula in $Sigma_1^0$ deve essere presente in $Gamma_m$. Ne deve seguire che $Gamma_m tack bot$. Questa, però, è una contraddizione siccome, per induzione sulla definizione della sequenza di Henkin e dalla Proposizione TdC.7, deve valere $Gamma_m tack.not bot$. Infatti, per costruzione vale che $Gamma_m = Gamma_(m - 1)^sharp$, e per ipotesi induttiva vale che $Gamma_(m - 1) tack.not bot$, poiché $Gamma tack.not bot$. Dunque deve valere che $Gamma_m tack.not bot$ siccome $Gamma_m$ è l'estensione di Henkin dell'insieme consistente $Gamma_(m-1)$, che genera una contraddizione. Dobbiamo concludere che $Gamma^* tack.not bot$.
]

#nota[
  Gli insiemi di Henkin sono _necessari_ per dimostrare la completezza della logica del primo ordine. Questo perché il quantificatore $exists x. phi(x)$ ragiona semanticamente su uno o più elementi del dominio, che sintatticamente sono modellati dai termini. Gli insiemi di Henkin colmano la distanza tra la formula sintattica $exists x. phi(x)$, che semanticamente può essere vera e sintatticamente derivabile, e un testimone sintattico $c_phi$ che garantisce l'esistenza di un elemento semantico $x$ tale che $phi(x)$.
]

Per estendere un insieme consistente ad un insieme massimalmente consistente nel caso proposizionale, si era fatto un utilizzo esplicito dell'enumerazione delle formule. Nel caso del primo ordine, invece, in cui il linguaggio può avere cardinalità arbitraria, impieghiamo uno strumento più potente, derivante dalla Teoria degli Insiemi.

#lemma(numbered: false, title: [Lemma di Zorn])[
  Sia $⟨ U, <= ⟩$ un insieme parzialmente ordinato tale che ogni sottoinsieme $V subset.eq U$ totalmente ordinato da $<=$, ovvero tale che, per ogni $a, b in V$, vale che $a <= b$ oppure $b <= a$, ammette un maggiorante, ovvero un upper bound, in $U$. Allora $U$ contiene un elemento massimale $z$ rispetto all'ordinamento $<=$, per cui non esiste un elemento $x in U$ tale che $z < x$.
]

In altre parole, se ogni catena ascendente dell'insieme $U$ rispetto all'ordinamento $<=$ ammette un maggiorante, allora esiste un elemento di $U$ maggiore di ogni altro elemento di $U$. Non dimostreremo il lemma, la cui prova è molto lunga e complessa, ma si sottolinea che questo lemma svolge un ruolo cruciale in molte altre dimostrazioni della matematica.

#teorema(numbered: false, title: [Zorn, 1935])[
  Il Lemma di Zorn è equivalente, in senso deduttivo e sintattico, nel sistema di deduzione logica, all'assioma della scelta.
]

L'_assioma della scelta_ è un principio classico che afferma che, data una qualunque famiglia di insiemi non vuoti, è sempre possibile assumere di poter scegliere un elemento da ciascuno di essi, anche se non è nota la procedura che permette di sceglierlo algoritmicamente. Formalmente, per ogni famiglia di insiemi $U$, esiste una funzione $f$ tale che, per ogni insieme $A in U$ non vuoto, vale che $f(A) in A$. In altre parole, la funzione $f$, detta _funzione di scelta_ su $U$, sceglie l'elemento corretto da ciascun insieme.

#teorema(tdc: 10, title: [Lemma di Lindenbaum])[
  Sia $Gamma subset.eq #pb[Wff]_cal(L)$ un insieme di formule consistente. Allora, esiste un insieme di formule $Gamma^#pb[Mc]$ tale che $Gamma subset.eq Gamma^#pb[Mc]$ e $Gamma^#pb[Mc]$ soddisfa due condizioni:
  + $Gamma^#pb[Mc]$ è massimalmente consistente
  + $Gamma^#pb[Mc]$ è un insieme di Henkin
]

#dimostrazione[
  Ancora una volta, ragioniamo per assurdo, per cui la presente dimostrazione vale solo per la logica dei predicati classica. Sia $Gamma^*$ la chiusura di Henkin dell'insieme di formule $Gamma$, che è consistente ed è un insieme di Henkin. Sia
  $
    E(Gamma^*) = {Delta | Delta tack.not bot, thick Delta subset.eq #pb[Wff]_(cal(L)^*), thick Gamma^* subset.eq Delta}
  $
  l'insieme di tutte le estensioni consistenti di $Gamma^*$. Definiamo l'ordine parziale $⟨ E(Gamma^*), subset.eq ⟩$, e sia $Sigma_1 := union.big_(Delta in K) Delta$, dove $K$ è una catena di elementi ordinati da $subset.eq$ in $E(Gamma^*)$, ossia $Sigma_1$ è l'unione degli elementi $Delta$ di una singola e generica catena $K$ di elementi di $E(Gamma^*)$ ordinati rispetto a $subset.eq$. Dimostriamo che
  + $Sigma_1$ è un maggiorante di $K$
  + $Sigma_1 tack.not bot$
  Il punto ($i$) segue naturalmente, siccome l'insieme $Sigma_1$ contiene ogni insieme $Delta in K$. Per il punto ($i i$), supponiamo che $Sigma_1 tack bot$. Allora esiste un insieme finito di formule $Sigma_1^0 subset.eq Sigma_1$ tale che $Sigma_1^0 tack bot$. Siccome $Sigma_1^0$ è finito, sia $Sigma_1^0 = {phi_1, dots, phi_n} subset.eq #pb[Wff]_(cal(L)^*)$. Allora, devono esistere gli insiemi $K_1, dots, K_n$ della catena $K$ tali che $phi_1 in K_1, dots, phi_n in K_n$. Siccome $K$ è una catena, esiste $K^+ in K$ tale che $Sigma_1^0 subset.eq K^+$, ossia $K^+ = max{K_1, dots, K_n} in K$, rispetto alla relazione di ordinamento $subset.eq$. Dunque, deve valere che $K^+ tack bot$, che è una contraddizione per costruzione, siccome $K^+ in E(Gamma^*)$ e, quindi, vale che $K^+ tack.not bot$ per definizione di $E(Gamma^*)$. Deve valere, quindi, che $Sigma_1 tack.not bot$. Per il _Lemma di Zorn_, dunque, siccome ogni sottoinsieme totalmente ordinata su $E(Gamma^*)$ rispetto alla relazione di ordinamento $subset.eq$, ovvero ogni catena $K$, ammette un maggiorante, per l'ordine parziale $⟨ E(Gamma^*), subset.eq ⟩$ esiste un elemento massimale $(Gamma^*)^#pb[Mc]$ tale che $(Gamma^*)^#pb[Mc] tack.not bot$ e $Gamma^* subset.eq (Gamma^*)^#pb[Mc]$ per costruzione di $E(Gamma^*)$. Siccome $Gamma^*$ è un insieme di Henkin, vale allora che $(Gamma^*)^#pb[Mc]$ è un insieme di Henkin. Infine, $(Gamma^*)^#pb[Mc]$ è massimale e consistente, dunque è massimalmente consistente, e il teorema è valido poiché $Gamma subset.eq Gamma^* subset.eq (Gamma^*)^#pb[Mc]$.
]

Volendo dimostrare che, se $Gamma tack.not bot$, allora $Gamma$ è soddisfacibile, dobbiamo collegare la sintassi della logica del primo ordine alla sua semantica, mediante i modelli semantici, o strutture. Ricordiamo la seguente proposizione, analoga al caso proposizionale.

#proposizione(tdc: 11)[
  Se $Gamma$ è massimalmente consistente, allora
  + $Gamma$ è chiuso rispetto alla derivabilità, ovvero se da $phi in Gamma$ deriviamo $psi$ con le regole del sistema deduttivo, allora $psi in Gamma$
  + per ogni $phi in #pb[Wff]_cal(L)$, vale che $phi in Gamma$ oppure $not phi in Gamma$
  + per ogni $phi in #pb[Wff]_cal(L)$, vale che $not phi in Gamma <==> phi in.not Gamma$
  + per ogni $phi, psi in #pb[Wff]_cal(L)$, vale che $(phi -> psi) in Gamma ==> (phi in Gamma ==> psi in Gamma)$
]

Nel punto ($i v$), si osservi che la prima implicazione, ovvero $phi -> psi$, è un'implicazione _sintattica_, ossia una formula del linguaggio formale $cal(L)$, mentre la seconda è un'implicazione _semantica_, nel metalinguaggio utilizzato per argomentare la proposizione. A partire dalla sintassi di un insieme di formule $Gamma$, quindi, costruiamo un _modello sintattico_, ovvero un modello costruito a partire dalla sintassi delle formule $phi in Gamma$, e che soddisfa ogni formula in $Gamma$. L'idea è di utilizzare, come dominio del modello, o della struttura, gli stessi termini sintattici dell'insieme di formule $Gamma$, identificando, però, i termini sintattici che l'insieme $Gamma$ dichiara uguali.

#proposizione(tdc: 12)[
  Sia $Gamma$ un insieme massimalmente consistente. Sia $tilde thin subset.eq #pb[Term] times #pb[Term]$ la relazione di equivalenza sui termini sintattici del linguaggio $cal(L)$, definita come
  $
    t tilde u quad <==> quad (t = u) in Gamma
  $
  Denotiamo con $||t||$ la classe di equivalenza sintattica del termine $t$, ossia $||t|| = {u in #pb[Term] | t tilde u}$.
]

Che $tilde$ sia una relazione di equivalenza segue dagli assiomi dell'identità e dalla chiusura dell'insieme $Gamma$ rispetto alla derivabilità. L'insieme $#pb[Term] slash tilde$ è detto _insieme quoziente_, ovvero l'insieme delle classi di equivalenza indotte dalla relazione $tilde$, che sono impiegate nelle formule dell'insieme $Gamma$ al posto di ogni singolo termine. Nelle argomentazioni successive, quindi, considereremo l'insieme $#pb[Term] slash tilde$ come dominio del modello sintattico.

#proposizione(tdc: 13)[
  Sia $Gamma$ un insieme massimalmente consistente, e siano $t_1, dots, t_n$ e $u_1, dots, u_n$ sequenze di $n$ termini tali che $(t_i = u_i) in Gamma$ per ogni $i in [n]$. Allora
  + per ogni simbolo di funzione $f$, vale che $(f(t_1, dots, t_n) = f(u_1, dots, u_n)) in Gamma$
  + per ogni simbolo di relazione $R$, vale che $R(t_1, dots, t_n) in Gamma <==> R(u_1, dots, u_n) in Gamma$
]

Questa proposizione garantisce che le funzioni e le relazioni del modello sintattico, che saranno successivamente introdotte, siano ben definite, ossia che non dipendano dal rappresentante scelto per ciascuna classe di equivalenza.

#definizione(tdc: 14, title: [Modello sintattico])[
  Sia $Delta subset.eq #pb[Wff]_cal(L)$ un insieme di Henkin massimalmente consistente. Definiamo il seguente _modello sintattico_ $frak(A) = ⟨ #pb[Term] slash tilde, [| dot |]^frak(A) ⟩$ come segue:
  + per ogni costante $c$, $c^frak(A) = ||c||$
  + per ogni simbolo di funzione $n$-aria $f in cal(F)^cal(L)$, $f^frak(A) (||t_1||, dots, ||t_n||) = ||f(t_1, dots, t_n)||$
  + per ogni simbolo di relazione $n$-aria $R in cal(R)^cal(L)$, $R^frak(A) (||t_1||, dots, ||t_n||) <==> R(t_1, dots, t_n) in Delta$
]

Questo _modello sintattico_ fornisce un'interpretazione semantica dell'insieme di formule sintattiche $Delta$, costruito a partire dalla sintassi del linguaggio formale $cal(L)$. Per questo motivo è chiamato modello sintattico. Intuitivamente, ogni termine sintattico denota semanticamente sé stesso o, meglio, la sua classe di equivalenza, e una relazione semantica vale tra una sequenza di $n$ oggetti semantici se e solo se l'insieme $Delta$ contiene una formula sintattica che garantisce la relazione tra gli $n$ termini sintattici corrispondenti.

#teorema(tdc: 15)[
  Sia $Delta subset.eq #pb[Wff]_cal(L)$ un insieme massimalmente consistente e di Henkin. Sia $frak(A)$ il modello sintattico associato, e sia $rho_frak(A)$ l'ambiente per le variabili definito come $rho_frak(A) (x) = ||x||$. Allora
  + $[| t |]_(rho_frak(A)) = ||t||$
  + $frak(A), rho_frak(A) tack.rr Delta$, ovvero l'insieme $Delta$ è soddisfacibile per il modello sintattico $frak(A)$ e l'ambiente $rho_frak(A)$
]

In altre parole, se un insieme di formule $Delta$ è massimalmente consistente e di Henkin, esso è soddisfacibile dal _modello sintattico_ associato. Dimostriamo, soltanto, un caso induttivo del punto ($i i$), anche se non sarà richiesto in sede d'esame.

#dimostrazione(title: [Dimostrazione (Caso del quantificatore universale)])[
  Vogliamo dimostrare la proprietà ($i i$) dimostrando che
  + se $phi in Delta$, allora $frak(A), rho_frak(A) tack.rr phi$
  + se $phi in.not Delta$, allora $frak(A), rho_frak(A) tack.rr.not phi$
  Dimostriamo questi due casi per una formula arbitraria $phi$ che contiene il quantificatore universale, ovvero tale per cui $phi := forall x. psi$.

  ($i$) Per ipotesi, vale che $forall x. psi in Delta$. Allora, a causa della chiusura dell'insieme $Delta$ rispetto alla derivabilità, e per la regola di derivazione $forall E$ della deduzione naturale, deve valere che, per ogni termine $t$, $psi[t slash x] in Delta$. Ne segue che, per ogni termine $t$, vale che $frak(A), rho_frak(A) tack.rr psi[t slash x]$, per ipotesi induttiva su $psi$. Ne possiamo concludere che
  $
    forall t in |frak(A)|. thick frak(A), rho_frak(A) [[| t |]_(rho_frak(A)) slash x] tack.rr psi quad <==>^([|t|]_(rho_frak(A))=||t||) quad forall t in |frak(A)|. thick frak(A), rho_frak(A) [ ||t|| slash x] tack.rr psi quad <==> quad frak(A), rho_frak(A) tack.rr forall x. psi
  $
  dove la prima equivalenza segue dal punto ($i$) del teorema, e l'ultima equivalenza dalla regola semantica del quantificatore $forall$, siccome ogni elemento del dominio è della forma $||t||$ per un qualche termine sintattico $t$.

  (b) Non è richiesta questa dimostrazione in sede d'esame, e non sarà fornita una prova formale. Si sottolinea, però, che nella dimostrazione devono essere utilizzate le proprietà degli insiemi di Henkin, e questo ci aiuta ad intuire perché gli insiemi di Henkin siano necessari per il Teorema di Completezza. Infatti, se $forall x. psi in.not Delta$, allora $exists x. not psi in Delta$, e il testimone sintattico $c$ fornito per definizione degli insiemi di Henkin è esattamente l'elemento semantico $||c||$ del dominio, o del modello sintattico, che permette di falsificare la formula $psi$. Infatti, deve valere che $(exists x. not psi -> not psi(c)) in Delta$ siccome $exists x. not psi in Delta$, e l'insieme di formule $Delta$ è un insieme di Henkin e chiuso per derivabilità. Di conseguenza, $not psi(c) in Delta$ per deduzione naturale mediante l'applicazione della regola di derivazione $-> E$, e, per ipotesi induttiva, deve valere che $exists c in |frak(A)| . frak(A), rho_frak(A) [ ||c|| \/ x ] tack.rr.not psi(c)$ . Ne segue che $frak(A), rho_frak(A) tack.rr exists x . not psi$ e, quindi, $frak(A), rho_frak(A) tack.rr.not forall x . psi$.
]

Giusti a questo punto, abbiamo tutti gli strumenti necessari per dimostrare il Teorema di Completezza nella formalizzazione di Leon Henkin.

#lemma(tdc: 16)[
  Se un insieme di formule $Gamma subset.eq #pb[Wff]_cal(L)$ è consistente, allora $Gamma$ è soddisfacibile.
]

#dimostrazione[
  Supponiamo che un insieme di formule $Gamma subset.eq #pb[Wff]_cal(L)$ sia consistente. Consideriamo, allora, l'insieme $(Gamma^*)^#pb[Mc]$, ottenuto dal _Lemma di Lindenbaum_ (Teorema TdC.10), che è massimalmente consistente e di Henkin. Per il Teorema TdC.15, possiamo definire il modello sintattico associato, per cui esiste una struttura $frak(A)$ e un ambiente $rho_frak(A)$ tale che $frak(A), rho_frak(A) tack.rr (Gamma^*)^#pb[Mc]$. Per costruzione di $(Gamma^*)^#pb[Mc]$, siccome $Gamma subset.eq (Gamma^*)^#pb[Mc]$, deve anche valere che $frak(A), rho_frak(A) tack.rr Gamma$.
]

#teorema(tdc: 17, title: [Teorema di Completezza per #pb[Fol]])[
  Se $Gamma tack.rr phi$, allora $Gamma tack phi$.
]

#dimostrazione[
  Supponiamo che, per un insieme di formule $Gamma$, vale che $Gamma tack.not phi$. Allora, deve valere che $Gamma, not phi tack.not bot$, per le proprietà degli insiemi di ipotesi $Gamma$. Infatti, in caso contrario, potremmo applicare la regola di derivazione #pb[Raa] del sistema logico deduttivo per derivare $Gamma tack phi$, che è una contraddizione. Per il Lemma TdC.16, deve valere che esistono una struttura $frak(A)$ e un ambiente $rho_frak(A)$ tali che $frak(A), rho_frak(A) tack.rr Gamma, not phi$. Ne segue che $frak(A), rho_frak(A) tack.rr Gamma$ e $frak(A), rho_frak(A) tack.rr not phi$, ovvero $frak(A), rho_frak(A) tack.rr.not phi$. Ne segue che deve anche valere che $Gamma tack.rr.not phi$. Per contrapposizione, quindi, vale che se $Gamma tack.rr phi$, allora $Gamma tack phi$.
]

Si noti che tutta la costruzione precedente è dedicata a dimostrare le relazioni tra un insieme di formule $Gamma$ consistente e la sua chiusura di Henkin massimalmente consistente $(Gamma^*)^#pb[Mc]$, a dimostrare la soddisfacibilità di insiemi massimalmente consistenti e di Henkin, e il collegamento tra questa tipologia di insiemi di formule e la loro derivabilità nel sistema logico deduttivo. Una volta terminata questa costruzione, la dimostrazione del Teorema di Completezza segue direttamente, e naturalmente, da tutti i risultati precedenti. Riassumendo, la catena di risultati è la seguente:
$
  Gamma tack.not bot & quad ==> quad Gamma^* tack.not bot "e" Gamma^* "è di Henkin" \
  & quad ==> quad (Gamma^*)^#pb[Mc] "è massimalmente consistente e di Henkin" \
  & quad ==> quad frak(A), rho_frak(A) tack.rr (Gamma^*)^#pb[Mc] "e" (Gamma^*)^#pb[Mc] supset.eq Gamma \
  & quad ==> quad frak(A), rho_frak(A) tack.rr Gamma \
  & quad ==> quad Gamma tack.rr.not bot
$

Dunque, per contrapposizione, vale che $Gamma tack.rr bot ==> Gamma tack bot$. Di conseguenza, vale che

$ Gamma tack.rr phi & quad ==> quad Gamma union {not phi} tack.rr bot \
  & quad ==> quad Gamma union {not phi} tack bot \
  & quad ==> quad Gamma tack phi
$

In particolare, per l'insieme di ipotesi $Gamma=emptyset$ vale che, se $tack.rr phi$, allora $tack phi$.
