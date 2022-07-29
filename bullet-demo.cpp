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

#include "btBulletDynamicsCommon.h"

int main(int argc, char **argv) {
    auto collisionConfiguration =
        std::make_unique<btDefaultCollisionConfiguration>();
    auto dispatcher =
        std::make_unique<btCollisionDispatcher>(collisionConfiguration.get());
    auto overlappingPairCache = std::make_unique<btDbvtBroadphase>();
    auto solver = std::make_unique<btSequentialImpulseConstraintSolver>();
    auto dynamicsWorld = std::make_unique<btDiscreteDynamicsWorld>(
        dispatcher.get(), overlappingPairCache.get(), solver.get(),
        collisionConfiguration.get());
    dynamicsWorld->setGravity(btVector3(0, -10, 0));

    // keep track of the shapes, we release memory at exit.
    // make sure to re-use collision shapes among rigid bodies whenever
    // possible!
    btAlignedObjectArray<btCollisionShape *> collisionShapes;

    /// create a few basic rigid bodies

    // the ground is a cube of side 100 at position y = -56.
    // the sphere will hit it at y = -6, with center at -5
    {
        btCollisionShape *groundShape = new btBoxShape(
            btVector3(btScalar(50.), btScalar(50.), btScalar(50.)));

        collisionShapes.push_back(groundShape);

        btTransform groundTransform;
        groundTransform.setIdentity();
        groundTransform.setOrigin(btVector3(0, -56, 0));

        btScalar mass(0.);

        // rigidbody is dynamic if and only if mass is non zero, otherwise
        // static
        bool isDynamic = (mass != 0.f);

        btVector3 localInertia(0, 0, 0);
        if (isDynamic) groundShape->calculateLocalInertia(mass, localInertia);

        // using motionstate is optional, it provides interpolation
        // capabilities, and only synchronizes 'active' objects
        btDefaultMotionState *myMotionState =
            new btDefaultMotionState(groundTransform);
        btRigidBody::btRigidBodyConstructionInfo rbInfo(
            mass, myMotionState, groundShape, localInertia);
        btRigidBody *body = new btRigidBody(rbInfo);

        // add the body to the dynamics world
        dynamicsWorld->addRigidBody(body);
    }

    {
        // create a dynamic rigidbody

        // btCollisionShape* colShape = new btBoxShape(btVector3(1,1,1));
        btCollisionShape *colShape = new btSphereShape(btScalar(1.));
        collisionShapes.push_back(colShape);

        /// Create Dynamic Objects
        btTransform startTransform;
        startTransform.setIdentity();

        btScalar mass(1.f);

        // rigidbody is dynamic if and only if mass is non zero, otherwise
        // static
        bool isDynamic = (mass != 0.f);

        btVector3 localInertia(0, 0, 0);
        if (isDynamic) colShape->calculateLocalInertia(mass, localInertia);

        startTransform.setOrigin(btVector3(2, 10, 0));

        // using motionstate is recommended, it provides interpolation
        // capabilities, and only synchronizes 'active' objects
        btDefaultMotionState *myMotionState =
            new btDefaultMotionState(startTransform);
        btRigidBody::btRigidBodyConstructionInfo rbInfo(mass, myMotionState,
                                                        colShape, localInertia);
        btRigidBody *body = new btRigidBody(rbInfo);

        dynamicsWorld->addRigidBody(body);
    }

    /// Do some simulation

    ///-----stepsimulation_start-----
    for (int i = 0; i < 150; i++) {
        dynamicsWorld->stepSimulation(1.f / 60.f, 10);

        // print positions of all objects
        for (int j = dynamicsWorld->getNumCollisionObjects() - 1; j >= 0; j--) {
            btCollisionObject *obj =
                dynamicsWorld->getCollisionObjectArray()[j];
            btRigidBody *body = btRigidBody::upcast(obj);
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

    ///-----stepsimulation_end-----

    // cleanup in the reverse order of creation/initialization

    ///-----cleanup_start-----

    // remove the rigidbodies from the dynamics world and delete them
    for (int i = dynamicsWorld->getNumCollisionObjects() - 1; i >= 0; i--) {
        btCollisionObject *obj = dynamicsWorld->getCollisionObjectArray()[i];
        btRigidBody *body = btRigidBody::upcast(obj);
        if (body && body->getMotionState()) {
            delete body->getMotionState();
        }
        dynamicsWorld->removeCollisionObject(obj);
        delete obj;
    }

    // delete collision shapes
    for (int j = 0; j < collisionShapes.size(); j++) {
        btCollisionShape *shape = collisionShapes[j];
        collisionShapes[j] = 0;
        delete shape;
    }
}
