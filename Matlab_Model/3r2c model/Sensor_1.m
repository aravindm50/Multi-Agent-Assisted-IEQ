%% Aravind Madan mohan
%% Do not share without explicit permission
function Sensor_1(block)
setup(block); %% Call the setup(.) once & initialize
% Sub-functions are defined below
%% Inner Sub_Fn-1 ============================================================================
%% setup(.) is called only once at the start of simulation
    function setup(block)
        % Register the number of in & out ports.
        block.NumInputPorts  = 1;   block.NumOutputPorts = 0;
        % Set up the i/o port properties to be inherited, ie. dynamic.
        block.SetPreCompInpPortInfoToDynamic;   block.SetPreCompOutPortInfoToDynamic;
         %block.InputPort(1).DatatypeID=-1; 
         block.InputPort(1).Complexity= 'Inherited';
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
        
        Display_Blocka=get_param(gcb,'Parent');
        C = strsplit(Display_Blocka,'/');
        Display_Block = get_param(gcs,'Parent');
        path= strcat(Display_Block,'/',cell2mat(C(end)));
        
        
        rto=get_param(strcat(path,'/ODE/Integrator'),'RuntimeObject');
        rto_CO=get_param(strcat(path,'/ODE1/Integrator'),'RuntimeObject');
        rto_HCHO=get_param(strcat(path,'/ODE2/Integrator'),'RuntimeObject');
        rto_O3=get_param(strcat(path,'/ODE3/Integrator'),'RuntimeObject');
        %rto_VOC=get_param(strcat(path,'/ODE4/Integrator'),'RuntimeObject');
        rto_PM2_5=get_param(strcat(path,'/ODE5/Integrator'),'RuntimeObject');
        rto_PM10=get_param(strcat(path,'/ODE6/Integrator'),'RuntimeObject');
%         rto_IAQ=0; %get_param(strcat(path,'/Max'),'RuntimeObject');
        
        
        IAQ = block.InputPort(1).Data(1);
        
        CO2 = (rto.OutputPort(1).Data);
        CO = (rto_CO.OutputPort(1).Data);
        HCHO = (rto_HCHO.OutputPort(1).Data);
        O3 = (rto_O3.OutputPort(1).Data);
        %VOC = (rto_VOC.OutputPort(1).Data);
        PM2_5 = (rto_PM2_5.OutputPort(1).Data);
        PM10 = (rto_PM10.OutputPort(1).Data);
        %IAQ = (rto_IAQ.OutputPort(1).Data);
        
        Display_String=['CO2 ' num2str(CO2,'%.2f') ' ppm\n\n'  'CO ' num2str(CO,'%.2f') ' ppm\n\n'  'HCHO ' num2str(HCHO,'%.2f') ' ppm\n\n'  'O3 ' num2str(O3,'%.2f') ' ppm\n\n'      'PM2_5 ' num2str(PM2_5,'%.2f') ' ppm\n\n'       'PM10 ' num2str(PM10,'%.2f') ' ppm\n\n'      'Air Quality Index ' num2str(IAQ,'%.2f') '\n\n'  ];
        set_param(path,'MaskDisplay',['fprintf(' char(39) Display_String char(39) ')']);
            
        
        %disp(gcb);
         
    end
end
%% END OF FILE