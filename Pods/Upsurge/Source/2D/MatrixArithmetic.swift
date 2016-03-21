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

/// Performs the matrix operation `C ← αAB+βC`
public func gemm<
    QTA: QuadraticType,
    QTB: QuadraticType,
    QTC: MutableQuadraticType
    where
    QTA.Element == Double,
    QTB.Element == Double,
    QTC.Element == Double
>(α: Double, a: QTA, b: QTB, β: Double, inout c: QTC) {
    precondition(a.columns == b.rows, "Input matrices dimensions not compatible with multiplication")
    precondition(a.rows == c.rows, "Output matrix dimensions not compatible with multiplication")
    precondition(b.columns == c.columns, "Output matrix dimensions not compatible with multiplication")

    let order = c.arrangement == .RowMajor ? CblasRowMajor : CblasColMajor
    let atrans = a.arrangement == c.arrangement ? CblasNoTrans : CblasTrans
    let btrans = b.arrangement == c.arrangement ? CblasNoTrans : CblasTrans

    withPointers(a, b, &c) { pa, pb, pc in
        cblas_dgemm(order, atrans, btrans, Int32(a.rows), Int32(b.columns), Int32(a.columns), α, pa, Int32(a.stride), pb, Int32(b.stride), β, pc, Int32(c.stride))
    }
}

/// Invert a square matrix
public func inv<M: QuadraticType where M.Element == Double>(x: M) -> Matrix<Double> {
    precondition(x.rows == x.columns, "Matrix must be square")

    var results = Matrix<Double>(x)

    var ipiv = [__CLPK_integer](count: x.rows * x.rows, repeatedValue: 0)
    var lwork = __CLPK_integer(x.columns * x.columns)
    var work = [CDouble](count: Int(lwork), repeatedValue: 0.0)
    var error: __CLPK_integer = 0
    var nc = __CLPK_integer(x.columns)

    withPointer(&results) { pointer in
        dgetrf_(&nc, &nc, pointer, &nc, &ipiv, &error)
        dgetri_(&nc, pointer, &nc, &ipiv, &work, &lwork, &error)
    }

    assert(error == 0, "Matrix not invertible")

    return results
}

public func transpose<M: QuadraticType where M.Element == Double>(x: M) -> Matrix<Double> {
    var results = Matrix<Double>(rows: x.columns, columns: x.rows, repeatedValue: 0.0)
    withPointers(x, &results) { xp, rp in
        vDSP_mtransD(xp, x.step, rp, results.step, vDSP_Length(results.rows), vDSP_Length(results.columns))
    }
    return results
}

// MARK: - Operators

public func +=<ML: MutableQuadraticType, MR: QuadraticType where ML.Element == Double, MR.Element == Double>(inout lhs: ML, rhs: MR) {
    precondition(lhs.rows == rhs.rows && lhs.columns == rhs.columns, "Matrix dimensions not compatible with addition")
    assert(lhs.span ≅ rhs.span)
    
    for (lhsIndex, rhsIndex) in zip(lhs.span, rhs.span) {
        lhs[lhsIndex] += rhs[rhsIndex]
    }
}

public func +<ML: QuadraticType, MR: QuadraticType where ML.Element == Double, MR.Element == Double>(lhs: ML, rhs: MR) -> Matrix<Double> {
    precondition(lhs.rows == rhs.rows && lhs.columns == rhs.columns, "Matrix dimensions not compatible with addition")

    var results = Matrix<Double>(lhs)
    results += rhs

    return results
}

public func -=<ML: MutableQuadraticType, MR: QuadraticType where ML.Element == Double, MR.Element == Double>(inout lhs: ML, rhs: MR) {
    precondition(lhs.rows == rhs.rows && lhs.columns == rhs.columns, "Matrix dimensions not compatible with subtraction")
    assert(lhs.span ≅ rhs.span)
    
    for (lhsIndex, rhsIndex) in zip(lhs.span, rhs.span) {
        lhs[lhsIndex] -= rhs[rhsIndex]
    }
}

public func -<ML: QuadraticType, MR: QuadraticType where ML.Element == Double, MR.Element == Double>(lhs: ML, rhs: MR) -> Matrix<Double> {
    precondition(lhs.rows == rhs.rows && lhs.columns == rhs.columns, "Matrix dimensions not compatible with subtraction")

    var results = Matrix<Double>(lhs)
    results -= rhs
    
    return results
}

public func *=<ML: MutableQuadraticType, MR: QuadraticType where ML.Element == Double, MR.Element == Double>(inout lhs: ML, rhs: MR) {
    // lhs can't be used for both input and output so it needs to be copied
    let a = Matrix<Double>(lhs)
    gemm(1.0, a: a, b: rhs, β: 0.0, c: &lhs)
}

public func *<ML: QuadraticType, MR: QuadraticType where ML.Element == Double, MR.Element == Double>(lhs: ML, rhs: MR) -> Matrix<Double> {
    var results = Matrix<Double>(rows: lhs.rows, columns: rhs.columns)
    gemm(1.0, a: lhs, b: rhs, β: 0.0, c: &results)
    return results
}

public func *=<ML: MutableQuadraticType where ML.Element == Double>(inout lhs: ML, rhs: Double) {
    for index in lhs.span {
        lhs[index] *= rhs
    }
}

public func *<MR: QuadraticType where MR.Element == Double>(lhs: Double, rhs: MR) -> Matrix<Double> {
    var results = Matrix<Double>(rhs)
    results *= lhs
    return results
}


postfix operator ′ {}
public postfix func ′<M: QuadraticType where M.Element == Double>(value: M) -> Matrix<Double> {
    return transpose(value)
}


