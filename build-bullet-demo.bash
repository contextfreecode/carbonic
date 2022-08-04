BULLET=$HOME/projects/bullet3
BULLET_LIB=$BULLET/build/src
g++ --std=c++20 \
    -I$BULLET/src \
    -L$BULLET_LIB/BulletDynamics \
    -L$BULLET_LIB/BulletCollision \
    -L$BULLET_LIB/LinearMath \
    -o bullet-demo bullet-demo.cpp \
    -lBulletDynamics -lBulletCollision -lLinearMath && \
valgrind ./bullet-demo
