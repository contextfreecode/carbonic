import std.stdio;

extern(C++) {
    struct btVector3 {
        float[4] m_floats;
        // final float getX(); // No good because header-only.
    }

    btVector3 vector3Make(float x, float y, float z);

    // void del(btVector3 vector);

    float x(const ref btVector3 vector);
    float y(const ref btVector3 vector);
    float z(const ref btVector3 vector);
}

void main() {
    auto origin = vector3Make(1, 2, 3);
    // scope(exit) origin.del;
    writefln("Origin: %f", origin.m_floats[1]);
    writefln("Origin: %f %f %f", origin.x, origin.y, origin.z);
}
