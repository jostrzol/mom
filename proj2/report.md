---
title:  'MOM projekt 1'
author: Jakub Ostrzołek
---

Rozwiązanie zadania podzieliłem tematycznie na kilka części, z której każda
została opisana w osobnym rozdziale.

Wartość $M$ użyta w sprawozdaniu oznacza dowolną dostatecznie dużą stałą, która
nie ogranicza w danym kontekście rozwiązania (tzn. ustalenie większej wartości
$M$ nie zmieniłoby rozwiązania).

Zmienne pomocnicze z prostymi ograniczeniami równościowymi będą zapisywane
bezpośrednio w sekcji _Zmienne_.

W rozwiązaniu rozważana jest tylko sytuacja na jeden dzień, więc w domyśle
wszystkie wartości są w przeliczeniu na dzień, np. ilość produkowanego
półproduktu na dzień, ilość kupowanego materiału na dzień, itp.

## Zbiory

* $S = \{S1, S2\}$ -- dostępne materiały
* $D = \{D1, D2\}$ -- półprodukty wytwarzane w przygotowalni
* $W = \{W1, W2\}$ -- produkty końcowe tworzone w rozważanym procesie
* $R = \{1, 2, 3\}$ -- zakresy funkcji ceny kosztu jednostkowego materiału,
    w obrębie których funkcja jest liniowa

## Funkcja celu

$$max \{z - c^m - c^d - c^p - c^c\}$$

Zmienne:

* $z$ - łączne zyski ze sprzedaży [zł]
* $c^m$ - łączny koszt zakupu materiałów [zł]
* $c^d$ - łączny koszt dowozu materiałów [zł]
* $c^p$ - łączny koszt przetwarzania w przygotowalni [zł]
* $c^c$ - łączny koszt pracy zakładu obróbki cieplnej materiałów [zł]

Poszczególne koszty zostaną obliczone w kolejnych rozdziałach. Warto zauważyć,
że maksymalizując taką funkcję celu, koszty zakupu materiału są minimalizowane.
Będzie to przydatne już w kolejnym rozdziale.

## Zakup materiałów

Funkcje kosztu jednostkowego materiałów $S1$ i $S2$ są to odcinkami liniowe
funkcje o dziedzinie w zbiorze nieujemnych liczb rzeczywistych. Ponadto, funkcja
ta dla $S1$ jest wklęsła, a dla $S2$ wypukła. A zatem, mając na uwadze fakt, że
cena materiałów jest minimalizowana, możliwe jest obliczenie całkowitego kosztu
dla $S2$ bez użycia zmiennych całkowitoliczbowych. Dla $S1$ natomiast zajdzie
konieczność użycia zmiennych całkowitoliczbowych.

Parametry:

* $x^{max}_s \: \forall s \in S$ -- maksymalna ilość kupionego materiału $s$
    [tona]
* $c^{m}_{sr} \: \forall s \in S, \forall r \in R$ -- cena materiału $s$ w
    przedziale cenowym $r$ [zł/tona]
* $r^{b}_{sr} \: \forall s \in S, \forall r \in R$ -- prawa granica przedziału
    cenowego $r$ dla ceny materiału $s$ [tona]; dla $r = 3$ zmienna wynosi $M$,
    jeśli ostatni przedział ma być nieograniczony (tak jak w treści zadania)
* $r^{w}_{sr} \: \forall s \in S, \forall r \in R$ -- szerokość przedziału
    cenowego $r$ dla ceny materiału $s$ [tona]; parametr wyliczony w następujący
    sposób:
  * $r^{w}_{s1} = r^{b}_{s1}$
  * $r^{w}_{sr} = r^{b}_{sr} - r^{b}_{s(r-1)}$ dla $r > 1$

Zmienne:

* $x_{sr} \: \forall s \in S, \forall r \in R$ -- ilość kupionego materiału $s$
    w przedziale cenowym $r$ [tona]
* $x_s = \sum_{r \in R} x_{sr}$ -- całkowita ilość kupionego materiału $s$
    [tona]
