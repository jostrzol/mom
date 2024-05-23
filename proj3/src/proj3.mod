### DOMAIN MODEL

set Plants;
set Warehouses;
set Clients;

set Sources = Plants union Warehouses;
set Destinations = Warehouses union Clients;
set Edges within {Sources, Destinations};

set ClientPreferences within {(_,c) in Edges : c in Clients};

param DISTRIBUTION_COST {Edges};
param PLANT_PRODUCTION_MAX {Plants};
param WAREHOUSE_STORAGE_MAX {Warehouses};
param CLIENT_DEMAND {Clients};

var flow {Edges} >= 0;
var satisfaction {Clients} >= 0 <=1;

var total_cost = sum {(s,d) in Edges} flow[s,d] * DISTRIBUTION_COST[s,d];
var total_satisfaction = sum {c in Clients} satisfaction[c];

s.t. plant_production_limit_max {p in Plants}:
  sum {(p,d) in Edges} flow[p, d] <= PLANT_PRODUCTION_MAX[p];

s.t. warehouse_storage_limit_max {w in Warehouses}:
  sum {(w,d) in Edges} flow[w, d] <= WAREHOUSE_STORAGE_MAX[w];

s.t. client_demand_limit_min {c in Clients}:
  sum {(s,c) in Edges} flow[s, c] >= CLIENT_DEMAND[c];

s.t. amperes_law {w in Warehouses}:
  sum {(s,w) in Edges} flow[s, w] = sum {(w,d) in Edges} flow[w, d];

s.t. calculate_client_preference_satisfaction {c in Clients}:
  sum {(s,c) in Edges : (s,c) in ClientPreferences} flow[s,c] / CLIENT_DEMAND[c]
  >= satisfaction[c];


### REFERENCE POINT MODEL

set Targets = {"cost", "satisfaction"};

param EPSILON default 1e-10;
param BETA default 0.01;
param ASPIRATION {Targets} default 0;
param LAMBDA {Targets} default 1;

var target_values {Targets};
var target_min;

s.t. target_cost:
  target_values["cost"] <= -LAMBDA["cost"] * (total_cost - ASPIRATION["cost"]);

s.t. target_cost_beta:
  target_values["cost"] <= -BETA * LAMBDA["cost"] * (total_cost - ASPIRATION["cost"]);

s.t. target_satisfaction:
  target_values["satisfaction"] <= LAMBDA["satisfaction"]
   * (total_satisfaction - ASPIRATION["satisfaction"]);

s.t. target_satisfaction_beta:
  target_values["satisfaction"] <= BETA * LAMBDA["satisfaction"]
   * (total_satisfaction - ASPIRATION["satisfaction"]);

s.t. target_min_less_than_others {t in Targets}:
  target_min <= target_values[t];

maximize reference_point_criterium:
  target_min + BETA * sum {t in Targets} target_values[t];
