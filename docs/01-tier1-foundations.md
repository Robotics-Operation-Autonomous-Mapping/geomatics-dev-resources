# Tier 1 — Foundations

Short reading list + exercises. Official docs win over tutorials when they disagree.

**Pass this tier via [Checkpoint 1](../checkpoints/cp1_imu_attitude/).**

## Linux

### Read

- Filesystem layout & permissions: `man hier`, `man chmod`, `man chown`
- Processes: `man ps`, `man top` (or `htop` if installed)
- Text tools: [GNU grep](https://www.gnu.org/software/grep/manual/), `man find`, `man sed`
- Bash: [Bash Guide for Beginners](https://tldp.org/LDP/Bash-Beginners-Guide/html/) (skim chapters on scripts, variables, loops)
- SSH: `man ssh`, `man ssh-keygen`
- Packages: `man apt`
- Environment: `man environ`, understand `PATH`, `source`, and ROS `setup.bash`
- Multiplexer: [tmux Getting Started](https://github.com/tmux/tmux/wiki/Getting-Started)

### Exercises

1. Write a bash script that finds all `*.yaml` under a directory and prints paths containing `imu`.
2. Create a non-root user-owned workspace dir, set permissions so only you can write it, and explain `umask`.
3. In `tmux`, split a pane; run `htop` (or `top`) in one and a long `sleep` in the other; detach/reattach.
4. Export a custom env var in `~/.bashrc`, open a new shell, and print it.

## Git

### Read

- [Pro Git — Git Basics](https://git-scm.com/book/en/v2/Getting-Started-Git-Basics) and [Branching](https://git-scm.com/book/en/v2/Git-Branching-Branches-in-a-Nutshell)
- [GitHub flow](https://docs.github.com/en/get-started/using-github/github-flow)
- Merge conflicts: [GitHub docs — Resolving a merge conflict](https://docs.github.com/en/pull-requests/collaborating-with-pull-requests/addressing-merge-conflicts/about-merge-conflicts)
- [gitignore](https://git-scm.com/docs/gitignore)
- Submodules (skim): [git-scm submodules](https://git-scm.com/book/en/v2/Git-Tools-Submodules)

### Team rule

**No direct pushes to `main`.** See [rules.md](rules.md).

### Exercises

1. Clone this private org repo (you need org access), create `cp1/<you>-practice`, commit a trivial doc typo fix on a branch, open a PR (draft OK).
2. Intentionally create a merge conflict with a teammate on a scratch branch; resolve and rebase onto `main`.
3. Add a `.gitignore` entry for `data/` and confirm `git status` ignores a dummy bag folder.

## ROS 2

### Read

Official Humble or Jazzy tutorials (pick your distro):

- [Nodes](https://docs.ros.org/en/humble/Tutorials/Beginner-CLI-Tools/Understanding-ROS2-Nodes/Understanding-ROS2-Nodes.html) (swap `humble`→`jazzy` in the URL if needed)
- [Topics](https://docs.ros.org/en/humble/Tutorials/Beginner-CLI-Tools/Understanding-ROS2-Topics/Understanding-ROS2-Topics.html)
- [Services](https://docs.ros.org/en/humble/Tutorials/Beginner-CLI-Tools/Understanding-ROS2-Services/Understanding-ROS2-Services.html)
- [Actions](https://docs.ros.org/en/humble/Tutorials/Beginner-CLI-Tools/Understanding-ROS2-Actions/Understanding-ROS2-Actions.html)
- [Parameters](https://docs.ros.org/en/humble/Tutorials/Beginner-CLI-Tools/Understanding-ROS2-Parameters/Understanding-ROS2-Parameters.html)
- [Launch](https://docs.ros.org/en/humble/Tutorials/Intermediate/Launch/Launch-Main.html)
- [colcon](https://docs.ros.org/en/humble/Tutorials/Beginner-Client-Libraries/Colcon-Tutorial.html)
- [tf2](https://docs.ros.org/en/humble/Tutorials/Intermediate/Tf2/Tf2-Main.html)
- [rosbag2](https://docs.ros.org/en/humble/Tutorials/Beginner-CLI-Tools/Recording-And-Playing-Back-Data/Recording-And-Playing-Back-Data.html)
- [RViz2](https://docs.ros.org/en/humble/Tutorials/Intermediate/RViz/RViz-Main.html) (and the RViz user guide linked from ROS docs)

### Exercises

1. `ros2 topic list/echo/hz` on the CP1 sample bag while playing it.
2. Write a minimal Python publisher/subscriber pair in a throwaway package; `colcon build` and `source install/setup.bash`.
3. Publish a static `tf2` transform with `static_transform_publisher`; view frames in RViz2.
4. Author a launch file that starts your node with a remapped topic and a parameter.

## Coding

### Read

- Python: enough to write nodes — [Python tutorial](https://docs.python.org/3/tutorial/) (data structures, modules)
- C++ for later performance nodes: [CMake tutorial](https://cmake.org/cmake/help/latest/guide/tutorial/index.html) (steps 1–3)
- Eigen quick start: [Eigen Getting Started](https://eigen.tuxfamily.org/dox/GettingStarted.html)

### Exercises

1. In Python, convert accelerometer \(a_x, a_y, a_z\) to roll/pitch (stationary assumption). Unit-test with known vectors.
2. Optional C++: same math with Eigen; build with a tiny `CMakeLists.txt`.

## Checkpoint 1

Implement the package under [`checkpoints/cp1_imu_attitude/`](../checkpoints/cp1_imu_attitude/). Read that README for pass criteria.

When ready for oral review, use [reviewer-rubric.md](reviewer-rubric.md).
