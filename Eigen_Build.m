function E=Eigen_Build(obs)
%E.vct - matrix of eigenvectors one per column 
%E.N   - number of observations used i.e. = n
%E.vct - matrix of eigenvectors one per column
%E - Eigenmodel structure
%E.org - mean
    E.N  =size(obs,2);
    E.D  =size(obs,1);
    E.org=mean(obs')';
    
    obs_translated=obs-repmat(E.org,1,E.N);
    
    
    C=(1/E.N) * (obs_translated * obs_translated');
    
    [U V]=eig(C);
    
    %sort eigenvectors and eigenvalues
    linV=V*ones(size(V,2),1);
    S=[linV U'];
    S=flipud(sortrows(S,1));
    U=S(:,2:end)';
    V=S(:,1);
    
    E.vct=U;
    E.val=V;
    