R2      = 32;
RCIC    = 8;
AstCIC  = 60;
FpCIC   = 1/R2;
DL      = 1;
HdCIC   = decCIC(RCIC,  FpCIC, AstCIC, DL, plotDir);
RComp   = 4;
FpComp  = 1/R2;
FstComp = 1/R2 * 1.1;
ApComp  = 0.25;
AstComp = 60;
HdComp  = compCIC(RComp, FpComp, FstComp, ApComp, AstComp, DL, ...
                  HdCIC, coefDir, plotDir);
