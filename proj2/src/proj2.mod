set Products = { "W1", "W2" };
set Materials = { "S1", "S2" };
set MaterialCostRanges within { Materials, 1..Infinity };

param material_limit { Materials };
param material_unit_cost { MaterialCostRanges };
param material_unit_cost_bound { MaterialCostRanges };
param material_unit_cost_convex { Materials } binary;
param material_unit_cost_range_width { (m, r) in MaterialCostRanges } =
  if (r = 1) then
    material_unit_cost_bound[m, r]
  else
    material_unit_cost_bound[m, r] - material_unit_cost_bound[m, r-1];
param material_unit_cost_range_last { m in Materials }
  = max { (mm, r) in MaterialCostRanges : m = mm } r;

param M = 1e6;

var material_bought_in_range { MaterialCostRanges };
var material_bought { m in Materials }
  = sum { (mm, r) in MaterialCostRanges : mm = m } material_bought_in_range[m, r];
#var material_bought { Materials } >= 0;
var material_price_total { m in Materials }
  = sum { (mm, r) in MaterialCostRanges : mm = m } material_bought_in_range[m, r] * material_unit_cost[m, r];
var material_unit_cost_range_depleted { (m, r) in MaterialCostRanges : material_unit_cost_convex[m] = 0 } binary;

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

maximize total_profit:
  sum {m in Materials} material_bought[m];
