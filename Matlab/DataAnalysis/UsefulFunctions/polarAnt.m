function polarAnt()
angle = [0 45 90 135 180 225 270 315];
radAngle = angle.*(pi/180);
dbm0base = [-30.9000  -36.5882  -49.1765  -56.4510  -39.0000  -45.4510  -42.5882  -36.9412];
mW0base = (10.^(dbm0base/10));
polar([radAngle radAngle(1)], [mW0base mW0base(1)]);

