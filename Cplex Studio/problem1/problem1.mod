/*********************************************
 * OPL 12.6.3.0 Model
 * Author: Hernan Caceres
 * Creation Date: Feb 22, 2016 at 8:56:02 PM
  *********************************************/

  dvar float+ x;
  dvar float+ y;

  minimize
    0.12 * x + 0.15 * y;

  subject to {
    cons01:
      60 * x + 60 * y >= 300;
    cons02:
      12 * x + 6 * y >= 36;
    cons03:
      10 * x + 30 * y >= 90;
  }

execute {
  if (cplex.getCplexStatus() == 1) {
    writeln("reduced cost of x ", x.reducedCost);
    writeln("reduced cost of y ", y.reducedCost);
    writeln("dual value cons1 ", cons01.dual);
    writeln("dual value cons2 ", cons02.dual);
    writeln("dual value cons3 ", cons03.dual);
  }
}