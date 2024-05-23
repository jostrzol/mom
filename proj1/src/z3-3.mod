set Materials;
set Products;

param max_material_throughput { Materials };
param product_material_cost { Products, Materials };

param standard_product_price { Products };
param product_discount_treshold { Products };
param discounted_product_price { Products };

var production { p in Products } >= 0;
var production_over_treshold { p in Products } >= 0;
var production_under_treshold { p in Products } >= 0;

s.t. material_limit { m in Materials }:
  sum { p in Products } product_material_cost[p, m] * production[p] <= max_material_throughput[m];

s.t. production_vs_treshold { p in Products }:
  production_over_treshold[p] - production_under_treshold[p]
  = production[p] - product_discount_treshold[p];

maximize profit:
  sum { p in Products } (
    standard_product_price[p] * (production[p] - production_over_treshold[p])
    + discounted_product_price[p] * production_over_treshold[p]
  );
