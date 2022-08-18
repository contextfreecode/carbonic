#include <lib.h>
#include <btBulletDynamicsCommon.h>
#include <vector>
#include <bullet-demo-support.hpp>
namespace Jakt {
namespace bullet {
}
static void init_body(btDiscreteDynamicsWorld& world, const btCollisionShape* shape, const f32 mass, const btVector3 origin);

static void clean_dynamics_world(btDiscreteDynamicsWorld& world);

namespace bullet {
}
static void init_body(btDiscreteDynamicsWorld& world,const btCollisionShape* shape,const f32 mass,const btVector3 origin) {
{
btTransform transform = btTransform();
((transform).setIdentity());
((transform).setOrigin((origin)));
const bool is_dynamic = (mass != static_cast<f32>(0));
btVector3 local_inertia = btVector3(static_cast<f32>(0),static_cast<f32>(0),static_cast<f32>(0));
if (is_dynamic){
{
(((*shape)).calculateLocalInertia(mass,(local_inertia)));
}

}
{
auto motionState = new btDefaultMotionState(transform);btRigidBody::btRigidBodyConstructionInfo rbInfo(    mass, motionState, const_cast<btCollisionShape*>(shape),    local_inertia);world.addRigidBody(new btRigidBody(rbInfo));
}

}
}

static void clean_dynamics_world(btDiscreteDynamicsWorld& world) {
{
const i32 num = (((world)).getNumCollisionObjects());
{
Range<i32> _magic = (Range<i32>{static_cast<i32>(static_cast<i32>(0)),static_cast<i32>(num)});
for (;;){
Optional<i32> _magic_value = ((_magic).next());
if ((!((_magic_value).has_value()))){
break;
}
i32 i = (_magic_value.value());
{
btCollisionObject* obj = ((((((world)).getCollisionObjectArray()))).at((JaktInternal::checked_sub<i32>((JaktInternal::checked_sub<i32>(num,i)),static_cast<i32>(1)))));
const btRigidBody* body = btRigidBody::upcast(obj);
{
if (body && body->getMotionState()) {    delete body->getMotionState();}
}

(((world)).removeCollisionObject(obj));
{
delete obj;
}

}

}
}

}
}

ErrorOr<int> main(Array<String>) {
{
btDefaultCollisionConfiguration collision_configuration = btDefaultCollisionConfiguration();
btCollisionDispatcher dispatcher = btCollisionDispatcher((&collision_configuration));
btDbvtBroadphase overlapping_pair_cache = btDbvtBroadphase();
btSequentialImpulseConstraintSolver solver = btSequentialImpulseConstraintSolver();
btDiscreteDynamicsWorld world = btDiscreteDynamicsWorld((&dispatcher),(&overlapping_pair_cache),(&solver),(&collision_configuration));

#define __SCOPE_GUARD_NAME __scope_guard_ ## __COUNTER__
ScopeGuard __SCOPE_GUARD_NAME ([&] 
#undef __SCOPE_GUARD_NAME
{{
clean_dynamics_world((world));
}

});
btBoxShape ground_shape = btBoxShape(btVector3(static_cast<f32>(50),static_cast<f32>(50),static_cast<f32>(50)));
init_body((world),cast<btCollisionShape, btBoxShape>((&ground_shape)),static_cast<f32>(0),btVector3(static_cast<f32>(0),(-static_cast<f32>(56)),static_cast<f32>(0)));
btSphereShape sphere_shape = btSphereShape(static_cast<f32>(1));
const std::vector<i32> v = std::vector<i32>();
if (((v).empty())){
outln(String("PASS"));
}
const Array<i64> x = (TRY((Array<i64>::create_with({static_cast<i64>(1LL), static_cast<i64>(2LL), static_cast<i64>(3LL)}))));
outln(String("{}"),((x)[static_cast<i64>(1LL)]));
}
return 0;
}

} // namespace Jakt
