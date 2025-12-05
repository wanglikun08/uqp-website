# Model Free Methods and Deep Reinforcement Learning

**Dr. Leandro Parada**

transport-systems.imperial.ac.uk

# Today's Session

1. Exploration vs. Exploitation
2. Model-free Prediction
3. Model-free Control
4. Deep Reinforcement Learning
5. Challenges of DRL

# Module Structure

A guided journey on the world of machine learning

**Reward sequence notation:**

The rewards received at different time steps are denoted as: $$R_{t}, R_{t+1}, R_{t+2}, R_{t+3}, R_{t+4}, R_{t+5}$$

Topics covered:
- Linear Regression
- Logistic Regression
- Unsupervised Learning (Week 8)
- Reinforcement Learning (Weeks 9-10)
- LSTM & Transformers

# Recap from Lecture 8

**Key notation:**

We use $R_{t}$ for rewards at time $t$ and $G_{t}$ for the return (cumulative reward) starting from time $t$. The return is calculated as:

$$G_t = R_{t+1} + R_{t+2} + R_{t+3} + ...$$

Reinforcement Learning differs from Supervised and Unsupervised Learning in its approach to learning through interaction with an environment.

# Recall: Reinforcement Learning in Practice

**Key concepts:**

The value function $v(s)$ represents the expected return from state $s$:

$$v(s) = \mathbb{E}[G_{t} | S_{t} = s] = \mathbb{E}[R_{t+1} + R_{t+2} + R_{t+3} + ... | S_{t} = s]$$

Using the recursive relationship $G_t = R_{t+1} + G_{t+1}$, we can write the Bellman equation:

$$v(s) = \mathbb{E}[R_{t+1} + v(S_{t+1}) | S_{t} = s]$$

# Example: The Cart-Pole Problem

**Policy notation:**

A policy $\pi$ maps states $s$ to actions $a$. We can represent this as $\pi(s) = a$ for deterministic policies or $\pi(a | s)$ for stochastic policies (probability of action $a$ given state $s$). The goal is to find the optimal policy $\pi^{*}$ that maximizes the return $G_t = R_{t+1} + R_{t+2} + R_{t+3} + ...$.

Keep the balance of a pole on top of a moving cart.

Reward value of 1 for each time step if the pole remains upright, 0 otherwise.

**Key Components:**

- **Agent**: An agent or set of agents whose behaviour we wish to train
- **Environment**: The "world" that the agent lives in and interacts with
- **Initial State**: The initial state of an agent, before an interaction with the world takes place
- **Action**: An action that the agent takes, based on its current state and its "world experience"
- **Reward**: A reward that is provided to the agent by the "world" for its actions
- **Resulting State**: The resulting state of the agent once the reward has been received

# States and Actions

**Bellman equation for policy evaluation:**

The value function under policy $\pi$ satisfies:

$$v_{\pi}(s) = \mathbb{E}_{\pi}[R_{t+1} + \gamma v(S_{t+1}) | S_{t} = s]$$

where $\gamma$ is the discount factor that weights immediate versus future rewards.

**State:**
- Represents the agent's current situation or position in the environment
- It includes all relevant information needed for the agent to make a decision
- Example: (x, y) coordinates, throttle, steering angle

**Purpose of State in Decision-Making:**
- The state defines what the agent "knows" at a given time
- Guides the agent's choice of actions based on the current situation

**Action:**
- An action is a choice made by the agent to interact with the environment
- Actions transition the environment from one state to another
- Example: Throttle, steering angle

**Role of Actions:**
- Determine how agents navigate toward goal
- Affect impact rewards and subsequent state

**Types of Actions:**
- **Discrete Actions**: Finite set of choices (e.g., move North, South, East, West in a grid world)
- **Continuous Actions**: Infinite range of values (e.g., steering angle or throttle in autonomous driving)

"Any goal can be formalised as the outcome of maximising a cumulative reward." - Richard S. Sutton

# Recall: Value Function and Policy

**Policy iteration framework:**

Policy iteration alternates between two steps: evaluating the value function $v_{\pi}(s)$ for the current policy $\pi$, then improving the policy by making it greedy with respect to the value function: $\pi \to \text{greedy}(v)$. This process continues until convergence to the optimal policy $\pi^{*}$ and optimal value function $v^{*}(s)$.

Policy iteration involves two steps:

1. **Evaluation**: Compute $v(s)$ given $\pi$
2. **Improvement**: Update $\pi$ to be greedy with respect to $v$

This process continues until convergence to $\pi^{*}$ and $v^{*}$.

# Recall: Bellman Expectation Equation

