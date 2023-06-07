function myimhist(img)
[count,bin] = hist(img(:),0:255);
stem(bin,count, 'Marker','none')

hAx = gca;
set(hAx, 'XLim',[0 255], 'XTickLabel',[], 'Box','on')

% Create axes, and draw grayscale colorbar
hAx2 = axes('Position',get(hAx,'Position'), 'HitTest','off');
image(0:255, [0 1], repmat(linspace(0,1,256),[1 1 3]), 'Parent',hAx2)
set(hAx2, 'XLim',[0 255], 'YLim',[0 1], 'YTick',[], 'Box','on')

% Resize the axis to make room for the colorbar
set(hAx, 'Units','pixels')
p = get(hAx, 'Position');
set(hAx, 'Position',[p(1) p(2)+26 p(3) p(4)-26])
set(hAx, 'Units','normalized')

% Position colorbar at bottom
set(hAx2, 'Units','pixels')
p = get(hAx2, 'Position');
set(hAx2, 'Position',[p(1:3) 26])
set(hAx2, 'Units','normalized')

% Link x-limits of the two axes
linkaxes([hAx;hAx2], 'x')
set(gcf, 'CurrentAxes',hAx)
end