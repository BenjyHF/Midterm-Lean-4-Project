# Ridge Regression Optimality in Lean 4

**STAT 4052 | Fall 2026 | Midterm Lean 4 project**

This project formalizes the **one-predictor, no-intercept** case of ridge
regression for any finite real-valued dataset. It proves that, when the penalty
`lam` is strictly positive, the explicit ridge coefficient minimizes the
sum of squared residuals plus the squared-coefficient penalty.

## Mathematical result

Given any `n : ℕ`, predictors `x : Fin n → ℝ`, responses `y : Fin n → ℝ`,
regularization `lam > 0`, and a candidate coefficient `beta : ℝ`, define

```
J(beta) = Σ_i (y_i - x_i * beta)^2 + lam * beta^2
A       = Σ_i x_i^2 + lam
B       = Σ_i x_i*y_i
beta*   = B / A
```

The Lean file establishes `A > 0`, the exact identity
`J(beta) - J(beta*) = A * (beta - beta*)^2`, and hence
`J(beta*) ≤ J(beta)` for every real `beta`.

## Main file and theorem names

- `RidgeOptimality.lean`
- `RidgeOptimality.ridgeLoss_expand`: expands the sample loss to a quadratic.
- `RidgeOptimality.denominator_pos`: shows `A > 0` under `lam > 0`.
- `RidgeOptimality.ridgeCoefficient_normal`: verifies `A * beta* = B`.
- `RidgeOptimality.ridgeLoss_gap`: proves the square-completion identity.
- `RidgeOptimality.ridgeCoefficient_minimizes`: proves global optimality.

## External inputs / axioms

**No additional external axioms are used beyond the stated theorem hypotheses
and the standard Lean/mathlib foundations.** The only mathematical hypothesis
of the main theorem is `lam > 0`; the dataset is arbitrary. Supporting tactics
and theorems (`ring`, `field_simp`, finite-sum lemmas, positivity of squares,
`linarith`) are provided by mathlib, not newly declared axioms.

## Reproduce the build

1. Install [elan](https://github.com/leanprover/elan) to obtain Lean and Lake.
2. From the repository root, run:

   ```bash
   lake update
   lake exe cache get
   lake build
   ```

3. For direct checking of the submitted source file, run:

   ```bash
   lake env lean RidgeOptimality.lean
   ```

The `lean-toolchain` file pins Lean **4.35.0**. `lakefile.toml` pins mathlib to
**v4.35.0**. The GitHub Actions workflow also attempts to build the project
on every push and pull request. After first setup, commit the generated
`lake-manifest.json` to preserve the complete transitive dependency lock.

**Verification status:** The files in the downloadable starter package were
authored without a local Lean executable or internet access in the artifact
runtime. The Lean proof has not been compiled in that runtime. Do not submit
until the commands above or the GitHub Actions workflow complete successfully.
If the build reports an error, correct it and rerun the build before finalizing
report claims.

## Scope

The result holds for any finite number of observations but **one predictor
only**, with **no intercept** and a **strictly positive** penalty. It is a
finite-sample algebraic minimization theorem. It does not establish out-of-
sample performance, an optimal penalty choice, or the full multivariate
ridge-regression matrix formula. No probability or noise-model assumptions
are made.

## AI-use disclosure

OpenAI ChatGPT (GPT-6) was used to help select and state the theorem, draft
the Lean proof, explain its mathematics, create the README and report,
and package the files. Team members are responsible for reading the proof,
executing the Lean build, and confirming the submitted version.

## References

1. Hoerl, A. E., and Kennard, R. W. (1970). “Ridge Regression: Biased
   Estimation for Nonorthogonal Problems.” *Technometrics* 12(1), 55–67.
   https://doi.org/10.1080/00401706.1970.10488634
2. Hastie, T., Tibshirani, R., and Friedman, J. (2009). *The Elements of
   Statistical Learning*, 2nd ed., Section 3.4.1, equations (3.41)–(3.44).
   Springer. https://hastie.su.domains/ElemStatLearn/
3. Lean/mathlib community. Mathlib repository and documentation.
   https://github.com/leanprover-community/mathlib4
