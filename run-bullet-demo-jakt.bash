BULLET=$HOME/projects/bullet3
BULLET_LIB=$BULLET/build/src
JAKT=$HOME/projects/jakt
$JAKT/build/jakt -C clang++-12 -R $JAKT/runtime \
    -I $(dirname $0) \
    -I $BULLET/src \
    -L $BULLET_LIB/BulletCollision \
    -L $BULLET_LIB/BulletDynamics \
    -L $BULLET_LIB/LinearMath \
    -l BulletDynamics -l BulletCollision -l LinearMath \
    -b bullet-demo.jakt && \
valgrind ./build/bullet-demo
