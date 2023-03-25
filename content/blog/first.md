+++
title = "Understanding git better"
date = 2019-11-27
+++

I use `git` many times a day and yet I only have a blurry idea of what's going on. I can use them enough to work 
without any problems but every now and then, I take on an old branch or I ended up in a weird state and I am ashamed
to report that I solve those by doing either:
* copying some commands that seems good from the internet (while not spending any time learning how and why it works)
* asking a colleague and do the above
* going through the commands I think I know in loop until I'm in a good state
* giving up and copying relevant files in a new branch, basically merging manually

An example I can give is the following (this is written from the point of view of not really understanding why):
At work more than once I ended up working on a pull request that ended up not being merged for a couple weeks, so could
not be merged before rebasing and fixing conflicts.

Before, I would not even rebase, I would merge master to branch, fix conflicts, push branch and merge the pull request.

In an attempt to do the right thing, recently I try rebasing and every time I would end up with all of the commits
between the creation of the PR and the current state of master inside the PR. To see the mess visually, here is how it
would look in the github UI:
[illustration]
