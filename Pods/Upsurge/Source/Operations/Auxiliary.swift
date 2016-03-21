// Copyright (c) 2014–2015 Mattt Thompson (http://mattt.me)
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in
// all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
// THE SOFTWARE.

import Accelerate

// MARK: - Double

/// Absolute Value
public func abs<M: LinearType where M.Element == Double>(x: M) -> ValueArray<Double> {
    let results = ValueArray<Double>(count: x.count)
    withPointer(x) { p in
        vDSP_vabsD(p + x.startIndex, x.step, results.mutablePointer + results.startIndex, results.step, vDSP_Length(x.count))
    }
    return results
}

/// Ceiling
public func ceil<M: LinearType where M.Element == Double>(x: M) -> ValueArray<Double> {
    precondition(x.step == 1, "ceil doesn't support step values other than 1")
    let results = ValueArray<Double>(count: x.count)
    withPointer(x) { p in
        vvceil(results.mutablePointer + results.startIndex, p + x.startIndex, [Int32(x.count)])
    }
    return results
}

/// Clip
public func clip<M: LinearType where M.Element == Double>(x: M, low: Double, high: Double) -> ValueArray<Double> {
    var results = ValueArray<Double>(count: x.count), y = low, z = high
    withPointer(x) { p in
        vDSP_vclipD(p + x.startIndex, x.step, &y, &z, results.mutablePointer + results.startIndex, results.step, vDSP_Length(x.count))
    }
    return results
}

// Copy Sign
public func copysign<M: LinearType where M.Element == Double>(sign: M, magnitude: M) -> ValueArray<Double> {
    precondition(sign.step == 1 && magnitude.step == 1, "copysign doesn't support step values other than 1")
    let results = ValueArray<Double>(count: sign.count)
    withPointers(sign, magnitude) { signPointer, magnitudePointer in
        vvcopysign(results.mutablePointer + results.startIndex, magnitudePointer + magnitude.startIndex, signPointer + sign.startIndex, [Int32(sign.count)])
    }
    return results
}

/// Floor
public func floor<M: LinearType where M.Element == Double>(x: M) -> ValueArray<Double> {
    precondition(x.step == 1, "floor doesn't support step values other than 1")
    let results = ValueArray<Double>(count: x.count)
    withPointer(x) { p in
        vvfloor(results.mutablePointer + results.startIndex, p + x.startIndex, [Int32(x.count)])
    }
    return results
}

/// Negate
public func neg<M: LinearType where M.Element == Double>(x: M) -> ValueArray<Double> {
    let results = ValueArray<Double>(count: x.count)
    withPointer(x) { p in
        vDSP_vnegD(p + x.startIndex, x.step, results.mutablePointer + results.startIndex, results.step, vDSP_Length(x.count))
    }
    return results
}

/// Reciprocal
public func rec<M: LinearType where M.Element == Double>(x: M) -> ValueArray<Double> {
    precondition(x.step == 1, "rec doesn't support step values other than 1")
    let results = ValueArray<Double>(count: x.count)
    withPointer(x) { p in
        vvrec(results.mutablePointer + results.startIndex, p + x.startIndex, [Int32(x.count)])
    }
    return results
}

/// Round
public func round<M: LinearType where M.Element == Double>(x: M) -> ValueArray<Double> {
    precondition(x.step == 1, "round doesn't support step values other than 1")
    let results = ValueArray<Double>(count: x.count)
    withPointer(x) { p in
        vvnint(results.mutablePointer + results.startIndex, p + x.startIndex, [Int32(x.count)])
    }
    return results
}

/// Threshold
public func threshold<M: LinearType where M.Element == Double>(x: M, low: Double) -> ValueArray<Double> {
    var results = ValueArray<Double>(count: x.count), y = low
    withPointer(x) { p in
        vDSP_vthrD(p + x.startIndex, x.step, &y, results.mutablePointer + results.startIndex, results.step, vDSP_Length(x.count))
    }
    return results
}

/// Truncate
public func trunc<M: LinearType where M.Element == Double>(x: M) -> ValueArray<Double> {
    precondition(x.step == 1, "trunc doesn't support step values other than 1")
    let results = ValueArray<Double>(count: x.count)
    withPointer(x) { p in
        vvint(results.mutablePointer + results.startIndex, p + x.startIndex, [Int32(x.count)])
    }
    return results
}

/// Power
public func pow<M: LinearType where M.Element == Double>(x: M, y: M) -> ValueArray<Double> {
    precondition(x.step == 1, "pow doesn't support step values other than 1")
    let results = ValueArray<Double>(count: x.count)
    withPointers(x, y) { xp, yp in
        vvpow(results.mutablePointer + results.startIndex, xp + x.startIndex, yp + y.startIndex, [Int32(x.count)])
    }
    return results
}


