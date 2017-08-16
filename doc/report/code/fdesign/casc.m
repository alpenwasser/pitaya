% ... design filter objects first ...
stages = cell(2,1);
stages{1} = Hd1;
stages{2} = Hd2;
Hcasc = cascador(R, Fp, Fst, Ap, Ast, 1, plotDir, stages);
