# Example makefile for Player client programs
#
# NOTE:  Be sure you have LD_LIBRARY_PATH defined, to include /usr/local/lib
#        (typically, this goes in your .cshrc file (or appropriate variant
#        for the shell you are using) as "setenv LD_LIBRARY_PATH /usr/local/lib")

PLAYERDIR = $(PSROOT)
PROJECTDIR = $(SUROOT)/Projects/PlayerProjects/FollowLeader

# change this stuff as you need to:

# the name you want to give the executable
TARGET = Follow

# the code files you want to compile
# if there is more than one file list them separated by a space.
# e.g. bigbob.cc bigbob2.cc bigbob3.cc
CFILES = Follow_main.cpp Wifi_funcs.cpp Motion_funcs.cpp Algo_funcs.cpp common.cpp

# the directory where all your code is stored
MAIN_DIR = $(PROJECTDIR)/src

# the folder where header files are stored
HEADERS = $(PROJECTDIR)/hdr

#############################################################
################## DON'T CHANGE CODE BELOW ##################
#############################################################

# which compiler to use 
CXX = g++
STRIP = strip

# turns the names of the code files into names of objects. It replaces the suffix
# also can be done by $(CFILES:%.cc = %.o) I think.
OBJS = $(CFILES:.cpp=.o)

# where to find all the header files. -I tells the compiler these folders 
# contain things that are included in your code
INCLUDES = -I$(MAIN_DIR) -I$(HEADERS) -I$(PLAYERDIR)/include/player-2.1/ -I$(PLAYERDIR)/include/boost-1_33_1/

# This links the object files together into a binary. It's dependancy is
# the $(OBJS) bit, so that gets done first.
all: $(OBJS)
	$(CXX) -o $(TARGET) $(OBJS) `pkg-config --libs playerc++`
	$(STRIP) $(TARGET)


# this is run before the make. It puts together object files without linking
# them together into a binary executable	
$(OBJS): 
	$(CXX) `pkg-config --cflags playerc++` $(MAIN_DIR)/$*.cpp  -c $(INCLUDES) 


# removes all the object files. Not automatically done by a call to make,
# need to type "make clean" (without the quotes) into the terminal.	
# or "make all clean"
clean:
	rm -f *.o
	