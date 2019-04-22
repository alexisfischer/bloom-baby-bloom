% plot classifier vs manual results checkerboard

    tot=sum(c1);
    fx=NaN*c1;
    for i=1:length(c1)
        fx(:,i)=c1(:,i)./tot(i);
    end
    
classfinal=classes;
classfinal(strmatch('Cryptophyte,NanoP_less10',classfinal))={'nanoplankton'};
classfinal(strmatch('Alexandrium_singlet',classfinal))={'Alexandrium'};
classfinal(strmatch('Cochlodinium',classfinal))={'Margalefidinium'};
        
figure('Units','inches','Position',[1 1 7 6],'PaperPositionMode','auto');
    cplot = zeros(size(fx)+1);
    cplot(1:length(classfinal),1:length(classfinal)) = fx;
    pcolor(fx)
    set(gca, 'ytick', 1:length(classfinal), 'yticklabel', [])
    text( -text_offset+ones(size(classfinal)),(1:length(classfinal))+.5, classfinal,...
        'interpreter', 'none', 'horizontalalignment', 'right', 'rotation', 0)
    set(gca,'xtick', 1:length(classfinal), 'xticklabel', [],'fontsize',12)
    text((1:length(classfinal))+.5, -text_offset+ones(size(classfinal)), classfinal,...
        'interpreter', 'none', 'horizontalalignment', 'right', 'rotation', 45) 
    axis square, caxis([0 1])
    colormap(jet)
    h=colorbar;
   
    pos=get(gca,'position');  % retrieve the current values
    pos(1)=0.1+pos(1); 
    pos(2)=pos(2)+.08;        
   pos(3)=0.90*pos(3);        % try reducing width 10%
    set(gca,'position',pos);

    % set figure parameters
    set(gcf,'color','w');
    print(gcf,'-dtiff','-r200',[out_dir 'fx_Classifier_vs_Manual.tif']);
    hold off
    
    