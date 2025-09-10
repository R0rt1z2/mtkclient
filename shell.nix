with import <nixpkgs> { };

mkShell {

  name = "mtkclient";

  buildInputs = with python3Packages; [
    capstone
    colorama
    flake8
    fusepy
    keystone
    keystone-engine
    pycryptodome
    pycryptodomex
    pyserial
    pyside6
    pyusb
    setuptools
    shiboken6
    unicorn
    wheel
  ];

}
