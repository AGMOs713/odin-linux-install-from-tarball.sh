### This is a helper script to install odin to the system given a tarball

- Odin releases can be found at https://github.com/odin-lang/Odin/releases

Just download the tarball for the release you want, then run:

```terminal
sudo ./odin-linux-install-from-tarball.sh <TARBALL>
```

- Note that it installs the required `base`, `core` and `vendor`
directories to `/usr/local/bin`, which is not exacly advised, but it's
also completely harmless. 

- The lincence is the Unlicense, with MIT-0 as fallback, as can be read
in the top of the script file.

When I wrote this, I was supposed to be programming at school if it
wasn't for a holiday. So I decided to write a little something for
myself, you know, for *the joy of programming*.
