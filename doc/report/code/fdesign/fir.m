R1     = 5;
Fp     = 0.2;
Fst    = [0.21 0.225];
Ast    = 60;
Ap     = 0.25;
HdFIR  = decFIR(R1, Fp, Fst, Ap, Ast, coefDir, plotDir);
