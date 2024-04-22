---
title:  'MOM projekt 1'
author: Jakub Ostrzołek
---

## Zadanie 1

### Model sieci przepływowej

Zadanie można przedstawić w postaci problemu wyznaczenia najtańszego przepływu o
przepływie zadanym równym sumie zapotrzebowań klientów.

$$F_{zad} = Z_F + Z_G + Z_H = 35$$

Struktura sieci dla tego problemu wygląda następująco.

![Model sieci przepływowej (oznaczenia na łukach: `[przepustowość] koszt_jednostkowy`)](graphs/z1-1.drawio.svg)

### Rozwiązanie modelu sieci przepływowej

![Model sieci przepływowej -- rozwiązanie (oznaczenia na łukach:
`[przepływ/przepustowość] koszt_jednostkowy`)](graphs/z1-1-rozw.drawio.svg)

A zatem plan wygląda następująco (planowany transport od wiersza do kolumny w
tys. ton):

|   | D | E | F | G | H |
|---|---|---|---|---|---|
| A |   | 10|   |   |   |
| B |   | 5 |   | 5 |   |
| C | 15|   |   |   |   |
| D |   |   | 10| 3 | 2 |
| E |   |   | 5 | 5 | 5 |

Co odpowiada łącznemu kosztowi:

$10 \cdot 2 + 1 \cdot 3 + 9 \cdot 8 + 15 \cdot 2 + 10 \cdot 3 + 3 \cdot 7 + 2 \cdot 2 + 5 \cdot 7 + 1 \cdot 6 + 5 \cdot 3 = 236$

### Zadanie programowania liniowego

Zbiory

- $V_{kop} = \{A, B, C\}$ -- kopalnie
- $V_{ele} = \{F, G, H\}$ -- elektrownie
- $V_{poś} = \{D, E\}$ -- stacje pośrednie
- $V_{wew} = V_{kop} \cup V_{ele} \cup V_{poś}$ -- wewnętrzne węzły sieci (bez startu i końca)
- $E_{wew} = \{(A, E), (B, E), ..., (E, G), (E, H)\}$ -- wewnętrzne krawędzie sieci
- $E = E_{wew} \cup \{\forall i \in V_{kop} : (s, i)\} \cup \{\forall i \in V_{ele} : (i, t)\}$ -- wszystkie krawędzie sieci

Parametry

- $t^{wew}_{ij}$ dla $(i, j) \in E_{wew}$ -- przepustowość połączenia między węzłem $i$ a $j$ [tys. ton]
- $c^{wew}_{ij}$ dla $(i, j) \in E_{wew}$ -- jednostkowy koszt przesłania towaru między węzłem $i$ a $j$ [jednostka nieznana]
- $W_i$ dla $i \in V_{kop}$ -- zdolności wydobywcze kopalni $i$ [tys. ton]
- $Z_i$ dla $i \in V_{ele}$ -- średnie dobowe zużycie węgla elektrowni $i$ [tys. ton]

Zmienne decyzyjne

- $f_{ij}$ dla $(i, j) \in E$ -- przepływ towaru między węzłem $i$ a $j$ [tys. ton]

Zmienne pomocnicze

- $t_{ij}$ dla $(i, j) \in E$ -- przepustowość połączenia między węzłem $i$ a $j$ [tys. ton]
- $c_{ij}$ dla $(i, j) \in E$ -- jednostkowy koszt przesłania towaru między węzłem $i$ a $j$ [jednostka nieznana]

Funkcja celu

- $min \sum_{(i,j) \in E} f_{ij} \cdot c_{ij}$ -- minimalizacja całkowitego
  kosztu

Ograniczenia

- $\forall (i,j) \in E : 0 \le f_{ij} \le t_{ij}$ -- ograniczenie przepływu od 0
  do wartości przepustowości na krawędzi
- $\forall j \in V_{wew} : \sum_{(i, j) \in E} f_{ij} = \sum_{(j, k) \in E} f_{jk}$ -- cały
  towar wchodzący do węzła wewnętrznego musi z niego wyjść
- $\forall i \in V_{ele} : f_{it} = Z_i$ -- trzeba spełnić zapotrzebowanie
  kopalń

Ograniczenia zmiennych pomocniczych:

