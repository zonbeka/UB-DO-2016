/*********************************************
 * OPL 12.6.0.0 Model
 * Author: Hernan Caceres
 * Creation Date: Feb 18, 2015 at 9:30:08 AM
*********************************************/

int n = ...;

range cities = 1 .. n;

float c[cities][cities];

//random data
tuple cityType {
  float x;
  float y;
}

cityType cityData[cities];

execute {
  for ( var i = 1; i <= n; i++) {
    cityData[i].x = Opl.rand(100000) / 1000;
    cityData[i].y = Opl.rand(100000) / 1000;
  }
  for ( var i = 1; i <= n; i++) {
    for ( var j = 1; j <= n; j++) {
      c[i][j] = Opl.sqrt(Opl.pow(cityData[i].x - cityData[j].x, 2)
          + Opl.pow(cityData[i].y - cityData[j].y, 2));
    }
  }
}

// decision variables
dvar boolean x[cities][cities];
dvar float+ u[cities];

// expressions

dexpr float TotalDistance = sum ( i in cities, j in cities : j != i )
   c[i][j] * x[i][j];

// model

minimize
  TotalDistance;

subject to {
  forall ( j in cities )
    sum ( i in cities : i != j ) x[i][j] == 1;

  forall ( i in cities )
    sum ( j in cities : j != i ) x[i][j] == 1;

  forall ( i in cities : i != 1, j in cities : j != 1 && i != j )
    u[i] - u[j] + ( n - 1 ) * x[i][j] <= n - 2;

}

main {
  var mod = thisOplModel.modelDefinition;
  var dat = thisOplModel.dataElements;
  for ( var size = 5; size <= 50; size += 5) {
    var MyCplex = new IloCplex();
    var opl = new IloOplModel(mod, MyCplex);
    dat.n = size;
    opl.addDataSource(dat);
    opl.generate();
    var t1 = MyCplex.getCplexTime();
    if (!MyCplex.solve()) {
      writeln("ERROR: could not solve");
    } else {
      var t2 = MyCplex.getCplexTime();
      var obj = MyCplex.getObjValue();
      writeln("solution: ", obj, "  size: ", size, "  time: ", t2 - t1);
    }
  }
}