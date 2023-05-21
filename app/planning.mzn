include "globals.mzn";

% Entradas
int: n;  % Número de equipos del campeonato
int: Min;  % Tamaño mínimo de gira o permanencia
int: Max;  % Tamaño máximo de gira o permanencia

array[1..n, 1..n] of int: D;  % Matriz de distancias entre las ciudades sedes

% Variables
array[1..2*(n-1), 1..n] of var -n..n: Cal;  % Calendario
array[1..n] of var 0..Max: gira;  % Tamaño de las giras para cada equipo

% Restricciones
/*constraint forall(i in 1..2*(n-1), j in 1..n)(
    (Cal[i, j] = 0) \/ (Cal[i, -Cal[i, j]] = -j)  % Cal[i,j] = k si y solo si Cal[i,k] = -j
);*/

constraint forall(i in 1..2*(n-1))(
    all_different([abs(Cal[i, j]) | j in 1..n])  % Todos los valores en la fila i deben ser distintos y abarcar el rango 1..n
);

constraint forall(i in 1..2*(n-1))(
    count(j in 1..n)(Cal[i, j] > 0) = count(j in 1..n)(Cal[i, j] < 0)  % Igual número de partidos de local y visitante en cada fecha
);

constraint forall(j in 1..n, k in 1..n where j != k)(
    exists(i1, i2 in 1..2*(n-1))(
        (Cal[i1, j] = k /\ Cal[i2, k] = -j) \/ (Cal[i2, j] = k /\ Cal[i1, k] = -j)
    )
);


% Restricción de tamaño de gira para cada equipo
constraint forall(i in 1..n)(
    sum(j in 1..2*(n-1))(Cal[j, i] > 0) = gira[i]
);

% Restricción de costo de gira para cada equipo
/*constraint forall(i in 1..n)(
    sum(j in 1..n, k in 1..n where j != k)(
        D[j, k] *
        (exists(idx in 2..2*(n-1))(Cal[idx, i] > 0) /\
         exists(idx in 1..2*(n-2))(Cal[idx, i] > 0 /\ Cal[idx, i] != Cal[idx+1, i]))
    ) = gira[i]
);*/

% Solución
solve minimize sum(i in 1..n)(gira[i]);

% Salida
output ["Calendario:\n"] ++ [show(Cal[i, j]) ++ if j = n then "\n" else " " endif | i in 1..2*(n-1), j in 1..n] ++
       ["Tamaño de las giras:\n"] ++ [show(gira[i]) ++ "\n" | i in 1..n];

