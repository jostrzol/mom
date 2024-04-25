# SETS AND GENERAL PARAMETERS

set Materials = {"S1", "S2"};
set HalfProducts = {"D1", "D2"};
set Products = {"W1", "W2"};
param material_cost_range_n;
set CostRanges = {1..material_cost_range_n};

param M;

# MATERIAL PURCHASE PARAMETERS, VARIABLES AND CONSTRAINTS

param material_limit {Materials};
param material_unit_cost {Materials, CostRanges};
param material_unit_cost_bound {Materials, CostRanges};
param material_unit_cost_range_width {m in Materials, r in CostRanges} =
  if (r = 1) then
    material_unit_cost_bound[m, r]
  else
    material_unit_cost_bound[m, r] - material_unit_cost_bound[m, r-1];

var material_bought_in_range {Materials, CostRanges};
var material_bought {m in Materials} = sum {r in CostRanges} material_bought_in_range[m, r];
var S1_unit_cost_range_depleted {r in CostRanges : r != material_cost_range_n} binary;

var material_cost_total
  = sum {m in Materials, r in CostRanges} material_bought_in_range[m, r] * material_unit_cost[m, r];

s.t. material_limit_not_exceeded {m in Materials}:
  material_bought[m] <= material_limit[m];

s.t. S2_bought_min {r in CostRanges}:
  material_bought_in_range["S2", r] >= 0;

s.t. S2_bought_max {r in CostRanges}:
  material_bought_in_range["S2", r] <= material_unit_cost_range_width["S2", r];

s.t. S1_bought_min {r in CostRanges}:
  material_bought_in_range["S1", r] >=
    if (r != material_cost_range_n) then
      material_unit_cost_range_width["S1", r] * S1_unit_cost_range_depleted[r]
    else 0;

s.t. S1_bought_max {r in CostRanges}:
  material_bought_in_range["S1", r] <=
    if (r == 1) then
      material_unit_cost_range_width["S1", r]
    else if (r != material_cost_range_n) then
      material_unit_cost_range_width["S1", r] * S1_unit_cost_range_depleted[r-1]
    else
      M * S1_unit_cost_range_depleted[r-1];

# MATERIAL DELIVERY PARAMETERS, VARIABLES AND CONSTRAINTS

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
  (S2_to_factory_truck_n + S2_to_heat_treatment_truck_n) * S2_truck_unit_cost;

s.t. S1_to_factory_max_one_trailer_per_truck:
  S1_to_factory_trailer_n <= S1_to_factory_truck_n;

s.t. S1_to_factory_all_delivered:
  material_bought["S1"] <=
    S1_to_factory_truck_n * S1_truck_capacity + S1_to_factory_trailer_n * S1_trailer_capacity;

s.t. S2_to_factory_max:
  S2_to_factory <= material_bought["S2"];

s.t. S2_to_factory_all_delivered:
  S2_to_factory <= S2_to_factory_truck_n * S2_truck_capacity;

s.t. S2_to_heat_treatment_all_delivered:
  S2_to_heat_treatment <= S2_to_heat_treatment_truck_n * S2_truck_capacity;

# FACTORY PRODUCTION PARAMETERS, VARIABLES AND CONSTRAINTS

param factory_halfproduct_per_material {Materials, HalfProducts};
param factory_capacity;
param factory_worker_group_capacity;
param factory_worker_group_size;
param factory_worker_salary;

var factory_stock {Materials};
var factory_halfproduct_made {hp in HalfProducts}
  = sum {m in Materials} factory_stock[m] * factory_halfproduct_per_material[m, hp];
var factory_throughput = sum {m in Materials} factory_stock[m];
var factory_worker_group_n integer;

var factory_cost_total = factory_worker_group_n * factory_worker_group_size * factory_worker_salary;

s.t. factory_stock_S1: factory_stock["S1"] = material_bought["S1"];
s.t. factory_stock_S2: factory_stock["S2"] = S2_to_factory;
s.t. factory_production_max: factory_throughput <= factory_capacity;
s.t. factory_worker_group_n_min:
  factory_throughput <=
    factory_worker_group_n * factory_worker_group_capacity;

# HEAT TREATMENT PARAMETERS, VARIABLES AND CONSTRAINTS

param heat_treatment_throughput_min;
param heat_treatment_throughput_max;
param heat_treatment_unit_cost;

var heat_treatment_throughput;
var heat_treatment_enabled binary;

var heat_treatment_cost_total = heat_treatment_throughput * heat_treatment_unit_cost;

s.t. heat_treatment_throughput_min_limit:
  heat_treatment_throughput >= heat_treatment_throughput_min * heat_treatment_enabled;
s.t. heat_treatment_throughput_max_limit:
  heat_treatment_throughput <= heat_treatment_throughput_max * heat_treatment_enabled;
s.t. heat_treatment_throughput_max_limit_stock:
  heat_treatment_throughput <= S2_to_heat_treatment;

# REVENUE PARAMETERS, VARIABLES AND CONSTRAINTS

param product_unit_revenue {Products};
param product_production_min {Products};

var product_made {Products};
var sell_revenue_total = sum {p in Products} product_made[p] * product_unit_revenue[p];

s.t. product_made_W1: product_made["W1"] = factory_halfproduct_made["D1"];
s.t. product_made_W2:
  product_made["W2"] = factory_halfproduct_made["D2"] + heat_treatment_throughput;
s.t. product_made_min {p in Products}:
  product_made[p] >= product_production_min[p];

# OPTIMIZATION TARGET

maximize total_profit:
  sell_revenue_total- material_cost_total - delivery_cost_total - factory_cost_total -
    heat_treatment_cost_total;
