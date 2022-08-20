#[cxx::bridge]
mod ffi {
    unsafe extern "C++" {
        include!("btBulletDynamicsCommon.h");
        type btVector3;
        fn getX(self: btVector3) -> f32;
    }
}

fn main() {
    let origin: ffi::btVector3;
    println!("Hello, world!");
}
