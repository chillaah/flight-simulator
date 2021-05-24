% Calculate Matrix A and B for lateral dynamics
% required parameters are:
% c = struct consiting of plane parameters
% V0 = cruising / equilibrium speed
function dX = lat_dynamics(c,V0)
u0 = V0;
q = 0.5*c.rho*(u0^2);
Yv = q*c.S/c.m/u0*c.Cyb;
Yp = q*c.S*c.b/2/c.m/u0*c.Cyp;
Yr = q*c.S*c.b/2/c.m/u0*c.Cyr;
Lv = q*c.S*c.b/c.Ix/u0*c.Clb;
Lp = q*c.S*c.b^2/2/c.Ix/u0*c.Clp;
Lr = q*c.S*c.b^2/2/c.Ix/u0*c.Clr;
Nv = q*c.S*c.b/c.Iz/u0*c.Cnb;
Np = q*c.S*c.b^2/2/c.Iz/u0*c.Cnp;
Nr = q*c.S*c.b^2/2/c.Iz/u0*c.Cnr;

Ydr = q*c.S*c.Cydr/c.m;
Yda = q*c.S*c.Cyda/c.m;
Ldr = q*c.S*c.b/c.Ix*c.Cldr;
Lda = q*c.S*c.b/c.Ix*c.Clda;
Ndr = q*c.S*c.b/c.Iz*c.Cndr;
Nda = q*c.S*c.b/c.Iz*c.Cnda;

Ip = 1 - c.Ixz^2/c.Ix/c.Iz;
Ipp = c.Ixz/c.Ix/c.Iz/Ip;

A = [Yv, Yp, -(u0 - Yr), c.g;
    Lv/Ip + Ipp*c.Iz*Nv, Lp/Ip + Ipp*c.Iz*Np, Lr/Ip + Ipp*c.Iz*Nr, 0;
    Nv/Ip + Ipp*c.Ix*Lv, Np/Ip + Ipp*c.Ix*Lp, Nr/Ip + Ipp*c.Ix*Lr, 0;
    0, 1, 0, 0];

B = [Ydr, 0;
    Ldr/Ip + Ipp*c.Iz*Ndr, Lda/Ip + Ipp*c.Iz*Nda;
    Ndr/Ip + Ipp*c.Ix*Ldr, Nda/Ip + Ipp*c.Ix*Lda;
    0, 0];
end