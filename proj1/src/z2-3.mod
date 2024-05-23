set Z;
set P;
set E within {Z, P};

param time {E};

var assignment {(i, j) in E} >= 0 <= 1 integer;
var max_time;

s.t. one_assignment_per_team {z in Z}:
  sum {(i, j) in E : i = z} assignment[i, j] = 1;

s.t. one_assignment_per_project {p in P}:
  sum {(i, j) in E : j = p} assignment[i, j] = 1;

s.t. max_time_ge_than_all_times {(i, j) in E}:
  max_time >= time[i, j] * assignment[i, j];

minimize min_max_time: max_time;
