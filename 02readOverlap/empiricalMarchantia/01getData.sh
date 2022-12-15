for i in ~/temp/MarchantiaSeq/HB*stats; do grep ^IS $i > `basename -- $i .stats`.IS ; done
