import bullet
import std/strformat

# type
#     DynamicsWorldStore = object
#         collisionConfiguration: DefaultCollisionConfiguration
#         dispatcher: CollisionDispatcher
#         overlappingPairCache: DbvtBroadphase
#         solver: SequentialImpulseConstraintSolver
#         world: DiscreteDynamicsWorld

# func makeDynamicsWorldStore(): DynamicsWorldStore =
#     let
#         collisionConfiguration = DefaultCollisionConfiguration()
#         dispatcher = makeCollisionDispatcher(unsafeAddr collisionConfiguration)
#         overlappingPairCache = DbvtBroadphase()
#         solver = SequentialImpulseConstraintSolver()
#     DynamicsWorldStore(
#         collisionConfiguration: collisionConfiguration,
#         dispatcher: dispatcher,
#         overlappingPairCache: overlappingPairCache,
#         solver: solver,
#         world: makeDiscreteDynamicsWorld(
#             unsafeAddr collisionConfiguration,
#             unsafeAddr dispatcher,
#             unsafeAddr overlappingPairCache,
#             unsafeAddr solver,
#         )
#     )

proc cleanDynamicsWorld(world: var DiscreteDynamicsWorld) =
    for i in countdown(world.numCollisionObjects - 1, 0):
        var
            obj = world.collisionObjectArray()[i]
            body = rigidBodyUpcast(obj)
        if body != nil and body.motionState != nil:
            body.motionState.cdelete
        world.removeCollisionObject(obj)
        obj.cdelete

proc main() =
    # let dynamicsWorldStore = makeDynamicsWorldStore()
    # discard dynamicsWorldStore.world
    var
        collisionConfiguration = makeDefaultCollisionConfiguration()
        dispatcher = makeCollisionDispatcher(unsafeAddr collisionConfiguration)
        overlappingPairCache = makeDbvtBroadphase()
        solver = SequentialImpulseConstraintSolver()
        world = makeDiscreteDynamicsWorld(
            unsafeAddr dispatcher,
            unsafeAddr overlappingPairCache,
            unsafeAddr solver,
            unsafeAddr collisionConfiguration,
        )
    defer: cleanDynamicsWorld(world)
    let transform = makeTransform()
    transform.setIdentity()
    echo(fmt"{transform.origin.x}")
    transform.origin.x = 1.5
    echo(fmt"{transform.origin.x}")
    let origin = makeVector3(1, 2, 3)
    echo(fmt"{origin.y}")

main()
