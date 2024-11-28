function [problem,guess] = corepressor(tau,para)
%myProblem - Template file for optimal control problem definition
%
%Syntax:  [problem,guess] = myProblem
%
% Outputs:
%    problem - Structure with information on the optimal control problem
%    guess   - Guess for state, control and multipliers.
%
% Other m-files required: none
% MAT-files required: none
%
% Copyright (C) 2019 Yuanbo Nie, Omar Faqir, and Eric Kerrigan. All Rights Reserved.
% The contribution of Paola Falugi, Eric Kerrigan and Eugene van Wyk for the work on ICLOCS Version 1 (2010) is kindly acknowledged.
% This code is published under the MIT License.
% Department of Aeronautics and Department of Electrical and Electronic Engineering,
% Imperial College London London  England, UK 
% ICLOCS (Imperial College London Optimal Control) Version 2.5 
% 1 Aug 2019
% iclocs@imperial.ac.uk
K21=para(1);
K31=para(2);
K32=para(3);
pi=zeros(1,2);
pi(1)=para(4);
pi(2)=para(5);
pf=zeros(1,2);
pf(1)=para(6);
pf(2)=para(7);

ri=zeros(1,3);
rf=zeros(1,3);


ri(1)=pi(2)/pi(1);
ri(2)=pi(1)/(1-(pi(1)+pi(2)));
ri(3)=1/(ri(1)*ri(2));
rf(1)=pf(2)/pf(1);
rf(2)=pf(1)/(1-(pf(1)+pf(2)));
rf(3)=1/(rf(1)*rf(2));

ki=zeros(1,6);
kf=zeros(1,6);

ki(1)=K21*ri(1);
ki(2)=K21;
ki(3)=K31/ri(2);
ki(4)=K31;
ki(5)=K32*ri(3);
ki(6)=K32;

kf(1)=K21*rf(1);
kf(2)=K21;
kf(3)=K31/rf(2);
kf(4)=K31;
kf(5)=K32*rf(3);
kf(6)=K32;
%------------- BEGIN CODE --------------
% Plant model name, provide in the format of function handle
InternalDynamics=@corepressor_Dynamics_Internal; 
SimDynamics=@corepressor_Dynamics_Sim;

% Analytic derivative files (optional), provide in the format of function handle

% (optional) customized call back function
%problem.callback=@callback_myProblem;

% Settings file
problem.settings=@settings_corepressor;

%Initial Time. t0<tf
problem.time.t0_min=0;
problem.time.t0_max=0;
guess.t0=0;

% Final time. Let tf_min=tf_max if tf is fixed.
problem.time.tf_min=tau;     
problem.time.tf_max=tau; 
guess.tf=tau;

% Parameters bounds. pl=< p <=pu
problem.parameters.pl=[];
problem.parameters.pu=[];
guess.parameters=[];

% Initial conditions for system.
problem.states.x0=pi;

% Initial conditions for system. Bounds if x0 is free s.t. x0l=< x0 <=x0u
problem.states.x0l=pi; 
problem.states.x0u=pi; 

% State bounds. xl=< x <=xu
problem.states.xl=[0,0];
problem.states.xu=[1,1];

% State rate bounds. xrl=< x_dot <=xru
%problem.states.xrl=[]; 
%problem.states.xru=[]; 

% State error bounds
problem.states.xErrorTol_local=[0.01,0.01]; 
problem.states.xErrorTol_integral=[0.01,0.01]; 

% State constraint error bounds
problem.states.xConstraintTol=[0.01,0.01];
%problem.states.xrConstraintTol=[0.1];

% Terminal state bounds. xfl=< xf <=xfu
problem.states.xfl=pf;
problem.states.xfu=pf;

% Guess the state trajectories with [x0 ... xf]
guess.time=[0 tau];
guess.states(:,1)=[pi(1),pf(1)];
guess.states(:,2)=[pi(2),pf(2)];

% Number of control actions N 
% Set problem.inputs.N=0 if N is equal to the number of integration steps.  
% Note that the number of integration steps defined in settings.m has to be divisible 
% by the  number of control actions N whenever it is not zero.
problem.inputs.N=0;       
      
% Input bounds
problem.inputs.ul=[0 0 0];
problem.inputs.uu=[inf inf inf];

% Bounds on the first control action
problem.inputs.u0l=[0 0 0];
problem.inputs.u0u=[inf inf inf];

% Input rate bounds
%problem.inputs.url=[]; 
%problem.inputs.uru=[];
% Input constraint error bounds
problem.inputs.uConstraintTol=[0.01 0.01 0.01];
%problem.inputs.urConstraintTol=[0.1 0.1];

% Guess the input sequences with [u0 ... uf]
guess.inputs(:,1)=[ki(1) kf(1)];
guess.inputs(:,2)=[ki(3) kf(3)];
guess.inputs(:,3)=[ki(5) kf(5)];
% Choose the set-points if required
problem.setpoints.states=[];
problem.setpoints.inputs=[];
% Path constraint function 
problem.constraints.ng_eq=0; % number of quality constraints in format of g(x,u,p,t) == 0
problem.constraints.gTol_eq=[]; % equality cosntraint error bounds

