# purescript-ui

This library is an experiment in using final interpreters to describe UI's.

See the example directory of some usages.

**Table of Contents**

* [Installation](#installation)
* [Motivation](#motivation)
* [Usage](#usage)

## Installation

You can install it from bower with

```
bower install -S purescript-ui
```

## Motivation

All good libraries deserve some motivation.

Creating UI's is hard.
Creating good UI's is even harder.

Creating UI's shouldn't be hard.
This library aims to make creating of a UI simple.

The goal is to use a simple DSL (Domain specific language) for describing UI's
and allow different interpretations of the DSL for differing situations.
What does that mean?
It means you should be able to describe your UI in one language,
and let the computer generate the proper files for wherever you want to use the UI.
If you had some killer web app, say, 
you shouldn't have to go through the code line by line to make sure it works on ie9+ or is ES3 compliant, or whatever.
You should be able to just generate the valid code from some description.

But, there are plenty of other ways to interpret a UI.
You can interpret it as a string.
You can interpret it as a curses program.
You can interpret it as a GTK program.
Given the correct interpreter you could even interpret it as an Android or iOS app.
You're only limited by what operations you can implement in the interpreter.

By limited it means that a string has no concept of a border, 
so you obviously can't interpret a UI that uses a border.
Whereas GTK can make borders around things,
so it should be able to interpret a UI that uses a border.

However, rather than finding out sometime after you've shipped your software
you can't actually interpret parts of it,
These checks are done up front (assuming you pre-compile everything.)

## Usage

TODO
