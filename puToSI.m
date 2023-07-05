function [R, L] = puToSI(Z, Zbase, f)
% Function to convert per unit (p.u.) impedance to standard unit (S.I.)
% input:
%   Z     : complex inductive impedance (p.u)
%   Zbase : base impedance (S.I.)
%   f     : base frequency (Hz)
% output:
%   R: resistance (Ohm)
%   L: inductance (Henry)

    Z_SI = Z.*Zbase;
    R = real(Z_SI);
    XL = imag(Z_SI);
    L = XL/(2*pi*f);
    
end