* $v_r \in \{0, 1\} \: \forall r \in \{1, 2\}$ -- czy ilość kupionego materiału
    $S1$ przekracza prawą granicę przedziału cenowego $r$ (zmienna binarna)
* $c^m = \sum_{s \in S}\sum_{r \in R} x_{sr} c^{m}_{sr}$ -- łączny koszt zakupu
    materiałów [zł]

Ograniczenia:

* $x_s \le x^{max}_s \: \forall s \in S$ -- ilość kupionego materiału $s$ nie
    przekracza maksymalnej możliwej ilości do kupienia
* ograniczenia ustawiające ilość kupionego materiału $S2$ w danym przedziale
  * $x_{(S2)r} \ge 0 \: \forall r \in R$ -- ilość kupionego materiału $S2$ w
      każdym z przedziałów cenowych $r$ jest nieujemna
  * $x_{(S2)r} \le r^{w}_{(S2)r} \: \forall r \in R$ -- ilość kupionego materiału $S2$
      w każdym z przedziałów cenowych $r$ nie przekracza szerokości przedziału
* ograniczenia ustawiające ilość kupionego materiału $S1$ w danym przedziale
  * $v_1 r^{w}_{(S1)1} \le x_{(S1)1} \le r^{w}_{(S1)1}$ -- ilość
      kupionego materiału $S1$ w przedziale cenowym $1$ jest nie większa niż jego
      szerokość, a ponadto jest maksymalna, gdy przedział cenowy $1$ jest
      całkowicie wykorzystany  <!--_-->
  * $v_2 r^{w}_{(S1)2} \le x_{(S1)2} \le v_1 r^{w}_{(S1)2}$ --
      ilość kupionego materiału $S1$ w przedziale cenowym $2$ jest nie większa
      niż jego szerokość, a ponadto jest maksymalna, gdy przedział cenowy $2$ jest
      całkowicie wykorzystany; gdy $x_{(S1)2} > 0$, to przedział cenowy $1$ jest
      całkowicie wykorzystany <!--_-->
  * $0 \le x_{(S1)3} \le v_2 M$ --
      ilość kupionego materiału $S1$ w przedziale cenowym $3$ jest nieujemna; gdy
      $x_{(S1)3} > 0$, to przedział cenowy $2$ jest całkowicie wykorzystany <!--_-->

## Dowóz materiałów

W rozwiązaniu założyłem, że całość kupionego materiału jest gdzieś dowożona --
w przeciwnym wypadku nie opłacałoby się kupować takiej ilości materiału, więc
takie rozwiązanie nie mogłoby być optymalne.

Parametry:

* $l^{c}_{s} \: \forall s \in S$ -- ładowność ciężarówki przewożącej materiał
    $s$ [tona]
* $l^{n}_{S1}$ -- ładowność naczepy przewożącej materiał $S1$ [tona]
* $c^{dc}_{s} \: \forall s \in S$ -- koszt wysyłu pojedynczej ciężarówki
    przewożącej materiał $s$ [zł]
* $c^{dn}_{S1}$ -- koszt wysyłu pojedynczej naczepy przewożącej materiał
    $S1$ [zł]

Zmienne:

* $d^p_{S1} = x_{S1}$ -- ilość przewożonego materiału $S1$ do przygotowalni
    [tona]
* $d^p_{S2}$ -- ilość przewożonego materiału $S2$ do przygotowalni [tona]
* $d^c_{S2} = x_{S2} - d^p_{S2}$ -- ilość przewożonego materiału $S2$ do obróbki
    cieplnej [tona]
* $n^{cp}_{S1} \in \{0, 1, ..., 337\}$ -- liczba ciężarówek do przewozu materiału
    $S1$ do przygotowalni [brak jednostki]
* $n^{np}_{S1} \in \{0, 1, ..., 337\}$ -- liczba naczep do przewozu materiału
    $S1$ do przygotowalni [brak jednostki]
* $n^{cp}_{S2} \in \{0, 1, ...\}$ -- liczba ciężarówek do przewozu materiału $S2$
    do przygotowalni [brak jednostki]
* $n^{cc}_{S2} \in \{0, 1, ...\}$ -- liczba ciężarówek do przewozu materiału $S2$
    do obróbki cieplnej [brak jednostki]
