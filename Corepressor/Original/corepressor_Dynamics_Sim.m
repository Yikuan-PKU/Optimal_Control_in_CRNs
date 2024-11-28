
function dx = corepressor_Dynamics_Sim(x,u,p,t,vdat)
% Template for specifying the dynamics for simulation 
%
% Syntax:  
%          [dx] = myProblem_Dynamics_Sim(x,u,p,t,vdat)
% 
% Inputs:
%    x  - state vector
%    u  - input
%    p  - parameter
%    t  - time
%    data - structured variable containing the values of additional data used inside
%          the function%      
% Output:
%    dx - time derivative of x
%
% Copyright (C) 2019 Yuanbo Nie, Omar Faqir, and Eric Kerrigan. All Rights Reserved.
% The contribution of Paola Falugi, Eric Kerrigan and Eugene van Wyk for the work on ICLOCS Version 1 (2010) is kindly acknowledged.
% This code is published under the MIT License.
% Department of Aeronautics and Department of Electrical and Electronic Engineering,
% Imperial College London London  England, UK 
% ICLOCS (Imperial College London Optimal Control) Version 2.5 
% 1 Aug 2019
% iclocs@imperial.ac.uk

%------------- BEGIN CODE --------------

%Stored data
%Define states
x1 = x(:,1);
x2 = x(:,2);
%Define inputs
k12 = u(:,1);
k21 = u(:,2);
k13 = u(:,3);
k31 = u(:,4);
k23 = u(:,5);
k32 = u(:,6);
%Define ODE right-hand side

dx(:,1) = x2.*(k21-k31)-x1.*(k12+k31+k13)+k31;
dx(:,2) = x1.*(k12-k32)-x2.*(k21+k23+k32)+k32;

%------------- END OF CODE --------------