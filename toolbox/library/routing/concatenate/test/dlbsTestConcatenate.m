% dlbsTestConcatenate
% Validates concatenate forward/backward behavior for 2, 3, and 4 inputs
% using dlbsTestHarnessConcatenate2/3/4 with randomized ALL_DIMS, DIM,
% and slice lengths S1-S4.
classdef dlbsTestConcatenate < dlbsAbstractHarnessTest

    methods (Test)

        function testCalc2Inputs(testCase)
            dlbsTestConcatenate.runCase(testCase, 2);
        end

        function testCalc3Inputs(testCase)
            dlbsTestConcatenate.runCase(testCase, 3);
        end

        function testCalc4Inputs(testCase)
            dlbsTestConcatenate.runCase(testCase, 4);
        end
    end

    methods (Static, Access = private)

        function runCase(testCase, nIn)
            cfg = dlbsTestConcatenate.randomConfig(nIn);

            inputs = struct;
            for i = 1:nIn
                shapeXi = cfg.shapeY;
                shapeXi(cfg.DIM) = cfg.S(i);
                inputs.("X" + i) = dlbsTestConcatenate.randTensor(shapeXi, cfg.ALL_DIMS);
            end
            inputs.dY = dlbsTestConcatenate.randTensor(cfg.shapeY, cfg.ALL_DIMS);

            expected.X = dlbsTestConcatenate.splitAlongDim(inputs.dY, cfg.DIM, cfg.S(1:nIn));
            catList = cell(1, nIn);
            for i = 1:nIn
                catList{i} = inputs.("X" + i);
            end
            expected.Y = cat(cfg.DIM, catList{:});

            testCase.setHarness("dlbsTestHarnessConcatenate" + nIn);
            testCase.harness = testCase.harness.setVariable('ALL_DIMS', cfg.ALL_DIMS);
            testCase.harness = testCase.harness.setVariable('DIM', cfg.DIM);
            testCase.harness = testCase.harness.setVariable('S1', cfg.S(1));
            testCase.harness = testCase.harness.setVariable('S2', cfg.S(2));
            testCase.harness = testCase.harness.setVariable('S3', cfg.S(3));
            testCase.harness = testCase.harness.setVariable('S4', cfg.S(4));
            for i = 1:nIn
                testCase.harness = testCase.harness.setVariable(char("X" + i), inputs.("X" + i));
            end
            testCase.harness = testCase.harness.setVariable('dY', inputs.dY);

            simout = sim(testCase.harness);
            output.Y = simout.Y.Data;
            for i = 1:nIn
                output.("dX" + i) = simout.("dX" + i).Data;
            end

            % Shape checks: each Xi must match dXi, and Y must match dY.
            testCase.verifyEqual(size(output.Y), size(inputs.dY));
            for i = 1:nIn
                testCase.verifyEqual(size(output.("dX" + i)), size(inputs.("X" + i)));
            end

            testCase.verifyEqual(output.Y, expected.Y, "AbsTol", 1e-6);
            for i = 1:nIn
                testCase.verifyEqual(output.("dX" + i), expected.X{i}, "AbsTol", 1e-6);
            end
        end

        function cfg = randomConfig(nIn)
            cfg.ALL_DIMS = randi([1, 4]);
            cfg.DIM = randi([1, cfg.ALL_DIMS]);
            cfg.shapeY = randi([1, 8], 1, cfg.ALL_DIMS);
            cfg.shapeY(end) = randi([2, 8]);

            cfg.S = randi([1, 4], 1, 4);
            if cfg.DIM == cfg.ALL_DIMS
                cfg.S(1:nIn) = randi([2, 4], 1, nIn);
            end

            cfg.shapeY(cfg.DIM) = sum(cfg.S(1:nIn));
        end

        function x = randTensor(shapeVec, allDims)
            if allDims == 1
                x = randn(shapeVec(1), 1);
            else
                x = randn(shapeVec);
            end
        end

        function parts = splitAlongDim(x, dim, lengths)
            n = numel(lengths);
            parts = cell(1, n);
            startIdx = 1;
            nIdx = max(dim, ndims(x));
            for i = 1:n
                idx = repmat({':'}, 1, nIdx);
                idx{dim} = startIdx:(startIdx + lengths(i) - 1);
                parts{i} = x(idx{:});
                startIdx = startIdx + lengths(i);
            end
        end
    end
end
