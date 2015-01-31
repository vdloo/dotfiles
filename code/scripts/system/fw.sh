#!/bin/bash
#forward remote ports to localhost
#example: $ fw 8080 s1
ssh -C -N -f -L $1:localhost:$1 ${*:2}