**Model-based components:**

The Bellman equation uses the transition probability $P(s' | s, a)$ (probability of reaching state $s'$ from state $s$ taking action $a$) and the reward function $R(s, a)$ (expected reward for taking action $a$ in state $s$).

We can evaluate the value of each state for a particular policy:

- **Immediate reward**: The reward received for taking an action
- **Value of the next state**: The expected future value
- **Expectation**: Averages over all possible outcomes of the next state

# Recall: Policy Iteration

Two-step iterative process for finding optimal policies.

# Components of an RL Problem

**Core components:**

In model-based RL, we need to know the transition dynamics $P(s' | s, a)$ and reward function $R(s, a)$ to solve the problem.

**Policy**: Defines the agent's behavior - how it selects actions in different states

# Real-World Complexity: Autonomous Driving

Why is the environment of an Autonomous Vehicle so complex?

- **Complex Interactions**: Predicting how the environment changes (e.g., how other cars, pedestrians, or cyclists react to the vehicle's actions) is highly non-trivial
- **External Factors**: Weather (e.g., rain altering road friction). Traffic flow changes dynamically and is influenced by countless variables
- **Reward Function is Ambiguous**: What's the "best" action - faster travel vs ensuring safety vs minimising energy consumption?

# Environment as a Black Box

**Real-World Environments are Often Black Boxes**

The agent can interact with the environment but doesn't have access to the underlying model (transition and reward functions). It can only observe the state, take actions, and receive rewards.

**What if we could learn optimal behaviour just by interacting with the environment?**

This is where model-free methods come in. They focus on using experiences (trajectories of states, actions, and rewards) to improve the policy.

# Exploration vs. Exploitation

# How Do Agents Learn the Best Actions?

Imagine you're in a new city, trying to find a restaurant.

You can try a random restaurant, or go back to the restaurant you already know is great.

- **If you explore**: You might discover an amazing new spot, but you risk ending up at a terrible one
- **If you exploit**: You know you'll have a good meal, but you might miss a hidden gem

# Exploration vs. Exploitation

In model-free methods, the agent doesn't know the environment - it can't plan ahead with a model.

Thus, agents face this same decision when learning:

- **Explore**: Take unknown actions to gather information
- **Exploit**: Use the best-known action to maximise immediate rewards

This is the essence of the Exploration vs. Exploitation Dilemma.

**Actions:**
- Select Best Known Action (Exploit)
- Select Random Action (Explore)

# Model-Free Methods

**Epsilon-greedy policy:**

In model-free methods, we balance exploration and exploitation using an epsilon-greedy policy: with probability $\epsilon$ we explore (random action), and with probability $1 - \epsilon$ we exploit by choosing the greedy action $\pi(s) = \arg\max_a q_{\pi}(s, a)$.

Can we find the optimal policy without having a model of the environment?

First, we need to estimate the Value Function.

# Model-Free Prediction

Remember, in prediction, our goal is to model the value function (expected value of the return):

| Row | Col 1 | Col 2 | Col 3 | Col 4 | Col 5 | Col 6 | Col 7 | Col 8 |
| --- | ----- | ----- | ----- | ----- | ----- | ----- | ----- | ----- |
| 1   |       |       | -3.0  | -2.2  | -1.4  | -0.4  |       |       |
| 2   |       |       | -3.7  |       | -0.4  | 0.6   | 1.8   |       |
| 3   | -5.4  | -4.9  | -4.3  |       |       | 1.8   | 3.1   |       |
| 4   |       |       | -4.9  |       |       | 3.1   | 4.6   |       |
| 5   |       |       | -5.4  |       |       | 4.6   | 5.8   | 6.2   |
| 6   |       |       | -5.9  | -6.2  |       |       |       | 8.0   |
| 7   |       |       | -6.2  | -6.6  | -6.9  | -7.3  |       |       |
| 8   |       |       | -6.6  |       |       |       |       |       |

**How can we estimate the value function of a given policy without the explicit model?**

A simple approach: we can sample trajectories by interacting with the environment. We can then use these samples to estimate the expected return.

# Monte Carlo Methods

Monte Carlo methods learn from complete episodes, updating value estimates only after the episode ends.

# Temporal Difference (TD)

**Temporal Difference Learning:**

Current value of the state + Learning rate * (Immediate Reward + Estimate of the value of the next state - Current value of the state)

**This is called the TD Error**

"If one had to identify one idea as central and novel to reinforcement learning, it would undoubtedly be temporal-difference (TD) learning."

Sutton & Barto (2018)

# Example: Driving Home

**Imagine This Scenario:**

You leave the office and want to predict how long it will take to get home.

Along the way, you encounter different states. At each state, you estimate:
- How much time is left to reach home (Predicted Time to Go)
- Total time to get home (Predicted Total Time)

Can you refine predictions during the drive? Must you finish the trip to update them?

| State               | Elapsed Time (minutes) | Predicted Time to Go (minutes) | Predicted Total Time (minutes) |
| ------------------- | ---------------------- | ------------------------------ | ------------------------------ |
| Leaving office      | 0                      | 30                             | 30                             |
| Reach car, raining  | 5                      | 35                             | 40                             |
| Exit highway        | 20                     | 15                             | 35                             |
| Behind truck        | 30                     | 10                             | 40                             |
| Home street         | 40                     | 3                              | 43                             |
| Arrive home         | 43                     | 0                              | 43                             |

**Explanation:**

- **Leaving Office**: You just started, so the elapsed time is 0 minutes. You estimate the journey will take 30 minutes to complete
- **Reach Car, Raining**: After 5 minutes, you've reached your car, but now it's raining. The rain makes you think the journey will now take 35 more minutes. Total predicted time becomes 40 minutes
- **Exit Highway**: After 20 minutes, you've exited the highway. You now estimate it will take 15 more minutes to get home. Total predicted time adjusts to 35 minutes
- **Behind Truck**: At the 30-minute mark, you're stuck behind a slow truck. You predict it will take 10 more minutes to reach home. Total predicted time is 40 minutes
- **Home Street**: You're on your home street after 40 minutes. Only 3 minutes remain to get home. Total predicted time is 43 minutes
- **Arrive Home**: After 43 minutes, you finally arrive home. Remaining time is 0 minutes. Total predicted time confirms it took 43 minutes

# Changes Recommended by Monte Carlo Methods

**Equations:**

$$v_{\pi}(s) = \mathbb{E}[G_{t} | S_{t} = s]$$

**Updates after the episode ends**: Predictions for each state are updated only after completing the entire trip. For example, "leaving office" gets updated only after you arrive home.

Uses the actual total outcome (final total travel time) to adjust predictions. However, this approach delays updates and requires the full episode.

# Changes Recommended by TD Methods

**Temporal Difference updates:**

TD methods update the value function $v_{\pi}(s)$ incrementally at each state $s$ during the episode, without waiting for the final outcome.

Predictions are updated step-by-step as the trip progresses. For example, "leaving office" gets updated as soon as you move to the next state ("reach car").

TD uses the current prediction of the next state (e.g., the predicted time from "reach car") instead of waiting for the actual outcome.

Now, we need to find a method to improve the policy.

# Model-Free Control

# Model-Based vs. Model-Free Control

**Value functions:**

In model-based control, we estimate the state value function $v_{\pi}(s)$. In model-free control, we estimate the state-action value function (Q-function) $Q_{\pi}(s, a)$ directly from experience.

The state value function can be estimated by averaging returns:

$$v_{\pi}(s) = \mathbb{E}[G_{t} | S_{t} = s] = \frac{1}{N}\sum_{i=1}^{N} G_{t}^{(i)}$$

where $G_{t}^{(i)}$ is the return from episode $(i)$ starting from state $s$ following policy $\pi$.

**Model-based Control (Policy Iteration)**: Requires knowledge of the environment model

**Model-free Control**: Learns directly from experience without a model

# The Q-table

**Q-function definition and update rule:**

The Q-function represents the expected return from taking action $a$ in state $s$:

$$Q_{\pi}(s, a) = \mathbb{E}[G_{t} | S_{t} = s, A_{t} = a]$$

The Q-table is updated using the TD learning rule with learning rate $\alpha$ and discount factor $\gamma$:

$$Q_{\pi}(s_{t}, a_{t}) = Q_{\pi}(s_{t}, a_{t}) + \alpha(R_{t+1} + \gamma Q_{\pi}(s_{t+1}, a_{t+1}) - Q_{\pi}(s_{t}, a_{t}))$$

**Where Can a Q-Table Be Applied?**

Q-tables work well in small, discrete environments. What do you think happens to the Q-table in larger environments?

# Q-table Example

**Q-learning update rule:**

The Q-table is updated at each step using:

$$Q_{\pi}(s_{t}, a_{t}) = Q_{\pi}(s_{t}, a_{t}) + \alpha(R_{t+1} + \gamma Q_{\pi}(s_{t+1}, a_{t+1}) - Q_{\pi}(s_{t}, a_{t}))$$

where $\alpha$ is the learning rate, $R_{t+1}$ is the immediate reward, and $\gamma$ is the discount factor.

Imagine the following GridWorld:

**Rewards:**
- +0: Going to a state with no cheese in it
- +1: Going to a state with a small cheese in it
- +10: Going to the state with the big pile of cheese, game ends
- -10: Going to the state with the poison and thus dying

Source: Hugging Face DRL course

The Q-table for this example looks like this:

| State/Action | Up   | Down | Left | Right |
| ------------ | ---- | ---- | ---- | ----- |
| State 1      | 6.14 | 7.76 | 6.58 | 4.32  |
| State 2      | 6.4  | 9    | 8.5  | -10   |
| State 3      | 4.94 | 6.14 | 3.1  | 10    |
| State 4      | 6.0  | -10  | 8.82 | 0.22  |
| State 5      | 0    | 0    | 0    | 0     |
| State 6      | 0    | 0    | 0    | 0     |

**All possible states** (rows) and **All possible actions** (columns)

**Value of taking each action in a particular state**

- Taking these actions leads directly to the Poison (negative values)
- Taking this action leads to the big cheese (value 10)
- These are terminal states (can't take actions here)

# Monte-Carlo Control

Monte Carlo control methods learn Q-values from complete episodes and improve the policy iteratively.

# Model-Free Control in Action

Let's play CliffWalking!

**Termination**: When the agent reaches the cookie

**Rewards**: -1 each timestep, -100 cliff

Learning with Monte Carlo on CliffWalking demonstrates how the agent learns to avoid the cliff while reaching the goal.

# Temporal Difference Control (SARSA)

**TD Error for state-action values:**

SARSA (State-Action-Reward-State-Action) updates Q-values using the action actually taken in the next state.

# Model-Free Control in Action

Learning with SARSA on CliffWalking:

Is this the optimal policy?

# The Problem with SARSA

Imagine you're controlling a character in a tricky level. You're learning the best strategy while occasionally exploring dangerous paths to see if they offer shortcuts.

**How SARSA Learns:**

If you explore a dangerous path and it ends badly, SARSA updates the strategy to reflect that specific action (even though it might just be bad luck). It learns based on what you actually do, including your mistakes or exploratory detours. This may lead to conservative policies.

SARSA aligns with what you are doing (your cautious, exploration-driven behaviour), rather than what you should do (the best or optimal policy).

**What if we could:**
1. Explore using one policy (exploration policy: epsilon-greedy)
2. Learn using another policy (target policy: always greedy)

This is the essence of the Q-Learning algorithm.

- **SARSA**: Learns from what you're doing now (on-policy)
- **Q-Learning**: Uses two policies:
  - Behavioural policy: For exploration (e.g., epsilon-greedy)
  - Target policy: For learning (always greedy)

# Q-Learning

**Q-Learning update rule (off-policy):**

Q-Learning uses the maximum Q-value for the next state, regardless of which action is actually taken:

$$Q(s_{t}, a_{t}) = Q(s_{t}, a_{t}) + \alpha(R_{t+1} + \gamma \max_{a} Q(s_{t+1}, a) - Q(s_{t}, a_{t}))$$

This makes Q-Learning off-policy: we assume the greedy action is always taken in the next step (for learning), even if we explore differently (for behavior).

# Model-Free Control in Action

**Bellman equation components:**

Recall that the value function can be decomposed into immediate reward $R_{t+1}$ and discounted future value $\gamma v_{\pi}(s_{t+1})$, which together determine $v_{\pi}(s_{t})$.

Learning with Q-learning on CliffWalking demonstrates the difference between on-policy and off-policy learning.

# Summary: Model-Free Control

Different model-free control methods have different trade-offs between exploration, exploitation, and optimality.

# The Game of Go: Why Q-Tables Fall Short

The game of Go has approximately $2.08 \times 10^{170}$ possible board positions. A Q-table would need to store values for each state-action pair, making it computationally infeasible.

# Deep Reinforcement Learning

Deep Reinforcement Learning combines neural networks with reinforcement learning to handle high-dimensional state spaces.

# How AlphaGo Mastered the Game of Go

AlphaGo used a combination of deep neural networks and tree search to master the game of Go, defeating world champion Lee Sedol.

# Taxonomy of DRL Methods

Deep Reinforcement Learning can be categorized into:
- **Value-based methods**: Learn value functions
- **Policy-based methods**: Learn policies directly
- **Actor-critic methods**: Combine both approaches

# Value-based Deep Reinforcement Learning

Value-based methods learn to estimate the value of states or state-action pairs.

# Deep Q-Learning

**Tabular Q-Learning:**

Uses a table to store Q-values for each state-action pair.

| State-Action Pair | Q-Value |
| ----------------- | ------- |
| (s1, a1)          | q1      |
| (s1, a2)          | q2      |
| (s2, a1)          | q3      |

**Deep Q-Learning:**

Instead of a table, use a neural network to approximate Q-values:
- Input: State
- Output: Q-value for each possible action

# Deep Q-Networks

**In practice, the Deep Q-Learning Algorithm is not effective to train Neural Networks:**

- **Correlated Data**: Consecutive state transitions are highly correlated, making training unstable
- **Feedback Loop**: The target Q-value depends on the same network being updated, causing errors to compound
- **Inefficient Learning**: Each experience is used only once, leading to slow convergence

Researchers at Google DeepMind proposed enhancements techniques that made learning effective (2015). This method received the name Deep Q-Networks (DQN).

It is the most widely adopted Deep Reinforcement Learning method to date.

**Result**: Human-level or above human-level performance on most Atari games

# Policy Gradient Methods

**Components:**
- **Gradient of the policy**: Direction to improve the policy
- **Advantage function**: How much better an action 'a' is compared to the average
- **The log is introduced to simplify differentiation**
- **Expectation over multiple rollouts**

# Actor-Critic Methods: Best of Both Worlds

**Combining value and policy learning:**

Actor-Critic methods aim to find the optimal policy $\pi^{*}$ by learning both the policy and the Q-function $q(s, a) = \mathbb{E}[G_{t} | S_{t} = s, A_{t} = a]$ simultaneously.

Actor-Critic methods combine:
- **Actor**: Policy network that selects actions
- **Critic**: Value network that evaluates actions

**Gradient of the actor** uses feedback from the critic to improve the policy.

# Challenges of Deep Reinforcement Learning

**Learning the policy and value function:**

Deep RL methods learn a policy $\pi$ and/or value function $q_{\pi}(s, a)$ using neural networks, which introduces unique challenges.

Deep Reinforcement Learning faces several challenges:
1. Sample Efficiency
2. Simulation to Reality Gap
3. Exploration vs Exploitation
4. Stability in Training

# DRL Success Stories vs Reality

**Breakthroughs**: Mastered Atari games, defeated champions in Go (AlphaGo), and trained robots for tasks like walking.

**The Reality of DRL**: Despite these successes, DRL has major limitations when applied to real-world problems.

# Sample Efficiency

**Q-function estimation challenge:**

The agent must learn Q-values $q_{\pi}(s, a)$ for all state-action pairs. For example, in a small environment with 4 states $(s_{0}, s_{1}, s_{2}, s_{3})$ and 4 actions $(a_{0}, a_{1}, a_{2}, a_{3})$, we need to estimate 16 Q-values: $q(s_{0}, a_{0}), q(s_{0}, a_{1}), q(s_{0}, a_{2}), q(s_{0}, a_{3}), q(s_{1}, a_{0}), ..., q(s_{3}, a_{3})$. This quickly becomes intractable as the state and action spaces grow.

**The Challenge:**

DRL often requires millions of interactions with the environment to learn effectively. In many real-world scenarios, interactions are expensive or impractical, such as healthcare applications where every decision impacts patient safety.

**Why It Happens:**
- **Trial-and-Error Learning**: Agents explore many possible actions to find optimal behaviour
- **Sparse Rewards**: Agents spend a lot of time in uninformative states without meaningful feedback

# Simulation to Reality Gap

**The Challenge:**

Agents trained in simulations often fail in the real world because simulations:
- Simplify environmental dynamics
- Lack real-world noise (e.g., sensor errors, physical unpredictability)

**Why It Happens:**
- **Overfitting to Simulation**: Agents learn policies that exploit quirks of the simulation
- **Reality Gap**: Simulations cannot perfectly capture real-world complexity

# Exploration vs Exploitation

**The Challenge:**

Agents must explore to discover better actions while exploiting known good strategies.

- Too much exploration: Wastes time on unproductive actions
- Too much exploitation: Misses opportunities to improve

**Why It Happens:**
- Sparse or delayed rewards make exploration harder
- Early mistakes can discourage trying new actions
- Promising states/actions may never be discovered

# Stability in Training

**The Challenge:**

DRL training is notoriously unstable, leading to:
- Oscillations in performance
- Divergence of Q-values or policies

**Why It Happens:**
- **Non-Stationarity**: The policy keeps changing during training, making the environment unpredictable
- **Bootstrapping**: Value-based methods use estimates of future rewards, which amplify small errors
- **Exploding/Vanishing Gradients**: Neural networks sometimes struggle with large or unstable updates

# Thank you
