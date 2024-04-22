set Materials = {"S1", "S2"};
set HalfProducts = {"D1", "D2"};
set Products = {"W1", "W2"};
set MaterialCostRanges within {Materials, 1..Infinity};

param material_limit {Materials};
param material_unit_cost {MaterialCostRanges};
param material_unit_cost_bound {MaterialCostRanges};
param material_unit_cost_convex {Materials} binary;
param material_unit_cost_range_width {(m, r) in MaterialCostRanges} =
  if (r = 1) then
    material_unit_cost_bound[m, r]
  else
    material_unit_cost_bound[m, r] - material_unit_cost_bound[m, r-1];
param material_unit_cost_range_last {m in Materials}
  = max {(mm, r) in MaterialCostRanges : m = mm} r;

param M = 1e6;

var material_bought_in_range {MaterialCostRanges};
var material_bought {m in Materials}
  = sum {(mm, r) in MaterialCostRanges : mm = m} material_bought_in_range[m, r];
#var material_bought {Materials} >= 0;
var material_price_total {m in Materials}
  = sum {(mm, r) in MaterialCostRanges : mm = m} material_bought_in_range[m, r] * material_unit_cost[m, r];
var material_unit_cost_range_depleted {(m, r) in MaterialCostRanges : material_unit_cost_convex[m] = 0} binary;

s.t. material_limit_not_exceeded {m in Materials}:
  material_bought[m] <= material_limit[m];

s.t. material_bought_min_convex {(m, r) in MaterialCostRanges : material_unit_cost_convex[m] = 1}:
  material_bought_in_range[m, r] >= 0;

s.t. material_bought_max_convex {(m, r) in MaterialCostRanges : material_unit_cost_convex[m] = 1}:
  material_bought_in_range[m, r] <= material_unit_cost_range_width[m, r];

s.t. material_bought_min_concave {(m, r) in MaterialCostRanges : material_unit_cost_convex[m] = 0}:
  material_bought_in_range[m, r] >=
    if (r != material_unit_cost_range_last[m]) then
      material_unit_cost_range_width[m, r] * material_unit_cost_range_depleted[m, r]
    else 0;

s.t. material_bought_max_concave {(m, r) in MaterialCostRanges : material_unit_cost_convex[m] = 0}:
  material_bought_in_range[m, r] <=
    if (r == 1) then
      material_unit_cost_range_width[m, r]
    else if (r != material_unit_cost_range_last[m]) then
      material_unit_cost_range_width[m, r] * material_unit_cost_range_depleted[m, r-1]
    else
      M * material_unit_cost_range_depleted[m, r-1];

param S1_truck_capacity;
param S1_truck_unit_cost;
param S1_trailer_capacity;
param S1_trailer_unit_cost;
param S1_truck_n_max;
param S2_truck_capacity;
param S2_truck_unit_cost;

var S1_to_factory_truck_n integer <= S1_truck_n_max;
var S1_to_factory_trailer_n integer;
var S2_to_factory >= 0;
var S2_to_factory_truck_n integer;
var S2_to_heat_treatment = material_bought["S2"] - S2_to_factory;
var S2_to_heat_treatment_truck_n integer;
var delivery_cost_total =
  S1_to_factory_truck_n * S1_truck_unit_cost +
  S1_to_factory_trailer_n * S1_trailer_unit_cost +
  S2_to_factory_truck_n * S2_truck_unit_cost;

s.t. S1_to_factory_max_one_trailer_per_truck:
  S1_to_factory_trailer_n <= S1_to_factory_truck_n;

s.t. S1_to_factory_all_delivered:
  material_bought["S1"] <=
    S1_to_factory_truck_n * S1_truck_capacity + S1_to_factory_trailer_n * S1_trailer_capacity;

s.t. S2_to_factory_all_delivered:
  S2_to_factory <= S2_to_factory_truck_n * S2_truck_capacity;

s.t. S2_to_heat_treatment_all_delivered:
  S2_to_heat_treatment <= S2_to_heat_treatment_truck_n * S2_truck_capacity;

param factory_halfproduct_per_material {Materials, HalfProducts};
param factory_capacity;
param factory_production_unit_size;
param factory_worker_n_per_production_unit;
param factory_worker_salary;

var factory_stock {Materials};
var factory_halfproduct_made {hp in HalfProducts}
  = sum {m in Materials} factory_stock[m] * factory_halfproduct_per_material[m, hp];
var factory_throughput = sum {m in Materials} factory_stock[m];
var factory_worker_n integer;
var factory_price_total = factory_worker_n * factory_worker_salary;

s.t. factory_stock_S1: factory_stock["S1"] = material_bought["S1"];
s.t. factory_stock_S2: factory_stock["S2"] = S2_to_factory;
s.t. factory_production_max: factory_throughput <= factory_capacity;
s.t. factory_worker_n_min:
  factory_worker_n >= factory_throughput /
    factory_production_unit_size * factory_worker_n_per_production_unit;

param heat_treatment_throughput_min;
param heat_treatment_throughput_max;
param heat_treatment_unit_cost;

var heat_treatment_throughput;
var heat_treatment_enabled binary;
var heat_treatment_price_total = heat_treatment_throughput * heat_treatment_unit_cost;

s.t. heat_treatment_throughput_min_limit:
  heat_treatment_throughput >= heat_treatment_throughput_min * heat_treatment_enabled;
s.t. heat_treatment_throughput_max_limit:
  heat_treatment_throughput <= heat_treatment_throughput_max * heat_treatment_enabled;

maximize total_profit:
  sum {m in Materials} material_bought[m];