problem.constraints.gl=[]; % Lower ounds for inequality constraint function gl =< g(x,u,p,t) =< gu
problem.constraints.gu=[]; % Upper ounds for inequality constraint function gl =< g(x,u,p,t) =< gu
problem.constraints.gTol_neq=[]; % inequality constraint error bounds

% OPTIONAL: define the time duration each constraint will be active, for
% example (for ECH enabled in setings)


% Bounds for boundary constraints bl =< b(x0,xf,u0,uf,p,t0,tf) =< bu
problem.constraints.bl=[];
problem.constraints.bu=[];
problem.constraints.bTol=[]; 

%problem.data.auxdata=[];

problem.data.K21=para(1);
problem.data.K31=para(2);
problem.data.K32=para(3);
problem.data.ki=ki;
problem.data.kf=kf;
% Get function handles and return to Main.m
problem.data.InternalDynamics=InternalDynamics;
problem.data.functionfg=@fg;
problem.data.plantmodel = func2str(InternalDynamics);
problem.functions={@L,@E,@f,@g,@avrc,@b};
problem.sim.functions=SimDynamics;
problem.sim.inputX=[];
problem.sim.inputU=1:length(problem.inputs.ul);
problem.functions_unscaled={@L_unscaled,@E_unscaled,@f_unscaled,@g_unscaled,@avrc,@b_unscaled};
problem.data.functions_unscaled=problem.functions_unscaled;
problem.data.ng_eq=problem.constraints.ng_eq;
problem.constraintErrorTol=[problem.constraints.gTol_eq,problem.constraints.gTol_neq,problem.constraints.gTol_eq,problem.constraints.gTol_neq,problem.states.xConstraintTol,problem.states.xConstraintTol,problem.inputs.uConstraintTol,problem.inputs.uConstraintTol];

%------------- END OF CODE --------------

function stageCost=L_unscaled(x,xr,u,ur,p,t,vdat)

% L_unscaled - Returns the stage cost.
% The function must be vectorized and
% xi, ui are column vectors taken as x(:,i) and u(:,i) (i denotes the i-th
% variable)
% 
% Syntax:  stageCost = L(x,xr,u,ur,p,t,data)
%
% Inputs:
%    x  - state vector
%    xr - state reference
%    u  - input
%    ur - input reference
%    p  - parameter
%    t  - time
%    data- structured variable containing the values of additional data used inside
%          the function
%
% Output:
%    stageCost - Scalar or vectorized stage cost
%
%  Remark: If the stagecost does not depend on variables it is necessary to multiply
%          the assigned value by t in order to have right vector dimesion when called for the optimization. 
%          Example: stageCost = 0*t;

%------------- BEGIN CODE --------------

%Define states and setpoints


stageCost = (x(:,1).*u(:,1)-x(:,2).*vdat.K21).*log((x(:,1).*u(:,1))./(x(:,2).*vdat.K21)) + (x(:,1).*u(:,2)-(1-x(:,1)-x(:,2)).*vdat.K31).*log((x(:,1).*u(:,2))./((1-x(:,1)-x(:,2)).*vdat.K31)) + (x(:,2).*u(:,3)-(1-x(:,1)-x(:,2)).*vdat.K32).*log((x(:,2).*u(:,3))./((1-x(:,1)-x(:,2)).*vdat.K32));


%------------- END OF CODE --------------


function boundaryCost=E_unscaled(x0,xf,u0,uf,p,t0,tf,data) 

% E_unscaled - Returns the boundary value cost
%
% Syntax:  boundaryCost=E(x0,xf,u0,uf,p,tf,data)
%
% Inputs:
%    x0  - state at t=0
%    xf  - state at t=tf
%    u0  - input at t=0
%    uf  - input at t=tf
%    p   - parameter
%    tf  - final time
%    data- structured variable containing the values of additional data used inside
%          the function
%
% Output:
%    boundaryCost - Scalar boundary cost
%
%------------- BEGIN CODE --------------

boundaryCost=0;%TerminalCost(xf,data.kf(1),data.kf(2),data.kf(3),data.kf(4),data.kf(5),data.kf(6),0.001);

%------------- END OF CODE --------------

function bc=b_unscaled(x0,xf,u0,uf,p,t0,tf,data,varargin)

% b_unscaled - Returns a column vector containing the evaluation of the boundary constraints: bl =< bf(x0,xf,u0,uf,p,t0,tf) =< bu
%
% Syntax:  bc=b(x0,xf,u0,uf,p,tf,data)
%
% Inputs:
%    x0  - state at t=0
%    xf  - state at t=tf
%    u0  - input at t=0
%    uf  - input at t=tf
%    p   - parameter
%    tf  - final time
%    data- structured variable containing the values of additional data used inside
%          the function
%
%          
% Output:
%    bc - column vector containing the evaluation of the boundary function 
%
% Leave it here
varargin=varargin{1};
%------------- BEGIN CODE --------------
bc=[];

%------------- END OF CODE --------------
% When adpative time interval add constraint on time
if length(varargin)==2
    options=varargin{1};
    t_segment=varargin{2};
    if (strcmp(options.discretization,'hpLGR'))  && options.adaptseg==1 
        if size(t_segment,1)>size(t_segment,2)
            bc=[bc;diff(t_segment)];
        else
            bc=[bc;diff(t_segment)];
        end
    end
end

%------------- END OF CODE --------------

