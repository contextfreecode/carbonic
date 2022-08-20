#pragma once

template<typename T, typename U>
auto cast(U* u) -> T* {
    return static_cast<T*>(u);
}
