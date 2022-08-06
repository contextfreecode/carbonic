import bullet
import std/strformat

proc main() =
    let transform = newTransform()
    transform.setIdentity()
    echo(fmt"{transform.origin.x}")
    transform.origin.x = 1.5
    echo(fmt"{transform.origin.x}")
    let origin = newVector3(1, 2, 3)
    echo(fmt"{origin.y}")

main()
