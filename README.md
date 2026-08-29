# Learning to Tune Kissat SAT Solver Parameters Using Graph Neural Networks
**A deep-learning approach to optimizing SAT solver parameters for faster solving.**

---

## Mathematical & Architectural Context

Modern Boolean Satisfiability (SAT) solvers, particularly those leveraging Conflict-Driven Clause Learning (CDCL), are highly sensitive to their internal heuristic parameters. These heuristics control restart strategies, variable branching, and clause elimination aggressiveness, effectively dictating how efficiently the solver traverses the NP-complete search space.

The primary objective of this project is to  steer the CDCL algorithm toward discovering higher-quality, invariant clauses that rapidly prove the unsatisfiability (UNSAT) of functionally equivalent circuits (miters). We approach this by establishing a corollary: **we approximate the mathematical quality of the discovered clauses by measuring the runtime of the SAT solver.** Less runtime strictly corresponds to superior clause discoveries.

While Kissat provides specialized modes (`--target=2 --restartint=50` for SAT, `--stable=0` for UNSAT), empirical evaluation on miter instances of functionally equivalent multipliers revealed a counter-intuitive phenomenon: Kissat's native UNSAT mode performs **2x worse** than SAT mode, and **1.5x worse** than default settings. 

To resolve this, we isolate and tune three high-impact internal variables:
1. `stable`
2. `eliminateeffort`
3. `decay`

---

## Methodology

### 1. Data Generation Pipeline via Bayesian Optimization
Given the combinatorial and continuous nature of the parameter space, exhaustive grid search is computationally intractable. We utilize **SMAC3 (Sequential Model-Based Algorithm Configuration)** to conduct Bayesian optimization. 

SMAC3 allows us to:
* Minimize brute-force evaluations.
* Utilize surrogate models to sample from the most promising topological regions of the parameter space.
* Generate a high-fidelity dataset of 40 runtime data points across 8-bit, 9-bit, and 10-bit multiplier miters.

### 2. Dual-Stream Neural Architecture
To predict the speedup coefficient for any given parameter state $\mathbf{p} \in \mathbb{R}^3$, we construct a dual-stream architecture fusing structural graph representations with continuous parameter vectors.

* **Graph Embedding Stream:** The input boolean circuit is converted into an And-Inverter Graph (AIG). This graph $G = (V, E)$ is processed through $L$ layers of a Graph Convolutional Network (GCN) to extract a fixed-length topological embedding $\mathbf{d}_g$.
* **Parameter Stream:** The solver parameters are vectorized into $\mathbf{d}_p$.
* **Fusion:** We concatenate the representations $\mathbf{x} = \mathbf{d}_g \oplus \mathbf{d}_p$ and pass them through a Multi-Layer Perceptron (MLP). The network maps $f_{MLP}(\mathbf{x}) 
ightarrow \hat{s}$, where $\hat{s}$ is the predicted speedup relative to Kissat's default configuration.

---

## Model Usage & Inference Pipeline

The trained GNN model operates as a high-speed surrogate to approximate runtime without executing the underlying CDCL loop. 

1. **Enumerate** a subset of candidate parameter vectors.
2. **Predict** the runtime speedup using the trained GCN+MLP architecture.
3. **Select** $	ext{argmax}_{\mathbf{p}} (\hat{s})$.
4. **Execute** Kissat with the optimized parameter vector.

---

## Performance Analysis

### Regression Accuracy
The model accurately captures the non-linear manifold of circuit topology and parameter efficiency:
* **Training Set:** Pearson correlation $r = 0.9460$.
* **Zero-Shot Test Set (11-bit multiplier miter):** Pearson correlation $r = 0.9706$, demonstrating robust generalization to larger, unseen hardware structures.

### Empirical Speedup (Kissat-param vs baselines)
Evaluated deterministically (seed = 64).

| Miter Circuit Algorithm | Kissat-default (s) | Kissat-SAT (s) | Kissat-param (s) | Speedup (vs Default) |
| :--- | :--- | :--- | :--- | :--- |
| `miter_behavioral_unrolled_11bit` | 449.60 | 379.60 | **362.58** | **1.24×** |
| `miter_U_SP_AR_RC_U_SP_DT_RC_9bit` | 12.94 | 11.89 | **9.99** | **1.30×** |
| `miter_U_SP_AR_RC_U_SP_DT_RC_10bit` | 59.70 | 54.48 | **42.98** | **1.39×** |
| `miter_U_SP_AR_RC_U_SP_DT_RC_11bit` | 381.92 | 336.60 | **258.07** | **1.48×** |
| `miter_U_SP_AR_RC_U_SP_DT_RC_12bit` | 2426.87 | — | **1874.49** | **1.29×** |
| `miter_behavioral_unrolled_12bit` | 2766.57 | — | **1517.23** | **1.82×** |

---

## Improvement Areas & Future Roadmap

To push this architecture further toward production-grade verification systems, my immediate focus areas are:

1. **Dataset Heterogeneity:** The current manifold is over-fitted to multiplier miters. We must inject varied algorithmic structures (e.g., control logic, DES/cryptographic permutations) to improve global generalizability.
2. **High-Performance C++ Inference Integration:** Python-based ML inference introduces IPC latency. I plan to rewrite the forward pass of the trained MLP/GCN natively in high-performance C++, utilizing template metaprogramming and hardware-aware bitwise operations to tightly couple the inference engine directly with Kissat's C source code. 
3. **Addressing Optimizer Bias:** SMAC3 aggressively seeks optimal regions, skewing the training distribution towards "good" parameters. Incorporating uniform adversarial sampling is required to improve the discriminative boundary of the loss function against suboptimal parameter configurations.
4. **Stochastic Control:** Implementing fixed seeds strictly throughout the data generation phase to eliminate unmodeled runtime noise during backpropagation.

---
*Authored by Krishnendu Sengupta*