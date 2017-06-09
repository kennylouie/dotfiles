# shell-setup
editable bash script to setup custom bashrc, zshrc, vimrc, and tmux.config scripts

## background

This repo has a single bash script that I have used over the years to help with automating and quickly setupping up a new linux setup. This was most useful when working with server side machines, e.g. amazon aws ec2. Simply just p/scp the script over and run.

## the scripts

The following bash script will generate a custom bashrc script (user made, will source into the original bashrc), a .zshrc, a .vimrc, and .tmux.config. The custom configs within are my personal perferences for working serverside. You are free to edit to your liking, or simply use as-is and should run just fine.

### notes

#### tmux

I like using tmux as it allows my amazon aws servers to keep running while disconnected (just like screen). However, it is very customizable. I have already added many changes (adapated from all places on the interwebs) that make this a non-standard tmux config. Overall, the commands are to match vim commands.

##### 1. ctrl-b is the binding key

#### vimrc

##### 1. Tab is esc. Tabbing is achieved by first pressing the leader key (\)

## discussion

The script is customizable and allows for easy server setup (in my case) when working with cloud servers, e.g. ec2. The script works best on a new system install.
