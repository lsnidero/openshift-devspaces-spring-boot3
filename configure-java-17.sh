#!/bin/bash

set -e

install_java(){
    . /home/user/.sdkman/bin/sdkman-init.sh
	sdk install java 17.0.5-tem
	sdk default java 17.0.5-tem
	sdk install maven 3.8.7
	sdk default maven 3.8.7
}

install_java


