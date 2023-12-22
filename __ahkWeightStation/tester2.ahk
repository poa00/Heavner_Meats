Loop 100000
{
	x := 1
	y := 2
	test(x, y)
}

test(x, y)
{
	return x < y ? x + 1 : y
}