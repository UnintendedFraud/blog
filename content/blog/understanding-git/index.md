+++
title = "Understanding git better"
date = 2023-11-27

[taxonomies]
tags = ["bebe", "newekf"]
+++

I use `git` many times a day and yet I only have a blurry idea of what's going on. I can use them enough to work
without any problems but every now and then, I take on an old branch or I ended up in a weird state and I am ashamed
to report that I solve those by doing either:

<!-- more -->

- copying some commands that seems good from the internet (while not spending any time learning how and why it works)
- asking a colleague and do the above
- going through the commands I think I know in loop until I'm in a good state
- giving up and copying relevant files in a new branch, basically merging manually

An example I can give is the following (this is written from the point of view of not really understanding why):
At work more than once I ended up working on a pull request that ended up not being merged for a couple weeks, so could
not be merged before rebasing and fixing conflicts.

Before, I would not even rebase, I would merge master to branch, fix conflicts, push branch and merge the pull request.

In an attempt to do the right thing, recently I try rebasing and every time I would end up with all of the commits
between the creation of the PR and the current state of master inside the PR. To see the mess visually, here is how it
would look in the github UI:
[illustration]

## Step for messy branch

We have our PR and our branch. `main` has been updated since with 3 commits, creating conflicts. Added another commit
to the branch after, to re-create the exact scenario.

Starting the rebase (make sure your local main branch is up to date):
`git rebase main`

Conflits exist so the rebase stops:

```
Auto-merging README.md
CONFLICT (content): Merge conflict in README.md
error: could not apply feacd65... bad take on the oscar
hint: Resolve all conflicts manually, mark them as resolved with
hint: "git add/rm <conflicted_files>", then run "git rebase --continue".
hint: You can instead skip this commit: run "git rebase --skip".
hint: To abort and get back to the state before "git rebase", run "git rebase --abort".
Could not apply feacd65... bad take on the oscar
```

Fixing the conflict by keeping everything, then:

```
git add README.md
git rebase --continue
```

```
[detached HEAD 237c721] after rebasing, adding and continuing
 1 file changed, 2 insertions(+)
Successfully rebased and updated refs/heads/messy-branch.
```

After writing the commit message, a `git status` gives me the following state:

```
On branch messy-branch
Your branch and 'origin/messy-branch' have diverged,
and have 5 and 2 different commits each, respectively.
  (use "git pull" to merge the remote branch into yours)

nothing to commit, working tree clean
```

Here I'm happy with the state of the branch, so what I want to do is push and merge this back to `main`.
However `git push` is denied, the following message shows:

```
 ! [rejected]        messy-branch -> messy-branch (non-fast-forward)
error: failed to push some refs to 'github.com-unintendedfraud:UnintendedFraud/git-playground.git'
hint: Updates were rejected because the tip of your current branch is behind
hint: its remote counterpart. Integrate the remote changes (e.g.
hint: 'git pull ...') before pushing again.
hint: See the 'Note about fast-forwards' in 'git push --help' for details.
```

Like a good boy, I follow the instructions, I `git pull` before `git push` again.

Here two things can happen depending of how `pull` is configured in your git config, it will pull by doing either a
`merge` or a `rebase`.

- pull doing a `merge`
  We end up in a situation where we have to fix the same conflicts again, once fixed we commit and push. Done? Now we have
  duplicated all of the commits from `main` into `messy-branch`.
  [image messy-git history]
  Definitely not what we want.

- pull doing a `rebase`

## What should I have done?

First, after the rebase when `main` and `messy-branch` diverged, instead of typing commands I should have step back and
understand the state of the branch and commits.
