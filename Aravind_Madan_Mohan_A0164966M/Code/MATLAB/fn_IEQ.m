function fn_IEQ(block)
setup(block); %% Call the setup(.) once & initialize
% Sub-functions are defined below
%% Inner Sub_Fn-1 ============================================================================
%% setup(.) is called only once at the start of simulation
    function setup(block)
        % Register the number of in & out ports.
        block.NumInputPorts  = 1;   block.NumOutputPorts = 0;
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
        rto=get_param(strcat(Display_Block,'/ROOM/Tbs'),'RuntimeObject');
        %IEQ = logsout{5}.Values.Data;
        IEQ = block.InputPort(1).Data(1) -273;
        
%         a = [51,255,153;
%             51,255,51;
%             0,255,0;
%             128,255,0;
%             255,255,51;
%             255,178,102;
%             255,153,51;
%             255,128,0;
%             255,0,0;
%             153,0,0]/255;
%         %assignin('base','ieq', IEQ);
%         if 0<= IEQ && 50 >= IEQ
%             SET = 1;
%         elseif 51<= IEQ && 75 >= IEQ
%             SET = 2;
%         elseif 76<= IEQ && 100 >= IEQ
%             SET = 3;
%         elseif 101<= IEQ && 150 >= IEQ
%             SET = 4;
%         elseif 151<= IEQ && 200 >= IEQ
%             SET = 5;
%         elseif 201<= IEQ && 250 >= IEQ
%             SET = 6;
%         elseif 251<= IEQ && 300 >= IEQ
%             SET = 7;
%         elseif 301<= IEQ && 350 >= IEQ
%             SET = 8;
%         elseif 351<= IEQ && 400 >= IEQ
%             SET = 9;
%         elseif 401<= IEQ && 500 >= IEQ
%             SET = 10;    
%         end
        %set_param(Display_Blocka, 'BackgroundColor', mat2str(a(SET,:))); %% Sets background-color of the bloc
        a = jet(40);
        n = round(IEQ);
%         if n<50 && n>10
%             set_param(Display_Blocka, 'BackgroundColor', mat2str(a(n-5,:))); %% Sets background-color of the block
%         else
%             set_param(Display_Blocka, 'BackgroundColor', mat2str(a(15,:))); %% Sets background-color of the block
%         end
       % p = Simulink.Mask.get('Wall_Model_Version_1_4/HVAC Control');
       % param = p.getParameter('Tbs');
    end
end
%% END OF FILE