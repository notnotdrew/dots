# Intuitive factoring for agents

- The useful cut is a name that states the idea, in a file whose other functions are not easy to choose instead. A split finer than the function barely changes the repair. Once the edit site is known, the rest of the file does not change the repair either.
- Tests do not grade the design. Agents follow a project instruction file over the code. A design constraint that is in neither mostly stays violated when the tests pass.

## Sources

### Review

[Assessing the Impact of Code Changes on the Fault Localizability of Large Language Models](https://arxiv.org/abs/2504.04372). After edits that keep behavior the same, models missed a bug they had already found in 78% of cases. Reordering functions in Java cut fault-localization accuracy by 83%. Ten models.

[How Does Naming Affect LLMs on Code Analysis Tasks?](https://arxiv.org/abs/2307.12488). Stripping function names hurt code search more than stripping variable names. A name swapped in from another function misled the model more than a random string. GraphCodeBERT.

[High Agreement, Shallow Reasoning](https://dl.acm.org/doi/10.1145/3803846.3807463). On extract-method and rename pairs, ChatGPT 5-mini preferred the refactor 91.8% of the time and LLaMA 4 Scout 82.9%. The study counts that as agreement because the human reviewers had marked the refactor better. The main miss is extract-method: the model judges the new method on its own and skips the coupling it added.

[Hierarchical Evaluation of Software Design Capabilities of Large Language Models of Code](https://arxiv.org/abs/2511.20933). In noisy, open-ended tasks, coupling F1 drops by more than half. Cohesion inside one unit holds up longer, until the prompt stops guiding the model. DeepSeek-R1, 14B to 70B.

### Agents editing the repo

[RepoNav](https://arxiv.org/abs/2609.08355). Right file, wrong function is 44–58% of function-level misses. Agents land on a nearby wrapper, handler, or entry method. LocBench, several model backbones.

[Fault localization granularity](https://arxiv.org/abs/2604.00167). With the correct location given, resolve rate was 45.6% at function level, 43.6% at line level, and 42.6% at file level. SWE-bench Mini, Qwen3-Coder in Agentless.

[Revisiting the Impact of Pursuing Modularity for Code Generation](https://arxiv.org/abs/2407.11406). A modularity score has a weak negative link with pass rate. One-shot examples on CodeContests.

[What Context Does a Coding Agent Actually Need to Act?](https://arxiv.org/abs/2607.09691). With the edit site given, UML skeletons of the rest of the file resolved no more issues than deleting that rest (p = 0.75, 70 multi-file instances). Oracle localization on SWE-bench Verified.

[Does Pass Rate Tell the Whole Story?](https://arxiv.org/abs/2604.05955). On SWE-Shield verified, pass rate was 70.25–75.95% and full design satisfaction was 32.64–42.80%. Across the benchmark, the two barely correlate (Cramér’s V ≤ 0.11). Putting the constraint in the prompt cut violations by up to 6.35 percentage points, and more than 30% stayed violated.

### Which pattern wins, and what sticks

[Stale Instruction Files Override the Code in Coding Agents](https://arxiv.org/abs/2610.30571). When an instruction file and the code disagreed, 90.1% of choices followed the file and 4.2% followed the code. Claude named the conflict in 79 of 80 runs and still followed the file. Codex rewrote the code to match the file in 20 of 80 runs, and the tests then failed in 17 of those. One sentence saying the code takes precedence moved code-following to 91.4%.

[SWE-bench Goes Live](https://arxiv.org/abs/2505.23419). A one-file patch under five lines resolves 48% of the time. The rate falls below 10% at three files or a hundred lines, and patches that touch seven or more files are never solved.

[What Makes Software Issue Resolution Tasks Difficult for Agents?](https://doi.org/10.4230/LIPIcs.ESEM.2026.3). Static features predict agent success (AUC 0.863). The drivers are how large and scattered the patch is, and how large the repo is.

[Theory of Code Space](https://arxiv.org/abs/2603.00601). Some models drop beliefs they already formed. Gemini 3 Flash reports only the files it just opened, and Gemini 2.5 Pro builds a map and then wipes it. Data-flow edges are the hard ones: Claude found none, and the best recall was 50%.

[Debt Behind the AI Boom](https://arxiv.org/abs/2603.28592). Across about 300k AI-authored commits, code smells were most of what static analysis found, and those commits fixed slightly more smells than they introduced. Correctness and security issues went the other way. 22.7% of tracked issues were still in the repo at HEAD.
