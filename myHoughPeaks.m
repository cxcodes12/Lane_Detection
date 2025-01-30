function [peaks] = myHoughPeaks(H,num_peaks)
peaks = zeros(num_peaks,2);

for i=1:num_peaks
    [~, max_idx] = max(H(:));
    [row,col] = ind2sub(size(H),max_idx); 
    peaks(i,:) = [row,col];
    
    %elimin punctele din vecinatatea maximului
    row_start = max(1,row-10);
    row_end = min(size(H,1),row+10);
    col_start = max(1,col-10);
    col_end = min(size(H,2),col+10);
    H(row_start:row_end,col_start:col_end) = 0;
end

end