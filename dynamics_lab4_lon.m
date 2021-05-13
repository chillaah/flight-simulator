function dX = dynamics_lab4_lon(X,u,c,V0)
u0 = V0;
q = 0.5*c.rho*(u0^2);

Xu = -(c.CD + 2*c.CD0)*q*c.S/(c.m*u0);
Xw = -(c.CDa - c.CL0)*q*c.S/(c.m*u0);
Xde = c.CLde*q*c.S/c.m;
XdT = 1;

Zu = -(c.CL + 2*c.CL0)*q*c.S/(c.m*u0);
Zw = -(c.CLa + c.CD0)*q*c.S/(c.m*u0);
Zwd = c.CZ_alphad * q * c.S / (2* u0^2 * c.m );
Zq = c.Czq * c.cbar * q * c.S / ( 2 * u0 * c.m );
Zde = c.CZde*q*c.S/c.m;
ZdT = 1;

Mu = c.Cmu*q*c.S*c.cbar/(u0*c.Iy);
Mw = c.Cma*q*c.S*c.cbar/(u0*c.Iy);
Mwd = c.Cmad*(c.cbar^2)*q*c.S/(2*(u0^2)*c.Iy);
Mq = c.Cmq*q*c.S*(c.cbar^2)/(2*u0*c.Iy);
Mde = c.CMde*q*c.S*c.cbar/c.Iy;
MdT = c.cbar;

A = [Xu, Xw, 0, -c.g; ...
    Zu, Zw, u0, 0; ...
    Mu + Mwd*Zu, Mw + Mwd*Zw, Mq + Mwd*u0, 0; ...
    0, 0, 1, 0];

B = [Xde, XdT; ...
    Zde, ZdT; ...
    Mde + Mwd*Zde, MdT + Mwd*ZdT; ...
    0, 0];

dX = A*X + B*u;
end