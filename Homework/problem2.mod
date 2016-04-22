/*********************************************
 * OPL 12.6.3.0 Model
 * Author: Hernan Caceres
 * Creation Date: Feb 22, 2016 at 5:25:55 PM
*********************************************/

// poblem size
int n = 500;
int m = 4;
int W = ...;
range items = 1 .. n;
range cons = 1 .. m;

// generate random data
float v[items];
float w[items][cons];

execute {
  // define function that returns a random number between a and b with d decimal places
  function getRand(a, b, d) {
    return a + Opl.rand((b - a) * Opl.pow(10, d)) / Opl.pow(10, d);
  }
  // calculate random vectors
  for ( var i in items) {
    v[i] = getRand(0.0, 10.0, 5);
    for ( var j in cons) {
      w[i][j] = getRand(0.0, 20.0, 5);
    }
  }
}

// decision variables
dvar boolean x[items];

// expressions
dexpr float obj = sum (i in items) v[i] * x[i];

maximize obj;

subject to {
  forall (j in cons)
    sum (i in items) w[i][j] * x[i] <= W;
}

main {
  var mod = thisOplModel.modelDefinition;
  var dat = thisOplModel.dataElements;
  writeln("n\tobj\ttime");
  for ( var size = 0; size <= 6000; size += 100) {
    var MyCplex = new IloCplex();
    var opl = new IloOplModel(mod, MyCplex);
    dat.W = size;
    opl.addDataSource(dat);
    opl.generate();
    var t1 = MyCplex.getCplexTime();
    if (!MyCplex.solve()) {
      writeln("ERROR: could not solve");
    } else {
      var t2 = MyCplex.getCplexTime();
      writeln(size, "\t", MyCplex.getObjValue(), "\t", t2 - t1);
    }
    opl.end();
    MyCplex.end();
  }
}