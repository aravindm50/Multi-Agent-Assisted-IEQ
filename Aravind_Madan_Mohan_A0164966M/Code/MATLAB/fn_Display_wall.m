function fn_Display_wall(block)
persistent BW_Temperature;
persistent FW_Temperature;
persistent LW_Temperature;
persistent RW_Temperature;
persistent Room;
persistent loop_l;
persistent loop_r;
persistent loop_b;
persistent loop_f;
persistent loop_room;

setup(block); %% Call the setup(.) once & initialize
% Sub-functions are defined below
%% Inner Sub_Fn-1 ============================================================================
%% setup(.) is called only once at the start of simulation
    function setup(block)
        % Register the number of in & out ports.
        block.NumInputPorts  = 1;   block.NumOutputPorts = 0;
        % Set up the i/o port properties to be inherited, ie. dynamic.
        block.SetPreCompInpPortInfoToDynamic;   block.SetPreCompOutPortInfoToDynamic;
        block.InputPort(1).DatatypeID=-1; block.InputPort(1).Complexity= 'Inherited';
        % Register the parameters.
        block.NumDialogPrms= 0;  %block.DialogPrmsTunable = {'Tunable'};
        block.SetAccelRunOnTLC(false); block.SimStateCompliance = 'DefaultSimState';
        block.RegBlockMethod('Outputs', @Outputs); %% Assign the output_function to be called each time
        BW_Temperature=[ones(1,1000)];
        FW_Temperature=[ones(1,1000)];
        RW_Temperature=[ones(1,1000)];
        LW_Temperature=[ones(1,1000)];
        Room = [ones(1,1000)];
        loop_l = 1;loop_r = 1;loop_b = 1;loop_f = 1;loop_room =1;
    end
%% Inner Sub_Fn-2 ============================================================================
%% output(.) is called for each time-step of simulation
%% The number of time is is called in a time-step depends on Solver for ODE
%% Ex: ode1 (Euler) calls output(.) only once in each time-step.
    function Outputs(block)
        %path = strcat(gcs,'Subsystem');
        T_outside_input = block.InputPort(1).Data(1) -273; %% 
        
        Display_Block1=get_param(gcb,'Parent');
        C = strsplit(Display_Block1,'/');
        Display_Block = get_param(gcs,'Parent');
        switch cell2mat(C(end))
            
            case 'Left_Wall'
%                 Temperature_2=get_param(strcat(Display_Block,'/Tout3'),'Value');
                Temperature_2 = T_outside_input;
                Display_String=['Temperature \n Left Room= \n'   num2str(Temperature_2,'%.2f')   ' deg. C\n' ];
                if loop_l==1
                    LW_Temperature = Temperature_2*LW_Temperature;
                    loop_l = 0;
                else
                    LW_Temperature=[LW_Temperature, (Temperature_2)];LW_Temperature=LW_Temperature(2:1001);
                end
                
            case 'Right_Wall'
%                 Temperature_2=get_param(strcat(Display_Block,'/Tout1'),'Value');
                Temperature_2 = T_outside_input;
                Display_String=['Temperature \n Right Room= \n'   num2str(Temperature_2,'%.2f')   ' deg. C\n' ];
                if loop_r==1
                    RW_Temperature = Temperature_2*RW_Temperature;
                    loop_r = 0;
                else
                    RW_Temperature=[RW_Temperature, (Temperature_2)];RW_Temperature=RW_Temperature(2:1001);
                end
            case 'Front_Wall'
%                 Temperature_2=get_param(strcat(Display_Block,'/Tout2'),'Value');
                Temperature_2 = T_outside_input;
                Display_String=['Temperature Corridor= '   num2str(Temperature_2,'%.2f')   ' deg. C\n' ];
                if loop_f==1
                    FW_Temperature = Temperature_2*FW_Temperature;
                    loop_f = 0;
                else
                    FW_Temperature=[FW_Temperature, (Temperature_2)];FW_Temperature=FW_Temperature(2:1001);
                end 
            case 'Back_Wall'
%                 rto=get_param(strcat(Display_Block,'/Tout'),'RuntimeObject');% disp(whos('Temperature_2'));
%                  Temperature_2 = (rto.OutputPort(1).Data);
                Temperature_2 = T_outside_input;
                Display_String=['Temperature Outside= '  num2str(Temperature_2,'%.2f')   ' deg. C\n' ];
                if loop_b==1
                    BW_Temperature = Temperature_2*BW_Temperature;
                    loop_b = 0;
                else
                    BW_Temperature=[BW_Temperature, (Temperature_2)];BW_Temperature=BW_Temperature(2:1001);
                end
             case 'Room'
%                 rto=get_param(strcat(Display_Block,'/Tout'),'RuntimeObject');% disp(whos('Temperature_2'));
%                  Temperature_2 = (rto.OutputPort(1).Data);
                Temperature_2 = T_outside_input;
                Display_String=['Temperature Room= '  num2str(Temperature_2,'%.2f')   ' deg. C\n' ];
                if loop_room==1
                    Room = Temperature_2*Room;
                    loop_room = 0;
                else
                    Room=[Room, (Temperature_2)];Room=Room(2:1001);
                end   
                
            case 'Roof'
%                 Temperature_2=get_param(strcat(Display_Block,'/Tout5'),'Value');
                Temperature_2 = T_outside_input;
                Display_String=['Temperature \n Above Roof= \n'   num2str(Temperature_2,'%.2f')   ' deg. C\n' ];
            case 'Floor'
%                 Temperature_2=get_param(strcat(Display_Block,'/Tout4'),'Value');
                Temperature_2 = T_outside_input;
                Display_String=['Temperature \n Below= \n'   num2str(Temperature_2,'%.2f')   ' deg. C\n' ];
        
        end 
        plot(Room,'*r'); hold('on');plot(FW_Temperature,'r'); hold('on'); plot(BW_Temperature,'.b');hold('on'); plot(RW_Temperature,'y');hold('on'); plot(LW_Temperature,'g'); hold('off');
        title('Temperature Readings')
        xlabel('Time(sec)')
        ylabel('deg. C')
        set_param(Display_Block1,'MaskDisplay',['fprintf(' char(39)  Display_String  char(39) ')']); %% Sets gray-string nearby the block
        a = jet(40);
        n = round(Temperature_2);
        if n<50 && n>10
            set_param(Display_Block1, 'BackgroundColor', mat2str(a(n-5,:))); %% Sets background-color of the block
        else
            set_param(Display_Block1, 'BackgroundColor', mat2str(a(15,:))); %% Sets background-color of the block
        end
    end
end
%% END OF FILE