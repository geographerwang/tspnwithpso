function plotSpaceAfterPSO( data, path, travelPoints )

    figure;
    for i=1:1:size(data,1)
        plotEllipse( data(i,1), data(i,2), data(i,3), data(i,4) );
    end
    
    for j=1:1:size(path,2)-1
        plot(travelPoints(path(1,j),1), travelPoints(path(1,j),2), '*');
        plot(travelPoints(path(1,j+1),1), travelPoints(path(1,j+1),2), '*');
        plot([travelPoints(path(1,j),1) travelPoints(path(1,j+1),1)],[travelPoints(path(1,j),2) travelPoints(path(1,j+1),2)], 'k')
        hold on
    end

    plot(travelPoints(path(1,size(path,2)),1), travelPoints(path(1,size(path,2)),2), '*');
    plot(travelPoints(path(1,1),1), travelPoints(path(1,1),2), '*');
    plot([travelPoints(path(1,size(path,2)),1) travelPoints(path(1,1),1)],[travelPoints(path(1,size(path,2)),2) travelPoints(path(1,1),2)], 'k')
    hold off

end
