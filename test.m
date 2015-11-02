
% list of datafiles
filename = {'_tspn2DE5_1', '_tspn2DE5_2', '_tspn2DE6_1', '_tspn2DE6_2', '_tspn2DE7_1', '_tspn2DE7_2', '_tspn2DE8_1', '_tspn2DE8_2', '_tspn2DE9_1', '_tspn2DE9_2', '_tspn2DE10_1', '_tspn2DE10_2', '_tspn2DE11_1', '_tspn2DE11_2', '_tspn2DE12_1', '_tspn2DE12_2', '_tspn2DE13_1', '_tspn2DE13_2', '_tspn2DE14_1', '_tspn2DE14_2', '_tspn2DE15_1', '_tspn2DE15_2', '_tspn2DE16_1', '_tspn2DE16_2'};

% set the delimiter
delimiterIn = ' ';

% set the header, if exist
headerlinesIn = 1; 

% loop through the files
for f=1 %size(filename,2)
    
    % load datafile
    datastruct = importdata(['data/' filename{f} '.dat'], delimiterIn, headerlinesIn);

    % get the data: structure = X Y R1 R2
    data = datastruct.data(:,:);
    
    % plot the ellipse
    for i=1:1:size(data,1)

        plotEllipse( data(i,1), data(i,2), data(i,3), data(i,4) );

    end
    
    % number of towns (stops)
    nStops = size(data,1);
    
    % calculate all possible town combinations / anz = n!/((n?k)! * k!)
    idxs = nchoosek(1:nStops,2);
    
    % calculate all the trip distances = sqrt(abs(a).^2 + abs(b).^2)
    dist = hypot(data(idxs(:,1),1) - data(idxs(:,2),1), ... % x
                 data(idxs(:,1),2) - data(idxs(:,2),2)); % y
    lendist = length(dist);
    
    % first equality constraint: we must have nStops trips
    Aeq = spones(1:length(idxs)); % Adds up the number of trips
    beq = nStops;

    % second equality constraint: two trips attached to each stop
    Aeq = [Aeq;spalloc(nStops,length(idxs),nStops*(nStops-1))]; % allocate a sparse matrix
    for ii = 1:nStops
        whichIdxs = (idxs == ii); % find the trips that include stop ii
        whichIdxs = sparse(sum(whichIdxs,2)); % include trips where ii is at either end
        Aeq(ii+1,:) = whichIdxs'; % include in the constraint matrix
    end
    beq = [beq; 2*ones(nStops,1)];
    
    % set lower & upper bound for binary bounds
    intcon = 1:lendist;
    lb = zeros(lendist,1);
    ub = ones(lendist,1);

    % Optimize Using intlinprog
    opts = optimoptions('intlinprog','Display','off');
    [x_tsp,costopt,exitflag,output] = intlinprog(dist,intcon,[],[],Aeq,beq,lb,ub,opts);
    
    % analyzes the solution
    tours = detectSubtours(x_tsp,idxs);
    numtours = length(tours); % number of subtours
    fprintf('# of subtours: %d\n',numtours);
    
    hold on
    segments = find(x_tsp); % Get indices of lines on optimal path
    lh = zeros(nStops,1); % Use to store handles to lines on plot
    lh = updateSalesmanPlot(lh,x_tsp,idxs,data(:,1),data(:,2));
    hold off
    
end

