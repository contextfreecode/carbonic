/*
Bullet Continuous Collision Detection and Physics Library
Copyright (c) 2003-2007 Erwin Coumans  https://bulletphysics.org

This software is provided 'as-is', without any express or implied warranty.
In no event will the authors be held liable for any damages arising from the
use of this software. Permission is granted to anyone to use this software for
any purpose, including commercial applications, and to alter it and
redistribute it freely, subject to the following restrictions:

1. The origin of this software must not be misrepresented; you must not claim
that you wrote the original software. If you use this software in a product, an
acknowledgment in the product documentation would be appreciated but is not
required.
2. Altered source versions must be plainly marked as such, and must not be
misrepresented as being the original software.
3. This notice may not be removed or altered from any source distribution.
*/

#include <stdio.h>

#include "btBulletDynamicsCommon.h"

struct DynamicsWorldStore {
    btDefaultCollisionConfiguration collisionConfiguration;
    btCollisionDispatcher dispatcher{&collisionConfiguration};
    btDbvtBroadphase overlappingPairCache;
    btSequentialImpulseConstraintSolver solver;
    btDiscreteDynamicsWorld world{&dispatcher, &overlappingPairCache, &solver,
                                  &collisionConfiguration};

    ~DynamicsWorldStore() {
        for (int i = world.getNumCollisionObjects() - 1; i >= 0; i--) {
            btCollisionObject* obj = world.getCollisionObjectArray()[i];
            btRigidBody* body = btRigidBody::upcast(obj);
            if (body && body->getMotionState()) {
                delete body->getMotionState();
            }
            world.removeCollisionObject(obj);
            delete obj;
        }
    }
};

struct InitBodyArgs {
    btScalar mass;
    btVector3 origin;
    btCollisionShape* shape;
};

auto init_body(const InitBodyArgs& init) -> btRigidBody* {
    btTransform transform;
    transform.setIdentity();
    transform.setOrigin(init.origin);
    bool isDynamic = (init.mass != 0.f);
    btVector3 localInertia(0, 0, 0);
    if (isDynamic) init.shape->calculateLocalInertia(init.mass, localInertia);
    // Using motionstate provides interpolation capabilities and only
    // synchronizes 'active' objects.
    btDefaultMotionState* motionState = new btDefaultMotionState(transform);
    btRigidBody::btRigidBodyConstructionInfo rbInfo(init.mass, motionState,
                                                    init.shape, localInertia);
    return new btRigidBody(rbInfo);
}

auto print_all(const btDiscreteDynamicsWorld& world) -> void {
    for (int i = 0; i < world.getNumCollisionObjects(); i += 1) {
        btCollisionObject* obj = world.getCollisionObjectArray()[i];
        btRigidBody* body = btRigidBody::upcast(obj);
        btTransform trans;
        if (body && body->getMotionState()) {
            body->getMotionState()->getWorldTransform(trans);
        } else {
            trans = obj->getWorldTransform();
        }
        printf("world pos object %d = %f %f %f\n", i,
               float(trans.getOrigin().getX()), float(trans.getOrigin().getY()),
               float(trans.getOrigin().getZ()));
    }
}

auto main() -> int {
    DynamicsWorldStore dynamicsWorldStore;
    auto& world = dynamicsWorldStore.world;
    world.setGravity({0, -10, 0});
    // Track shapes separately for potential reuse.
    auto groundShape = btBoxShape({0, 50, 50});
    auto sphereShape = btSphereShape(1);
    world.addRigidBody(init_body({
        .mass = 0,
        .origin = {0, -56, 0},
        .shape = &groundShape,
    }));
    world.addRigidBody(init_body({
        .mass = 1,
        .origin = {2, 10, 0},
        .shape = &sphereShape,
    }));
    /// Run simulation.
    for (int i = 0; i < 10; i++) {
        world.stepSimulation(1.f / 60.f, 10);
        print_all(world);
    }
}
