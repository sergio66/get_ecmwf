#!/bin/bash

rsync -av --include="*/" --include="UAD*.gz" --exclude="*" --prune-empty-dirs \
 /asl/models/ecmwf/ steven@spud.umbc.edu:/Volumes/ExtBackup-8TB/NESDIS_ECMWF
