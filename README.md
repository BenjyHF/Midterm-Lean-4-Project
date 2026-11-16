# Ridge Regression Optimality — STAT 4052 Lean 4 Project

This repository contains a Lean 4 formalization of a **one-predictor ridge regression model without an intercept**, using any finite number of real-valued observations. The proof verifies that the closed-form ridge coefficient globally minimizes squared error plus an L2 penalty.

## Mathematical statement

Let `n : ℕ`, `x y : Fin n → ℝ`, and `lam : ℝ` with `0 < lam`. For any real coefficient `beta`, define

```text
J(beta) = ∑ i, (y i - x i * beta)^2 + lam * beta^2
A       = ∑ i, (x i)^2 + lam
B       = ∑ i, (x i) * (y i)
beta*   = B / A
```

The proof establishes `A > 0` and the **exact completion-of-the-square identity**

```text
J(beta) - J(beta*) = A * (beta - beta*)^2.
```

Since the right-hand side is nonnegative, `J(beta*) ≤ J(beta)` for every real `beta`.

## Formalized results

All results are in [`RidgeOptimality.lean`](RidgeOptimality.lean), in namespace `RidgeOptimality`:

- `ridgeLoss_expand` — expand the actual residual-squares objective as a quadratic.
- `denominator_pos` — prove the positive denominator when `lam > 0`.
- `ridgeCoefficient_normal` — establish the candidate's normal equation.
- `ridgeLoss_gap` — establish the exact objective-gap identity.
- **`ridgeCoefficient_minimizes`** — prove global optimality for all finite samples and all real candidate coefficients.

## Assumptions and external axioms

The mathematical hypothesis is `lam > 0`. Predictors and responses are arbitrary finite real-valued sequences; there is no assumed noise distribution, probability model, or invertibility condition on the data. The single-predictor/no-intercept form defines the scope of the model.

**No additional external axioms are used beyond the stated theorem hypotheses and the standard Lean/mathlib foundations.** The development relies on proved mathlib lemmas and tactics, including finite-sum identities, positivity of squares, `ring`, `field_simp`, and `linarith`. It introduces no `axiom`, `sorry`, or `admit` declarations.

## Reproduce the proof check

Install [elan](https://github.com/leanprover/elan), which installs the pinned Lean toolchain, then run from the repository root:

```bash
lake exe cache get
lake build
lake env lean RidgeOptimality.lean
```

The committed [`lean-toolchain`](lean-toolchain) pins **Lean 4.35.0**; [`lakefile.toml`](lakefile.toml) requests **mathlib v4.35.0**, and the committed [`lake-manifest.json`](lake-manifest.json) locks the exact dependency Git commits. **Do not run `lake update` when reproducing this exact version**, as updating may change the dependency lock. The [GitHub Actions workflow](.github/workflows/lean.yml) checks the committed source on pushes and pull requests.

[View GitHub Actions verification runs](../../actions/workflows/lean.yml). The instructor should inspect the successful run corresponding to the **exact commit SHA identified in the PDF report**.

## Verified scope and limitations

Lean checks a **finite-sample algebraic minimization theorem** for one predictor, with no intercept, and `lam > 0`. The formalization does **not** establish out-of-sample improvement, an optimal tuning parameter, a probability model, or the multivariable matrix-form ridge estimator.

## AI assistance

OpenAI ChatGPT (GPT-6) was used to help state the theorem, draft and debug the Lean code, prepare the mathematical explanation and README, and configure CI. The team must review the proof and comply with the course syllabus's AI-disclosure requirements.

## References

1. Hoerl, A. E., and Kennard, R. W. (1970), “Ridge Regression: Biased Estimation for Nonorthogonal Problems,” *Technometrics* **12**(1), 55–67. https://doi.org/10.1080/00401706.1970.10488634
2. Hastie, T., Tibshirani, R., and Friedman, J. (2009), *The Elements of Statistical Learning*, 2nd ed., §3.4.1, eqs. (3.41)–(3.44). https://hastie.su.domains/ElemStatLearn/
3. Mathlib community, *mathlib4* repository. https://github.com/leanprover-community/mathlib4