- $\forall (i,j) \in E_{wew} : t_{ij} = t^{wew}_{ij}$
- $\forall i \in V_{kop} : t_{si} = W_i$
- $\forall i \in V_{ele} : t_{it} = Z_i$
- $\forall (i,j) \in E_{wew} : c_{ij} = c^{wew}_{ij}$
- $\forall i \in V_{kop} : c_{si} = 0$
- $\forall i \in V_{ele} : c_{it} = 0$

### Wąskie gardło

Problem można sprowadzić do zadania wyznaczenia największego przepływu w sieci.
Rozwiązanie podzieli węzły na dwa rozłączne zbiory $S$ i $T$, między którymi
nie będzie już możliwości transportu dodatkowych towarów. Zbiór krawędzi
łączących te 2 zbiory będzie przekrojem o minimalnej przepustowości.

Należy wprowadzić kilka modyfikacji do wcześniejszego grafu:

- usunięcie kosztów (niepotrzebne do tego zadania),
- zmiana $Z_i$ dla każdej z elektrowni na liczbę $N$, większą od przepustowości
  każdego przekroju (dzięki temu zapotrzebowanie elektrowni nie będzie
  ograniczać rozwiązania)
- zmiana $W_i$ dla każdej z kopalń na liczbę $N$, większą od przepustowości
  każdego przekroju (dzięki temu produkcja kopalń nie będzie ograniczać
  rozwiązania)

Poniżej omawiana sieć dla $N = 100$ wraz z wyznaczonymi przepływami.

![Model sieci przepływowej, wąskie gardło (oznaczenia na łukach:
`[przepływ/przepustowość]`)](graphs/z1-2.drawio.svg)

A zatem $S = \{s, A, B, C, D, E\}$, $T = \{F, G, H\}$, czyli poszukiwany
przekrój to $\{(D, F), (D, G), (D, H), (B, G), (E, F), (E, G), (E, H)\}$ o
przepustowości równej $10 + 3 + 2 + 9 + 5 \cdot 3 = 39$. Wartość ta jest
jednocześnie równa maksymalnemu przepływowi w sieci (nieograniczonemu
zapotrzebowaniem ani produkcją towaru).

Na każdym z węzłów $(s, *)$ i $(*, t)$ przepływ jest mniejszy niż $N$. Gdyby
było inaczej, oznaczałoby to, że wybrane $N$ jest zbyt małe i trzeba powtórzyć
obliczenia z większym $N$.

## Zadanie 2

### Zadanie 2.1

Problem można rozwiązać przy pomocy zadania wyznaczania największego przepływu w
sieci. Jeżeli $F_{max}$ będzie równe liczbie zespołów/projektów, to wartości
przepływów będą wyrażały przypisanie zespołów do projektów.

Poniżej sieć modelująca zadanie wraz z rozwiązaniem.

![Model sieci przepływowej, dopasowanie zadań (oznaczenia na łukach:
`[przepływ/przepustowość]`)](graphs/z2-1.drawio.svg)

$F_{max} = 6$, więc udało się przydzielić wszystkie zespoły do projektów.

Przydział będzie wyglądał następująco:

|   | A | B | C | D | E | F |
|---|---|---|---|---|---|---|
| 1 |   | X |   |   |   |   |
| 2 |   |   | X |   |   |   |
| 3 | X |   |   |   |   |   |
| 4 |   |   |   |   |   | X |
| 5 |   |   |   |   | X |   |
| 6 |   |   |   | X |   |   |

### Zadanie 2.2

Zadanie podobne do poprzedniego z tą różnicą, że wykorzystany zostanie problem
najtańszego przepływu, a do sieci trzeba będzie dopisać jednostkowe koszty
przesyłu odpowiadające kosztom realizacji projektu przez zespół.

Sieć i rozwiązanie znajduje się poniżej.

![Model sieci przepływowej, dopasowanie zadań z kosztem (oznaczenia na łukach:
`[przepływ/przepustowość] koszt_jednostkowy`)](graphs/z2-2.drawio.svg)

Wtedy całkowity koszt wynosi $50$, a przydział wygląda następująco:

|   | A | B | C | D | E | F |
|---|---|---|---|---|---|---|
| 1 |   |   |   | X |   |   |
| 2 |   |   |   |   | X |   |
| 3 | X |   |   |   |   |   |
| 4 |   |   |   |   |   | X |
| 5 |   | X |   |   |   |   |
| 6 |   |   | X |   |   |   |

