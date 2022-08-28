const
  bullet = "btBulletDynamicsCommon.h"

type
  AlignedObjectArray*[T] {.
    header: bullet, importcpp: "btAlignedObjectArray".} = object

  CollisionConfiguration* {.
    header: bullet,
    importcpp: "btCollisionConfiguration".} = object of RootObj

  CollisionDispatcher* {.
    header: bullet, importcpp: "btCollisionDispatcher".} = object

  CollisionObject* {.
    header: bullet, importcpp: "btCollisionObject".} = object

  CollisionShape* {.
    header: bullet, importcpp: "btCollisionShape".} = object of RootObj

  BoxShape* {.
    header: bullet, importcpp: "btBoxShape".} = object of CollisionShape

  SphereShape* {.
    header: bullet,
    importcpp: "btSphereShape".} = object of CollisionShape

  DbvtBroadphase* {.header: bullet, importcpp: "btDbvtBroadphase".} = object

  DefaultCollisionConfiguration* {.
      header: bullet, importcpp: "btDefaultCollisionConfiguration".} =
    object of CollisionConfiguration

  DiscreteDynamicsWorld* {.
    header: bullet, importcpp: "btDiscreteDynamicsWorld".} = object

  MotionState* {.
    header: bullet, importcpp: "btMotionState".} = object of RootObj

  DefaultMotionState* {.
    header: bullet,
    importcpp: "btDefaultMotionState".} = object of MotionState

  RigidBody* {.
    header: bullet, importcpp: "btRigidBody".} = object

  RigidBodyConstructionInfo* {.
      header: bullet,
      importcpp: "btRigidBody::btRigidBodyConstructionInfo"
    .} = object

  SequentialImpulseConstraintSolver* {.
    header: bullet,
    importcpp: "btSequentialImpulseConstraintSolver".} = object

  Transform* {.header: bullet, importcpp: "btTransform".} = object

  Vector3* {.header: bullet, importcpp: "btVector3".} = object

proc `[]`*[T](this: var AlignedObjectArray[T], n: int): var T {.
  header: bullet,
  importcpp: "#[#]".}

func makeBoxShape*(halfExtents: Vector3): BoxShape {.
  header: bullet, importcpp: "btBoxShape(@)", constructor.}

func makeCollisionDispatcher*(
  collisionConfiguration: ptr CollisionConfiguration,
): CollisionDispatcher {.
  header: bullet,
  importcpp: "btCollisionDispatcher(@)",
  constructor.}

func worldTransform*(obj: ptr CollisionObject): Transform {.
  header: bullet, importcpp: "#.getWorldTransform()".}

proc calculateLocalInertia*(
  collisionShape: CollisionShape, mass: float32, localInertia: var Vector3
) {.header: bullet, importcpp: "#.calculateLocalInertia(@)".}

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

func addRigidBody*(
  world: var DiscreteDynamicsWorld, body: ptr RigidBody
) {.header: bullet, importcpp: "#.addRigidBody(#)".}

func collisionObjectArray*(
  world: DiscreteDynamicsWorld
): var AlignedObjectArray[ptr CollisionObject] {.
  header: bullet,
  importcpp: "#.getCollisionObjectArray()".}

func numCollisionObjects*(world: DiscreteDynamicsWorld): int {.
  header: bullet,
  importcpp: "#.getNumCollisionObjects()".}

proc removeCollisionObject*(
  world: var DiscreteDynamicsWorld, obj: ptr CollisionObject
) {.
  header: bullet,
  importcpp: "#.removeCollisionObject(#)".}

proc stepSimulation*(
  world: var DiscreteDynamicsWorld, timeStep: float32, maxSubSteps: int
) {.header: bullet, importcpp: "#.stepSimulation(@)".}

func makeDefaultMotionState*(transform: Transform): DefaultMotionState {.
  header: bullet, importcpp: "btDefaultMotionState(@)", constructor.}

proc getWorldTransform*(
  motionState: ptr MotionState, transform: var Transform
) {.header: bullet, importcpp: "#.getWorldTransform(@)".}

func makeRigidBody*(info: RigidBodyConstructionInfo): RigidBody {.
  header: bullet, importcpp: "btRigidBody(@)", constructor.}

proc rigidBodyUpcast*(obj: ptr CollisionObject): ptr RigidBody {.
  header: bullet,
  importcpp: "btRigidBody::upcast(@)".}

proc motionState*(body: ptr RigidBody): ptr MotionState {.
  header: bullet,
  importcpp: "#.getMotionState()".}

func makeRigidBodyConstructionInfo*(
  mass: float32,
  motionState: ptr MotionState,
  shape: ptr CollisionShape,
  localInertia: Vector3,
): RigidBodyConstructionInfo {.
  header: bullet,
  importcpp: "btRigidBody::btRigidBodyConstructionInfo(@)",
  constructor.}

func makeSphereShape*(radius: float32): SphereShape {.
  header: bullet, importcpp: "btSphereShape(@)", constructor.}

func makeTransform*(): Transform {.
  header: bullet,
  importcpp: "btTransform()",
  constructor.}

proc origin*(transform: Transform): var Vector3 {.
  header: bullet,
  importcpp: "#.getOrigin()".}

proc `origin=`*(transform: var Transform, origin: Vector3) {.
  header: bullet,
  importcpp: "#.setOrigin(#)".}

proc setIdentity*(transform: Transform) {.
  header: bullet,
  importcpp: "#.setIdentity()".}

func makeVector3*(x: float32, y: float32, z: float32): Vector3 {.
  header: bullet,
  importcpp: "btVector3(@)",
  constructor.}

func x*(vector: Vector3): float32 {.header: bullet, importcpp: "#.getX()".}

func y*(vector: Vector3): float32 {.header: bullet, importcpp: "#.getY()".}

func z*(vector: Vector3): float32 {.header: bullet, importcpp: "#.getZ()".}
