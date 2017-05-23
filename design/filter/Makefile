# ---------------------------------------------------------------------------- #
# Makefile for Filter Design
#
# Makefile for design/filter/
# Location:    design/filter/Makefile
# 
# Authors: Raphael Frey <rmfrey@alpenwasser.net>
#
# Date:   2017-05-21
# 
# Called by: user
#
# Working Directory: design/filter/
# ---------------------------------------------------------------------------- #

# NOTE: Adding -nojvm shaves off about 10 seconds for the FIR5 iterator
#       (figures disabled, of course).
MATLAB     = matlab -nosplash -nodesktop -r
DISPATCHER = cliDispatcher
PLOT_DIR   = plotData
COEF_DIR   = coefData
RM         = rm -rf

.DEFAULT: fir5

fir5:
	@$(MATLAB) "filtertype='FIR5';$(DISPATCHER)"

clean:
	$(RM) $(PLOT_DIR)
	$(RM) $(COEF_DIR)
