# stub.sh [![Build Status](https://travis-ci.org/jimeh/stub.sh.png)](https://travis-ci.org/jimeh/stub.sh)

A set of stubbing helpers for use in bash script tests. Supports stubbing and
restoring both binaries and bash functions.

Particularly useful when used in combination with the simple and elegant
[assert.sh](https://github.com/lehmannro/assert.sh) test framework.


## Usage

Put `stub.sh` in your project, and source it into your tests. For detailed
examples, why not have a look at the [tests][] for stub.sh itself?

[tests]: https://github.com/jimeh/stub.sh/tree/master/test

### Examples

Stubbing binaries:

```bash
source "stub.sh"
uname #=> Darwin
stub uname
uname #=> uname stub:
uname -r #=> uname stub: -r
restore uname
uname #=> Darwin
```

Stubbing bash functions:

```bash
source "stub.sh"
my-name-is() { echo "My name is $@."; }
my-name-is Edward Elric #=> My name is Edward Elric.
stub my-name-is
my-name-is Edward Elric #=> my-name-is stub: Edward Elric
restore my-name-is
my-name-is Edward Elric #=> My name is Edward Elric.
```

Asserting stub has been called:

```bash
source "stub.sh"
my-uname() { uname; }
stub_and_echo uname "FooBar"
stub_called uname # return value of 1 (error)
my-uname            #=> FooBar
stub_called uname # return value of 0 (success)
restore uname
```

Asserting stub has been called X times:

```bash
source "stub.sh"
my-uname() { uname; }
stub_and_echo uname "FooBar"
stub_called_times uname   #=> 0
stub_called_times uname 2 # return value of 1 (error)
my-uname                  #=> FooBar
stub_called_times uname   #=> 1
stub_called_times uname 2 # return value of 1 (error)
my-uname                  #=> FooBar
stub_called_times uname   #=> 2
stub_called_times uname 2 # return value of 0 (success)
restore uname
```


## Function Reference

- `stub`: Basic stubbing command. Will echo a default message to STDOUT.
  Arguments:
    - `$1`: Name of command to stub
    - `$2`: When set to "STDERR", echo to STDERR instead of STDOUT (optional).
- `stub_and_echo`: Stub given command and echo a custom string to STDOUT.
  Arguments:
    - `$1`: Name of command to stub.
    - `$2`: String to echo when stub is called.
    - `$3`: When set to "STDERR", echo to STDERR instead of STDOUT (optional).
- `stub_and_eval`: Stub given command and execute custom commands via eval.
  Arguments:
    - `$1`: Name of command to stub.
    - `$2`: String to eval when stub is called.
- `restore`: Restores use of original binary/function that was stubbed.
  Arguments:
    - `$1`: Name of command to restore.
- `stub_called`: Check if given stub has been called. Gives a `0` return value
  when true, and `1` when false.
    - `$1`: Name of stub to check.
- `stub_called_times`: Find out how many times a stub has been called, or
  given a second argument it validates if stub was called exactly X times.
    - `$1`: Name of stub to check.
    - `$2`: Exact number of times stub should have been called (optional).
- `stub_called_at_least_times`: Validate that stub has been called at least X
  number of times.
    - `$1`: Name of stub to check.
    - `$2`: Minimum number of times stub should have been called.
- `stub_called_at_most_times`: Validate that stub has been called no more than
  X number of times.
    - `$1`: Name of stub to check.
    - `$2`: Maximum number of times stub should have been called.


## Todo

- Add a `stub_called_with` function that validates the stub has been called
  with specific arguments.
- Add a `stub_called_with_times` function that validates the stub has been
  called with specific arguments a specific number of times.


## License

(The MIT license)

Copyright (c) 2014 Jim Myhrberg.

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.
