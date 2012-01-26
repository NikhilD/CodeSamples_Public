function area = areaTriangle(node1, node2)

h = ObjectDist(node1, node2.intersec);
b = ObjectDist(node2, node2.intersec);

area = (b*h)/2;

