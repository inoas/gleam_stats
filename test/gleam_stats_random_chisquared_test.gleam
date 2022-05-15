import gleam/pair
import gleam/list
import gleam_stats/generators
import gleam_stats/distributions/chisquared
import gleam_stats/stats
import gleeunit
import gleam/io
import gleeunit/should

pub fn main() {
  gleeunit.main()
}

// The relative tolerance
const rtol: Float = 0.025

// The absolute tolerance
const atol: Float = 0.025

// Number of random numbers to generate when validating the 
// population mean and variance of the generated random numbers
const n: Int = 25_000

// The degrees of freedom of a chi-squared random variable (continuous) 
const ddof: Int = 2

// Test that the implemented probability density function (pdf) of a 
// chi-squared distribution (continuous) is correct by checking equality a
// certain analytically calculated points
pub fn chisquared_pdf_test() {
  let xs: List(Float) = [-100.0, 0.0, 1.0, 100.0]
  let fxs: List(Float) = [0.0, 0.0, 0.30326533, 0.0]
  let vs: List(#(Float, Float)) = list.zip(xs, fxs)
  vs
  |> list.map(fn(v: #(Float, Float)) -> Bool {
    pair.first(v)
    |> chisquared.chisquared_pdf(ddof)
    |> io.debug()
    |> fn(x: Result(Float, String)) {
      case x {
        Ok(x) ->
          x
          |> stats.isclose(pair.second(v), rtol, atol)
        _ -> False
      }
    }
  })
  |> list.all(fn(a: Bool) -> Bool { a })
  |> should.be_true()
}

// Test that the cumulative distribution function (cdf) of a 
// chi-squared distribution (continuous) is correct by checking equality a
// certain analytically calculated points
pub fn chisquared_cdf_test() {
  let xs: List(Float) = [-100.0, 0.0, 1.0, 100.0]
  let fxs: List(Float) = [0.0, 0.0, 0.39346934, 1.0]
  let vs: List(#(Float, Float)) = list.zip(xs, fxs)
  vs
  |> list.map(fn(v: #(Float, Float)) -> Bool {
    pair.first(v)
    |> chisquared.chisquared_cdf(ddof)
    |> fn(x: Result(Float, String)) {
      case x {
        Ok(x) ->
          x
          |> stats.isclose(pair.second(v), rtol, atol)
        _ -> False
      }
    }
  })
  |> list.all(fn(a: Bool) -> Bool { a })
  |> should.be_true()
}

pub fn chisquared_random_test() {
  io.debug("")
  assert Ok(mean) = chisquared.chisquared_mean(ddof)
  io.debug("Mean: ")
  io.debug(mean)
  assert Ok(variance) = chisquared.chisquared_variance(ddof)
  io.debug("Variance: ")
  io.debug(variance)
  assert Ok(out) =
    generators.seed_pcg32(8, 1)
    |> chisquared.chisquared_random(ddof, n)
  // Make sure the population mean of the generated normal random numbers
  // is close to the analytically calculated mean
  pair.first(out)
  |> stats.mean()
  |> io.debug()
  |> fn(x) {
    case x {
      Ok(x) -> stats.isclose(x, mean, rtol, atol)
      _ -> False
    }
  }
  |> should.be_true()
  // Make sure the population variance of the generated normal random numbers
  // is close to the analytically calculated variance
  pair.first(out)
  |> stats.var(1)
  |> io.debug()
  |> fn(x) {
    case x {
      Ok(x) -> stats.isclose(x, variance, rtol, atol)
      _ -> False
    }
  }
  |> should.be_true()
}
