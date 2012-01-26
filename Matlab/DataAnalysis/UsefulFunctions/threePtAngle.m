function angle = threePtAngle(vertex1, intersection, vertex2)
x1 = vertex1.x;         y1 = vertex1.y;
x2 = intersection.x;    y2 = intersection.y;
x3 = vertex2.x;         y3 = vertex2.y;

angle = atan2(abs((x1-x2)*(y3-y2)-(x3-x2)*(y1-y2)), ...
               (x1-x2)*(x3-x2)+(y1-y2)*(y3-y2));