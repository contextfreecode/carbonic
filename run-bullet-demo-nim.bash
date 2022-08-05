BULLET=$HOME/projects/bullet3
BULLET_LIB=$BULLET/build/src
# Using --clibdir and --clib puts them in the wrong order for some reason.
# So be explicit with full paths here.
nim cpp \
    --cincludes:$BULLET/src \
    --passL:$BULLET_LIB/BulletDynamics/libBulletDynamics.a \
    --passL:$BULLET_LIB/BulletCollision/libBulletCollision.a \
    --passL:$BULLET_LIB/LinearMath/libLinearMath.a \
    -d:release \
    bullet_demo.nim && \
valgrind ./bullet_demo