### Zadanie 2.3

Zbiory

- $Z = \{1, 2, 3, 4, 5, 6\}$ -- zespoły
- $P = \{A, B, C, D, E, F\}$ -- projekty
- $E = \{(1, B), (1, D), ..., (6, D)\}$ -- dozwolone pary (zespół, projekt)

Parametry

- $t_{ij}$ dla $(i, j) \in E$ -- czas realizacji projektu $j$ przez zespój $i$ [msc]

Zmienne decyzyjne

- $f_{ij} \in \{0, 1\}$ -- przypisanie zespołu $i$ do projektu $j$
- $t_{max}$ -- maksymalny czas trwania pracy zespołu nad projektem [msc]

Funkcja celu

- $min \ t_{max}$ -- minimalizacja maksymalnego czasu

Ograniczenia

- $\forall i \in Z : \sum_{(i, j) \in E} f_{ij} = 1$ -- każdy zespół musi mieć
    przypisany projekt
- $\forall j \in P : \sum_{(i, j) \in E} f_{ij} = 1$ -- każdy projekt musi mieć
    przypisany zespół
- $\forall (i, j) \in E : t_{max} \ge f_{ij} \cdot t_{ij}$ -- maksymalny czas
    jest większy lub równy od każdego z czasów pracy zespołu nad projektem

#### Rozwiązanie zadania 2.3

|   | A | B | C | D | E | F |
|---|---|---|---|---|---|---|
| 1 |   | X |   |   |   |   |
| 2 |   |   |   |   | X |   |
| 3 |   |   |   | X |   |   |
| 4 | X |   |   |   |   |   |
| 5 |   |   |   |   |   | X |
| 6 |   |   | X |   |   |   |

$$t_{max} = 13 \ [msc]$$

## Zadanie 3

Zbiory

- $I = \{1, ..., n\}$ -- zasoby
- $J = \{1, ..., m\}$ -- produkty

Parametry

- $c^{max}_i$ dla $i \in I$ -- przepustowości zasobów [jednostka nieznana]
- $A_{ij}$ dla $(i, j) \in I \times J$ -- współczynnik jednostkowego zużycia
    zasobu $i$ przez produkt $j$ [jednostka nieznana]
- $p_j$ dla $j \in J$ -- standardowa cena produktu $j$ [jednostka nieznana]
- $q_j$ dla $j \in J$ -- próg obniżenia przychodu jednostkowego produktu $j$
    [jednostka nieznana]
- $p^{disc}_j$ dla $j \in J$ -- obniżona cena produktu $j$ [jednostka nieznana]

Zmienne

- $x_j$ dla $j \in J$ -- produkcja produktu $j$ [jednostka nieznana]
- $x'^+_j$, $x'^-_j$ dla $j \in J$ -- odpowiednio nadwyżka i niedobór względem
    progu obniżenia przychodu jednostkowego produktu $j$ [jednostka niezana]

Funkcja celu

- $max \sum_{j \in J} p_j \cdot (x_j - x'^+_j) + p^{disc}_j \cdot x'^+_j$
    -- maksymalizacja zysków
  - składnik $p_j \cdot (x_j - x'^+_j)$ -- odpowiada za cenę części towaru
      poniżej progu obniżenia ceny produktu (dla $x_j > q_j$ będzie to funkcja
      stała)
  - składnik $p^{disc}_j \cdot x'^+_j$ -- odpowiada za cenę części towaru
      powyżej progu obniżenia ceny produktu (dla $x_j < q_j$ będzie miał wartość 0)

Ograniczenia

- $\forall i \in I : \sum_{j \in J} A_{ij} \cdot x_j \le c_j$ -- zużycie zasobów
    mniejsze niż przepustowość
- $\forall j \in J : x'^+_j - x'^-_j = q_j - x_j$ -- nadwyżka i niedobór
    względem progu obniżenia przychodu jednostkowego produktu $j$
- $\forall j \in J : x_j \ge 0$ -- produkcja większa lub równa 0
- $\forall j \in J : x'^+_j \ge 0$ -- nadwyżka względem progu większa lub równa
    0
- $\forall j \in J : x'^-_j \ge 0$ -- niedobór względem progu większy lub równy
    0