// MARK: - Float

/// Absolute Value
public func abs<M: LinearType where M.Element == Float>(x: M) -> ValueArray<Float> {
    let results = ValueArray<Float>(count: x.count)
    withPointer(x) { p in
        vDSP_vabs(p + x.startIndex, x.step, results.mutablePointer + results.startIndex, results.step, vDSP_Length(x.count))
    }
    return results
}

/// Ceiling
public func ceil<M: LinearType where M.Element == Float>(x: M) -> ValueArray<Float> {
    precondition(x.step == 1, "ceil doesn't support step values other than 1")
    let results = ValueArray<Float>(count: x.count)
    withPointer(x) { p in
        vvceilf(results.mutablePointer + results.startIndex, p + x.startIndex, [Int32(x.count)])
    }
    return results
}

/// Clip
public func clip<M: LinearType where M.Element == Float>(x: M, low: Float, high: Float) -> ValueArray<Float> {
    var results = ValueArray<Float>(count: x.count), y = low, z = high
    withPointer(x) { p in
        vDSP_vclip(p + x.startIndex, x.step, &y, &z, results.mutablePointer + results.startIndex, results.step, vDSP_Length(x.count))
    }
    return results
}

// Copy Sign
public func copysign<M: LinearType where M.Element == Float>(sign: M, magnitude: M) -> ValueArray<Float> {
    precondition(sign.step == 1 && magnitude.step == 1, "copysign doesn't support step values other than 1")
    let results = ValueArray<Float>(count: sign.count)
    withPointers(sign, magnitude) { sp, mp in
        vvcopysignf(results.mutablePointer + results.startIndex, mp + magnitude.startIndex, sp + sign.startIndex, [Int32(sign.count)])
    }
    return results
}

/// Floor
public func floor<M: LinearType where M.Element == Float>(x: M) -> ValueArray<Float> {
    precondition(x.step == 1, "floor doesn't support step values other than 1")
    let results = ValueArray<Float>(count: x.count)
    withPointer(x) { p in
        vvfloorf(results.mutablePointer + results.startIndex, p + x.startIndex, [Int32(x.count)])
    }
    return results
}

/// Negate
public func neg<M: LinearType where M.Element == Float>(x: M) -> ValueArray<Float> {
    let results = ValueArray<Float>(count: x.count)
    withPointer(x) { p in
        vDSP_vneg(p + x.startIndex, x.step, results.mutablePointer + results.startIndex, results.step, vDSP_Length(x.count))
    }
    return results
}

/// Reciprocal
public func rec<M: LinearType where M.Element == Float>(x: M) -> ValueArray<Float> {
    precondition(x.step == 1, "rec doesn't support step values other than 1")
    let results = ValueArray<Float>(count: x.count)
    withPointer(x) { p in
        vvrecf(results.mutablePointer + results.startIndex, p + x.startIndex, [Int32(x.count)])
    }
    return results
}

/// Round
public func round<M: LinearType where M.Element == Float>(x: M) -> ValueArray<Float> {
    precondition(x.step == 1, "round doesn't support step values other than 1")
    let results = ValueArray<Float>(count: x.count)
    withPointer(x) { p in
        vvnintf(results.mutablePointer + results.startIndex, p + x.startIndex, [Int32(x.count)])
    }
    return results
}

/// Threshold
public func threshold<M: LinearType where M.Element == Float>(x: M, low: Float) -> ValueArray<Float> {
    var results = ValueArray<Float>(count: x.count), y = low
    withPointer(x) { p in
        vDSP_vthr(p + x.startIndex, x.step, &y, results.mutablePointer + results.startIndex, results.step, vDSP_Length(x.count))
    }
    return results
}

/// Truncate
public func trunc<M: LinearType where M.Element == Float>(x: M) -> ValueArray<Float> {
    precondition(x.step == 1, "trunc doesn't support step values other than 1")
    let results = ValueArray<Float>(count: x.count)
    withPointer(x) { p in
        vvintf(results.mutablePointer + results.startIndex, p + x.startIndex, [Int32(x.count)])
    }
    return results
}

/// Power
public func pow<M: LinearType where M.Element == Float>(x: M, y: M) -> ValueArray<Float> {
    precondition(x.step == 1, "pow doesn't support step values other than 1")
    let results = ValueArray<Float>(count: x.count)
    withPointers(x, y) { xp, yp in
        vvpowf(results.mutablePointer + results.startIndex, xp + x.startIndex, yp + y.startIndex, [Int32(x.count)])
    }
    return results
}
