#include <lib.h>
#include <btBulletDynamicsCommon.h>
#include <vector>
#include <bullet-demo-support.hpp>
namespace Jakt {
namespace bullet {
}
static void init_body(btDiscreteDynamicsWorld& world, const btCollisionShape* shape, const f32 mass, const btVector3 origin);

static void clean_dynamics_world(btDiscreteDynamicsWorld& world);

static void print_all(btDiscreteDynamicsWorld const& world);

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

static void print_all(btDiscreteDynamicsWorld const& world) {
{
{
Range<i32> _magic = (Range<i32>{static_cast<i32>(static_cast<i32>(0)),static_cast<i32>((((world)).getNumCollisionObjects()))});
for (;;){
Optional<i32> _magic_value = ((_magic).next());
if ((!((_magic_value).has_value()))){
break;
}
i32 i = (_magic_value.value());
{
const btCollisionObject* obj = ((((((world)).getCollisionObjectArray()))).at(i));
const btRigidBody* body = btRigidBody::upcast(obj);
btTransform trans = btTransform();
{
if (body && body->getMotionState()) {    body->getMotionState()->getWorldTransform(trans);} else {    trans = obj->getWorldTransform();}
}

outln(String("world pos object {} = {} {} {}"),i,((((trans).getOrigin())).getX()),((((trans).getOrigin())).getY()),((((trans).getOrigin())).getZ()));
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
init_body((world),cast<btCollisionShape, btSphereShape>((&sphere_shape)),static_cast<f32>(1),btVector3(static_cast<f32>(2),static_cast<f32>(10),static_cast<f32>(0)));
{
Range<i64> _magic = (Range<i64>{static_cast<i64>(static_cast<i64>(0LL)),static_cast<i64>(static_cast<i64>(10LL))});
for (;;){
Optional<i64> _magic_value = ((_magic).next());
if ((!((_magic_value).has_value()))){
break;
}
i64 i = (_magic_value.value());
{
((world).stepSimulation((static_cast<f32>(1) / static_cast<f32>(60)),static_cast<i32>(10)));
print_all((world));
}

}
}

}
return 0;
}

} // namespace Jakt
