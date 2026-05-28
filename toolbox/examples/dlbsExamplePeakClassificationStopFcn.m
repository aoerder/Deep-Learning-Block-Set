function peakClassificationStopFcn(out)
    num = 1e3;

    x = out.logsout.getElement('x').Values.Data(:,:,end-num+1:end);
    y = out.logsout.getElement('y').Values.Data(:,:,end-num+1:end);

    x = permute(x,[1,3,2]);
    y = permute(y,[1,3,2]);

    x1 =  reshape(x(:,:,1),size(x,1)*num,1);
    x2 =  reshape(x(:,:,2),size(x,1)*num,1);
    y =  reshape(y,size(y,1)*num,size(y,3));

    [m,c] = max(y,[],2);
    m = m(:);
    c = c(:);
    t = out.logsout.getElement('y').Values.Time(:);
    [px1,px2,py] = peaks(30);
    clf;
    contour(px2,px1,py,[-1 1] ,LineWidth=5,EdgeColor=[.5,.5,.5]);
    hold on
    % scatter(x1(y>0.5),x2(y>0.5),5*ones(size(t(y>0.5))),t(y>0.5),'*')
    scatter(x1,x2,m*20,c,'o', 'filled', MarkerFaceAlpha=.5)
    clim([0,4])
    axis equal
    colormap jet
end