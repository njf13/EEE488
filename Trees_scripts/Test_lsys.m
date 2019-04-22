axiom = "[FA]";
ruleA = ["A", "[+F[+F[+F[+F]-FB]-F[+F]-F]-F]-F[+F[+F[+F]-FA]-F]-FB", 1];
ruleB = ["B", "[+F[+F]-F]-F[+FB]-F", 1];
l = lsystem(axiom,[ruleA; ruleB], 17.5, false);
l.generate(12)



d = dendrite(l.dA, l.X, l.Y, []);
d.plot;