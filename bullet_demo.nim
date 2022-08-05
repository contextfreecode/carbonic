import std/strformat

const
    bullet = "btBulletDynamicsCommon.h"

type
    Vector3 {.header: bullet, importcpp: "btVector3".} = object
    Transform {.header: bullet, importcpp: "btTransform".} = object

func newVector3(x: float32, y: float32, z: float32): Vector3 {.
    header: bullet,
    importcpp: "btVector3(@)",
    constructor.}

func x(vector: Vector3): float32 {.
    header: bullet,
    importcpp: "#.getX()".}

proc `x=`(vector: var Vector3, x: float32) {.
    header: bullet,
    importcpp: "#.setX(@)".}

func y(vector: Vector3): float32 {.
    header: bullet,
    importcpp: "#.getY()".}

proc origin(transform: Transform): var Vector3 {.
    header: bullet,
    importcpp: "#.getOrigin()".}

proc setIdentity(transform: Transform) {.
    header: bullet,
    importcpp: "#.setIdentity()".}

proc main() =
    let transform = Transform()
    transform.setIdentity()
    echo(fmt"{transform.origin.x}")
    transform.origin.x = 1.5
    echo(fmt"{transform.origin.x}")
    let origin = newVector3(1, 2, 3)
    echo(fmt"{origin.y}")

main()