* $c^d = n^{cp}_{S1} c^{dc}_{S1} + n^{np}_{S1} c^{dn}_{S1} + (n^{cp}_{S2} + n^{cc}_{S2}) c^{dc}_{S2}$
    -- całkowity koszt dowozu [zł]

Ograniczenia:

* $n^{cp}_{S1} \ge n^{np}_{S1}$ -- liczba naczep nie większa niż liczba
    ciężarówek przewożących towar $S1$
* $d^p_{S1} \le n^{cp}_{S1} l^c_{S1} + n^{np}_{S1} l^n_{S1}$ -- całość
    materiału $S1$ przewożonego do przygotowalni mieści się do ciężarówek i
    naczep z materiałem $S1$ jadących do przygotowalni
* $0 \le d^p_{S2} \le x_{S2}$ -- ilość przewożonego materiału $S2$ do
    przygotowalni jest w zakresie od 0 do ilości kupionego materiału $S2$
* $d^p_{S2} \le n^{cp}_{S2} l^c_{S2}$ -- całość materiału $S2$ przewożonego do
    przygotowalni mieści się do ciężarówek z materiałem $S2$ jadących do
    przygotowalni
* $d^c_{S2} \le n^{cc}_{S2} l^c_{S2}$ -- całość materiału $S2$ przewożonego do
    obróbki cieplnej mieści się do ciężarówek z materiałem $S2$ jadących do
    zakładu obróbki cieplnej

## Przetwarzanie w przygotowalni

W rozwiązaniu założyłem, że całość dowiezionego do przygotowalni materiału jest
przerabiana -- w przeciwnym wypadku nie opłacałoby się dowozić takiej ilości
materiału, więc takie rozwiązanie nie mogłoby być optymalne.

Parametry:

* $h_{sd} \: \forall s \in S, \forall d \in D$ --ilość produkowanego półproduktu
    $d$ z jednostki materiału $s$ [tona/tona]
* $p^{max}$ -- maksymalna całkowita ilość produkowanych półproduktów w
    przygotowalni [tona]
* $g^n = 2$ -- liczba pracowników w grupie pracowników [brak jednostki]
* $g^p = 200$ -- maksymalna ilość przetworzonego materiału w przygotowalni
    przez jedną grupę pracowników [tona]
* $c^w$ -- koszt zatrudnienia jednego pracownika [zł]

Zmienne:

* $p_d \: \forall d \in D$ -- ilość produkowanego półproduktu $d$ w
    przygotowalni [tona]
* $p = \sum_{d \in D} p_d$ -- całkowita ilość produkowanych półproduktów w
    przygotowalni [tona]
* $n^g$ -- liczba zatrudnionych grup pracowników w przygotowalni [brak jednostki]
* $c^p = n^g g^n c^w$ -- całkowity koszt pracy przygotowalni [zł], czyli łączny
    koszt zatrudnienia pracowników

Ograniczenia:

* $p_d = \sum_{s \in S} d^p_s h_{sd} \: \forall d \in D$ -- ilość produkowanego
     półproduku $d$ ze wszystkich dowiezionych do przygotowalni materiałów $s$
* $p \le p^{max}$ -- całkowita ilość produkowanych półproduktów w przygotowalni
    nie przekracza limitu
* $p \le n^g g^p$ -- całkowita ilość produkowanych półproduktów w przygotowalni
    jest ograniczona przez liczbę grup pracowników i maksymalną przepustowość
    każdej z nich

## Obróbka cieplna

W rozwiązaniu założyłem, że całość dowiezionego do zakładu obróbki cieplnej
materiału jest obrabiana -- w przeciwnym wypadku nie opłacałoby się dowozić
takiej ilości materiału, więc takie rozwiązanie nie mogłoby być optymalne.

## Zyski

