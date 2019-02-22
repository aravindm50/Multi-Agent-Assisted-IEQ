function fn_Display_Room(block)
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
        %path = strcat(gcs,'Subsystem');
        
        Display_Blocka=get_param(gcb,'Parent');
        C = strsplit(Display_Blocka,'/');
        Display_Block = get_param(gcs,'Parent');
        Temperature_2=get_param(strcat(Display_Block,'/Setpoint'),'Value');
        a = jet(40);
        n = str2double(Temperature_2)-273;
        if n<50 && n>10
            set_param(Display_Blocka, 'BackgroundColor', mat2str(a(n-5,:))); %% Sets background-color of the block
        else
            set_param(Display_Blocka, 'BackgroundColor', mat2str(a(15,:))); %% Sets background-color of the block
        end
       % p = Simulink.Mask.get('Wall_Model_Version_1_4/HVAC Control');
       % param = p.getParameter('Tbs');
    end
end
%% END OF FILE