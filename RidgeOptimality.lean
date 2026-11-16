import Mathlib

/-!
# Ridge regression optimality (one predictor)

For arbitrary finite samples, a positive regularization parameter makes
ridge regression's scalar objective a strictly convex quadratic.  We verify
its expansion, the positivity of its quadratic coefficient, an exact
completion-of-the-square identity, and global minimization.
-/

namespace RidgeOptimality

open BigOperators

noncomputable section

/-- Sum of squared residuals plus an L2 penalty, for a model with
    one predictor and no intercept. -/
def ridgeLoss {n : ℕ} (x y : Fin n → ℝ) (lam beta : ℝ) : ℝ :=
  (∑ i : Fin n, (y i - x i * beta) ^ 2) + lam * beta ^ 2

/-- The positive quadratic coefficient of the scalar ridge objective. -/
def denominator {n : ℕ} (x : Fin n → ℝ) (lam : ℝ) : ℝ :=
  (∑ i : Fin n, (x i) ^ 2) + lam

/-- The sample cross-product. -/
def numerator {n : ℕ} (x y : Fin n → ℝ) : ℝ :=
  ∑ i : Fin n, x i * y i

/-- The familiar closed-form one-predictor ridge coefficient. -/
def ridgeCoefficient {n : ℕ} (x y : Fin n → ℝ) (lam : ℝ) : ℝ :=
  numerator x y / denominator x lam

/-- Algebraic expansion of the actual residual-squares objective. -/
theorem ridgeLoss_expand {n : ℕ} (x y : Fin n → ℝ) (lam beta : ℝ) :
    ridgeLoss x y lam beta =
      denominator x lam * beta ^ 2 - 2 * numerator x y * beta +
        (∑ i : Fin n, (y i) ^ 2) := by
  unfold ridgeLoss denominator numerator
  calc
    (∑ i : Fin n, (y i - x i * beta) ^ 2) + lam * beta ^ 2 =
      (∑ i : Fin n,
        (x i) ^ 2 * beta ^ 2 - (x i * y i) * (2 * beta) + (y i) ^ 2) +
          lam * beta ^ 2 := by
      congr 1
      apply Finset.sum_congr rfl
      intro i hi
      ring
    _ = ((∑ i : Fin n, (x i) ^ 2) + lam) * beta ^ 2 -
        2 * (∑ i : Fin n, x i * y i) * beta +
          (∑ i : Fin n, (y i) ^ 2) := by
      simp only [Finset.sum_add_distrib, Finset.sum_sub_distrib,
        ← Finset.sum_mul]
      ring

/-- A positive ridge penalty guarantees that the denominator is positive,
    even if every observed predictor is zero. -/
theorem denominator_pos {n : ℕ} (x : Fin n → ℝ) (lam : ℝ)
    (hlam : 0 < lam) : 0 < denominator x lam := by
  unfold denominator
  have hsum : 0 ≤ ∑ i : Fin n, (x i) ^ 2 := by
    apply Finset.sum_nonneg
    intro i hi
    exact sq_nonneg (x i)
  linarith

/-- The proposed coefficient solves the scalar normal equation. -/
theorem ridgeCoefficient_normal {n : ℕ} (x y : Fin n → ℝ) (lam : ℝ)
    (hlam : 0 < lam) :
    denominator x lam * ridgeCoefficient x y lam = numerator x y := by
  have hne : denominator x lam ≠ 0 :=
    ne_of_gt (denominator_pos x lam hlam)
  unfold ridgeCoefficient
  field_simp [hne] <;> ring

/-- Exact completion-of-the-square identity: the objective gap is a
    positive coefficient times a squared difference. -/
theorem ridgeLoss_gap {n : ℕ} (x y : Fin n → ℝ) (lam : ℝ)
    (hlam : 0 < lam) (beta : ℝ) :
    ridgeLoss x y lam beta - ridgeLoss x y lam (ridgeCoefficient x y lam) =
      denominator x lam * (beta - ridgeCoefficient x y lam) ^ 2 := by
  have hnormal := ridgeCoefficient_normal x y lam hlam
  rw [ridgeLoss_expand x y lam beta,
    ridgeLoss_expand x y lam (ridgeCoefficient x y lam)]
  rw [← hnormal]
  ring

/-- Main project result: the closed-form scalar ridge estimator globally
    minimizes residual sum of squares plus positive L2 regularization. -/
theorem ridgeCoefficient_minimizes {n : ℕ} (x y : Fin n → ℝ) (lam : ℝ)
    (hlam : 0 < lam) (beta : ℝ) :
    ridgeLoss x y lam (ridgeCoefficient x y lam) ≤
      ridgeLoss x y lam beta := by
  have hgap := ridgeLoss_gap x y lam hlam beta
  have hnonneg :
      0 ≤ denominator x lam * (beta - ridgeCoefficient x y lam) ^ 2 :=
    mul_nonneg (le_of_lt (denominator_pos x lam hlam)) (sq_nonneg _)
  linarith

end
end RidgeOptimality
