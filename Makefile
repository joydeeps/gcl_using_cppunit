# Sample command lines:
#
# Build just the libraries:
#   $ make
#
# Build and run the tests:
#   $ make test
#
# Build and test with g++-4.4 in C++98 mode:
#   $ make test CXX=g++-4.4 CXXFLAGS=-std=c++98
#
# Build and test with g++-4.4 in C++0x mode:
#   $ make test CXX=g++-4.4 CXXFLAGS=-std=c++0x
#
# Build optimized libraries:
#   $ make ALLCFLAGS=-O3
#
# Remove all build output. Remember to do this when changing compilers or flags.
#   $ make clean

# Put the user's flags after the defaults, so the user can override
# the defaults.
CppFlags := $(CPPFLAGS)
AllCFlags := -pthread -Wall -Werror -g $(ALLCFLAGS)
CxxFlags := $(AllCFlags) $(CXXFLAGS)
CFlags := $(AllCFlags) $(CFLAGS)
LdLibs := -L/home/JoydeepS/Projects/google-concurrency-library/trunk /home/JoydeepS/third_party_libraries/cppunit-1.12.1/lib/libcppunit.a -lstd_thread -pthread $(LDLIBS)


all: libstd_thread.a

clean:
	find * -name '*.a' -o -name '*.o' -o -name '*.d' | xargs $(RM)
	$(RM) AllTests

test: AllTests
	./AllTests

STD_THREAD_OBJS := src/thread.o src/mutex.o src/condition_variable.o
libstd_thread.a: CppFlags += -Iinclude
libstd_thread.a: $(STD_THREAD_OBJS)

TEST_OBJS := testing/thread_test_cpp.o
AllTests: CppFlags += -Iinclude -I/home/JoydeepS/third_party_libraries/cppunit-1.12.1/include
AllTests: $(TEST_OBJS)
	$(CXX) -o $@ $(LdFlags) $^ $(LOADLIBES) $(LdLibs)


%.a:
	$(RM) $@
	$(AR) -rc $@ $^

# Automatically rebuild when header files change:
DEPEND_OPTIONS = -MMD -MP -MF "$*.d.tmp"
MOVE_DEPENDFILE = then mv -f "$*.d.tmp" "$*.d"; \
                  else $(RM) "$*.d.tmp"; exit 1; fi
%.o: %.cc
	if $(CXX) -o $@ -c $(CppFlags) $(DEPEND_OPTIONS) $(CxxFlags) $< ; \
		$(MOVE_DEPENDFILE)

# Include the generated dependency makefiles.
ALL_SOURCE_BASENAMES := $(basename $(shell find * -name "*.c" -o -name "*.cc"))
-include $(ALL_SOURCE_BASENAMES:%=%.d)
