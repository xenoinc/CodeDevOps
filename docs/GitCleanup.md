# Git - Remove Dead Branches
Below lists several methods for removing branches which no longer exist on the remote repository.

These solutions were copied from [StackOverflow](https://stackoverflow.com/questions/7726949/remove-tracking-branches-no-longer-on-remote) by various authors.

## Safely Remove Local Branch with "[Gone]" Remotes
This approach is somewhat safer, because there is no risk of accidentally matching on part of the commit message.

```sh
git fetch -p && for branch in $(git for-each-ref --format '%(refname) %(upstream:track)' refs/heads | awk '$2 == "[gone]" {sub("refs/heads/", "", $1); print $1}'); do git branch -D $branch; done
```

## Remove local branch with ": gone" remotes
```sh
git fetch -p && for branch in $(git branch -vv | grep ': gone]' | awk '{print $1}'); do git branch -D $branch; done
```

## PowerShell

### Method A
```powershell
git config --global alias.branch-prune '!git fetch -p && for b in $(git for-each-ref --format=''%(if:equals=[gone])%(upstream:track)%(then)%(refname:short)%(end)'' refs/heads); do git branch -d $b; done'
```

### Method B (39 votes)
Uses pattern matching for ``[gone]`` and uses ``--format`` to pull each branch's [upstream tracking status](https://git-scm.com/docs/git-for-each-ref#Documentation/git-for-each-ref.txt-upstream).

1. First line lists local branches with the upstream ``gone``
2. Removes blank lines (_output for branches not gone_)
3. And finally, deletes the branch

```powershell
git branch --list --format "%(if:equals=[gone])%(upstream:track)%(then)%(refname:short)%(end)" |
    ? { $_ -ne "" } |
    % { git branch -D $_ }
```

Alternative long-hand format:
```powershell
git branch --list --format "%(if:equals=[gone])%(upstream:track)%(then)%(refname:short)%(end)" | where { $_ -ne "" } | foreach { git branch -d $_ }
```

### Method C (55 votes)
* ``git checkout develop`` - Switches to the ``develop`` branch
* ``git remote update origin --prune`` - Prunes remote branches
* ``git branch -vv`` - Gets a verbose output of all branches (git reference)
* ``Select-String -Pattern ": gone]"`` - Gets only the records where they have been removed from remote.
* ``% { $_.toString().Trim().Split(" ")[0]}`` - Get the branch name and remove leading spaces before parsing
* ``% {git branch -d $_}`` - Deletes the branch


```powershell
git checkout develop; git remote update origin --prune; git branch -vv | Select-String -Pattern ": gone]" | % { $_.toString().Trim().Split(" ")[0]} | % {git branch -d $_}
```

## Number1 Vote
* ``git remote prune origin`` - Prunes tracking branches not on the remote.
* ``git branch --merged`` - Lists branches that have been merged into the current branch.
* ``xargs git branch -d`` - Deletes branches listed on standard input.

Be careful deleting branches listed by ``git branch --merged``. The list could include master or other branches you'd prefer not to delete.

To give yourself the opportunity to edit the list before deleting branches, you could do the following in one line:

```sh
git branch --merged >/tmp/merged-branches && \
  vi /tmp/merged-branches && xargs git branch -d </tmp/merged-branches
```
