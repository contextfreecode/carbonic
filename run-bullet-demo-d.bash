BULLET=$HOME/projects/bullet3
BULLET_LIB=$BULLET/build/src
g++ --std=c++20 \
    -I$BULLET/src \
    -c bullet-demo-support-d.cpp && \
dmd bullet_demo.d bullet-demo-support-d.o \
    -L-L$BULLET_LIB/BulletDynamics \
    -L-L$BULLET_LIB/BulletCollision \
    -L-L$BULLET_LIB/LinearMath \
    -L-lBulletDynamics -L-lBulletCollision -L-lLinearMath -L-lstdc++ && \
valgrind ./bullet_demo
