import std/strformat

const
    bullet = "btBulletDynamicsCommon.h"

type
    Transform {.header: bullet, importcpp: "btTransform".} = object
        x: float

const
    transform = Transform(x: 5.0)

proc hi() {.header: bullet, importcpp: "hi".}

echo(fmt"hi {transform.x}")
hi()
