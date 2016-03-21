// Copyright © 2015 Venture Media Labs.
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

public func sum<M: LinearType where M.Element == Double>(x: M) -> Double {
    var result = 0.0
    withPointer(x) { xp in
        vDSP_sveD(xp + x.startIndex, x.step, &result, vDSP_Length(x.count))
    }
    return result
}

public func max<M: LinearType where M.Element == Double>(x: M) -> Double {
    var result: Double = 0.0
    withPointer(x) { xp in
        vDSP_maxvD(xp + x.startIndex, x.step, &result, vDSP_Length(x.count))
    }
    return result
}

public func min<M: LinearType where M.Element == Double>(x: M) -> Double {
    var result: Double = 0.0
    withPointer(x) { xp in
        vDSP_minvD(xp + x.startIndex, x.step, &result, vDSP_Length(x.count))
    }
    return result
}

public func mean<M: LinearType where M.Element == Double>(x: M) -> Double {
    var result: Double = 0.0
    withPointer(x) { xp in
        vDSP_meanvD(xp + x.startIndex, x.step, &result, vDSP_Length(x.count))
    }
    return result
}

public func meamg<M: LinearType where M.Element == Double>(x: M) -> Double {
    var result: Double = 0.0
    withPointer(x) { xp in
        vDSP_meamgvD(xp + x.startIndex, x.step, &result, vDSP_Length(x.count))
    }
    return result
}

public func measq<M: LinearType where M.Element == Double>(x: M) -> Double {
    var result: Double = 0.0
    withPointer(x) { xp in
        vDSP_measqvD(xp + x.startIndex, x.step, &result, vDSP_Length(x.count))
    }
    return result
}

public func rmsq<M: LinearType where M.Element == Double>(x: M) -> Double {
    var result: Double = 0.0
    withPointer(x) { xp in
        vDSP_rmsqvD(xp + x.startIndex, x.step, &result, vDSP_Length(x.count))
    }
    return result
}

/// Compute the standard deviation, a measure of the spread of deviation.
public func std<M: LinearType where M.Element == Double>(x: M) -> Double {
    let diff = x - mean(x)
    let variance = measq(diff)
    return sqrt(variance)
}

/**
    Perform a linear regression.

    - parameter x: Array of x-values
    - parameter y: Array of y-values
    - returns: The slope and intercept of the regression line
*/
public func linregress<MX: LinearType, MY: LinearType where MX.Element == Double, MY.Element == Double>(x: MX, _ y: MY) -> (slope: Double, intercept: Double) {
    precondition(x.count == y.count, "Vectors must have equal count")
    let meanx = mean(x)
    let meany = mean(y)
    let meanxy = mean(x * y)
    let meanx_sqr = measq(x)

    let slope = (meanx * meany - meanxy) / (meanx * meanx - meanx_sqr)
    let intercept = meany - slope * meanx
    return (slope, intercept)
}

public func mod<ML: LinearType, MR: LinearType where ML.Element == Double, MR.Element == Double>(lhs: ML, _ rhs: MR) -> ValueArray<Double> {
    precondition(lhs.step == 1, "mod doesn't support step values other than 1")
    let results = ValueArray<Double>(count: lhs.count)
    withPointers(lhs, rhs) { lhsp, rhsp in
        vvfmod(results.mutablePointer + results.startIndex, lhsp + lhs.startIndex, rhsp + rhs.startIndex, [Int32(lhs.count)])
    }
    return results
}

public func remainder<ML: LinearType, MR: LinearType where ML.Element == Double, MR.Element == Double>(lhs: ML, rhs: MR) -> ValueArray<Double> {
    precondition(lhs.step == 1, "remainder doesn't support step values other than 1")
    let results = ValueArray<Double>(count: lhs.count)
    withPointers(lhs, rhs) { lhsp, rhsp in
        vvremainder(results.mutablePointer + results.startIndex, lhsp + lhs.startIndex, rhsp + rhs.startIndex, [Int32(lhs.count)])
    }
    return results
}

public func sqrt<M: LinearType where M.Element == Double>(x: M) -> ValueArray<Double> {
    precondition(x.step == 1, "sqrt doesn't support step values other than 1")
    let results = ValueArray<Double>(count: x.count)
    withPointer(x) { xp in
        vvsqrt(results.mutablePointer + results.startIndex, xp + x.startIndex, [Int32(x.count)])
    }
    return results
}

public func dot<ML: LinearType, MR: LinearType where ML.Element == Double, MR.Element == Double>(lhs: ML, _ rhs: MR) -> Double {
    precondition(lhs.count == rhs.count, "Vectors must have equal count")

    var result: Double = 0.0
    withPointers(lhs, rhs) { lhsp, rhsp in
        vDSP_dotprD(lhsp + lhs.startIndex, lhs.step, rhsp + rhs.startIndex, rhs.step, &result, vDSP_Length(lhs.count))
    }
    return result
}


