```
                                                .,ad88888888baa,
                                            ,d8P"""        ""9888ba.
                                         .a8"          ,ad88888888888a
                                        aP'          ,88888888888888888a
                                      ,8"           ,88888888888888888888,
                                     ,8'            (888888888( )888888888,
                                    ,8'             `8888888888888888888888
                                    8)               `888888888888888888888,
                                    8                  "8888888888888888888)
                                    8                   `888888888888888888)
                                    8)                    "8888888888888888
                                    (b                     "88888888888888'
                                    `8,        (8)          8888888888888)
                                     "8a                   ,888888888888)
                                       V8,                 d88888888888"
                                        `8b,             ,d8888888888P'
                                          `V8a,       ,ad8888888888P'
                                             ""88888888888888888P"    
```
# Yet Another "New GCC" (Yang)

This is a simple C compiler for a custom CPU architecture (see [ying](https://www.github.com/guillaumebour/ying)).  

It is based on the following C BNF:  
https://cs.wmich.edu/~gupta/teaching/cs4850/sumII06/The%20syntax%20of%20C%20in%20Backus-Naur%20form.htm

See also the [Taijitu](https://www.github.com/guillaumebour/taijitu) project, which is the corresponding interpreter.

## Compilation

This project can be compiled using the autotools with the following commands:
```
~/yang $ autoreconf --install
~/yang $ ./configure
~/yang $ make
```

## Usage

```
Usage: compiler [options] < FILE
Options:
  -v            Increase verbosity level.
  -q            Set verbosity level to quiet.
  -b            Output raw binary code instead of assembly.
  -o filename   Write assembly to file. Default is stdout.
  -h            Display this help message.
```

## Running tests

To run tests:
```
~/yang $ python3 tests/run-tests.py -vv
```



