#! /usr/bin/env bash
source "test-helper.sh"

#
# stub() tests.
#


# Stubbing a bash function.
my-name-is() { echo "My name is $@."; }
assert "my-name-is Edward Elric" "My name is Edward Elric."

stub "my-name-is"
assert "my-name-is" "my-name-is stub: "
assert "my-name-is Edward" "my-name-is stub: Edward"
assert "my-name-is Edward Elric" "my-name-is stub: Edward Elric"
unset -f my-name-is


# Stubbing a executable file.
stub "uname"
assert "uname" "uname stub: "
assert "uname -h" "uname stub: -h"
unset -f uname


# Redirect stub output to STDERR.
my-name-is() { echo "My name is $@."; }
stub "my-name-is" STDERR
assert "my-name-is Edward" ""
assert "my-name-is Edward 2>&1" "my-name-is stub: Edward"
unset -f my-name-is


# Stubbing something that doesn't exist.
stub "cowabunga-dude"
assert "cowabunga-dude yeah dude" "cowabunga-dude stub: yeah dude"
unset -f cowabunga-dude


# End of tests.
assert_end "stub()"
