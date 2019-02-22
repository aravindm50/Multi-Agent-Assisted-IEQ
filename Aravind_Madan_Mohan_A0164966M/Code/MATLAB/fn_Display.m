%% Coded by Krishnanand K.R. [17.Dec.2015]
%% Do not share without explicit permission
function fn_Display(block)
setup(block); %% Call the setup(.) once & initialize
% Sub-functions are defined below
%% Inner Sub_Fn-1 ============================================================================
%% setup(.) is called only once at the start of simulation
    function setup(block)
        % Register the number of in & out ports.
        block.NumInputPorts  = 0;   block.NumOutputPorts = 0;
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
        Simulation_Time_Elapsed=get_param(bdroot,'SimulationTime');
        Physical_Time_Elapsed=toc;
        Simulation_Speed=Simulation_Time_Elapsed/Physical_Time_Elapsed;
        Display_String=['Simulation_Time_Elapsed=' num2str(Simulation_Time_Elapsed,'%.2f') ' seconds\n' 'Physical_Time_Elapsed=' num2str(Physical_Time_Elapsed,'%.2f') ' seconds\n' 'Simulation_Speed=' num2str(Simulation_Speed,'%.2f') ' times'];
        Display_Block=get_param(gcb,'Parent');
        %disp(gcb);
        set_param(Display_Block,'MaskDisplay',['fprintf(' char(39) Display_String char(39) ')']); %% Sets gray-string nearby the block
        set_param(Display_Block,'AttributesFormatString',num2str(Physical_Time_Elapsed,'%.2f'));
        %set_param(Display_Block, 'BackgroundColor', ['[' num2str(rand(1,3)) ']']); %% Sets background-color of the block
    end
end
%% END OF FILE