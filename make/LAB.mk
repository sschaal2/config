#############################################################################
#############################################################################
#
#  This is a make include file originally programmed for the CLMC/AMD labs
#  at the University of Southern California and the Max-Planck-Institute for
#  Intelligent Systems. We use a mixutre of explicit makefiles and cmake, but 
#  primarily we relay on cmake for all major compile dependencies. All our
#  software is provided under a slightly modified version of the LGPL license
#  to be found at http://www-clmc.usc.edu/software/license.
#
#  Copyright by Stefan Schaal, 2014
#
#############################################################################
#############################################################################

CMAKE_CMD = cmake
MAKE      = make
MKDIR     = mkdir

all::
doc::
%:: 
	@case '${MFLAGS}' in *[ik]*) set +e; esac; \
	for i in $(SUBDIRS) ; \
	do \
		 if [ ! -d $$i ]; then \
		     $(MKDIR) $$i; \
		     echo "Created " $$i; \
		  fi; \
		  cd $$i; \
		  if [ ! -f "CMakeCache.txt" ]; then \
		     $(CMAKE_CMD) ../src; \
		  fi; \
		  echo "Make $@ in `pwd` begun..."; \
		  $(MAKE) $(MFLAGS) $@; \
	done

