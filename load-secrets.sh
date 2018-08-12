#!/bin/bash

name=$1
file=$2

docker secret create $name $file
