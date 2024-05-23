set V_in;
set V = V_in union {"s", "t"};
set E within {V, V};

param capacity {E};

var flow {(i, j) in E} <= capacity[i, j] >= 0;

s.t. con_amper_law {v in V_in}:
  sum {(i, j) in E : j = v} flow[i, j] = sum {(i, j) in E : i = v} flow[i, j];

maximize total_flow:
  sum {(i, j) in E : j = "t"} flow[i, j];
