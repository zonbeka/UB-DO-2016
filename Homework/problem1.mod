/*********************************************
 * OPL 12.6.3.0 Model
 * Author: zonbe
 * Creation Date: Mar 4, 2016 at 12:25:14 PM
*********************************************/

int n = ...;
int K = ...;
int Q = ...;

range nodes = 0..n;

float coordX[nodes] = ...;
float coordY[nodes] = ...;
float q[nodes] = ...;
float c[nodes][nodes];

execute {
	for (var i=0; i<=n; i++) {
		for (var j=0; j<=n; j++) {
			c[i][j] = Opl.sqrt(Opl.pow(coordX[i]-coordX[j], 2)+Opl.pow(coordY[i]-coordY[j], 2));
		}
	}
}

dvar boolean x[nodes][nodes];
dvar float+ u[nodes];

minimize sum(i in nodes, j in nodes : j!=i) c[i][j]*x[i][j];

subject to {
	forall (i in nodes : i!=0) sum (j in nodes : j!=i) x[i][j] == 1;
	forall (j in nodes : j!=0) sum (i in nodes : i!=j) x[i][j] == 1;
	sum (j in nodes : j!=0) x[0][j] == K;
	forall (i in nodes : i!=0, j in nodes : j!=i && j!=0) u[i] - u[j] + Q*x[i][j] <= Q - q[i];
	forall (i in nodes : i!=0) q[i] <= u[i] <= Q;
}

execute {
	for (var h=1; h<=n; h++) {
		if (x[0][h]>0.9) {
			writeln("New tour");
			var i=h;
			while (i!=0) {
				for (var j=0; j<=n; j++) {
					if (x[i][j]>0.9) {
						writeln("\t"+i);
						i=j;
						break;
					}
				}
			}
		}
	}
}