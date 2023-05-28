include "globals.mzn";

% Entradas
int: n;  % Número de equipos del campeonato
int: Min;  % Tamaño mínimo de gira o permanencia
int: Max;  % Tamaño máximo de gira o permanencia

array[1..n, 1..n] of int: D;  % Matriz de distancias entre las ciudades sedes

% Variables
array[1..2*(n-1), 1..n] of var -n..n: Cal;  % Calendario
array[1..n] of var 0..Max: gira;  % Tamaño de las giras para cada equipo

var 0..2*(n-1) : giras;  % Número total de giras realizadas
array[1..n] of var 0..2*(n-1): numGiras;  % Número de giras realizadas por cada equipo
var int: costo;

% Restricciones
constraint forall(i in 1..2*(n-1), j in 1..n)(
    (Cal[i, j] > 0) -> (Cal[i, -Cal[i, j]] = -j)
    /\ (Cal[i, j] < 0) -> (Cal[i, -Cal[i, j]] = j)
);


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


% Restricción para calcular el costo total de las giras
constraint costo = sum(i in 1..2*(n-1), j in 1..n-1)(
  let {
    var int: equipo_actual = abs(Cal[i, j]);
    var int: equipo_siguiente = abs(Cal[i, j+1]);
    var int: distancia = if Cal[i, j] > 0 then D[equipo_actual, equipo_siguiente] else D[equipo_siguiente, equipo_actual] endif;
  } in distancia
);

% Solución
solve minimize costo + sum(i in 1..n)(gira[i]);

% Salida
output ["Calendario:\n"] ++ [show(Cal[i, j]) ++ if j = n then "\n" else " " endif | i in 1..2*(n-1), j in 1..n] ++
       ["Tamaño de las giras:\n"] ++ [show(costo) ++ "\n" | i in 1..n];