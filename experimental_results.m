% test PSO with one by one neighborhood optimization

% load datasets
% load('data/datasets.mat');

showplot_dpso = false;
showplot_pso = false;

fullloops = 10;

resultDist = zeros(fullloops, 2, size(datasetname,2)); % 1: min. DPSO, 2: min. PSO
resultTime = zeros(fullloops, 3, size(datasetname,2)); % 1: min. DPSO, 2: min. PSO, 3: sum

% 1: relative error (with mean value), 
% 2: max. value found by the algorithm, 
% 3: mean value, 
% 4: standard deviation, 
% 5: best solution found by the algorithm
resultOverview = zeros(size(datasetname,2), 5);

% vRandType: edgeExch or 2opt
% vRandIter: interger > 0 (only for vRandType edgeExch)
% randArt: randomStart or randomTemp
moveOptionsDPSO = struct('bLoc', 0.2, 'bGlob', 0.2, 'randArt', 'randomTemp', 'vRandType', '2opt', 'vRandIter', 2);

moveOptionsPSO = struct('initVelocity', 0.5, 'initInertiaWeight', 0.5,'noChangeCountTh', 0, 'boundaryhandlingPercentage', 0.0);

% loop through all files
for f = 1%:1:size(datasetname,2) % iterate through datasets
    
    fprintf('dataset: %s\n',datasetname{f});

    % get the data: structure = X Y R1 R2
    data = eval(datasetname{f});
    
    travelPoints = data(:,1:2);
    
    for l=1:1:fullloops % runs to compute the mean error and the standard deviation

        tDpso = tic;
        % [ path, total_length_dpso, travelPoints ] = dPsoOpt( data , swarmQuantity, particleIter, moveOptionsDPSO);
        [ path, total_length_dpso ] = psoOptDisc( data , 30, 1000, moveOptionsDPSO);

        resultTime(l,1,f) = toc(tDpso) * 1000; % in ms
        resultDist(l,1,f) = total_length_dpso;

        if showplot_dpso == true
            plotSpace( [travelPoints data(:,3:4)], path );
        end
        
        tPso = tic;
        %[ path, total_length, travelPoints ] = psoOpt( data, path, swarmQuantity, particleIter, moveOptionsPSO )
        [ path, total_length_pso, travelPoints ] = psoOpt( data, path, 50, 1000, moveOptionsPSO);

        resultTime(l,2,f) = toc(tPso) * 1000; % in ms
        resultDist(l,2,f) = total_length_pso;

        if showplot_pso == true
            plotSpaceAfterPSO( data, path, travelPoints );
        end
        
        resultTime(l,3,f) = resultTime(l,1,f) + resultTime(l,2,f); % sum of over time in ms
    end
    
    % results
    resultOverview(f,3) = mean(resultDist(:,2,f)); % mean value
    
    resultOverview(f,1) = (resultOverview(f,3) - optimalValue(f,1)) / optimalValue(f,1); % relative error (with mean value)
    
    resultOverview(f,2) = max(resultDist(:,2,f)); % max. value found by the algorithm
    
    resultOverview(f,5) = min(resultDist(:,2,f)); % best solution found by the algorithm
    
    resultOverview(f,4) = std(resultDist(:,2,f)); % standard deviation
    
    fprintf('relative error: %f\n', resultOverview(f,1));
    fprintf('max. value: %f\n', resultOverview(f,2));
    fprintf('mean value: %f\n', resultOverview(f,3));
    fprintf('standard deviation: %f\n', resultOverview(f,4));
    fprintf('best solution: %f\n', resultOverview(f,5));
    
end

clearvars variables showplot_dpso showplot_pso f l tDpso tPso fullloops total_length_dpso total_length_pso moveOptionsDPSO