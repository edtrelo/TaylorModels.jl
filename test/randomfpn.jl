# Simulation of random floating-point numbers

using Random
using Distributions

"""
γsectionCC(a,b)

Draw a float from an interval [a,b] uniformly at random.

This algorithm is proposed by [Goualard 2022] as a way
to guarantee uniformity in a floting-point numbers sample.

Frédéric Goualard. Drawing random floating-point numbers from an interval. 
ACM Transactions on Modeling and Computer Simulation, 2022, 32 (3). ffhal-03282794v2f
"""
function γsectionCC(a, b)

    a = Float64(a)
    b = Float64(b)

    """
    γ(x, y)

    Maximum between the distance from x to prev(x)
    and the distance from y to next(y).
    """
    function γ(x, y)
        γ_low = abs(y- nextfloat(y))
        γ_high = abs(x - prevfloat(x))
        return max(γ_low, γ_high)
    end

    """
    ceilint(a, b, g)

    Compute ⌈b/g-a/g⌉ correctly using Dekker’s algorithm 
    for an exact summation.
    """
    function ceilint(a, b, g)
        s = b/g - a/g
        if abs(a) <= abs(b)
            ε = -a/g - (s - b/g)
        else
            ε = b/g - (s + a/g)
        end
        si = ceil(Int, s)
        return (s != si) ? si : si + Int(ε > 0)
    end

    g = γ(a,b)
    hi = ceilint(a,b,g)
    k = rand(DiscreteUniform(0, hi))
    if abs(a) <= abs(b)
        return (k == hi) ? a : b-k*g
    else
        return (k == hi) ? b : a+k*g
    end
end
