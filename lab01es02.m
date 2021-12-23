clear all
close all
clc

c = 0.2;
w0=0;
i0=1;
t=0:0.01:10;
i = i0*cos(w0*t);

for es = 1:8
   switch es
       case 1, R=10; L=0.5; x0=[0;0];
       case 2, R=100; L=0.5; x0=[0;0];
       case 3, R=0.1; L=0.05; x0=[0;0];
       case 4, R=10; L=0.5; x0=[0;0.2];
   end
   
   A = [0, -1/c; 1/L, 0];
   B = [1/c; 0];
   C = [1, 0];
   D = [0];
   
   SYS = ss(A, B, C, D);
   figure,lsim(SYS,i,t,x0)
   
end