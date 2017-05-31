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

# ---------------------------------------------------------------------------- #
# Variables
# ---------------------------------------------------------------------------- #
PLOT_DIR  = plotData
COEF_DIR  = coefData
LOG_DIR   = logs
TIMESTAMP = $(shell date '+%Y-%m-%d--%H-%M-%S')
LOG_FILE  = $(TIMESTAMP)--$@.log
MSG       = $(shell echo $@ | sed 's/dec/Building decimator for R = /')
# NOTE: Adding -nojvm shaves off about  5 to 10 seconds, but
# if you want to perform  more analysis of your results with
# graphical tools,  for example fvtool, then  you'll need to
# launch with jvm.
# -nojvm makes most sense when you also specify EXIT=exit on
# the command  line to  instantly exit  Matlab after  it has
# designed  the  filters  and  written the  results  to  its
# coefficient and plot files.
JVM       ?= # By default, launch with JVM,
EXIT      ?= # don't exit at the end, and
REDIRECT  ?= # don't redirect output.
LOGARG    ?= -logfile $(LOG_DIR)/$(LOG_FILE)
# For the all target, don't launch the jvm and exit when done.
all:      JVM      = -nojvm
all:      EXIT     = exit
all:      REDIRECT = 1>/dev/null
parallel: JVM      = -nojvm
parallel: EXIT     = exit
parallel: REDIRECT = 1>/dev/null
# NOTE: Do  not  change  the  assignment  operator  to  ':='
# here! JVM gets modified by some targets.
MATLAB     = matlab -nosplash -nodesktop $(LOGARG) $(JVM) -r
DISPATCHER = cliDispatcher
RM         = rm -rf
MKDIR      = mkdir -p

# ---------------------------------------------------------------------------- #
.DEFAULT: logdir
# ---------------------------------------------------------------------------- #

# ---------------------------------------------------------------------------- #
# Aggregate Targets
# ---------------------------------------------------------------------------- #
# For testing purposes:
#inefficient: dec5 dec25 dec625 dec1250 dec2500 dec4 \
#	     dec6 dec24 dec120 dec600 dec1200 dec2400

# Much more efficient, since only one Matlab instance is started.
all: logdir
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
	            filtertype='DEC2400';$(DISPATCHER);$(EXIT)" $(REDIRECT)

# Invoke  with -j<cores  count>  to  launch multiple  Matlab
# instances concurrently. If you have  enough cores, this is
# the most  efficient way  to do  things. If not,  the 'all'
# target is probably faster.
parallel: dec5 dec25 dec625 dec1250 dec2500 dec4 \
	  dec6 dec24 dec120 dec600 dec1200 dec2400

# ---------------------------------------------------------------------------- #
# Single Targets
# ---------------------------------------------------------------------------- #
dec5: logdir
	@echo $(MSG)
	@$(MATLAB) "filtertype='DEC5';$(DISPATCHER);$(EXIT)" $(REDIRECT)

dec25: logdir
	@echo $(MSG)
	@$(MATLAB) "filtertype='DEC25';$(DISPATCHER);$(EXIT)" $(REDIRECT)

dec125: logdir
	@echo $(MSG)
	@$(MATLAB) "filtertype='DEC125';$(DISPATCHER);$(EXIT)" $(REDIRECT)

dec625: logdir
	@echo $(MSG)
	@$(MATLAB) "filtertype='DEC625';$(DISPATCHER);$(EXIT)" $(REDIRECT)

dec1250: logdir
	@echo $(MSG)
	@$(MATLAB) "filtertype='DEC1250';$(DISPATCHER);$(EXIT)" $(REDIRECT)

dec2500: logdir
	@echo $(MSG)
	@$(MATLAB) "filtertype='DEC2500';$(DISPATCHER);$(EXIT)" $(REDIRECT)

dec4: logdir
	@echo $(MSG)
	@$(MATLAB) "filtertype='DEC4';$(DISPATCHER);$(EXIT)" $(REDIRECT)

dec6: logdir
	@echo $(MSG)
	@$(MATLAB) "filtertype='DEC6';$(DISPATCHER);$(EXIT)" $(REDIRECT)

dec24: logdir
	@echo $(MSG)
	@$(MATLAB) "filtertype='DEC24';$(DISPATCHER);$(EXIT)" $(REDIRECT)

dec120: logdir
	@echo $(MSG)
	@$(MATLAB) "filtertype='DEC120';$(DISPATCHER);$(EXIT)" $(REDIRECT)

dec600: logdir
	@echo $(MSG)
	@$(MATLAB) "filtertype='DEC600';$(DISPATCHER);$(EXIT)" $(REDIRECT)

dec1200: logdir
	@echo $(MSG)
	@$(MATLAB) "filtertype='DEC1200';$(DISPATCHER);$(EXIT)" $(REDIRECT)

dec2400: logdir
	@echo $(MSG)
	@$(MATLAB) "filtertype='DEC2400';$(DISPATCHER);$(EXIT)" $(REDIRECT)

logdir:
	@$(MKDIR) $(LOG_DIR)

clean:
	$(RM) $(PLOT_DIR)
	$(RM) $(COEF_DIR)
	$(RM) $(LOG_DIR)
