#! /usr/bin/env bash
source "test-helper.sh"

#
# stub_called() tests.
#

# Returns 1 when stub doesn't exist.
assert_raises 'stub_called "uname"' 1

# Returns 1 when stub hasn't been called.
stub "uname"
assert_raises 'stub_called "uname"' 1
restore "uname"

# Returns 0 when stub has been called.
stub "uname"
uname
assert_raises 'stub_called "uname"' 0
restore "uname"

# Returns 1 after called stub has been restored.
stub "uname"
uname
restore "uname"
assert_raises 'stub_called "uname"' 1

# Restoring only resets called state of restored stub.
stub "uname"
stub "top"
uname
top
restore "uname"
assert_raises 'stub_called "uname"' 1
assert_raises 'stub_called "top"' 0
restore "top"


# End of tests.
assert_end "stub_called()"
