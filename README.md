
Clir is a Cirru to C compiler for fun
----

> C is designed with curly brackets, and I want to write in Cirru syntax.

Status: prototyping...

### Usage

```bash
npm i --save clir
```

```coffee
clir = require 'clir'

source = """
stdio.h #include

main :: (int int) int
main \ (a b)
  (a + b) return
"""

clir.transform(source)
```

returns:

```c
#include <stdio.h>

int main(int a, int b) {
  return a + b;
}
```

### Develop

Use Webpack for debugging:

```bash
npm i
webpack-dev-server --hot
# debugger.html
```

### License

MIT
