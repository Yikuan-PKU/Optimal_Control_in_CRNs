function g = guess(x) % initial guess for y and y'
    global X Y;
    [m,n]=find(X==x);
    g=[Y(1,n);Y(2,n);Y(3,n);Y(4,n)];
end

