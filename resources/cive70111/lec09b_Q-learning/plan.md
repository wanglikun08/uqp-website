# lec09b Q-learning Demo Plan

## Goals tied to lecture 09
- Illustrate exploration vs exploitation with an epsilon-greedy behavioural policy (corpus: Exploration vs. Exploitation, Model-Free Methods).
- Show model-free control via Q-learning and the off-policy update rule using the CartPole task (corpus: Q-Learning, Model-Free Control).
- Contrast on-policy SARSA vs. off-policy Q-learning targets to explain why Q-learning can be more optimal yet less cautious (corpus: The Problem with SARSA, Q-Learning).
- Add Monte Carlo control as a third baseline to link back to full-episode targets and sample efficiency limits (corpus: Monte Carlo Control, Model-Free Prediction).
- Expose the role of the TD error and the Bellman backup in state-action value updates (corpus: Temporal Difference, Q-table update rules).
- Highlight the limitations of tabular methods and motivate function approximation/DRL (corpus: Q-table limitations, Deep Q-Learning).

## Experience flow
- **Recap/Manual mode**: Same canvas and physics from lec09a_cartpole-control; user manually balances to recall the task and reward structure.
- **Cold-start agent**: Run with random policy to set a baseline return and visualize poor survival.
- **Snapshot playback only**: Load precomputed CartPole agents (MC, SARSA, Q-learning) at selected step-count checkpoints; no live training.
- **On-policy vs. off-policy vs. Monte Carlo**: Switch between SARSA, Q-learning, and Monte Carlo checkpoints to show different targets and trajectories without client-side computation.
- **Evaluation run**: Exploit-only playback of a chosen snapshot to see stability and failure patterns.
- **Stretch bridge**: Brief hook showing why tabular Q explodes in size and a teaser for DQN (no NN implementation, just messaging).

## Lightweight comparison and performance constraints
- Pretrain small, discrete CartPole agents (Q-learning, SARSA, Monte Carlo) offline and store checkpoints (e.g., at 0, 2k, 10k, 50k steps) as JSON tables to load instantly client-side.
- No live training; all comparisons rely on loading snapshots to keep CPU/GPU usage minimal.
- Offer a playback timeline: pick a snapshot (algorithm + step count), then press Play to watch how that policy behaves; render only at 60 fps while stepping physics at fixed tau.
- Keep state discretization coarse for live runs (so tables stay small) and use precomputed finer tables for the comparison heatmaps to avoid client CPU spikes.
- Use a capped number of transitions when showing TD error breakdowns (sample a few recent steps) to avoid large arrays in memory.

## UI layout and panels
- **Canvas**: Reuse CartPole render; overlay current action arrow and termination message when done.
- **Controls panel**:
    - Simple mode buttons: Manual, Play snapshot.
    - Snapshot picker: algorithm (MC, SARSA, Q-learning) and step-count checkpoint (e.g., 0, 2k, 10k, 50k) loaded from precomputed tables.
    - Minimal hyperparams in an "Advanced" drawer only to explain what was used in pretraining (read-only values) and to swap discretization presets for visualization.
    - Quick actions: Play/Pause, Step one transition, Reset env.
- **Metrics panel**:
    - Episode return plot vs. step count for the selected snapshot (uses precomputed learning curve).
    - Epsilon schedule used during pretraining (static).
    - TD error illustration: pull a few representative transitions from the chosen snapshot (MC shows update only at episode end).
    - Current snapshot best return and last episode length (precomputed).
    - Policy view: best action for current discretized state (Left/Right).
- **Q-Table view**:
    - Heatmap slices for selected state dimensions (e.g., pole angle vs. angular velocity holding cart position/velocity near zero).
    - Tooltip showing Q(s,a) and chosen greedy action; annotation reminding of combinatorial growth.
    - Side-by-side snapshots for MC, SARSA, and Q-learning at the same episode count to visualize target differences.
- **Status and teaching callouts**:
    - Inline notes mapping what is visible to lecture points (e.g., "off-policy target uses max_a Q(s',a)" when Q-learning is active).
    - Warning when discretization bins are small/large to discuss approximation trade-offs.

## Teaching checkpoints (scripted prompts)
- **Checkpoint 1 (Exploration vs. Exploitation)**: Start with high epsilon; watch unstable returns; decay epsilon and observe stabilization.
- **Checkpoint 2 (TD Update)**: Freeze screen on a transition and display the TD error components: current Q(s,a), reward, gamma*max_a Q(s',a), updated Q. Show that MC waits until episode end to apply the return.
- **Checkpoint 3 (On vs. Off Policy vs. MC)**: Switch between MC, SARSA, and Q-learning snapshots at the same step count; compare trajectories, returns, and targets (full-episode vs. on-policy TD vs. off-policy TD).
- **Checkpoint 4 (Sample Efficiency + Limits)**: Show Q-table size estimate vs. chosen bin counts; prompt that continuous control needs function approximation/DQN.

## Data and implementation notes (for future coding)
- Reuse `CartPoleEnvironment` and rendering from lec09a; wrap a tabular agent with configurable discretization (per-variable bins).
- Episode loop should support real-time speed (1x) and fast-forward (no render) with summarized metrics to keep UI responsive.
- Persist optional session stats in-memory only; no leaderboard needed unless a late “challenge” mode is desired.
- Keep styles aligned with `demos/source/styles.css`; add a local `style.css` only for layout tweaks specific to this demo.
- Remember to update `demos/source/demos.json` when the demo ships; include a short description and preview.

## Open questions to settle before implementation
- Exact discretization presets for CartPole (e.g., angle in {-12, -6, 0, 6, 12} degrees); confirm bins so Q-table remains inspectable.
- Do we include stochastic resets or domain randomization (cart mass/length) to show policy robustness, or keep the classic deterministic setup?
- Should the SARSA comparison be interactive (single toggle) or a side-by-side dual-agent run for clearer contrast?
- How aggressive should default epsilon decay be to let students see exploration long enough without boredom?
- Which step-count checkpoints best illustrate MC’s end-of-episode updates versus TD’s per-step updates without large checkpoint files?
