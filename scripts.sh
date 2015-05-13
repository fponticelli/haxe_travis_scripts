function install_hxcpp {
  if [[ $TRAVIS_HAXE_VERSION == "development" ]]; then
    (
      cd $HOME
      git clone https://github.com/HaxeFoundation/hxcpp.git
      haxelib dev hxcpp ./hxcpp
      cd hxcpp/tools/hxcpp
      haxe compile.hxml
      cd ../../project
      neko build.n default
    )
  fi
  if [[ $TRAVIS_HAXE_VERSION == "3.2.0" ]]; then
    haxelib install hxcpp 3.2.94;
  fi
  if [[ $TRAVIS_HAXE_VERSION == "3.1.3" ]]; then
    haxelib install hxcpp 3.1.68;
  fi
}

function install_hxjava {
  if [[ $TRAVIS_HAXE_VERSION == "development" ]]; then
    haxelib git hxjava https://github.com/HaxeFoundation/hxjava.git;
  fi
  if [[ $TRAVIS_HAXE_VERSION == "3.2.0" ]]; then
    haxelib install hxjava 3.2.0;
  fi
  if [[ $TRAVIS_HAXE_VERSION == "3.1.3" ]]; then
    haxelib install hxjava 3.1.0;
  fi
}

function install_hxcs {
  if [[ $TRAVIS_HAXE_VERSION == "development" ]]; then
    haxelib git hxcs https://github.com/HaxeFoundation/hxcs.git;
  fi
  if [[ $TRAVIS_HAXE_VERSION == "3.2.0" ]]; then
    haxelib install hxcs 3.2.0;
  fi
  if [[ $TRAVIS_HAXE_VERSION == "3.1.3" ]]; then
    haxelib install hxcs 3.1.1;
  fi
}

function install_flashplayer {
  wget http://fpdownload.macromedia.com/pub/flashplayer/updaters/11/flashplayer_11_sa_debug.i386.tar.gz
  sudo apt-get install libgtk2.0-0:i386 libxt6:i386 libnss3:i386 libcurl3:i386
  [ -f /etc/init.d/xvfb ] || sudo apt-get install xvfb
  tar -xf flashplayer* -C $HOME/
  echo "ErrorReportingEnable=1\nTraceOutputFileEnable=1" > $HOME/mm.cfg
  export DISPLAY=:99.0
	export AUDIODEV=null
  FLASHLOGPATH=$HOME/.macromedia/Flash_Player/Logs/flashlog.txt
}

function run_flash {
  sudo killall "Flash Player Debugger"
	killall tail
	rm -f /tmp/flash-fifo
	rm -f "$FLASHLOGPATH"
  xvfb-run -a $HOME/flashplayerdebugger "$@" &
  for i in 0 1 2 3 4 5 6 7 8 9 10 11 12 13 14 15 16 17 18 19 20; do
		sudo chmod 777 "$FLASHLOGPATH"
		if [ -f "$FLASHLOGPATH" ]; then
			break
		fi
		sleep 1
		echo "waiting for $FLASHLOGPATH"
	done
  if [ ! -f "$FLASHLOGPATH" ]; then
		echo "$FLASHLOGPATH not found"
		exit 1
	fi
  #mkfifo /tmp/flash-fifo
  TEST=$(cat $FLASHLOGPATH)
  "echo \$TEST"
  exit [ $TEST ?? 'success: true' ]
}
