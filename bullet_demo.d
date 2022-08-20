import std.stdio;

extern(C++) {
    extern (C++, struct)
    class btVector3 {}

    btVector3 vector3New(float x, float y, float z);

    void del(btVector3 vector);

    float x(btVector3 vector);
    float y(btVector3 vector);
    float z(btVector3 vector);
}

void main() {
    auto origin = vector3New(1, 2, 3);
    scope(exit) origin.del;
    writefln("Origin: %f %f %f", origin.x, origin.y, origin.z);
}
