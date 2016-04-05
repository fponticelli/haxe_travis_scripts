function install_hxcpp {
  if [[ $TRAVIS_HAXE_VERSION == "development" ]]; then
    (
      haxelib git hxcpp https://github.com/HaxeFoundation/hxcpp.git
      cd $(haxelib path hxcpp | head -1)tools/hxcpp && haxe compile.hxml
      cd $(haxelib path hxcpp | head -1)project && neko build.n linux-m64
    )
  elif [[ $TRAVIS_HAXE_VERSION == 3.2.* ]]; then
    haxelib install hxcpp;
  elif [[ $TRAVIS_HAXE_VERSION == "3.1.3" ]]; then
    haxelib install hxcpp 3.1.68;
  elif
    echo "unable to install hxcpp";
    exit 1;
  fi
}

function install_hxjava {
  if [[ $TRAVIS_HAXE_VERSION == "development" ]]; then
    haxelib git hxjava https://github.com/HaxeFoundation/hxjava.git;
  elif [[ $TRAVIS_HAXE_VERSION == 3.2.* ]]; then
    haxelib install hxjava;
  elif [[ $TRAVIS_HAXE_VERSION == "3.1.3" ]]; then
    haxelib install hxjava 3.1.0;
  elif
    echo "unable to install hxjava";
    exit 1;
  fi
}

function install_hxcs {
  if [[ $TRAVIS_HAXE_VERSION == "development" ]]; then
    haxelib git hxcs https://github.com/HaxeFoundation/hxcs.git;
  elif [[ $TRAVIS_HAXE_VERSION == 3.2.* ]]; then
    haxelib install hxcs;
  elif [[ $TRAVIS_HAXE_VERSION == "3.1.3" ]]; then
    haxelib install hxcs 3.1.1;
  elif
    echo "unable to install hxcs";
    exit 1;
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
  export FLASHLOGPATH=$HOME/.macromedia/Flash_Player/Logs/flashlog.txt
  sh -e /etc/init.d/xvfb start
  sleep 3
}

function run_flash {
  sudo killall "Flash Player Debugger"
	killall tail
	rm -f /tmp/flash-fifo
	rm -f "$FLASHLOGPATH"
  xvfb-run -a $HOME/flashplayerdebugger "$@" &
	echo -n "waiting for $FLASHLOGPATH "
  for i in 1 2 3 4 5 6 7 8 9 10 11 12 13 14 15 16 17 18 19 20; do
		if [ -f "$FLASHLOGPATH" ]; then
			break
		fi
    echo -n "."
		sleep 1
	done
  echo
  if [ ! -f "$FLASHLOGPATH" ]; then
		echo "$FLASHLOGPATH not found"
		exit 1
	fi
	sudo chmod 777 "$FLASHLOGPATH"
  echo -n "FOUND $FLASHLOGPATH"
  local CODE=1
  for i in 1 2 3 4 5 6 7 8 9 10 11 12 13 14 15 16 17 18 19 20; do
    if grep -Fq "ALL TESTS OK" "$FLASHLOGPATH"; then
      CODE=0
      break
    fi
    if grep -Fq "fail" "$FLASHLOGPATH"; then
      break
    fi
    echo -n "."
    sleep 2
    echo "-----------------------"
    cat "$FLASHLOGPATH"
    echo "======================="
  done
  echo
  cat "$FLASHLOGPATH"
  if [ $CODE ]; then
    exit 1
  fi
}
