# genpass
128-bit secure password generators for Z shell. Initially written for Oh My Zsh!, but I got tired of
extending them in my own `~/.zshrc`, so I figured I would put them here

There are seven password generators with different goals:

- `genpass-apple`: Part of the initial Oh My Zsh! commit. Generates an [iOS-like
  password](https://rmondello.com/2024/10/07/apple-passwords-generated-strong-password-format/) that
  is pronounceable using CVCVC. 
- `genpass-csv`: [A silly
  meme](https://www.reddit.com/r/ProgrammerHumor/comments/r3cc80/saw_this_had_to_share_here/) where
  adding a comma to your password will mess up the CSV file a password database breach gets dumped
  to.
- `genpass-graph`: Just a run-of-the-mill random ASCII password using all 94 graphical ASCII
  characters.
- `genpass-key`: Inspired by the [NSA Password
  Generator](https://github.com/nsacyber/RandPassGenerator/) (do you trust it?), this generates
  hexadecimal keys for cryptographic primitives.
- `genpass-monkey`: Part of the initial Oh My Zsh! commit. This idea comes from the [infinite monkey
  theorem](https://en.wikipedia.org/wiki/Infinite_monkey_theorem) stating that a monkey hitting keys
  independently at random on a typewriter keyboard for an infinite amount of time will almost
  surely type any given text. Uses [Crockford's base-32
  alphabet](https://www.crockford.com/base32.html).
- `genpass-whitespace`: Another silly generator using strictly white space only. If you are using a
  password manager, not only will you not know the password, you won't be able to read it either!
- `genpass-xkcd`: Part of the initial Oh My Zsh! commit. Inspired by [XKCD "Correct Horse Battery
  Staple"](https://xkcd.com/936/), but getting the entropy correct while using your locally
  installed `/usr/share/dict/words` file. Prepends the number of words to comply with some password
  requirements.

Each function accepts a numerical argument for generating that many passwords. Otherwise, just
generates one password:

```
% genpass-graph
H(EzZrof&Oed=rb94@L:

% genpass-graph 5
Y(\,yJm)aS2n{s/Z#a$W
w%TC`"DX#V`RjYhe5sD&
UG#hu[tXqDP*[&`-xd:,
fmRFIT@<Ft,6-IoCh\xh
a,y-zYHpC;%T.L$l2q[3
```

Assumes that your Z shell is compiled with 64-bit integer support. No 3rd-party external
requirements needed as everything uses Z shell built-ins.
