function ax = setZData(ax,val)
    ax = arrayfun(@(x)setZData_ax(x,val),ax);

    function ax = setZData_ax(ax,val)
        ax.ZData = val*ones(size(ax.XData));
    end
end