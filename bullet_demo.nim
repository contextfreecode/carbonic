import bullet
import std/strformat

type
    DynamicsWorldStore = object
        collisionConfiguration: DefaultCollisionConfiguration
        dispatcher: CollisionDispatcher
        overlappingPairCache: DbvtBroadphase
        solver: SequentialImpulseConstraintSolver
        world: DiscreteDynamicsWorld

func makeDynamicsWorldStore(): DynamicsWorldStore =
    let
        collisionConfiguration = DefaultCollisionConfiguration()
        dispatcher = makeCollisionDispatcher(unsafeAddr collisionConfiguration)
        overlappingPairCache = DbvtBroadphase()
        solver = SequentialImpulseConstraintSolver()
    DynamicsWorldStore(
        collisionConfiguration: collisionConfiguration,
        dispatcher: dispatcher,
        overlappingPairCache: overlappingPairCache,
        solver: solver,
        world: makeDiscreteDynamicsWorld(
            unsafeAddr collisionConfiguration,
            unsafeAddr dispatcher,
            unsafeAddr overlappingPairCache,
            unsafeAddr solver,
        )
    )

proc main() =
    let dynamicsWorldStore = makeDynamicsWorldStore()
    discard dynamicsWorldStore.world
    let transform = makeTransform()
    transform.setIdentity()
    echo(fmt"{transform.origin.x}")
    transform.origin.x = 1.5
    echo(fmt"{transform.origin.x}")
    let origin = makeVector3(1, 2, 3)
    echo(fmt"{origin.y}")

main()
