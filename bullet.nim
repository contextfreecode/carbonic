const
    bullet = "btBulletDynamicsCommon.h"

type
    AlignedObjectArray*[T] {.
        header: bullet,
        importcpp: "btAlignedObjectArray".} = object

    CollisionConfiguration* {.
        header: bullet,
        importcpp: "btCollisionConfiguration".} = object of RootObj

    CollisionDispatcher* {.
        header: bullet,
        importcpp: "btCollisionDispatcher".} = object

    CollisionObject* {.
        header: bullet,
        importcpp: "btCollisionObject".} = object

    DbvtBroadphase* {.header: bullet, importcpp: "btDbvtBroadphase".} = object

    DefaultCollisionConfiguration* {.
            header: bullet,
            importcpp: "btDefaultCollisionConfiguration".} =
        object of CollisionConfiguration

    DiscreteDynamicsWorld* {.
        header: bullet,
        importcpp: "btDiscreteDynamicsWorld".} = object

    MotionState* {.
        header: bullet,
        importcpp: "btMotionState".} = object

    RigidBody* {.
        header: bullet,
        importcpp: "btRigidBody".} = object

    SequentialImpulseConstraintSolver* {.
        header: bullet,
        importcpp: "btSequentialImpulseConstraintSolver".} = object

    Transform* {.header: bullet, importcpp: "btTransform".} = object

    Vector3* {.header: bullet, importcpp: "btVector3".} = object

proc cdelete*(obj: ptr auto) {.importcpp: "delete #".}

func makeCollisionDispatcher*(
    collisionConfiguration: ptr CollisionConfiguration,
): CollisionDispatcher {.
    header: bullet,
    importcpp: "btCollisionDispatcher(@)",
    constructor.}

proc `[]`*[T](this: var AlignedObjectArray[T], n: int): var T {.
    header: bullet,
    importcpp: "#[#]".}

func makeDbvtBroadphase*(): DbvtBroadphase {.
    header: bullet,
    importcpp: "btDbvtBroadphase()",
    constructor.}

func makeDefaultCollisionConfiguration*(): DefaultCollisionConfiguration {.
    header: bullet,
    importcpp: "btDefaultCollisionConfiguration()",
    constructor.}

func makeDiscreteDynamicsWorld*(
    dispatcher: ptr CollisionDispatcher,
    overlappingPairCache: ptr DbvtBroadphase,
    solver: ptr SequentialImpulseConstraintSolver,
    collisionConfiguration: ptr CollisionConfiguration,
): DiscreteDynamicsWorld {.
    header: bullet,
    importcpp: "btDiscreteDynamicsWorld(@)",
    constructor.}

func collisionObjectArray*(
    world: DiscreteDynamicsWorld
): var AlignedObjectArray[ptr CollisionObject] {.
    header: bullet,
    importcpp: "#.getCollisionObjectArray()".}

func numCollisionObjects*(world: DiscreteDynamicsWorld): int {.
    header: bullet,
    importcpp: "#.getNumCollisionObjects()".}

func removeCollisionObject*(
    world: var DiscreteDynamicsWorld, obj: ptr CollisionObject
) {.
    header: bullet,
    importcpp: "#.removeCollisionObject(#)".}

proc rigidBodyUpcast*(obj: ptr CollisionObject): ptr RigidBody {.
    header: bullet,
    importcpp: "btRigidBody::upcast(@)".}

proc motionState*(body: ptr RigidBody): ptr MotionState {.
    header: bullet,
    importcpp: "#.getMotionState()".}

func makeVector3*(x: float32, y: float32, z: float32): Vector3 {.
    header: bullet,
    importcpp: "btVector3(@)",
    constructor.}

func x*(vector: Vector3): float32 {.
    header: bullet,
    importcpp: "#.getX()".}

proc `x=`*(vector: var Vector3, x: float32) {.
    header: bullet,
    importcpp: "#.setX(@)".}

func y*(vector: Vector3): float32 {.
    header: bullet,
    importcpp: "#.getY()".}

func makeTransform*(): Transform {.
    header: bullet,
    importcpp: "btTransform()",
    constructor.}

proc origin*(transform: Transform): var Vector3 {.
    header: bullet,
    importcpp: "#.getOrigin()".}

proc setIdentity*(transform: Transform) {.
    header: bullet,
    importcpp: "#.setIdentity()".}
