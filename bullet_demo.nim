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
#             unsafeAddr dispatcher,
#             unsafeAddr overlappingPairCache,
#             unsafeAddr solver,
#             unsafeAddr collisionConfiguration,
#         )
#     )

proc delete*(obj: ptr auto) {.importcpp: "delete #".}

proc new*[T](t: T): ptr T {.importcpp: "(new '*0#@)".}

proc cleanDynamicsWorld(world: var DiscreteDynamicsWorld) =
    for i in countdown(world.numCollisionObjects - 1, 0):
        var
            obj = world.collisionObjectArray[i]
            body = rigidBodyUpcast(obj)
        if body != nil and body.motionState != nil:
            body.motionState.delete
        world.removeCollisionObject(obj)
        obj.delete

proc initBody(
    mass: float32, origin: Vector3, shape: var CollisionShape
): ptr RigidBody =
    var
        localInertia = makeVector3(0, 0, 0)
        transform = makeTransform()
    transform.setIdentity()
    transform.origin = origin
    let isDynamic = mass != 0
    if isDynamic:
        shape.calculateLocalInertia(mass = mass, localInertia = localInertia)
    var motionState = makeDefaultMotionState(transform).new
    let rbInfo = makeRigidBodyConstructionInfo(
        mass = mass,
        motionState = motionState,
        shape = unsafeAddr shape,
        localInertia = localInertia,
    )
    makeRigidBody(rbInfo).new

proc printAll(world: var DiscreteDynamicsWorld) =
    for i in 0..<world.numCollisionObjects:
        let
            obj = world.collisionObjectArray[i]
            body = rigidBodyUpcast(obj)
        var transform = makeTransform()
        if body != nil and body.motionState != nil:
            body.motionState.getWorldTransform(transform)
        else:
            transform = obj.worldTransform
        let origin = transform.origin
        echo(fmt"world pos object {i} = {origin.x} {origin.y} {origin.z}")

proc main() =
    var
        collisionConfiguration = makeDefaultCollisionConfiguration()
        dispatcher = makeCollisionDispatcher(unsafeAddr collisionConfiguration)
        overlappingPairCache = makeDbvtBroadphase()
        solver = SequentialImpulseConstraintSolver()
        world = makeDiscreteDynamicsWorld(
            dispatcher = unsafeAddr dispatcher,
            overlappingPairCache = unsafeAddr overlappingPairCache,
            solver = unsafeAddr solver,
            collisionConfiguration = unsafeAddr collisionConfiguration,
        )
    defer: cleanDynamicsWorld(world)
    var
        groundShape = makeBoxShape(makeVector3(50, 50, 50))
        sphereShape = makeSphereShape(1)
    world.addRigidBody(
        initBody(mass = 0, origin = makeVector3(0, -56, 0), shape = groundShape)
    )
    world.addRigidBody(
        initBody(mass = 1, origin = makeVector3(2, 10, 0), shape = sphereShape)
    )
    for i in 1..150:
        world.stepSimulation(1.0 / 60.0, 10)
        printAll(world)

main()
