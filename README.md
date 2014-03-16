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


## Function Reference

- `stub`: Basic stubbing command. Will echo a default message to STDOUT.
  Arguments:
    - `$1`: Name of command to stub
    - `$2`: When set to "STDERR", echo to STDERR instead of STDOUT.
- `stub_and_echo`: Stub given command and echo a custom string to STDOUT.
  Arguments:
    - `$1`: Name of command to stub.
    - `$2`: String to echo when stub is called.
    - `$3`: When set to "STDERR", echo to STDERR instead of STDOUT.
- `stub_and_eval`: Stub given command and execute custom commands via eval.
  Arguments:
    - `$1`: Name of command to stub.
    - `$2`: String to eval when stub is called.
- `restore`: Restores use of original binary/function that was stubbed.
  Arguments:
    - `$1`: Name of command to restore.


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
