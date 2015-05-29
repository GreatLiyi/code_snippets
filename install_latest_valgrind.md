## install valgrind(works on Mac 10.10 Yosemite)
``` bash
svn co svn://svn.valgrind.org/valgrind
cd valgrind
./autogen.sh
./configure
make
make install

#or use brew
brew install --HEAD valgrind
#brew doctor
#brew prune
```
