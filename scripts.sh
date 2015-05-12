function install_hxcpp {
  if [ $TRAVIS_HAXE_VERSION == "development" ]; then
    git clone https://github.com/HaxeFoundation/hxcpp.git;
    haxelib dev hxcpp ./hxcpp;
    cd hxcpp/tools/hxcpp;
    haxe compile.hxml;
    cd ../../project;
    neko build.n;
    cd ../../;
  fi
  if [ $TRAVIS_HAXE_VERSION == "3.2.0" ]; then
    haxelib install hxcpp 3.2.94;
  fi
}

function install_hxjava {
  if [ $TRAVIS_HAXE_VERSION == "development" ]; then
    haxelib git hxjava https://github.com/HaxeFoundation/hxjava.git;
  fi
  if [ $TRAVIS_HAXE_VERSION == "3.2.0" ]; then
    haxelib install hxjava 3.2.0;
  fi
}

function install_hxcs {
  if [ $TRAVIS_HAXE_VERSION == "development" ]; then
    haxelib git hxcs https://github.com/HaxeFoundation/hxcs.git;
  fi
  if [ $TRAVIS_HAXE_VERSION == "3.2.0" ]; then
    haxelib install hxcs 3.2.0;
  fi
}
