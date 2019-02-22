function Q_hvac_2_m3(block)
% Level-2 MATLAB file S-Function for times two demo.
%   Copyright 1990-2009 The MathWorks, Inc.

  setup(block);
  
%endfunction

function setup(block)
  
  %% Register number of input and output ports
  block.NumInputPorts  = 4;
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
  cfm = ((block.InputPort(1).Data)/(1.08*(block.InputPort(2).Data-block.InputPort(3).Data); 
  %  2118.8799727597 is conersion factor of cfm to m3/hr
  m3hr = cfm / 2118.8799727597;
  co2 = block.InputPort(4).Data * 44.01 /24.45; % 44.01 co2 moelcular weight -- ppm to mg/m3 conversion
  block.OutputPort(1).Data = m3hr * co2 ;