#include "btBulletDynamicsCommon.h"

auto vector3New(btScalar x, btScalar y, btScalar z) -> btVector3* {
    return new btVector3(x, y, z);
}

auto del(btVector3* vector) -> void {
    delete vector;
}

auto x(btVector3* vector) -> btScalar { return vector->getX(); }
auto y(btVector3* vector) -> btScalar { return vector->getY(); }
auto z(btVector3* vector) -> btScalar { return vector->getZ(); }
