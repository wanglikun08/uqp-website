Overview

     Build an interactive demo comparing three model-free RL algorithms (Monte Carlo, SARSA, Q-learning) on the CartPole task using snapshot playback only (no live client-side 
     training). Users can switch between precomputed checkpoints at different training stages and view side-by-side comparisons of all three algorithms.

     Key Design Decisions (User Confirmed)

     - ❌ No manual mode - Jump directly to trained agent comparison
     - ✅ Side-by-side comparison - Show all THREE algorithms (MC, SARSA, Q-learning) simultaneously with dual/triple Q-table heatmaps
     - ❌ No leaderboard - Focus purely on algorithm comparison
     - ✅ Fixed Q-table slice - Show theta vs theta_dot only (cart position near center)
     - ✅ 4 checkpoints - 0 steps (random), 2k steps, 10k steps, 50k steps

     File Structure

     demos/source/lec09b_Q-learning/
     ├── content.html              # Main HTML with side-by-side layout
     ├── style.css                 # Demo-specific styles
     ├── script.js                 # Main demo controller
     ├── q-learning-engine.js      # TabularAgent class (Q-table + discretization)
     ├── snapshot-loader.js        # Checkpoint loading and management
     ├── q-table-viz.js           # Q-table heatmap visualization
     ├── preview.svg              # Gallery preview image
     ├── data/
     │   ├── mc_checkpoints.json      # Monte Carlo snapshots
     │   ├── sarsa_checkpoints.json   # SARSA snapshots
     │   └── qlearn_checkpoints.json  # Q-learning snapshots
     └── support/                 # Python training scripts (excluded from build)
         ├── train_agents.py      # Train all 3 algorithms
         ├── requirements.txt     # torch, gymnasium, numpy
         └── README.md            # Training instructions

     JSON Data Format

     Each checkpoint file (e.g., qlearn_checkpoints.json) contains:

     {
       "algorithm": "Q-learning",
       "metadata": {
         "environment": "CartPole-v1",
         "discretization": {
           "x_bins": [-2.4, -1.2, 0.0, 1.2, 2.4],
           "x_dot_bins": [-3.0, -1.0, 0.0, 1.0, 3.0],
           "theta_bins": [-0.21, -0.10, 0.0, 0.10, 0.21],
           "theta_dot_bins": [-2.0, -0.5, 0.0, 0.5, 2.0]
         },
         "hyperparameters": {
           "gamma": 0.99,
           "alpha": 0.1,
           "epsilon_start": 1.0,
           "epsilon_end": 0.01,
           "epsilon_decay": 0.995
         }
       },
       "checkpoints": [
         {
           "step": 0,
           "episode": 0,
           "q_table": {
             "shape": [5, 5, 5, 5, 3],
             "data": [/* Flattened 1D array */]
           },
           "learning_curve": {
             "episodes": [1, 2, 3, ...],
             "returns": [12, 18, 24, ...]
           },
           "statistics": {
             "avg_return_last_100": 0.0,
             "max_return": 0.0,
             "epsilon": 1.0
           },
           "sample_transitions": [
             {
               "state": [0.02, -0.01, 0.03, -0.05],
               "action": 1,
               "reward": 1.0,
               "next_state": [0.01, 0.02, 0.02, -0.03],
               "td_error": 0.15,
               "q_old": 2.3,
               "q_new": 2.45,
               "q_next_max": 2.41  // For Q-learning
             }
           ]
         }
       ]
     }

     Critical Implementation Files to Reuse

     1. CartPole Physics: demos/source/lec09a_cartpole-control/cartpole-engine.js (copy as-is)
     2. Snapshot Loading Pattern: demos/source/lec05b_cnn-architecture/script.js (lines 56-85)
     3. Chart.js Learning Curves: demos/source/lec08a_multi-armed-bandit/script.js (lines 177-226)
     4. MetricLabel: demos/source/phoebe-js/metriclabel.js
     5. InfoTab: demos/source/phoebe-js/infotab.js
     6. CanvasHelper: demos/source/phoebe-js/canvashelper.js

     UI Layout (Side-by-Side Comparison)

     ┌─────────────────────────────────────────────────────────────────┐
     │  InfoTab (left sidebar - 5 tabs)                               │
     │  - Introduction                                                 │
     │  - Theory (update rules with MathJax)                          │
     │  - Discretization                                               │
     │  - Teaching Checkpoints                                         │
     │  - Limitations & DQN Bridge                                     │
     └─────────────────────────────────────────────────────────────────┘

     ┌─────────────────────────────────────────────────────────────────┐
     │  Checkpoint Selector (top controls)                            │
     │  [0 steps] [2k steps] [10k steps] [50k steps]                  │
     │  Teaching Callout: "Currently viewing: 10k steps"              │
     └─────────────────────────────────────────────────────────────────┘

     ┌──────────────────┬──────────────────┬──────────────────┐
     │   Monte Carlo    │      SARSA       │   Q-learning     │
     ├──────────────────┼──────────────────┼──────────────────┤
     │  CartPole Canvas │  CartPole Canvas │  CartPole Canvas │
     │  [Play] [Step]   │  [Play] [Step]   │  [Play] [Step]   │
     ├──────────────────┼──────────────────┼──────────────────┤
     │  Metrics:        │  Metrics:        │  Metrics:        │
     │  - Avg Return    │  - Avg Return    │  - Avg Return    │
     │  - Epsilon       │  - Epsilon       │  - Epsilon       │
     │  - Max Return    │  - Max Return    │  - Max Return    │
     ├──────────────────┼──────────────────┼──────────────────┤
     │  Learning Curve  │  Learning Curve  │  Learning Curve  │
     │  Chart.js        │  Chart.js        │  Chart.js        │
     ├──────────────────┼──────────────────┼──────────────────┤
     │  Q-Table Heatmap │  Q-Table Heatmap │  Q-Table Heatmap │
     │  (theta vs       │  (theta vs       │  (theta vs       │
     │   theta_dot)     │   theta_dot)     │   theta_dot)     │
     ├──────────────────┴──────────────────┴──────────────────┤
     │  TD Error Breakdown (shared panel, updates based on     │
     │  which agent is active)                                  │
     │  - Shows algorithm-specific target calculation           │
     │  - MC: Episode return G_t                               │
     │  - SARSA: R + γ Q(s',a') [actual next action]          │
     │  - Q-learning: R + γ max Q(s',a') [best next action]   │
     └──────────────────────────────────────────────────────────┘

     Core Classes and Responsibilities

     1. QLearningDemo (script.js)

     - Main controller orchestrating all components
     - Manages checkpoint loading (all 3 algorithms)
     - Handles checkpoint switching
     - Coordinates side-by-side agent playback
     - Updates shared UI elements

     Key Methods:
     async initialize()
     async loadAllCheckpoints()
     loadCheckpoint(checkpointIndex)  // Loads all 3 algorithms for this checkpoint
     playAllAgents()  // Synchronized playback of all 3
     updateTDErrorDisplay(algorithm, transition)

     2. TabularAgent (q-learning-engine.js)

     - Q-table reconstruction from JSON
     - State discretization (continuous → discrete bins)
     - Action selection (epsilon-greedy)
     - Q-value queries for visualization

     Key Methods:
     constructor(checkpoint)
     reconstructQTable(flatData, shape)
     discretizeState(state)
     selectAction(state, epsilon)
     getQValue(state, action)

     3. SnapshotLoader (snapshot-loader.js)

     - Manages checkpoint data for all 3 algorithms
     - Checkpoint indexing and retrieval
     - Validation of loaded data

     Key Methods:
     async loadAllCheckpoints()
     getCheckpoint(algorithm, index)
     getMetadata(algorithm)

     4. QTableVisualization (q-table-viz.js)

     - Renders 2D heatmap slice (theta vs theta_dot)
     - Color-coding Q-values (viridis colormap)
     - Action arrows showing best action per state
     - Axes labels and colorbar

     Key Methods:
     constructor(canvasId)
     updateHeatmap(qTableData, discretization)
     render()
     getColor(qValue)  // Colormap function
     drawActionArrow(x, y, action)

     5. AgentColumn (script.js helper class)

     - Encapsulates one algorithm's display (MC, SARSA, or Q-learning)
     - Manages: CartPole canvas, metrics, chart, Q-table heatmap
     - Isolated playback loop

     Key Methods:
     constructor(algorithm, containerId)
     loadSnapshot(checkpoint)
     playEpisode()
     updateMetrics()
     renderCanvas()

     State Discretization Strategy

     Bins per dimension: 5 (total Q-table size: 5^4 × 3 actions = 1,875 values)

     | Variable                     | Range             | Bins | Rationale                      |
     |------------------------------|-------------------|------|--------------------------------|
     | x (position)                 | [-2.4, 2.4] m     | 5    | Coarse, position less critical |
     | x_dot (velocity)             | [-3, 3] m/s       | 5    | Moderate resolution            |
     | theta (angle)                | [-0.21, 0.21] rad | 5    | CRITICAL - finer near 0        |
     | theta_dot (angular velocity) | [-2, 2] rad/s     | 5    | CRITICAL - capture dynamics    |

     Q-table Heatmap Slice:
     - Fix: x ≈ 0, x_dot ≈ 0 (cart near center, low velocity)
     - Display: theta (horizontal) × theta_dot (vertical)
     - Result: 5×5 grid with color-coded max Q-values + action arrows

     TD Error Display Logic

     Show algorithm-specific update rule with actual values from sample transitions:

     Monte Carlo:
     Current Q-value: Q(s,a) = 2.35
     Episode return:  G_t = 45.2
     Error:          δ = G_t - Q(s,a) = 42.85
     Updated:        Q'(s,a) = 2.35 + 0.1 × 42.85 = 6.64

     SARSA (On-policy):
     Current Q-value: Q(s,a) = 2.35
     Reward:         R = 1.0
     Target:         γ Q(s',a') = 0.99 × 2.41 = 2.39
     TD Error:       δ = R + γ Q(s',a') - Q(s,a) = 0.04
     Updated:        Q'(s,a) = 2.35 + 0.1 × 0.04 = 2.354

     Q-learning (Off-policy):
     Current Q-value: Q(s,a) = 2.35
     Reward:         R = 1.0
     Target:         γ max Q(s',a') = 0.99 × 2.48 = 2.46
     TD Error:       δ = R + γ max Q(s',a') - Q(s,a) = 0.11
     Updated:        Q'(s,a) = 2.35 + 0.1 × 0.11 = 2.361

     Teaching Checkpoints (Scripted Prompts)

     Checkpoint 0 (Random Policy):
     - Message: "Random initialization - watch all three agents fail!"
     - Action: Play all agents simultaneously

     Checkpoint 1 (2k steps - Early Training):
     - Message: "Early training with high exploration (ε ≈ 0.8). Notice MC updates only at episode end."
     - Action: Show TD error breakdown for each algorithm

     Checkpoint 2 (10k steps - Mid-Training):
     - Message: "Key difference: SARSA uses actual next action, Q-learning uses max. Compare Q-tables side-by-side!"
     - Action: Highlight Q-table differences in heatmaps

     Checkpoint 3 (50k steps - Converged):
     - Message: "Near-optimal policies. Q-table size: 625 states × 3 actions = 1,875 values. Imagine millions of states!"
     - Action: Show Q-table size calculation and bridge to DQN

     Python Training Script Requirements

     File: support/train_agents.py

     Core functionality:
     1. Train all 3 algorithms (MC, SARSA, Q-learning) on CartPole-v1
     2. Use gymnasium environment
     3. 5×5×5×5 discretization bins
     4. Save checkpoints at 0, 2k, 10k, 50k steps
     5. Store Q-table as flattened 1D array
     6. Decimate learning curves (store every 10th episode)
     7. Save 20 sample transitions per checkpoint for TD error display
     8. Export to JSON format matching specification above

     Hyperparameters:
     - gamma = 0.99
     - alpha = 0.1
     - epsilon_start = 1.0, epsilon_end = 0.01, epsilon_decay = 0.995

     Estimated file sizes:
     - Q-table per checkpoint: ~240 KB
     - Learning curve: ~16 KB (decimated)
     - Sample transitions: ~2 KB
     - Total per algorithm: ~1 MB (4 checkpoints)
     - Total data folder: ~3 MB (all 3 algorithms)

     Implementation Phases

     Phase 1: Infrastructure (Days 1-2)

     Goal: File structure + CartPole reuse + single agent working

     Tasks:
     1. Create directory structure
     2. Copy cartpole-engine.js from lec09a
     3. Create empty HTML shell with InfoTab structure
     4. Implement TabularAgent class (Q-table reconstruction + discretization)
     5. Implement SnapshotLoader with mock data
     6. Basic render loop showing CartPole canvas

     Deliverable: Can load a mock Q-table and play CartPole with random actions

     Phase 2: Python Training (Days 2-3)

     Goal: Generate real checkpoint data

     Tasks:
     1. Write train_agents.py with tabular RL implementation
     2. Implement discretization matching frontend
     3. Train all 3 algorithms (MC, SARSA, Q-learning)
     4. Export checkpoints at 0, 2k, 10k, 50k steps
     5. Validate JSON format matches specification
     6. Test file sizes (should be ~3 MB total)

     Deliverable: data/ folder with 3 checkpoint files, real trained agents

     Phase 3: Single Agent Playback (Day 3)

     Goal: One algorithm working end-to-end

     Tasks:
     1. Load real Q-learning checkpoints
     2. Implement epsilon-greedy action selection in TabularAgent
     3. Create playback loop (Play/Pause/Step controls)
     4. Render CartPole with agent actions
     5. Add MetricLabel displays (avg return, epsilon, max return)

     Deliverable: Can watch Q-learning agent play CartPole at any checkpoint

     Phase 4: Side-by-Side Layout (Days 4-5)

     Goal: All 3 algorithms displayed simultaneously

     Tasks:
     1. Create 3-column CSS grid layout
     2. Implement AgentColumn helper class
     3. Instantiate 3 AgentColumn objects (MC, SARSA, Q-learning)
     4. Synchronized checkpoint switching
     5. Independent playback controls per column
     6. 3 separate CartPole canvases rendering

     Deliverable: Side-by-side view of all 3 algorithms, independent playback

     Phase 5: Q-Table Heatmaps (Days 5-6)

     Goal: Visual Q-table comparison

     Tasks:
     1. Implement QTableVisualization class
     2. Create viridis colormap function
     3. Render 5×5 heatmap slice (theta vs theta_dot)
     4. Draw action arrows on heatmap
     5. Add axes labels and colorbar
     6. Instantiate 3 heatmaps (one per column)

     Deliverable: Side-by-side Q-table heatmaps showing policy differences

     Phase 6: Learning Curves (Day 6)

     Goal: Episode return plots

     Tasks:
     1. Initialize Chart.js in each column
     2. Load learning curve data from checkpoints
     3. Plot episode return vs episode number
     4. Add tooltips and zoom controls
     5. Update charts on checkpoint switch

     Deliverable: 3 learning curve charts showing training progress

     Phase 7: TD Error Display (Day 7)

     Goal: Algorithm-specific update rule visualization

     Tasks:
     1. Create shared TD error panel below columns
     2. Implement algorithm detection (MC vs SARSA vs Q-learning)
     3. Format equations with MathJax
     4. Load sample transitions from checkpoint
     5. Update display when user clicks an agent column

     Deliverable: Interactive TD error breakdown showing algorithm differences

     Phase 8: Teaching Checkpoints (Day 7)

     Goal: Guided learning prompts

     Tasks:
     1. Implement teaching callout system
     2. Add checkpoint-specific messages
     3. Create modal or inline prompts
     4. Link prompts to actions (play all, compare Q-tables, etc.)

     Deliverable: Scripted teaching flow guiding users through checkpoints

     Phase 9: InfoTab Content (Day 8)

     Goal: Educational content

     Tasks:
     1. Write 5 InfoTab panels:
       - Introduction (why compare RL algorithms)
       - Theory (MC/SARSA/Q-learning update rules with MathJax)
       - Discretization (bin strategy, trade-offs)
       - Teaching Checkpoints (what to look for)
       - Limitations (tabular methods → DQN bridge)
     2. Add MathJax equations
     3. Include figures/diagrams if needed

     Deliverable: Complete educational sidebar content

     Phase 10: Polish & Testing (Days 8-9)

     Goal: Production-ready demo

     Tasks:
     1. Create preview.svg for gallery
     2. Optimize CSS (responsive layout, mobile breakpoints)
     3. Add loading spinners for checkpoint switching
     4. Error handling for failed JSON loads
     5. Cross-browser testing (Chrome, Safari, Firefox)
     6. iPad testing (touch interactions)
     7. Performance optimization (Canvas rendering, Chart.js decimation)
     8. Update demos/source/demos.json with entry

     Deliverable: Fully polished, tested, production-ready demo

     Performance Considerations

     Checkpoint Loading:
     - Load all 3 checkpoints in parallel using Promise.all()
     - Show loading spinner during fetch
     - Cache checkpoints in memory (don't re-fetch)

     Canvas Rendering:
     - Use CanvasHelper.setupHighDPI() for retina displays
     - requestAnimationFrame at 60fps
     - Independent render loops per column (3 simultaneous agents)

     Q-Table Heatmap:
     - Render only on checkpoint switch (not every frame)
     - Use off-screen canvas for better performance
     - Cache colormap function results

     Chart.js:
     - Enable decimation plugin for learning curves
     - Disable animations during checkpoint switch (update('none'))
     - Limit tooltip callbacks to reduce CPU

     Open Design Questions (Resolved)

     ✅ Manual mode: No - jump to agents
     ✅ Comparison UI: Side-by-side for all 3 algorithms
     ✅ Leaderboard: Skip it
     ✅ Q-table slice: Fixed (theta vs theta_dot)
     ⚠️ Stochastic resets: Keep deterministic (consistent with lec09a)
     ⚠️ Epsilon decay: Use standard 0.995 decay

     Success Criteria

     1. ✅ All 3 algorithms (MC, SARSA, Q-learning) load and play simultaneously
     2. ✅ Checkpoint switching works smoothly (0, 2k, 10k, 50k steps)
     3. ✅ Q-table heatmaps show clear policy differences
     4. ✅ Learning curves demonstrate convergence patterns
     5. ✅ TD error display correctly shows algorithm-specific updates
     6. ✅ Teaching prompts guide users through key concepts
     7. ✅ Demo loads in <2 seconds on modern browsers
     8. ✅ Works on iPad (responsive layout, touch interactions)
     9. ✅ InfoTab content is pedagogically clear
     10. ✅ Code follows existing demo patterns (CartPole, CNN, Bandit)

     Critical Files to Modify/Create

     New files to create:
     1. demos/source/lec09b_Q-learning/content.html
     2. demos/source/lec09b_Q-learning/script.js
     3. demos/source/lec09b_Q-learning/style.css
     4. demos/source/lec09b_Q-learning/q-learning-engine.js
     5. demos/source/lec09b_Q-learning/snapshot-loader.js
     6. demos/source/lec09b_Q-learning/q-table-viz.js
     7. demos/source/lec09b_Q-learning/preview.svg
     8. demos/source/lec09b_Q-learning/support/train_agents.py

     Files to copy:
     1. demos/source/lec09a_cartpole-control/cartpole-engine.js → demos/source/lec09b_Q-learning/ (reuse directly via script tag)

     Files to reference:
     1. demos/source/phoebe-js/metriclabel.js
     2. demos/source/phoebe-js/infotab.js
     3. demos/source/phoebe-js/canvashelper.js
     4. demos/source/styles.css

     Files to update:
     1. demos/source/demos.json - Add lec09b entry

● Excellent! The plan is approved. Let me create a todo list and start implementation with Phase 1.

● Now let me start Phase 1 by creating the directory structure and copying the CartPole engine:

● Bash(mkdir -p demos/source/lec09b_Q-learning/data demos/source/lec09b_Q-learning/support)
  ⎿  (No content)

● Bash(cp demos/source/lec09a_cartpole-control/cartpole-engine.js demos/source/lec09b_Q-learning/)
  ⎿  (No content)

● Perfect! Now let me create the HTML shell with the side-by-side layout:

● Write(demos/source/lec09b_Q-learning/content.html)
  ⎿  Wrote 316 lines to demos/source/lec09b_Q-learning/content.html                                                   
     <!DOCTYPE html>
     <html lang="en">
     <head>
         <meta charset="UTF-8">
         <meta name="viewport" content="width=device-width, initial-scale=1.0">
         <title>Q-learning vs SARSA vs Monte Carlo</title>
         <script src="https://cdn.jsdelivr.net/npm/chart.js@4.4.0/dist/chart.umd.js"></script>
         <script src="https://polyfill.io/v3/polyfill.min.js?features=es6"></script>
         <script id="MathJax-script" async src="https://cdn.jsdelivr.net/npm/mathjax@3/es5/tex-mml-chtml.js"></script>
         <link rel="stylesheet" href="../styles.css">
     … +306 lines (ctrl+o to expand)

● Excellent! Now let me create the CSS styling for the side-by-side layout:

● Write(demos/source/lec09b_Q-learning/style.css)
  ⎿  Wrote 383 lines to demos/source/lec09b_Q-learning/style.css
     /* Q-learning Demo Specific Styles */
     .demo-wrapper {
         flex: 1;
         padding: 20px;
         overflow-y: auto;
     }
     /* Checkpoint Controls */
     .checkpoint-controls {
     … +373 lines (ctrl+o to expand)

● Perfect! Now let me implement the TabularAgent class:

● Write(demos/source/lec09b_Q-learning/q-learning-engine.js)
  ⎿  Wrote 228 lines to demos/source/lec09b_Q-learning/q-learning-engine.js    
     /**
      * TabularAgent - Q-learning agent with discretized state space
      * Reconstructs Q-table from checkpoint JSON and provides action selection
      */
     class TabularAgent {
         constructor(checkpoint, algorithm) {
             this.algorithm = algorithm || checkpoint.algorithm;
             this.checkpoint = checkpoint;
             // Reconstruct Q-table from flattened data
     … +218 lines (ctrl+o to expand)

● Excellent! Now let me implement the SnapshotLoader:

● Write(demos/source/lec09b_Q-learning/snapshot-loader.js)
  ⎿  Wrote 301 lines to demos/source/lec09b_Q-learning/snapshot-loader.js      
     /**
      * SnapshotLoader - Manages loading and retrieval of algorithm checkpoints
      */
     class SnapshotLoader {
         constructor() {
             this.checkpoints = {
                 mc: null,
                 sarsa: null,
                 qlearning: null
             };
     … +291 lines (ctrl+o to expand)
  ⎿  Limit reached · resets 4pm (Europe/London) · /upgrade to Max or turn on /extra-usage
     Opening your options…

  Todos
  ☒ Phase 1: Create directory structure and copy CartPole engine
  ☒ Phase 1: Create HTML shell with InfoTab structure
  ☒ Phase 1: Implement TabularAgent class (Q-table reconstruction + discretization)
  ☐ Phase 1: Implement SnapshotLoader with mock data
  ☐ Phase 1: Create basic render loop for CartPole canvas
  ☐ Phase 2: Write Python training script (train_agents.py)
  ☐ Phase 2: Train all 3 algorithms and generate checkpoint data
  ☐ Phase 3: Load real checkpoints and implement action selection
  ☐ Phase 4: Create 3-column side-by-side layout with AgentColumn class
  ☐ Phase 5: Implement Q-table heatmap visualizations
  ☐ Phase 6: Add Chart.js learning curves for all 3 algorithms
  ☐ Phase 7: Create TD error display panel with algorithm-specific formatting
  ☐ Phase 8: Implement teaching checkpoint system with prompts
  ☐ Phase 9: Write all InfoTab content with MathJax equations
  ☐ Phase 10: Polish, test, create preview.svg, and update demos.json