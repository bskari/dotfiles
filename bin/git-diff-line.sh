#!/bin/sh
git diff --color=always | \
    gawk '{bare=$0;gsub("\033[[][0-9]*m","",bare)};\
      match(bare,"^@@ -([0-9]+),[0-9]+ [+]([0-9]+),[0-9]+ @@",a){left=a[1];right=a[2];next};\
      bare ~ /^(---|\+\+\+|[^-+ ])/{print;next};\
      {line=gensub("^(\033[[][0-9]*m)?(.)","\\2\\1",1,$0)};\
      bare~/^-/{print "-"left++ ":" line;next};\
      bare~/^[+]/{print "+"right++ ":" line;next};\
      {print "("left++","right++"):"line;next}'
