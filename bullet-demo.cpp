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

#include <memory>
#include <vector>

#include "btBulletDynamicsCommon.h"

template <class T, class U, class... Args>
auto push_unique_and_borrow(std::vector<U>& vector, Args&&... args) -> T* {
    auto store = std::make_unique<T>(std::forward<Args>(args)...);
    auto borrow = store.get();
    vector.push_back(std::move(store));
    return borrow;
}

struct DynamicsWorldStore {
    std::unique_ptr<btDiscreteDynamicsWorld> world;
    ~DynamicsWorldStore() {
        for (int i = world->getNumCollisionObjects() - 1; i >= 0; i--) {
            btCollisionObject* obj = world->getCollisionObjectArray()[i];
            btRigidBody* body = btRigidBody::upcast(obj);
            if (body && body->getMotionState()) {
                delete body->getMotionState();
            }
            world->removeCollisionObject(obj);
            delete obj;
        }
    }
};

int main(int argc, char** argv) {
    auto collisionConfiguration =
        std::make_unique<btDefaultCollisionConfiguration>();
    auto dispatcher =
        std::make_unique<btCollisionDispatcher>(collisionConfiguration.get());
    auto overlappingPairCache = std::make_unique<btDbvtBroadphase>();
    auto solver = std::make_unique<btSequentialImpulseConstraintSolver>();
    DynamicsWorldStore dynamicsWorldStore = {
        std::make_unique<btDiscreteDynamicsWorld>(
            dispatcher.get(), overlappingPairCache.get(), solver.get(),
            collisionConfiguration.get())};
    auto dynamicsWorld = dynamicsWorldStore.world.get();
    dynamicsWorld->setGravity(btVector3(0, -10, 0));

    // keep track of the shapes, we release memory at exit.
    // make sure to re-use collision shapes among rigid bodies whenever
    // possible!
    std::vector<std::unique_ptr<btCollisionShape>> collisionShapes;

    /// create a few basic rigid bodies

    // the ground is a cube of side 100 at position y = -56.
    // the sphere will hit it at y = -6, with center at -5
    {
        auto groundShape = push_unique_and_borrow<btBoxShape>(
            collisionShapes,
            btVector3(btScalar(50.), btScalar(50.), btScalar(50.)));
        btTransform groundTransform;
        groundTransform.setIdentity();
        groundTransform.setOrigin(btVector3(0, -56, 0));
        // rigidbody is dynamic if and only if mass is non zero, otherwise
        // static
        btScalar mass(0.);
        bool isDynamic = (mass != 0.f);
        btVector3 localInertia(0, 0, 0);
        if (isDynamic) groundShape->calculateLocalInertia(mass, localInertia);
        // using motionstate is optional, it provides interpolation
        // capabilities, and only synchronizes 'active' objects
        btDefaultMotionState* myMotionState =
            new btDefaultMotionState(groundTransform);
        btRigidBody::btRigidBodyConstructionInfo rbInfo(
            mass, myMotionState, groundShape, localInertia);
        btRigidBody* body = new btRigidBody(rbInfo);
        // add the body to the dynamics world
        dynamicsWorld->addRigidBody(body);
    }

    {
        // create a dynamic rigidbody
        auto colShape = push_unique_and_borrow<btSphereShape>(collisionShapes,
                                                              btScalar(1.));
        /// Create Dynamic Objects
        btTransform startTransform;
        startTransform.setIdentity();
        // rigidbody is dynamic if and only if mass is non zero, otherwise
        // static
        btScalar mass(1.f);
        bool isDynamic = (mass != 0.f);
        btVector3 localInertia(0, 0, 0);
        if (isDynamic) colShape->calculateLocalInertia(mass, localInertia);
        startTransform.setOrigin(btVector3(2, 10, 0));
        // using motionstate is recommended, it provides interpolation
        // capabilities, and only synchronizes 'active' objects
        btDefaultMotionState* myMotionState =
            new btDefaultMotionState(startTransform);
        btRigidBody::btRigidBodyConstructionInfo rbInfo(mass, myMotionState,
                                                        colShape, localInertia);
        btRigidBody* body = new btRigidBody(rbInfo);
        dynamicsWorld->addRigidBody(body);
    }

    /// Do some simulation
    for (int i = 0; i < 150; i++) {
        dynamicsWorld->stepSimulation(1.f / 60.f, 10);
        // print positions of all objects
        for (int j = dynamicsWorld->getNumCollisionObjects() - 1; j >= 0; j--) {
            btCollisionObject* obj =
                dynamicsWorld->getCollisionObjectArray()[j];
            btRigidBody* body = btRigidBody::upcast(obj);
            btTransform trans;
            if (body && body->getMotionState()) {
                body->getMotionState()->getWorldTransform(trans);
            } else {
                trans = obj->getWorldTransform();
            }
            printf("world pos object %d = %f,%f,%f\n", j,
                   float(trans.getOrigin().getX()),
                   float(trans.getOrigin().getY()),
                   float(trans.getOrigin().getZ()));
        }
    }
}
