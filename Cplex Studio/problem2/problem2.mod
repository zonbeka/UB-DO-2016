/*********************************************
 * OPL 12.6.0.0 Model
 * Author: Hernan Caceres
 * Creation Date: Feb 11, 2015 at 9:26:59 AM
*********************************************/

// parameters

int n = ...;
int m = ...;

range cargos = 1 .. n;
range comps = 1 .. m;

float profit[cargos] = ...;
float weight[cargos] = ...;
float volume[cargos] = ...;

float weight_cap[comps] = ...;
float space_cap[comps] = ...;

// VARIABLE

dvar int+ x[cargos][comps];
dvar float+ y;

maximize sum ( i in cargos, j in comps ) profit[i] * x[i][j];
  
subject to {
  forall ( i in cargos )
    sum ( j in comps ) x[i][j] <= weight[i];

  forall ( j in comps )
    sum ( i in cargos ) x[i][j] <= weight_cap[j];

  forall ( j in comps )
    sum ( i in cargos ) volume[i] * x[i][j] <= space_cap[j];

  forall ( j in comps )
    sum ( i in cargos ) x[i][j] / weight_cap[j] == y;

}