// MARK: - Float

public func sum<M: LinearType where M.Element == Float>(x: M) -> Float {
    var result = Float()
    withPointer(x) { xp in
        vDSP_sve(xp + x.startIndex, x.step, &result, vDSP_Length(x.count))
    }
    return result
}

public func max<M: LinearType where M.Element == Float>(x: M) -> Float {
    var result = Float()
    withPointer(x) { xp in
        vDSP_maxv(xp + x.startIndex, x.step, &result, vDSP_Length(x.count))
    }
    return result
}

public func min<M: LinearType where M.Element == Float>(x: M) -> Float {
    var result = Float()
    withPointer(x) { xp in
        vDSP_minv(xp + x.startIndex, x.step, &result, vDSP_Length(x.count))
    }
    return result
}

public func mean<M: LinearType where M.Element == Float>(x: M) -> Float {
    var result = Float()
    withPointer(x) { xp in
        vDSP_meanv(xp + x.startIndex, x.step, &result, vDSP_Length(x.count))
    }
    return result
}

public func meamg<M: LinearType where M.Element == Float>(x: M) -> Float {
    var result = Float()
    withPointer(x) { xp in
        vDSP_meamgv(xp + x.startIndex, x.step, &result, vDSP_Length(x.count))
    }
    return result
}

public func measq<M: LinearType where M.Element == Float>(x: M) -> Float {
    var result = Float()
    withPointer(x) { xp in
        vDSP_measqv(xp + x.startIndex, x.step, &result, vDSP_Length(x.count))
    }
    return result
}

public func rmsq<M: LinearType where M.Element == Float>(x: M) -> Float {
    var result = Float()
    withPointer(x) { xp in
        vDSP_rmsqv(xp + x.startIndex, x.step, &result, vDSP_Length(x.count))
    }
    return result
}

/// Compute the standard deviation, a measure of the spread of deviation.
public func std<M: LinearType where M.Element == Float>(x: M) -> Float {
    let diff = x - mean(x)
    let variance = measq(diff)
    return sqrt(variance)
}

/**
 Perform a linear regression.

 - parameter x: Array of x-values
 - parameter y: Array of y-values
 - returns: The slope and intercept of the regression line
 */
public func linregress<MX: LinearType, MY: LinearType where MX.Element == Float, MY.Element == Float>(x: MX, _ y: MY) -> (slope: Float, intercept: Float) {
    precondition(x.count == y.count, "Vectors must have equal count")
    let meanx = mean(x)
    let meany = mean(y)
    let meanxy = mean(x * y)
    let meanx_sqr = measq(x)

    let slope = (meanx * meany - meanxy) / (meanx * meanx - meanx_sqr)
    let intercept = meany - slope * meanx
    return (slope, intercept)
}

public func mod<ML: LinearType, MR: LinearType where ML.Element == Float, MR.Element == Float>(lhs: ML, _ rhs: MR) -> ValueArray<Float> {
    precondition(lhs.step == 1, "mod doesn't support step values other than 1")
    let results = ValueArray<Float>(count: lhs.count)
    withPointers(lhs, rhs) { lhsp, rhsp in
        vvfmodf(results.mutablePointer + results.startIndex, lhsp + lhs.startIndex, rhsp + rhs.startIndex, [Int32(lhs.count)])
    }
    return results
}

public func remainder<ML: LinearType, MR: LinearType where ML.Element == Float, MR.Element == Float>(lhs: ML, rhs: MR) -> ValueArray<Float> {
    precondition(lhs.step == 1, "remainder doesn't support step values other than 1")
    let results = ValueArray<Float>(count: lhs.count)
    withPointers(lhs, rhs) { lhsp, rhsp in
        vvremainderf(results.mutablePointer + results.startIndex, lhsp + lhs.startIndex, rhsp + rhs.startIndex, [Int32(lhs.count)])
    }
    return results
}

public func sqrt<M: LinearType where M.Element == Float>(x: M) -> ValueArray<Float> {
    precondition(x.step == 1, "sqrt doesn't support step values other than 1")
    let results = ValueArray<Float>(count: x.count)
    withPointer(x) { xp in
        vvsqrtf(results.mutablePointer + results.startIndex, xp + x.startIndex, [Int32(x.count)])
    }
    return results
}

public func dot<ML: LinearType, MR: LinearType where ML.Element == Float, MR.Element == Float>(lhs: ML, _ rhs: MR) -> Float {
    precondition(lhs.count == rhs.count, "Vectors must have equal count")

    var result: Float = 0.0
    withPointers(lhs, rhs) { lhsp, rhsp in
        vDSP_dotpr(lhsp + lhs.startIndex, lhs.step, rhsp + rhs.startIndex, rhs.step, &result, vDSP_Length(lhs.count))
    }
    return result
}
