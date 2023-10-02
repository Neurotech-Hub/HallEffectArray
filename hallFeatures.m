function feats = hallFeatures(data)
feats = NaN(height(data),6); % pairwise features
for iTrain = 1:height(data)
    iFeat = 1;
    for ii = 1:4
        for jj = ii:4
            if ii == jj
                continue;
            end
            % fprintf("%i-%i\n",ii,jj);
            feats(iTrain,iFeat) = data(iTrain,ii) / data(iTrain,jj);
            iFeat = iFeat + 1;
        end
    end
end