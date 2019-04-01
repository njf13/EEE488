clear

a1 = ["A", "[+F[+F[+F[+F]-FB]-F[+F]-F]-F]-F[+F[+F[+F]-FA]-F[+F]-F]-FB", 0.8];
a2 = ["A", "[+F[+F[+F[+F]-F]-F[+F]-F]-F]-F[+F[+F[+F]-F]-F[+F]-F]-FB", 0.2];
b = ["B", "[+F[+F]-F]-F[+FB]-F", 1];


l = lsystem("[FA]",[a1;a2;b], 15, false);
%l.rules(1,:) = ["F", "F+F", 1];

l.generate(10)



d = dendrite(l.dA, l.X, l.Y, []);
d.plot;