function I = integrateRsecOrd(A, abc, f, fun, x, y)

w = [0.333333333333333, 0.333333333333333, 0.1125
         0.470142064105115, 0.470142064000000, 0.066197076394253
         0.059715871789770, 0.470142064000000, 0.066197076394253
         0.470142064105115, 0.059715872000000, 0.066197076394253
         0.101286507323456, 0.101286507000000, 0.062969590272414
         0.797426985353087, 0.797426985000000, 0.066197076394253
         0.101286507323456, 0.101286507000000, 0.066197076394253];

nP = 7;
I = 0;

for iPt = 1:nP
    
    % Transformation into unit element (triangle) at (0,0) (1,0) (0,1) :
    z2 = w(iPt,1);
    z3 = w(iPt,2);
    z1 = 1-z2-z3;
    
    q = [z1*(2*z1-1); z2*(2*z2-1); z3*(2*z3-1);
         4*z1*z2;      4*z2*z3;    4*z1*z3];
    
    xv = x*q;
    yv = y*q;
    
    % Gaussian quadrature : sum(f(xi)*wi)
    fv = fun(xv, yv, A, abc);
    I = I + fv*w(iPt,3);
end

I = f*I*A*2;