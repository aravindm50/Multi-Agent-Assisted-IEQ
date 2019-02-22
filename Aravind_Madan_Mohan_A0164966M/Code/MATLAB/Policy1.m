%% Coded by Aravind MadanMohan
%% Do not share without explicit permission
function Policy1(block)
setup(block); %% Call the setup(.) once & initialize
% Sub-functions are defined below
%% Inner Sub_Fn-1 ============================================================================
%% setup(.) is called only once at the start of simulation
    function setup(block)
        % Register the number of in & out ports.
        block.NumInputPorts  = 2;   block.NumOutputPorts = 1;
        % Set up the i/o port properties to be inherited, ie. dynamic.
        block.SetPreCompInpPortInfoToDynamic;   block.SetPreCompOutPortInfoToDynamic;
        % Register the parameters.
        block.NumDialogPrms= 0;  %block.DialogPrmsTunable = {'Tunable'};
        block.SetAccelRunOnTLC(false); block.SimStateCompliance = 'DefaultSimState';
        block.RegBlockMethod('Outputs', @Outputs); %% Assign the output_function to be called each time
    end
%% Inner Sub_Fn-2 ============================================================================
%% output(.) is called for each time-step of simulation
%% The number of time is is called in a time-step depends on Solver for ODE
%% Ex: ode1 (Euler) calls output(.) only once in each time-step.
    function Outputs(block)
        Set_Point = block.InputPort(1).Data -273;
        Thermal_comfort = block.InputPort(2).Data;
        if Thermal_comfort == 0
            block.OutputPort(1).Data = Set_Point;
        elseif Thermal_comfort > 0 && Thermal_comfort <= 1
            block.OutputPort(1).Data = Set_Point - 0.0020;
        elseif Thermal_comfort > 1 && Thermal_comfort <= 2
            block.OutputPort(1).Data = Set_Point - 0.035;
        elseif Thermal_comfort > 2 && Thermal_comfort <= 3
            block.OutputPort(1).Data = Set_Point - 0.05;
        elseif Thermal_comfort < 0 && Thermal_comfort >= -1
            block.OutputPort(1).Data = Set_Point + 0.002;
        elseif Thermal_comfort < -1 && Thermal_comfort >= -2
            block.OutputPort(1).Data = Set_Point + 0.035;
        elseif Thermal_comfort < -2 && Thermal_comfort >= -3
            block.OutputPort(1).Data = Set_Point + 0.05;   
        end
        
        %set_param(Display_Block, 'BackgroundColor', ['[' num2str(rand(1,3)) ']']); %% Sets background-color of the block
    end
end
%% END OF FILE