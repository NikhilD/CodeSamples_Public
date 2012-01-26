function area = areaTrapeze(node1, node2)

a = ObjectDist(node1, node1.intersec);
b = ObjectDist(node2, node2.intersec);
h = ObjectDist(node1.intersec, node2.intersec);

area = ((a + b)/2)*h;

