func1()
{
    int a;
    a = 1;
    return a;
}
func2()
{
    int a;
    a = 1;
    func1();
    return a;
}
main()
{
    int b;
    b = 2;
    func2();
}
