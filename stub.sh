# !/usr/bin/env bash
# stub.sh 1.0.0 - stubbing helpers for simplifying bash script tests.
# Copyright (c) 2014 Jim Myhrberg.
#
# https://github.com/jimeh/stub.sh
#
# Permission is hereby granted, free of charge, to any person obtaining a copy
# of this software and associated documentation files (the "Software"), to
# deal in the Software without restriction, including without limitation the
# rights to use, copy, modify, merge, publish, distribute, sublicense, and/or
# sell copies of the Software, and to permit persons to whom the Software is
# furnished to do so, subject to the following conditions:
#
# The above copyright notice and this permission notice shall be included in
# all copies or substantial portions of the Software.
#
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
# FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
# AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
# LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
# FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS
# IN THE SOFTWARE.
#


# Stub given command, echoing a default stub message.
#
# Arguments:
#   - $1: Name of command to stub.
#   - $2: When set to "STDERR", echo to STDERR instead of STDOUT.
#
#
stub() {
  stub_and_echo "$1" "$1 stub: \$@" "$2"
}


# Stub given command, and echo given string.
#
# Arguments:
#   - $1: Name of command to stub.
#   - $2: String to echo when stub is called.
#   - $3: When set to "STDERR", echo to STDERR instead of STDOUT.
#
stub_and_echo() {
  if [ "$3" == "STDERR" ]; then local redirect=" 1>&2"; fi
  stub_and_eval "$1" "echo \"$2\"$redirect"
}


# Stub given command, and executes given string with eval.
#
# Arguments:
#   - $1: Name of command to stub.
#   - $2: String to eval when stub is called.
#
stub_and_eval() {
  local cmd="$1"

  # If stubbing a function, store non-stubbed copy of it required for restore.
  if [ -n "$(command -v "$cmd")" ]; then
    if [[ "$(type "$cmd" | head -1)" == *"is a function" ]]; then
      local source="$(type "$cmd" | tail -n +2)"
      source="${source/$cmd/non_stubbed_${cmd}}"
      eval "$source"
    fi
  fi

  # Use a function to keep track of if the command is stubbed, as variable
  # names doesn't support the "-" character, while function names do.
  eval "$(echo -e "${cmd}_is_stubbed() {\n  return 0\n}")"

  # Create the stub.
  eval "$(echo -e "${cmd}() {\n  $2\n}")"
}


# Restore the original command/function that was stubbed.
#
# Arguments:
#   - $1: Name of command to restore.
#
restore() {
  local cmd="$1"

  # Don't do anything if the command isn't currently stubbed.
  if [[ "$(type "${cmd}_is_stubbed" 2>&1)" == *"not found"* ]]; then
    return 0;
  fi

  # Remove stub functions.
  unset -f "${cmd}_is_stubbed"
  unset -f "$cmd"

  # If stub was for a function, restore the original function.
  if type "non_stubbed_${cmd}" &>/dev/null; then
    if [[ "$(type "non_stubbed_${cmd}" | head -1)" == *"is a function" ]]; then
      local source="$(type "non_stubbed_$cmd" | tail -n +2)"
      source="${source/non_stubbed_${cmd}/$cmd}"
      eval "$source"
      unset -f "non_stubbed_${cmd}"
    fi
  fi
}
