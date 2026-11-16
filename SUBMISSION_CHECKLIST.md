# Final checks before submission (STAT 4052)

- [ ] Supply **all team members' full names** on page 1 of the PDF.
- [ ] Follow the team-size / non-paid-AI-subscription rule in the handout.
- [ ] Run `lake update`, `lake exe cache get`, `lake build`, and `lake env lean RidgeOptimality.lean`.
- [ ] Fix any Lean compiler errors, and verify no incomplete proof placeholders exist.
- [ ] Commit `lake-manifest.json` from `lake update` to version-lock transitive dependencies.
- [ ] Push source, `lean-toolchain`, `lakefile.toml`, README, workflow, and PDF to a **public or instructor-accessible** GitHub repository.
- [ ] Confirm that GitHub Actions is green on the exact submitted commit.
- [ ] Replace `[REPOSITORY URL]` and `[COMMIT SHA]` in the LaTeX report, then re-run `pdflatex`.
- [ ] Update the PDF's verification-status sentence after a *real successful build*.
- [ ] Verify the final PDF is no longer than 3 pages and includes **no Lean source code**.
- [ ] Review the AI-assistance disclosure against the course syllabus.
- [ ] Submit by **November 20, 2026**.
