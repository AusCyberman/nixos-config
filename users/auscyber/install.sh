#!/bin/sh
nix build .#homeConfigurations."${1}".activationPackage
