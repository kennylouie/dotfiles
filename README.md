# dotfiles
bash script to generate custom bashrc, vimrc, and tmux.conf scripts

![alt text](https://user-images.githubusercontent.com/29260348/26998182-92ca9b8c-4d35-11e7-8ca4-f7f8b529cc08.png)

## background

This repo has a single bash script that I have used over the years to help with automating and quickly setting up a new linux setup. This was most useful when working with server side machines, e.g. amazon aws ec2. Simply just scp the script over or git clone this repo and run.

## the scripts

The following bash script will generate a custom bashrc script (user made, will source into the original bashrc), .vimrc, and .tmux.conf. The custom configs within are my personal perferences for working serverside. You are free to edit to your liking, or simply use as-is and should run just fine.

## brief documentation

### tmux

I like using tmux as it allows my amazon aws servers to keep running while disconnected (just like screen). However, it is very customizable. I have already added many changes (adapated from all places on the interwebs) that make this a non-standard tmux config. Overall, the commands are to match vim commands.

#### 1. ctrl-b is the binding key

```
tnew hello
```
Creates a new tmux session.

```
tls
```
Lists all tmux sessions.

```
ta hello
```
Reattaches into the hello tmux session.
```
tkill hello
```
Terminates the hello tmux session.
```
tkillall
```
Terminates all tmux session. 

Once you are in a tmux session:
```
ctrl-b + c
```
Creates another emulated terminal shell.
```
ctrl-b + ctrl-h
```
Moves one terminal left.
```
ctrl-b + |
```
Creates a new terminal in a vertical split.
```
ctrl-b + d
```
Detaches from the current tmux session.


### vimrc

The vimrc generated from my script will have a customized netrw functionality similar to nerdtree. This was adapted from a blog post by George Orbo.

```
Leader + f
```
Opens the netrw tree.

```
tab
```
Tab is the escape key. To tab, simply use
```
Leader + tab
```
