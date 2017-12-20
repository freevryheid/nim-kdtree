import random, kdtree, strutils

randomize()

var
  kd = create(3)
  x,y,z: cdouble

for i in 0..<100:
  x = random(100.0)
  y = random(100.0)
  z = random(100.0)
  # echo "$1, $2, $3" % [x.formatFloat(precision=3), y.formatFloat(precision=3), z.formatFloat(precision=3)]
  discard kd.insert3(x, y, z, nil)

var
  res = kd.nearest3(0.cdouble, 0.cdouble, 0.cdouble)
  pos: array[3, float]
  near = resItem(res, pos[0].addr)

echo "closest: $1, $2, $3" % [pos[0].formatFloat(precision=3), pos[1].formatFloat(precision=3), pos[2].formatFloat(precision=3)]  


  


