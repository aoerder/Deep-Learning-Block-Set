classdef dlbsTestAdam < dlbsAbstractHarnessTest
    % Test class for Adam Optimizer
    % This test simulates 1000 steps using a Python-generated reference
    
    methods (Test)
        function testAdam1000Steps(testCase)

            testCase.setHarness("dlbsTestHarnessAdam");
            testCase.harness = testCase.harness.setModelParameter( ...
                'Solver','FixedStepDiscrete', ...
                'FixedStep','1', ...
                'StartTime','0', ...
                'StopTime','1000' );


            % 1. Get reference data from Python
            pyAddPath(fileparts(mfilename('fullpath')));
            ref = py.dlbsTestAdamTorch.generate_adam_reference();
            
            p_history = double(ref{'p_history'});
            dp_history = double(ref{'dp_history'});
            lr = double(ref{'lr'});
            beta1 = double(ref{'beta1'});
            beta2 = double(ref{'beta2'});
            eps = double(ref{'eps'});
            p_init = double(ref{'p_init'});
            
            % 2. Setup Simulink inputs
            % Time vector for the simulation (0 to 1 sec with 1000 steps, dt=0.001)
            numSteps = 1000;
            dt = 1;
            t = (0:numSteps-1)' * dt;
            
            % Prepare timeseries for dp (gradient of parameters)
            dp_ts = timeseries(dp_history', t);
            
            % Initial value for p
            testCase.harness=testCase.harness.setVariable('init', p_init);
            testCase.harness=testCase.harness.setVariable('gamma', lr);
            testCase.harness=testCase.harness.setVariable('beta1', beta1);
            testCase.harness=testCase.harness.setVariable('beta2', beta2);
            testCase.harness=testCase.harness.setVariable('epsilon', eps); 
            testCase.harness=testCase.harness.setVariable('dp', dp_ts);
            
            % 3. Run Simulation for 1000 steps (Total time: (numSteps-1)*dt)
            stopTime = (numSteps-1) * dt;
            testCase.harness = testCase.harness.setModelParameter('StopTime', num2str(stopTime));
            
            % Run simulation
            out = sim(testCase.harness);
            
            % 4. Validate output
            % Assuming the block output terminal for updated parameters is 'p'
            p_sim = squeeze(out.p.Data);
            
            % Compare results with small tolerance
            testCase.verifyEqual(p_sim(:), p_history(:), 'AbsTol', 1e-6, ...
                'Adam simulation steps do not match Python reference.');
        end
    end
end

function pyAddPath(path)
    if count(py.sys.path, path) == 0
        insert(py.sys.path, int32(0), path);
    end
end