// MARK: - Float

/// Performs the matrix operation `C ← αAB+βC`
public func gemm<
    QTA: QuadraticType,
    QTB: QuadraticType,
    QTC: MutableQuadraticType
    where
    QTA.Element == Float,
    QTB.Element == Float,
    QTC.Element == Float
    >(α: Float, a: QTA, b: QTB, β: Float, inout c: QTC) {
        precondition(a.columns == b.rows, "Input matrices dimensions not compatible with multiplication")
        precondition(a.rows == c.rows, "Output matrix dimensions not compatible with multiplication")
        precondition(b.columns == c.columns, "Output matrix dimensions not compatible with multiplication")

        let order = c.arrangement == .RowMajor ? CblasRowMajor : CblasColMajor
        let atrans = a.arrangement == c.arrangement ? CblasNoTrans : CblasTrans
        let btrans = b.arrangement == c.arrangement ? CblasNoTrans : CblasTrans
        withPointers(a, b, &c) { pa, pb, pc in
            cblas_sgemm(order, atrans, btrans, Int32(a.rows), Int32(b.columns), Int32(a.columns), α, pa, Int32(a.stride), pb, Int32(b.stride), β, pc, Int32(c.stride))
        }
}

/// Invert a square matrix
public func inv<M: QuadraticType where M.Element == Float>(x: M) -> Matrix<Float> {
    precondition(x.rows == x.columns, "Matrix must be square")

    var results = Matrix<Float>(x)

    var ipiv = [__CLPK_integer](count: x.rows * x.rows, repeatedValue: 0)
    var lwork = __CLPK_integer(x.columns * x.columns)
    var work = [CFloat](count: Int(lwork), repeatedValue: 0.0)
    var error: __CLPK_integer = 0
    var nc = __CLPK_integer(x.columns)

    withPointer(&results) { pointer in
        sgetrf_(&nc, &nc, pointer, &nc, &ipiv, &error)
        sgetri_(&nc, pointer, &nc, &ipiv, &work, &lwork, &error)
    }

    assert(error == 0, "Matrix not invertible")

    return results
}

public func transpose<M: QuadraticType where M.Element == Float>(x: M) -> Matrix<Float> {
    var results = Matrix<Float>(rows: x.columns, columns: x.rows, repeatedValue: 0.0)
    withPointers(x, &results) { xp, rp in
        vDSP_mtrans(xp, x.step, rp, results.step, vDSP_Length(results.rows), vDSP_Length(results.columns))
    }
    return results
}

// MARK: - Operators

public func +=<ML: MutableQuadraticType, MR: QuadraticType where ML.Element == Float, MR.Element == Float>(inout lhs: ML, rhs: MR) {
    precondition(lhs.rows == rhs.rows && lhs.columns == rhs.columns, "Matrix dimensions not compatible with addition")
    assert(lhs.span ≅ rhs.span)

    for (lhsIndex, rhsIndex) in zip(lhs.span, rhs.span) {
        lhs[lhsIndex] += rhs[rhsIndex]
    }
}

public func +<ML: QuadraticType, MR: QuadraticType where ML.Element == Float, MR.Element == Float>(lhs: ML, rhs: MR) -> Matrix<Float> {
    precondition(lhs.rows == rhs.rows && lhs.columns == rhs.columns, "Matrix dimensions not compatible with addition")

    var results = Matrix<Float>(lhs)
    results += rhs

    return results
}

public func -=<ML: MutableQuadraticType, MR: QuadraticType where ML.Element == Float, MR.Element == Float>(inout lhs: ML, rhs: MR) {
    precondition(lhs.rows == rhs.rows && lhs.columns == rhs.columns, "Matrix dimensions not compatible with subtraction")
    assert(lhs.span ≅ rhs.span)

    for (lhsIndex, rhsIndex) in zip(lhs.span, rhs.span) {
        lhs[lhsIndex] -= rhs[rhsIndex]
    }
}

public func -<ML: QuadraticType, MR: QuadraticType where ML.Element == Float, MR.Element == Float>(lhs: ML, rhs: MR) -> Matrix<Float> {
    precondition(lhs.rows == rhs.rows && lhs.columns == rhs.columns, "Matrix dimensions not compatible with subtraction")

    var results = Matrix<Float>(lhs)
    results -= rhs

    return results
}

public func *=<ML: MutableQuadraticType, MR: QuadraticType where ML.Element == Float, MR.Element == Float>(inout lhs: ML, rhs: MR) {
    // lhs can't be used for both input and output so it needs to be copied
    let a = Matrix<Float>(lhs)
    gemm(1.0, a: a, b: rhs, β: 0.0, c: &lhs)
}

public func *<ML: QuadraticType, MR: QuadraticType where ML.Element == Float, MR.Element == Float>(lhs: ML, rhs: MR) -> Matrix<Float> {
    var results = Matrix<Float>(rows: lhs.rows, columns: rhs.columns)
    gemm(1.0, a: lhs, b: rhs, β: 0.0, c: &results)
    return results
}

public func *=<ML: MutableQuadraticType where ML.Element == Float>(inout lhs: ML, rhs: Float) {
    for index in lhs.span {
        lhs[index] *= rhs
    }
}

public func *<MR: QuadraticType where MR.Element == Float>(lhs: Float, rhs: MR) -> Matrix<Float> {
    var results = Matrix<Float>(rhs)
    results *= lhs
    return results
}

public postfix func ′<M: QuadraticType where M.Element == Float>(value: M) -> Matrix<Float> {
    return transpose(value)
}
