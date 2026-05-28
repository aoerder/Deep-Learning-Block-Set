% dlbsTestSlice
% Validates slice forward/backward behavior for 2, 3, and 4 outputs using
% dlbsTestHarnessSlice2/3/4 with randomized ALL_DIMS, DIM, and S1-S4.
classdef dlbsTestSlice < dlbsAbstractHarnessTest

    methods (Test)

        function testCalc2Outputs(testCase)
            dlbsTestSlice.runCase(testCase, 2);
        end

        function testCalc3Outputs(testCase)
            dlbsTestSlice.runCase(testCase, 3);
        end

        function testCalc4Outputs(testCase)
            dlbsTestSlice.runCase(testCase, 4);
        end
    end

    methods (Static, Access = private)

        function runCase(testCase, nOut)
            cfg = dlbsTestSlice.randomConfig(nOut);

            inputs = struct;
            inputs.X = dlbsTestSlice.randTensor(cfg.shapeX, cfg.ALL_DIMS);
            for i = 1:nOut
                shapeYi = cfg.shapeX;
                shapeYi(cfg.DIM) = cfg.S(i);
                inputs.("dY" + i) = dlbsTestSlice.randTensor(shapeYi, cfg.ALL_DIMS);
            end

            expected.Y = dlbsTestSlice.splitAlongDim(inputs.X, cfg.DIM, cfg.S(1:nOut));
            catList = cell(1, nOut);
            for i = 1:nOut
                catList{i} = inputs.("dY" + i);
            end
            expected.dX = cat(cfg.DIM, catList{:});

            testCase.setHarness("dlbsTestHarnessSlice" + nOut);
            testCase.harness = testCase.harness.setVariable('ALL_DIMS', cfg.ALL_DIMS);
            testCase.harness = testCase.harness.setVariable('DIM', cfg.DIM);
            testCase.harness = testCase.harness.setVariable('S1', cfg.S(1));
            testCase.harness = testCase.harness.setVariable('S2', cfg.S(2));
            testCase.harness = testCase.harness.setVariable('S3', cfg.S(3));
            testCase.harness = testCase.harness.setVariable('S4', cfg.S(4));
            testCase.harness = testCase.harness.setVariable('X', inputs.X);
            for i = 1:nOut
                testCase.harness = testCase.harness.setVariable(char("dY" + i), inputs.("dY" + i));
            end

            simout = sim(testCase.harness);
            output.dX = simout.dX.Data;
            for i = 1:nOut
                output.("Y" + i) = simout.("Y" + i).Data;
            end

            % Shape checks: X must match dX, and each Yi must match dYi.
            testCase.verifyEqual(size(output.dX), size(inputs.X));
            for i = 1:nOut
                testCase.verifyEqual(size(output.("Y" + i)), size(inputs.("dY" + i)));
            end

            testCase.verifyEqual(output.dX, expected.dX, "AbsTol", 1e-6);
            for i = 1:nOut
                testCase.verifyEqual(output.("Y" + i), expected.Y{i}, "AbsTol", 1e-6);
            end
        end

        function cfg = randomConfig(nOut)
            cfg.ALL_DIMS = randi([1, 4]);
            cfg.DIM = randi([1, cfg.ALL_DIMS]);
            cfg.shapeX = randi([1, 8], 1, cfg.ALL_DIMS);
            cfg.shapeX(end) = randi([2, 8]);

            cfg.S = randi([1, 4], 1, 4);
            if cfg.DIM == cfg.ALL_DIMS
                cfg.S(1:nOut) = randi([2, 4], 1, nOut);
            end

            cfg.shapeX(cfg.DIM) = sum(cfg.S(1:nOut));
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
