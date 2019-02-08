# emacs on macosx

* emacs that ships with Xcode is really old
* head to gnu.org
- https://www.gnu.org/software/emacs/download.html

### configure for mac finder
```
./configure --with-ns
make install
```

### open application
```
open nextstep/Emacs.app
open -R nextstep/Emacs.app
```

### add adobe SourceCodePro fonts
```
/User/loki/Library/Fonts
SourceCodePro-Black.otf		SourceCodePro-Medium.otf
SourceCodePro-Bold.otf		SourceCodePro-Regular.otf
SourceCodePro-ExtraLight.otf	SourceCodePro-Semibold.otf
SourceCodePro-Light.otf
```

### add stack

* add stack to the .local/bin
https://www.stackage.org/stack/osx-x86_64

```
tar zxvf stack.tar.gz
cp stack $HOME/.local/bin
```