<!-- ### Model sieci przepływowej -->
<!--  -->
<!-- Zadanie można przedstawić w postaci problemu wyznaczenia najtańszego przepływu o -->
<!-- przepływie zadanym równym sumie zapotrzebowań klientów. -->
<!--  -->
<!-- $$F_{zad} = Z_F + Z_G + Z_H = 35$$ -->
<!--  -->
<!-- Struktura sieci dla tego problemu wygląda następująco. -->
<!--  -->
<!-- ![Model sieci przepływowej (oznaczenia na łukach: `[przepustowość] koszt_jednostkowy`)](graphs/z1-1.drawio.svg) -->
<!--  -->
<!-- ### Rozwiązanie modelu sieci przepływowej -->
<!--  -->
<!-- ![Model sieci przepływowej -- rozwiązanie (oznaczenia na łukach: -->
<!-- `[przepływ/przepustowość] koszt_jednostkowy`)](graphs/z1-1-rozw.drawio.svg) -->
<!--  -->
<!-- A zatem plan wygląda następująco (planowany transport od wiersza do kolumny w -->
<!-- tys. ton): -->
<!--  -->
<!-- |   | D | E | F | G | H | -->
<!-- |---|---|---|---|---|---| -->
<!-- | A |   | 10|   |   |   | -->
<!-- | B |   | 5 |   | 5 |   | -->
<!-- | C | 15|   |   |   |   | -->
<!-- | D |   |   | 10| 3 | 2 | -->
<!-- | E |   |   | 5 | 5 | 5 | -->
<!--  -->
<!-- Co odpowiada łącznemu kosztowi: -->
<!--  -->
<!-- $10 \cdot 2 + 1 \cdot 3 + 9 \cdot 8 + 15 \cdot 2 + 10 \cdot 3 + 3 \cdot 7 + 2 \cdot 2 + 5 \cdot 7 + 1 \cdot 6 + 5 \cdot 3 = 236$ -->
<!--  -->
<!-- ### Zadanie programowania liniowego -->
<!--  -->
<!-- Zbiory -->
<!--  -->
<!-- - $V_{kop} = \{A, B, C\}$ -- kopalnie -->
<!-- - $V_{ele} = \{F, G, H\}$ -- elektrownie -->
<!-- - $V_{poś} = \{D, E\}$ -- stacje pośrednie -->
<!-- - $V_{wew} = V_{kop} \cup V_{ele} \cup V_{poś}$ -- wewnętrzne węzły sieci (bez startu i końca) -->
<!-- - $E_{wew} = \{(A, E), (B, E), ..., (E, G), (E, H)\}$ -- wewnętrzne krawędzie sieci -->
<!-- - $E = E_{wew} \cup \{\forall i \in V_{kop} : (s, i)\} \cup \{\forall i \in V_{ele} : (i, t)\}$ -- wszystkie krawędzie sieci -->
<!--  -->
<!-- Parametry -->
<!--  -->
<!-- - $t^{wew}_{ij}$ dla $(i, j) \in E_{wew}$ -- przepustowość połączenia między węzłem $i$ a $j$ [tys. ton] -->
<!-- - $c^{wew}_{ij}$ dla $(i, j) \in E_{wew}$ -- jednostkowy koszt przesłania towaru między węzłem $i$ a $j$ [jednostka nieznana] -->
<!-- - $W_i$ dla $i \in V_{kop}$ -- zdolności wydobywcze kopalni $i$ [tys. ton] -->
<!-- - $Z_i$ dla $i \in V_{ele}$ -- średnie dobowe zużycie węgla elektrowni $i$ [tys. ton] -->
<!--  -->
<!-- Zmienne decyzyjne -->
<!--  -->
<!-- - $f_{ij}$ dla $(i, j) \in E$ -- przepływ towaru między węzłem $i$ a $j$ [tys. ton] -->
<!--  -->
<!-- Zmienne pomocnicze -->
<!--  -->
<!-- - $t_{ij}$ dla $(i, j) \in E$ -- przepustowość połączenia między węzłem $i$ a $j$ [tys. ton] -->
<!-- - $c_{ij}$ dla $(i, j) \in E$ -- jednostkowy koszt przesłania towaru między węzłem $i$ a $j$ [jednostka nieznana] -->
<!--  -->
<!-- Funkcja celu -->
<!--  -->
<!-- - $min \sum_{(i,j) \in E} f_{ij} \cdot c_{ij}$ -- minimalizacja całkowitego -->
<!--   kosztu -->
<!--  -->
<!-- Ograniczenia -->
<!--  -->
<!-- - $\forall (i,j) \in E : 0 \le f_{ij} \le t_{ij}$ -- ograniczenie przepływu od 0 -->
<!--   do wartości przepustowości na krawędzi -->
<!-- - $\forall j \in V_{wew} : \sum_{(i, j) \in E} f_{ij} = \sum_{(j, k) \in E} f_{jk}$ -- cały -->
<!--   towar wchodzący do węzła wewnętrznego musi z niego wyjść -->
<!-- - $\forall i \in V_{ele} : f_{it} = Z_i$ -- trzeba spełnić zapotrzebowanie -->
<!--   kopalń -->
<!--  -->
<!-- Ograniczenia zmiennych pomocniczych: -->
<!--  -->
<!-- - $\forall (i,j) \in E_{wew} : t_{ij} = t^{wew}_{ij}$ -->
<!-- - $\forall i \in V_{kop} : t_{si} = W_i$ -->
<!-- - $\forall i \in V_{ele} : t_{it} = Z_i$ -->
<!-- - $\forall (i,j) \in E_{wew} : c_{ij} = c^{wew}_{ij}$ -->
<!-- - $\forall i \in V_{kop} : c_{si} = 0$ -->
<!-- - $\forall i \in V_{ele} : c_{it} = 0$ -->
<!--  -->
<!-- ### Wąskie gardło -->
<!--  -->
<!-- Problem można sprowadzić do zadania wyznaczenia największego przepływu w sieci. -->
<!-- Rozwiązanie podzieli węzły na dwa rozłączne zbiory $S$ i $T$, między którymi -->
<!-- nie będzie już możliwości transportu dodatkowych towarów. Zbiór krawędzi -->
<!-- łączących te 2 zbiory będzie przekrojem o minimalnej przepustowości. -->
<!--  -->
<!-- Należy wprowadzić kilka modyfikacji do wcześniejszego grafu: -->
<!--  -->
<!-- - usunięcie kosztów (niepotrzebne do tego zadania), -->
<!-- - zmiana $Z_i$ dla każdej z elektrowni na liczbę $N$, większą od przepustowości -->
<!--   każdego przekroju (dzięki temu zapotrzebowanie elektrowni nie będzie -->
<!--   ograniczać rozwiązania) -->
<!-- - zmiana $W_i$ dla każdej z kopalń na liczbę $N$, większą od przepustowości -->
<!--   każdego przekroju (dzięki temu produkcja kopalń nie będzie ograniczać -->
<!--   rozwiązania) -->
<!--  -->
<!-- Poniżej omawiana sieć dla $N = 100$ wraz z wyznaczonymi przepływami. -->
<!--  -->
<!-- ![Model sieci przepływowej, wąskie gardło (oznaczenia na łukach: -->
<!-- `[przepływ/przepustowość]`)](graphs/z1-2.drawio.svg) -->
<!--  -->
<!-- A zatem $S = \{s, A, B, C, D, E\}$, $T = \{F, G, H\}$, czyli poszukiwany -->
<!-- przekrój to $\{(D, F), (D, G), (D, H), (B, G), (E, F), (E, G), (E, H)\}$ o -->
<!-- przepustowości równej $10 + 3 + 2 + 9 + 5 \cdot 3 = 39$. Wartość ta jest -->
<!-- jednocześnie równa maksymalnemu przepływowi w sieci (nieograniczonemu -->
<!-- zapotrzebowaniem ani produkcją towaru). -->
<!--  -->
<!-- Na każdym z węzłów $(s, *)$ i $(*, t)$ przepływ jest mniejszy niż $N$. Gdyby -->
<!-- było inaczej, oznaczałoby to, że wybrane $N$ jest zbyt małe i trzeba powtórzyć -->
<!-- obliczenia z większym $N$. -->
<!--  -->
<!-- ## Zadanie 2 -->
<!--  -->
<!-- ### Zadanie 2.1 -->
<!--  -->
<!-- Problem można rozwiązać przy pomocy zadania wyznaczania największego przepływu w -->
<!-- sieci. Jeżeli $F_{max}$ będzie równe liczbie zespołów/projektów, to wartości -->
<!-- przepływów będą wyrażały przypisanie zespołów do projektów. -->
<!--  -->
<!-- Poniżej sieć modelująca zadanie wraz z rozwiązaniem. -->
<!--  -->
<!-- ![Model sieci przepływowej, dopasowanie zadań (oznaczenia na łukach: -->
<!-- `[przepływ/przepustowość]`)](graphs/z2-1.drawio.svg) -->
<!--  -->
<!-- $F_{max} = 6$, więc udało się przydzielić wszystkie zespoły do projektów. -->
<!--  -->
<!-- Przydział będzie wyglądał następująco: -->
<!--  -->
<!-- |   | A | B | C | D | E | F | -->
<!-- |---|---|---|---|---|---|---| -->
<!-- | 1 |   | X |   |   |   |   | -->
<!-- | 2 |   |   | X |   |   |   | -->
<!-- | 3 | X |   |   |   |   |   | -->
<!-- | 4 |   |   |   |   |   | X | -->
<!-- | 5 |   |   |   |   | X |   | -->
<!-- | 6 |   |   |   | X |   |   | -->
<!--  -->
<!-- ### Zadanie 2.2 -->
<!--  -->
<!-- Zadanie podobne do poprzedniego z tą różnicą, że wykorzystany zostanie problem -->
<!-- najtańszego przepływu, a do sieci trzeba będzie dopisać jednostkowe koszty -->
<!-- przesyłu odpowiadające kosztom realizacji projektu przez zespół. -->
<!--  -->
<!-- Sieć i rozwiązanie znajduje się poniżej. -->
<!--  -->
<!-- ![Model sieci przepływowej, dopasowanie zadań z kosztem (oznaczenia na łukach: -->
<!-- `[przepływ/przepustowość] koszt_jednostkowy`)](graphs/z2-2.drawio.svg) -->
<!--  -->
<!-- Wtedy całkowity koszt wynosi $50$, a przydział wygląda następująco: -->
<!--  -->
<!-- |   | A | B | C | D | E | F | -->
<!-- |---|---|---|---|---|---|---| -->
<!-- | 1 |   |   |   | X |   |   | -->
<!-- | 2 |   |   |   |   | X |   | -->
<!-- | 3 | X |   |   |   |   |   | -->
<!-- | 4 |   |   |   |   |   | X | -->
<!-- | 5 |   | X |   |   |   |   | -->
<!-- | 6 |   |   | X |   |   |   | -->
<!--  -->
<!-- ### Zadanie 2.3 -->
<!--  -->
<!-- Zbiory -->
<!--  -->
<!-- - $Z = \{1, 2, 3, 4, 5, 6\}$ -- zespoły -->
<!-- - $P = \{A, B, C, D, E, F\}$ -- projekty -->
<!-- - $E = \{(1, B), (1, D), ..., (6, D)\}$ -- dozwolone pary (zespół, projekt) -->
<!--  -->
<!-- Parametry -->
<!--  -->
<!-- - $t_{ij}$ dla $(i, j) \in E$ -- czas realizacji projektu $j$ przez zespój $i$ [msc] -->
<!--  -->
<!-- Zmienne decyzyjne -->
<!--  -->
<!-- - $f_{ij} \in \{0, 1\}$ -- przypisanie zespołu $i$ do projektu $j$ -->
<!-- - $t_{max}$ -- maksymalny czas trwania pracy zespołu nad projektem [msc] -->
<!--  -->
<!-- Funkcja celu -->
<!--  -->
<!-- - $min \ t_{max}$ -- minimalizacja maksymalnego czasu -->
<!--  -->
<!-- Ograniczenia -->
<!--  -->
<!-- - $\forall i \in Z : \sum_{(i, j) \in E} f_{ij} = 1$ -- każdy zespół musi mieć -->
<!--     przypisany projekt -->
<!-- - $\forall j \in P : \sum_{(i, j) \in E} f_{ij} = 1$ -- każdy projekt musi mieć -->
<!--     przypisany zespół -->
<!-- - $\forall (i, j) \in E : t_{max} \ge f_{ij} \cdot t_{ij}$ -- maksymalny czas -->
<!--     jest większy lub równy od każdego z czasów pracy zespołu nad projektem -->
<!--  -->
<!-- #### Rozwiązanie zadania 2.3 -->
<!--  -->
<!-- |   | A | B | C | D | E | F | -->
<!-- |---|---|---|---|---|---|---| -->
<!-- | 1 |   | X |   |   |   |   | -->
<!-- | 2 |   |   |   |   | X |   | -->
<!-- | 3 |   |   |   | X |   |   | -->
<!-- | 4 | X |   |   |   |   |   | -->
<!-- | 5 |   |   |   |   |   | X | -->
<!-- | 6 |   |   | X |   |   |   | -->
<!--  -->
<!-- $$t_{max} = 13 \ [msc]$$ -->
<!--  -->
<!-- ## Zadanie 3 -->
<!--  -->
<!-- Zbiory -->
<!--  -->
<!-- - $I = \{1, ..., n\}$ -- zasoby -->
<!-- - $J = \{1, ..., m\}$ -- produkty -->
<!--  -->
<!-- Parametry -->
<!--  -->
<!-- - $c^{max}_i$ dla $i \in I$ -- przepustowości zasobów [jednostka nieznana] -->
<!-- - $A_{ij}$ dla $(i, j) \in I \times J$ -- współczynnik jednostkowego zużycia -->
<!--     zasobu $i$ przez produkt $j$ [jednostka nieznana] -->
<!-- - $p_j$ dla $j \in J$ -- standardowa cena produktu $j$ [jednostka nieznana] -->
<!-- - $q_j$ dla $j \in J$ -- próg obniżenia przychodu jednostkowego produktu $j$ -->
<!--     [jednostka nieznana] -->
<!-- - $p^{disc}_j$ dla $j \in J$ -- obniżona cena produktu $j$ [jednostka nieznana] -->
<!--  -->
<!-- Zmienne -->
<!--  -->
<!-- - $x_j$ dla $j \in J$ -- produkcja produktu $j$ [jednostka nieznana] -->
<!-- - $x'^+_j$, $x'^-_j$ dla $j \in J$ -- odpowiednio nadwyżka i niedobór względem -->
<!--     progu obniżenia przychodu jednostkowego produktu $j$ [jednostka niezana] -->
<!--  -->
<!-- Funkcja celu -->
<!--  -->
<!-- - $max \sum_{j \in J} p_j \cdot (x_j - x'^+_j) + p^{disc}_j \cdot x'^+_j$ -->
<!--     -- maksymalizacja zysków -->
<!--   - składnik $p_j \cdot (x_j - x'^+_j)$ -- odpowiada za cenę części towaru -->
<!--       poniżej progu obniżenia ceny produktu (dla $x_j > q_j$ będzie to funkcja -->
<!--       stała) -->
<!--   - składnik $p^{disc}_j \cdot x'^+_j$ -- odpowiada za cenę części towaru -->
<!--       powyżej progu obniżenia ceny produktu (dla $x_j < q_j$ będzie miał wartość 0) -->
<!--  -->
<!-- Ograniczenia -->
<!--  -->
<!-- - $\forall i \in I : \sum_{j \in J} A_{ij} \cdot x_j \le c_j$ -- zużycie zasobów -->
<!--     mniejsze niż przepustowość -->
<!-- - $\forall j \in J : x'^+_j - x'^-_j = q_j - x_j$ -- nadwyżka i niedobór -->
<!--     względem progu obniżenia przychodu jednostkowego produktu $j$ -->
<!-- - $\forall j \in J : x_j \ge 0$ -- produkcja większa lub równa 0 -->
<!-- - $\forall j \in J : x'^+_j \ge 0$ -- nadwyżka względem progu większa lub równa -->
<!--     0 -->
<!-- - $\forall j \in J : x'^-_j \ge 0$ -- niedobór względem progu większy lub równy -->
<!--     0 -->
