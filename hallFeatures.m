function feats = hallFeatures(data)
% feats = NaN(height(data),6); % pairwise features
feats = [];
for iTrain = 1:height(data)
    iFeat = 1;
    for ii = 1:width(data)-1
        for jj = ii:width(data)-1
            if ii == jj
                continue;
            end
            % fprintf("%i-%i\n",ii,jj);
            feats(iTrain,iFeat) = 1 - (data(iTrain,ii) / data(iTrain,jj));
            iFeat = iFeat + 1;
        end
    end
end