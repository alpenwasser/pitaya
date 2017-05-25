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

# NOTE: Adding -nojvm shaves off about 5 to 10 seconds, but if you want
# to perform more analysis of your results with graphical tools, for
# example fvtool, then you'll need to launch with jvm.
# -nojvm makes most sense when you also specify EXIT=exit on the command
# line to instantly exit Matlab after it has designed the filters and
# written the results to its coefficient and plot files.
# By default, launch with JVM and don't exit at end
JVM       ?=
EXIT      ?= 
# For the all target, don't launch the jvm and exit when done.
all: JVM  = -nojvm
all: EXIT = exit
# NOTE: Do not change the assignment operator to ':=' here! JVM gets
# modified by some targets.
MATLAB     = matlab -nosplash -nodesktop $(JVM) -r
DISPATCHER = cliDispatcher
PLOT_DIR   = plotData
COEF_DIR   = coefData
RM         = rm -rf

.DEFAULT: dec5

# Inefficient, but leaving here for testing purposes:
#all: dec5 dec25 dec625 dec1250 dec2500 dec4 dec6 dec24 dec120 dec600 dec1200 dec2400

# Much more efficient, since only one Matlab instance is started.
all: 
	@$(MATLAB) "filtertype='DEC5';   $(DISPATCHER);\
	            filtertype='DEC25';  $(DISPATCHER);\
	            filtertype='DEC125'; $(DISPATCHER);\
	            filtertype='DEC625'; $(DISPATCHER);\
	            filtertype='DEC1250';$(DISPATCHER);\
	            filtertype='DEC2500';$(DISPATCHER);\
	            filtertype='DEC4';   $(DISPATCHER);\
	            filtertype='DEC6';   $(DISPATCHER);\
	            filtertype='DEC24';  $(DISPATCHER);\
	            filtertype='DEC120'; $(DISPATCHER);\
	            filtertype='DEC600'; $(DISPATCHER);\
	            filtertype='DEC1200';$(DISPATCHER);\
	            filtertype='DEC2400';$(DISPATCHER);$(EXIT)"

dec5:
	@$(MATLAB) "filtertype='DEC5';$(DISPATCHER);$(EXIT)"

dec25:
	@$(MATLAB) "filtertype='DEC25';$(DISPATCHER);$(EXIT)"

dec125:
	@$(MATLAB) "filtertype='DEC125';$(DISPATCHER);$(EXIT)"

dec625:
	@$(MATLAB) "filtertype='DEC625';$(DISPATCHER);$(EXIT)"

dec1250:
	@$(MATLAB) "filtertype='DEC1250';$(DISPATCHER);$(EXIT)"

dec2500:
	@$(MATLAB) "filtertype='DEC2500';$(DISPATCHER);$(EXIT)"

dec4:
	@$(MATLAB) "filtertype='DEC4';$(DISPATCHER);$(EXIT)"

dec6:
	@$(MATLAB) "filtertype='DEC6';$(DISPATCHER);$(EXIT)"

dec24:
	@$(MATLAB) "filtertype='DEC24';$(DISPATCHER);$(EXIT)"

dec120:
	@$(MATLAB) "filtertype='DEC120';$(DISPATCHER);$(EXIT)"

dec600:
	@$(MATLAB) "filtertype='DEC600';$(DISPATCHER);$(EXIT)"

dec1200:
	@$(MATLAB) "filtertype='DEC1200';$(DISPATCHER);$(EXIT)"

dec2400:
	@$(MATLAB) "filtertype='DEC2400';$(DISPATCHER);$(EXIT)"

clean:
	$(RM) $(PLOT_DIR)
	$(RM) $(COEF_DIR)
