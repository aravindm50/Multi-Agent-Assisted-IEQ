function Q_air(block)
% Level-2 MATLAB file S-Function for times two demo.
%   Copyright 1990-2009 The MathWorks, Inc.

  setup(block);
  
%endfunction

function setup(block)
  
  %% Register number of input and output ports
  block.NumInputPorts  = 3;
  block.NumOutputPorts = 1;

  %% Setup functional port properties to dynamically
  %% inherited.
  block.SetPreCompInpPortInfoToDynamic;
  block.SetPreCompOutPortInfoToDynamic;
 
  block.InputPort(1).DirectFeedthrough = true;
  
  %% Set block sample time to inherited
  block.SampleTimes = [-1 0];
  
  %% Set the block simStateCompliance to default (i.e., same as a built-in block)
  block.SimStateCompliance = 'DefaultSimState';

  %% Run accelerator on TLC
  block.SetAccelRunOnTLC(true);
  
  %% Register methods
  block.RegBlockMethod('Outputs',                 @Output);  
  
%endfunction

function Output(block)
    %sum = (block.InputPort(1).Data + block.InputPort(3).Data)* 7.37*2.63 + (block.InputPort(2).Data + block.InputPort(4).Data)* 10.11 *2.63 ;
    average = (block.InputPort(1).Data);
    %average = sum/(2*(7.37*2.63 + 10.11 *2.63));
    mass_specific_heat = block.InputPort(3).Data;
  block.OutputPort(1).Data = (average - block.InputPort(2).Data)*mass_specific_heat;