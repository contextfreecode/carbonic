const
    bullet = "btBulletDynamicsCommon.h"

type
    Vector3* {.header: bullet, importcpp: "btVector3".} = object
    Transform* {.header: bullet, importcpp: "btTransform".} = object
    CollisionConfiguration* {.
        header: bullet,
        importcpp: "btCollisionConfiguration".} = object of RootObj
    DefaultCollisionConfiguration* {.
            header: bullet,
            importcpp: "btDefaultCollisionConfiguration".} =
        object of CollisionConfiguration
    CollisionDispatcher* {.
        header: bullet,
        importcpp: "btCollisionDispatcher".} = object
    DbvtBroadphase* {.header: bullet, importcpp: "btDbvtBroadphase".} = object
    SequentialImpulseConstraintSolver* {.
        header: bullet,
        importcpp: "btSequentialImpulseConstraintSolver".} = object
    DiscreteDynamicsWorld* {.
        header: bullet,
        importcpp: "btDiscreteDynamicsWorld".} = object

func makeCollisionDispatcher*(
    collisionConfiguration: ptr CollisionConfiguration,
): CollisionDispatcher {.
    header: bullet,
    importcpp: "btCollisionDispatcher(@)",
    constructor.}

func makeDiscreteDynamicsWorld*(
    collisionConfiguration: ptr CollisionConfiguration,
    dispatcher: ptr CollisionDispatcher,
    overlappingPairCache: ptr DbvtBroadphase,
    solver: ptr SequentialImpulseConstraintSolver,
): DiscreteDynamicsWorld {.
    header: bullet,
    importcpp: "btDiscreteDynamicsWorld(@)",
    constructor.}

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
