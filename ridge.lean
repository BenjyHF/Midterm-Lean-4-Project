import Mathlib

/-!
# Ridge regression with one coefficient and no intercept

Data: `x y : Fin n → ℝ`, penalty `lam > 0`.
Objective: `∑ᵢ (yᵢ - b xᵢ)² + lam * b²`.
Result: the unique minimizer is `b̂ = (∑ xᵢ yᵢ) / ((∑ xᵢ²) + lam)`.

No additional external axioms are used beyond the stated theorem hypotheses
and the standard Lean/mathlib foundations.
-/

/-- The expanded objective, with data summaries
`xx = ∑ xᵢ²`, `xy = ∑ xᵢ yᵢ`, `yy = ∑ yᵢ²`. -/
def ridgeLoss (xx xy yy lam b : ℝ) : ℝ :=
  (xx + lam) * b ^ 2 - 2 * xy * b + yy

/-- The ridge objective on data. The penalty is outside the sum. -/
noncomputable def ridgeObj {n : ℕ} (x y : Fin n → ℝ) (lam b : ℝ) : ℝ :=
  (∑ i, (y i - b * x i) ^ 2) + lam * b ^ 2

/-- Expanding the data objective gives `ridgeLoss` with the data summaries. -/
theorem ridgeObj_eq {n : ℕ} (x y : Fin n → ℝ) (lam b : ℝ) :
    ridgeObj x y lam b
      = ridgeLoss (∑ i, x i ^ 2) (∑ i, x i * y i) (∑ i, y i ^ 2) lam b := by
  have h : ∑ i, (y i - b * x i) ^ 2
      = ∑ i, (x i ^ 2 * b ^ 2 - 2 * (x i * y i) * b + y i ^ 2) :=
    Finset.sum_congr rfl (fun i _ => by ring)
  unfold ridgeObj ridgeLoss
  rw [h]
  simp only [Finset.sum_add_distrib, Finset.sum_sub_distrib, Finset.sum_mul,
    Finset.mul_sum, add_mul]
  ring

/-- Completing the square gives the loss gap to the candidate minimizer. -/
theorem ridgeLoss_gap (xx xy yy lam b : ℝ) (hpos : 0 < xx + lam) :
    ridgeLoss xx xy yy lam b - ridgeLoss xx xy yy lam (xy / (xx + lam))
      = (xx + lam) * (b - xy / (xx + lam)) ^ 2 := by
  have hzero : xx + lam ≠ 0 := ne_of_gt hpos
  unfold ridgeLoss
  field_simp [hzero]
  ring

/-- `xy / (xx + lam)` minimizes the one-dimensional objective. -/
theorem ridge_minimizes (xx xy yy lam b : ℝ) (hxx : 0 ≤ xx) (hlam : 0 < lam) :
    ridgeLoss xx xy yy lam (xy / (xx + lam)) ≤ ridgeLoss xx xy yy lam b := by
  have hpos : 0 < xx + lam := by linarith
  have hgap := ridgeLoss_gap xx xy yy lam b hpos
  have hnonneg : 0 ≤ (xx + lam) * (b - xy / (xx + lam)) ^ 2 :=
    mul_nonneg hpos.le (sq_nonneg _)
  linarith

/-- Any minimizer equals `xy / (xx + lam)`. -/
theorem ridge_unique (xx xy yy lam b : ℝ) (hxx : 0 ≤ xx) (hlam : 0 < lam)
    (hmin : ∀ b', ridgeLoss xx xy yy lam b ≤ ridgeLoss xx xy yy lam b') :
    b = xy / (xx + lam) := by
  have hpos : 0 < xx + lam := by linarith
  have hgap := ridgeLoss_gap xx xy yy lam b hpos
  have hle := hmin (xy / (xx + lam))
  have h0 : (xx + lam) * (b - xy / (xx + lam)) ^ 2 ≤ 0 := by linarith
  have hsq : (b - xy / (xx + lam)) ^ 2 = 0 := by
    by_contra hne
    have hpos' : 0 < (b - xy / (xx + lam)) ^ 2 :=
      lt_of_le_of_ne (sq_nonneg _) (Ne.symm hne)
    have := mul_pos hpos hpos'
    linarith
  have hzero : b - xy / (xx + lam) = 0 := (pow_eq_zero_iff two_ne_zero).mp hsq
  exact sub_eq_zero.mp hzero

/-- On data, the ridge estimate minimizes the ridge objective. -/
theorem ridgeObj_minimizes {n : ℕ} (x y : Fin n → ℝ) (lam b : ℝ) (hlam : 0 < lam) :
    ridgeObj x y lam ((∑ i, x i * y i) / ((∑ i, x i ^ 2) + lam))
      ≤ ridgeObj x y lam b := by
  have hxx : 0 ≤ ∑ i, x i ^ 2 := Finset.sum_nonneg (fun i _ => sq_nonneg (x i))
  rw [ridgeObj_eq, ridgeObj_eq]
  exact ridge_minimizes (∑ i, x i ^ 2) (∑ i, x i * y i) (∑ i, y i ^ 2) lam b hxx hlam

/-- On data, any minimizer of the ridge objective is the ridge estimate. -/
theorem ridgeObj_unique {n : ℕ} (x y : Fin n → ℝ) (lam b : ℝ) (hlam : 0 < lam)
    (hmin : ∀ b', ridgeObj x y lam b ≤ ridgeObj x y lam b') :
    b = (∑ i, x i * y i) / ((∑ i, x i ^ 2) + lam) := by
  have hxx : 0 ≤ ∑ i, x i ^ 2 := Finset.sum_nonneg (fun i _ => sq_nonneg (x i))
  exact ridge_unique (∑ i, x i ^ 2) (∑ i, x i * y i) (∑ i, y i ^ 2) lam b hxx hlam
    (fun b' => by
      have h := hmin b'
      rwa [ridgeObj_eq, ridgeObj_eq] at h)

-- Inspect which axioms the main theorems depend on.
#print axioms ridgeObj_minimizes
#print axioms ridgeObj_unique
