function install_hxcpp {
  if [[ $TRAVIS_HAXE_VERSION == "development" ]]; then
    git clone https://github.com/HaxeFoundation/hxcpp.git;
    haxelib dev hxcpp ./hxcpp;
    (
      cd hxcpp/tools/hxcpp;
      haxe compile.hxml default || true;
      cd ../../project;
      neko build.n || true;
    ) || true;
  fi
  if [[ $TRAVIS_HAXE_VERSION == "3.2.0" ]]; then
    haxelib install hxcpp 3.2.94;
  fi
}

function install_hxjava {
  if [[ $TRAVIS_HAXE_VERSION == "development" ]]; then
    haxelib git hxjava https://github.com/HaxeFoundation/hxjava.git;
  fi
  if [[ $TRAVIS_HAXE_VERSION == "3.2.0" ]]; then
    haxelib install hxjava 3.2.0;
  fi
}

function install_hxcs {
  if [[ $TRAVIS_HAXE_VERSION == "development" ]]; then
    haxelib git hxcs https://github.com/HaxeFoundation/hxcs.git;
  fi
  if [[ $TRAVIS_HAXE_VERSION == "3.2.0" ]]; then
    haxelib install hxcs 3.2.0;
  fi
}

function install_flashplayer {
  wget http://fpdownload.macromedia.com/pub/flashplayer/updaters/11/flashplayer_11_sa_debug.i386.tar.gz
  sudo apt-get install libgtk2.0-0:i386 libxt6:i386 libnss3:i386 libcurl3:i386
  [ -f /etc/init.d/xvfb ] || sudo apt-get install xvfb
  tar -xf flashplayer* -C $HOME/
}

function run_flash {
  xvfb-run -extension RANDR -a $HOME/flashplayerdebugger "$@"
}
