set V_in;
set V = V_in union {"s", "t"};
set E within {V, V};

param capacity {E};
param unit_cost {E};
param target_flow;

var flow {(i, j) in E} <= capacity[i, j] >= 0;

s.t. con_amper_law {v in V_in}:
  sum {(i, j) in E : j = v} flow[i, j] = sum {(i, j) in E : i = v} flow[i, j];

s.t. con_target_met:
  sum {(i, j) in E : j = "t"} flow[i, j] = target_flow;

minimize total_cost:
  sum {(i, j) in E} flow[i, j] * unit_cost[i, j];
