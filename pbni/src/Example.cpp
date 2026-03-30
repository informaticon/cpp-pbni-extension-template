#include "Example.h"

INF_REGISTER_CLASS(Example, L"u_pbni_example");

INF_REGISTER_FUNC(Add, L"of_add", L"al_a", L"al_b");
Inf::PBLong Example::Add(Inf::PBLong a, Inf::PBLong b)
{
    return a + b;
}