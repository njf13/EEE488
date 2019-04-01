clear

a = ["A", "[+F[+F[+F[+F]-FB]-F[+F]-F]-F]-F[+F[+F[+F]-FA]-F[+F]-F]-FB", 1];
b = ["B", "[+F[+F]-F]-F[+FB]-F", 1];

%a = ["A", "F[-F]+FA", 1];

l = lsystem("[FA]",[a;b], 15, false);
%l.rules(1,:) = ["F", "F+F", 1];

l.generate(5)



d = dendrite(l.dA, l.X, l.Y, []);
d.plot;