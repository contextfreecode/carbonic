#include "btBulletDynamicsCommon.h"

auto vector3Make(btScalar x, btScalar y, btScalar z) -> btVector3 {
    return btVector3(x, y, z);
}

auto del(btVector3* vector) -> void {
    delete vector;
}

auto x(const btVector3& vector) -> btScalar { return vector.getX(); }
auto y(const btVector3& vector) -> btScalar { return vector.getY(); }
auto z(const btVector3& vector) -> btScalar { return vector.getZ(); }
